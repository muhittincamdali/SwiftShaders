import SwiftUI
import Testing
@testable import SwiftShaders

/// A black view with a white vertical bar from x = 14 to x = 18.
private func whiteBar() -> some View {
    ZStack(alignment: .leading) {
        Color.black
        Color.white.frame(width: 4).offset(x: 14)
    }
    .frame(width: 32, height: 16)
}

@MainActor
@Suite("Layer effects")
struct LayerEffectTests {
    @Test("Pixelate fills each cell with one color")
    func pixelateCells() throws {
        let pixels = try Pixels(grayRamp().pixelate(cellSize: 8), width: 32, height: 16)
        for cellX in stride(from: 0, to: 32, by: 8) {
            let first = pixels[cellX, 0]
            for y in 0..<8 {
                for x in cellX..<(cellX + 8) {
                    #expect(pixels[x, y] == first)
                }
            }
        }
        // The cells follow the ramp from dark to light.
        #expect(pixels[0, 0].red < pixels[8, 0].red)
        #expect(pixels[16, 0].red < pixels[24, 0].red)
    }

    @Test("Partial cells at the edge sample inside the view instead of turning transparent")
    func pixelatePartialCells() throws {
        let pixels = try Pixels(srgb(200, 60, 60).pixelate(cellSize: 12), width: 30, height: 30)
        #expect(pixels[29, 29].isClose(to: RGBA(200, 60, 60)))
    }

    @Test("Cell size 1 or less leaves the view unchanged", arguments: [1.0, 0.0, -4.0, .nan])
    func pixelateIdentity(cellSize: Double) throws {
        let original = try Pixels(grayRamp(), width: 16, height: 8)
        let pixelated = try Pixels(grayRamp().pixelate(cellSize: cellSize), width: 16, height: 8)
        #expect(pixelated.maxDifference(from: original) == 0)
    }

    @Test("Chromatic aberration moves red and blue in opposite directions")
    func chromaticAberration() throws {
        let pixels = try Pixels(whiteBar().chromaticAberration(offset: 2), width: 32, height: 16)
        // The bar covers x = 14..<18. Red is shifted right by 2 (to 16..<20), blue left by 2
        // (to 12..<16), green stays.
        #expect(pixels[19, 8] == RGBA(255, 0, 0))
        #expect(pixels[12, 8] == RGBA(0, 0, 255))
        #expect(pixels[15, 8] == RGBA(0, 255, 255))
        #expect(pixels[16, 8] == RGBA(255, 255, 0))
        #expect(pixels[21, 8] == RGBA(0, 0, 0))
        let unchanged = try Pixels(whiteBar().chromaticAberration(offset: 0), width: 32, height: 16)
        #expect(unchanged.maxDifference(from: try Pixels(whiteBar(), width: 32, height: 16)) == 0)
    }

    @Test("Sketch draws flat areas as paper and edges as lines")
    func sketch() throws {
        let pixels = try Pixels(
            whiteSquare(side: 12).sketch(lineColor: srgb(0, 0, 255), paperColor: srgb(255, 255, 0)),
            width: 32, height: 32
        )
        #expect(pixels[16, 16].isClose(to: RGBA(255, 255, 0)))  // inside the square
        #expect(pixels[2, 2].isClose(to: RGBA(255, 255, 0)))    // background
        #expect(pixels[10, 16].isClose(to: RGBA(0, 0, 255)))    // left edge of the square
    }

    @Test("Emboss keeps flat areas and lights edges that face the light")
    func emboss() throws {
        let original = try Pixels(whiteSquare(side: 16), width: 32, height: 32)
        let pixels = try Pixels(srgb(128, 128, 128).overlay(whiteSquare(side: 16).opacity(0.5)).emboss(strength: 1), width: 32, height: 32)
        #expect(original[16, 16] == RGBA(255, 255, 255))
        let center = pixels[16, 16]
        // Light comes from the top left: the top-left edge brightens, the bottom-right edge darkens.
        #expect(pixels[8, 16].red > center.red + 20)
        #expect(pixels[23, 16].red < center.red - 20)
        #expect(pixels[2, 2].isClose(to: try Pixels(srgb(128, 128, 128).overlay(whiteSquare(side: 16).opacity(0.5)), width: 32, height: 32)[2, 2]))
    }

    @Test("Sharpen raises contrast at edges and leaves flat areas alone")
    func sharpen() throws {
        let source = srgb(100, 100, 100).overlay(srgb(150, 150, 150).frame(width: 16, height: 16))
        let original = try Pixels(source, width: 32, height: 32)
        let pixels = try Pixels(source.sharpen(1), width: 32, height: 32)
        #expect(pixels[16, 16] == original[16, 16])
        #expect(pixels[2, 2] == original[2, 2])
        #expect(pixels[8, 16].red > original[8, 16].red)  // light side of the edge gets lighter
        #expect(pixels[7, 16].red < original[7, 16].red)  // dark side gets darker
    }

    @Test("Halftone dots cover more of dark areas than of light ones")
    func halftone() throws {
        func inkCoverage(of gray: Int) throws -> Double {
            let pixels = try Pixels(srgb(gray, gray, gray).halftone(dotSize: 8, angle: .zero), width: 32, height: 32)
            return Double(pixels.all.filter { $0.red < 128 }.count) / Double(32 * 32)
        }
        let dark = try inkCoverage(of: 40)
        let middle = try inkCoverage(of: 128)
        let light = try inkCoverage(of: 220)
        #expect(dark > middle && middle > light)
        // Dot area is proportional to darkness: 50% gray covers about half of the paper.
        #expect(abs(middle - 0.5) < 0.12)
    }

    @Test("Kaleidoscope repeats the pattern every 360 / segments degrees")
    func kaleidoscope() throws {
        let pixels = try Pixels(colorField().kaleidoscope(segments: 4), width: 40, height: 40)
        // With 4 segments, a quarter turn around the center lands on the same color.
        let points = [(28, 22), (30, 26), (34, 21)]
        for (x, y) in points {
            let turned = (40 - y, x)  // (x, y) turned by 90 degrees around (20, 20)
            #expect(pixels[x, y].isClose(to: pixels[turned.0, turned.1], tolerance: 12))
        }
        // Points of the wedge outside the view are mirrored back in, so nothing is transparent.
        #expect(pixels.all.allSatisfy { $0.alpha == 255 })
    }

    @Test("Glitch is repeatable for a fixed time and does nothing at intensity 0")
    func glitch() throws {
        let source = grayRamp()
        let original = try Pixels(source, width: 64, height: 64)
        let first = try Pixels(source.glitch(intensity: 1, time: .fixed(3)), width: 64, height: 64)
        let again = try Pixels(source.glitch(intensity: 1, time: .fixed(3)), width: 64, height: 64)
        #expect(first.maxDifference(from: again) == 0)
        #expect(first.maxDifference(from: original) > 20)
        let off = try Pixels(source.glitch(intensity: 0, time: .fixed(3)), width: 64, height: 64)
        #expect(off.maxDifference(from: original) == 0)
    }

    @Test("Effects that compare neighbors leave a flat view unchanged up to its edges")
    func flatViewsHaveNoBorder() throws {
        // Reading outside the view would see transparent pixels and draw a border.
        let flat = srgb(90, 140, 200)
        let original = try Pixels(flat, width: 24, height: 24)
        #expect(try Pixels(flat.sharpen(2, radius: 3), width: 24, height: 24).maxDifference(from: original) <= 1)
        #expect(try Pixels(flat.emboss(strength: 3, distance: 3), width: 24, height: 24).maxDifference(from: original) <= 1)
        let sketched = try Pixels(flat.sketch(lineWidth: 3, paperColor: srgb(255, 255, 0)), width: 24, height: 24)
        #expect(sketched.all.allSatisfy { $0.isClose(to: RGBA(255, 255, 0)) })
    }

    @Test("Progressive blur leaves the start sharp and blurs the end")
    func progressiveBlur() throws {
        let stripes = Rectangle().fill(.stripes(width: 2, angle: .zero, srgb(255, 255, 255), srgb(0, 0, 0)))
        let original = try Pixels(stripes, width: 32, height: 32)
        let blurred = try Pixels(stripes.progressiveBlur(radius: 8, from: .top, to: .bottom), width: 32, height: 32)
        let firstRow = (0..<32).map { blurred[$0, 0] }
        #expect(zip(firstRow, (0..<32).map { original[$0, 0] }).allSatisfy { $0.isClose(to: $1, tolerance: 8) })
        // At the bottom the 2-point stripes are averaged to an even gray. Near the left and right
        // edges the blur averages only the part of its window inside the view, which holds a
        // few more light or dark points, so those pixels may lean a little to one side.
        let lastRow = (0..<32).map { blurred[$0, 31].red }
        #expect(lastRow[8..<24].allSatisfy { abs($0 - 128) <= 3 }, "\(lastRow)")
        #expect(lastRow.allSatisfy { abs($0 - 128) <= 30 }, "\(lastRow)")
        // The contrast falls steadily from top to bottom.
        func contrast(_ y: Int) -> Int {
            let row = (0..<32).map { blurred[$0, y].red }
            return row.max()! - row.min()!
        }
        #expect(contrast(2) > contrast(16) && contrast(16) > contrast(30))
    }

    @Test("Progressive blur keeps the edges of an opaque view opaque")
    func progressiveBlurEdges() throws {
        let blurred = try Pixels(grayRamp().progressiveBlur(radius: 20, from: .leading, to: .trailing), width: 32, height: 32)
        #expect(blurred.all.allSatisfy { $0.alpha == 255 }, "\(Set(blurred.all.map(\.alpha)).sorted())")
    }
}

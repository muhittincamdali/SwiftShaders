import SwiftUI
import Testing
@testable import SwiftShaders

/// The sepia matrix, applied in Swift to check the shader's output.
private func sepiaReference(_ red: Int, _ green: Int, _ blue: Int) -> RGBA {
    let r = Double(red) / 255, g = Double(green) / 255, b = Double(blue) / 255
    func channel(_ x: Double, _ y: Double, _ z: Double) -> Int {
        Int((min(1, x * r + y * g + z * b) * 255).rounded())
    }
    return RGBA(channel(0.393, 0.769, 0.189), channel(0.349, 0.686, 0.168), channel(0.272, 0.534, 0.131))
}

@MainActor
@Suite("Color effects")
struct ColorEffectTests {
    @Test("Sepia applies the sepia matrix")
    func sepiaMatrix() throws {
        let pixels = try Pixels(srgb(100, 150, 200).sepia(), width: 8, height: 8)
        #expect(pixels[4, 4].isClose(to: sepiaReference(100, 150, 200)))
    }

    @Test("Sepia at half strength is halfway between the original and the sepia color")
    func sepiaAmount() throws {
        let pixels = try Pixels(srgb(100, 150, 200).sepia(0.5), width: 8, height: 8)
        let full = sepiaReference(100, 150, 200)
        let expected = RGBA((100 + full.red) / 2, (150 + full.green) / 2, (200 + full.blue) / 2)
        #expect(pixels[4, 4].isClose(to: expected))
    }

    @Test("Sepia keeps the alpha of translucent views")
    func sepiaKeepsAlpha() throws {
        let pixels = try Pixels(srgb(100, 150, 200, opacity: 0.5).sepia(), width: 8, height: 8)
        let pixel = pixels[4, 4]
        let full = sepiaReference(100, 150, 200)
        #expect(abs(pixel.alpha - 128) <= 2)
        // The bitmap is premultiplied: each channel is the straight value times alpha.
        #expect(abs(pixel.red - full.red / 2) <= 3)
        #expect(abs(pixel.blue - full.blue / 2) <= 3)
    }

    @Test("Amount 0 leaves the view unchanged")
    func zeroAmounts() throws {
        let source = grayRamp()
        let original = try Pixels(source, width: 16, height: 8)
        for effect in [
            AnyView(source.sepia(0)),
            AnyView(source.vignette(intensity: 0)),
            AnyView(source.scanlines(intensity: 0)),
            AnyView(source.filmGrain(intensity: 0, time: .fixed(1))),
            AnyView(source.duotone(shadows: .red, highlights: .yellow, amount: 0)),
        ] {
            #expect(try Pixels(effect, width: 16, height: 8).maxDifference(from: original) <= 1)
        }
    }

    @Test("Duotone maps black to the shadow color and white to the highlight color")
    func duotone() throws {
        let view = HStack(spacing: 0) {
            srgb(0, 0, 0)
            srgb(255, 255, 255)
        }
        .duotone(shadows: srgb(20, 40, 120), highlights: srgb(250, 220, 90))
        let pixels = try Pixels(view, width: 16, height: 8)
        #expect(pixels[2, 4].isClose(to: RGBA(20, 40, 120)))
        #expect(pixels[13, 4].isClose(to: RGBA(250, 220, 90)))
    }

    @Test("Posterize leaves only the requested number of values per channel", arguments: [2, 3, 5])
    func posterize(levels: Int) throws {
        let pixels = try Pixels(grayRamp().posterize(levels: levels), width: 64, height: 4)
        let values = Set(pixels.all.map(\.red))
        let allowed = Set((0..<levels).map { Int((Double($0) / Double(levels - 1) * 255).rounded()) })
        #expect(values.count == levels)
        for value in values {
            #expect(allowed.contains { abs($0 - value) <= 2 }, "unexpected level \(value)")
        }
    }

    @Test("Threshold draws the dark color below the cutoff and the light color above it")
    func threshold() throws {
        let view = HStack(spacing: 0) {
            srgb(90, 90, 90)
            srgb(160, 160, 160)
        }
        .threshold(0.5, dark: srgb(10, 20, 30), light: srgb(240, 230, 220))
        let pixels = try Pixels(view, width: 16, height: 8)
        #expect(pixels[2, 4].isClose(to: RGBA(10, 20, 30)))
        #expect(pixels[13, 4].isClose(to: RGBA(240, 230, 220)))
    }

    @Test("Vignette leaves the center alone and darkens the corners")
    func vignette() throws {
        let pixels = try Pixels(srgb(200, 200, 200).vignette(intensity: 0.8, radius: 0.3, softness: 0.8), width: 40, height: 40)
        #expect(pixels[20, 20].isClose(to: RGBA(200, 200, 200)))
        #expect(pixels[0, 0].red < 80)
        // Symmetric around the center.
        #expect(pixels[0, 0].isClose(to: pixels[39, 39], tolerance: 4))
        #expect(pixels[0, 20].red > pixels[0, 0].red)
    }

    @Test("Scanlines darken the lower half of each band")
    func scanlines() throws {
        let pixels = try Pixels(srgb(200, 200, 200).scanlines(spacing: 4, intensity: 0.5), width: 8, height: 8)
        let column = (0..<8).map { pixels[3, $0].red }
        #expect(column[0] == column[1])
        #expect(abs(column[0] - 200) <= 2)
        #expect(abs(column[2] - 100) <= 2)
        #expect(column[2] == column[3])
        #expect(column[4] == column[0])
    }

    @Test("Film grain is repeatable for a fixed time and changes with the frame")
    func filmGrain() throws {
        let gray = srgb(128, 128, 128)
        let first = try Pixels(gray.filmGrain(intensity: 0.3, time: .fixed(0)), width: 24, height: 24)
        let again = try Pixels(gray.filmGrain(intensity: 0.3, time: .fixed(0)), width: 24, height: 24)
        let nextFrame = try Pixels(gray.filmGrain(intensity: 0.3, time: .fixed(1.0 / 24)), width: 24, height: 24)
        #expect(first.maxDifference(from: again) == 0)
        #expect(first.maxDifference(from: nextFrame) > 10)
        // The noise is centered on zero, so the average brightness stays close to the original.
        let mean = Double(first.all.map(\.red).reduce(0, +)) / Double(first.width * first.height)
        #expect(abs(mean - 128) < 6)
        #expect(first.all.allSatisfy { abs($0.red - 128) <= 40 })
    }

    @Test("Dithering 50% gray to two levels turns half of every 4 x 4 block white")
    func dither() throws {
        let pixels = try Pixels(srgb(128, 128, 128).dither(levels: 2), width: 8, height: 8)
        #expect(pixels.all.allSatisfy { $0.red == 0 || $0.red == 255 })
        for blockY in [0, 4] {
            for blockX in [0, 4] {
                let white = (0..<4).flatMap { y in (0..<4).map { x in pixels[blockX + x, blockY + y] } }
                    .filter { $0.red == 255 }.count
                #expect(white == 8)
            }
        }
    }

    @Test("Dithering keeps pure black and pure white")
    func ditherExtremes() throws {
        let view = HStack(spacing: 0) {
            srgb(0, 0, 0)
            srgb(255, 255, 255)
        }
        .dither(levels: 4)
        let pixels = try Pixels(view, width: 16, height: 8)
        #expect((0..<8).allSatisfy { pixels[$0, 3].red == 0 })
        #expect((8..<16).allSatisfy { pixels[$0, 3].red == 255 })
    }

    @Test("A gradient map maps black to the first color and white to the last")
    func gradientMapEnds() throws {
        let view = HStack(spacing: 0) {
            srgb(0, 0, 0)
            srgb(255, 255, 255)
        }
        .gradientMap([srgb(30, 0, 90), srgb(200, 40, 40), srgb(250, 230, 120)])
        let pixels = try Pixels(view, width: 16, height: 8)
        #expect(pixels[2, 4].isClose(to: RGBA(30, 0, 90)))
        #expect(pixels[13, 4].isClose(to: RGBA(250, 230, 120)))
    }

    @Test("A black-to-white gradient map leaves grays as they are")
    func gradientMapIdentity() throws {
        let original = try Pixels(grayRamp(), width: 64, height: 4)
        let mapped = try Pixels(grayRamp().gradientMap([srgb(0, 0, 0), srgb(255, 255, 255)]), width: 64, height: 4)
        #expect(mapped.maxDifference(from: original) <= 3)
    }

    @Test("The shimmer band is outside the view at time 0 and crosses the middle halfway through")
    func shimmer() throws {
        let gray = srgb(100, 100, 100)
        let original = try Pixels(gray, width: 64, height: 8)
        let start = try Pixels(gray.shimmer(intensity: 1, width: 0.1, angle: .zero, duration: 2, time: .fixed(0)), width: 64, height: 8)
        #expect(start.maxDifference(from: original) <= 1)

        let middle = try Pixels(gray.shimmer(intensity: 1, width: 0.1, angle: .zero, duration: 2, time: .fixed(1)), width: 64, height: 8)
        #expect(middle[32, 4].red > 240)           // the center of the band is the band's color
        #expect(middle[5, 4] == original[5, 4])    // far from the band nothing changes
        #expect(middle[36, 4].red > middle[40, 4].red)  // and it fades out from the center
    }

    @Test("Shimmer only brightens what is drawn")
    func shimmerKeepsTransparency() throws {
        let view = HStack(spacing: 0) {
            Color.clear
            srgb(100, 100, 100)
        }
        let pixels = try Pixels(view.shimmer(intensity: 1, width: 0.5, angle: .zero, duration: 2, time: .fixed(1)), width: 32, height: 8)
        #expect((0..<16).allSatisfy { pixels[$0, 4].alpha == 0 })
        #expect(pixels[20, 4].alpha == 255)
    }
}

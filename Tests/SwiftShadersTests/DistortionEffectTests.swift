import SwiftUI
import Testing
@testable import SwiftShaders

/// A black view with a white vertical bar at x = 14..<18.
private func whiteBar(height: CGFloat = 32) -> some View {
    ZStack(alignment: .leading) {
        Color.black
        Color.white.frame(width: 4).offset(x: 14)
    }
    .frame(width: 32, height: height)
}

/// The columns of row `y` that are mostly white.
private func whiteColumns(_ pixels: Pixels, row y: Int) -> [Int] {
    (0..<pixels.width).filter { pixels[$0, y].red > 128 }
}

@MainActor
@Suite("Distortion effects")
struct DistortionEffectTests {
    @Test("Wave shifts each row by amplitude times the sine of its phase")
    func wave() throws {
        // Wavelength 32 and time 0: row 8 is a quarter wave (shift +4), row 24 three quarters
        // (shift -4), row 0 no shift. A shift of +4 reads from 4 points to the right, so the bar
        // appears 4 points further left.
        let pixels = try Pixels(whiteBar().wave(amplitude: 4, wavelength: 32, speed: 1, time: .fixed(0)), width: 32, height: 32)
        #expect(whiteColumns(pixels, row: 0) == [14, 15, 16, 17])
        #expect(whiteColumns(pixels, row: 8) == [10, 11, 12, 13])
        #expect(whiteColumns(pixels, row: 24) == [18, 19, 20, 21])
    }

    @Test("Wave travels: half a period later, rows are shifted the other way")
    func waveMoves() throws {
        let pixels = try Pixels(whiteBar().wave(amplitude: 4, wavelength: 32, speed: 1, time: .fixed(0.5)), width: 32, height: 32)
        #expect(whiteColumns(pixels, row: 8) == [18, 19, 20, 21])
    }

    @Test("Amplitude 0 leaves the view unchanged")
    func waveIdentity() throws {
        let original = try Pixels(whiteBar(), width: 32, height: 32)
        let waved = try Pixels(whiteBar().wave(amplitude: 0, time: .fixed(1)), width: 32, height: 32)
        #expect(waved.maxDifference(from: original) == 0)
    }

    @Test("Swirl turns content near the center and leaves the outside alone")
    func swirl() throws {
        let halves = HStack(spacing: 0) {
            srgb(255, 0, 0)
            srgb(0, 0, 255)
        }
        let pixels = try Pixels(halves.swirl(angle: .degrees(180), radius: 0.5), width: 32, height: 32)
        // Just right of the center is turned by about 140 degrees and now shows the red half.
        #expect(pixels[18, 16].red > 200 && pixels[18, 16].blue < 50)
        // The corners are outside the radius of 16 points.
        #expect(pixels[1, 1].isClose(to: RGBA(255, 0, 0)))
        #expect(pixels[30, 30].isClose(to: RGBA(0, 0, 255)))
    }

    @Test("Bulge magnifies the center and a negative strength pinches it")
    func bulge() throws {
        let square = whiteSquare(side: 8)
        let original = try Pixels(square, width: 32, height: 32)
        let magnified = try Pixels(square.bulge(strength: 1, radius: 0.5), width: 32, height: 32)
        let pinched = try Pixels(square.bulge(strength: -1, radius: 0.5), width: 32, height: 32)
        // The square covers 12..<20. Magnified, it reaches x = 21; pinched, it ends before x = 19.
        #expect(original[21, 16].red == 0 && magnified[21, 16].red > 200)
        #expect(original[19, 16].red == 255 && pinched[19, 16].red < 50)
        // Outside the radius nothing moves.
        #expect(magnified[1, 1] == original[1, 1])
    }

    @Test("A loupe enlarges the area inside its circle and leaves the rest alone")
    func loupe() throws {
        let square = whiteSquare(side: 8)
        let original = try Pixels(square, width: 32, height: 32)
        // Radius 0.5 of 32 points is 16. At magnification 2 the square (12..<20) appears twice
        // as large, 8..<24, and the corners outside the circle do not move.
        let pixels = try Pixels(square.loupe(radius: 0.5, magnification: 2), width: 32, height: 32)
        #expect(original[9, 16].red == 0 && pixels[9, 16].red > 200)
        #expect(pixels[22, 16].red > 200 && pixels[25, 16].red < 50)
        #expect(pixels[1, 1] == original[1, 1])
        let unchanged = try Pixels(square.loupe(magnification: .nan), width: 32, height: 32)
        #expect(unchanged.maxDifference(from: original) == 0)
    }

    @Test("Water moves pixels by at most the amplitude and repeats for a fixed time")
    func water() throws {
        let view = whiteBar()
        let first = try Pixels(view.water(amplitude: 3, scale: 40, time: .fixed(2)), width: 32, height: 32)
        let again = try Pixels(view.water(amplitude: 3, scale: 40, time: .fixed(2)), width: 32, height: 32)
        #expect(first.maxDifference(from: again) == 0)
        for y in 0..<32 {
            let columns = whiteColumns(first, row: y)
            // The bar is 4 points wide at 14..<18; no row can show white more than 3 points away.
            #expect(columns.allSatisfy { (11...20).contains($0) }, "row \(y): \(columns)")
        }
        #expect(first.maxDifference(from: try Pixels(view, width: 32, height: 32)) > 100)
    }
}

@MainActor
@Suite("Ripple")
struct RippleTests {
    @Test("A ripple that has not started leaves the view unchanged")
    func notStarted() throws {
        let original = try Pixels(grayRamp(), width: 32, height: 32)
        let rippled = try Pixels(grayRamp().ripple(origin: CGPoint(x: 16, y: 16), elapsedTime: 0), width: 32, height: 32)
        #expect(rippled.maxDifference(from: original) == 0)
    }

    @Test("The ring changes the view only where it has reached")
    func ringSpreads() throws {
        let style = RippleStyle(amplitude: 6, frequency: 15, decay: 2, speed: 100)
        let original = try Pixels(grayRamp(), width: 64, height: 64)
        // After 0.1 s the ring has spread 10 points from the top-left corner.
        let rippled = try Pixels(
            grayRamp().ripple(origin: .zero, elapsedTime: 0.1, style: style), width: 64, height: 64
        )
        #expect(rippled[5, 2] != original[5, 2])
        #expect(rippled[50, 50].isClose(to: original[50, 50], tolerance: 1), "\(rippled[50, 50]) \(original[50, 50])")
    }
}

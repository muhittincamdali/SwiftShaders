import SwiftUI
import Testing
@testable import SwiftShaders

@MainActor
@Suite("Fills")
struct FillTests {
    @Test("Checkerboard alternates the two colors cell by cell")
    func checkerboard() throws {
        let fill = Rectangle().fill(.checkerboard(cellSize: 4, srgb(255, 0, 0), srgb(0, 0, 255)))
        let pixels = try Pixels(fill, width: 16, height: 16)
        #expect(pixels[1, 1] == RGBA(255, 0, 0))
        #expect(pixels[5, 1] == RGBA(0, 0, 255))
        #expect(pixels[5, 5] == RGBA(255, 0, 0))
        #expect(pixels[1, 13] == RGBA(0, 0, 255))
    }

    @Test("Stripes at angle 0 are vertical bands of the given width")
    func stripes() throws {
        let fill = Rectangle().fill(.stripes(width: 4, angle: .zero, srgb(255, 255, 255), srgb(0, 0, 0)))
        let pixels = try Pixels(fill, width: 16, height: 8)
        let row = (0..<16).map { pixels[$0, 3].red }
        #expect(row == [255, 255, 255, 255, 0, 0, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0])
        #expect((0..<8).allSatisfy { pixels[1, $0].red == 255 })
    }

    @Test("Plasma blends only its three colors and moves with time")
    func plasma() throws {
        let colors = (srgb(255, 0, 0), srgb(0, 255, 0), srgb(0, 0, 255))
        let first = try Pixels(Rectangle().fill(.plasma(time: 0, colors: colors)), width: 32, height: 32)
        let later = try Pixels(Rectangle().fill(.plasma(time: 1, colors: colors)), width: 32, height: 32)
        #expect(first.maxDifference(from: later) > 20)
        // Each pixel mixes neighbors on the gradient, so red and blue never appear together.
        #expect(first.all.allSatisfy { min($0.red, $0.blue) <= 3 })
    }
}

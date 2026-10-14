import SwiftUI
import Testing
@testable import SwiftShaders

/// The README samples, compiled from the example app through the symlink ReadmeSamples.swift and
/// rendered here, so a sample that stops compiling or drawing fails the tests.
@MainActor
@Suite("README samples")
struct ReadmeSampleTests {
    @Test("The quick start draws the symbol as a black-and-white halftone")
    func quickStart() throws {
        let pixels = try Pixels(QuickStartSample(), width: 200, height: 200)
        let drawn = pixels.all.filter { $0.alpha > 0 }
        #expect(drawn.count > 20_000)
        // The halftone replaces the blue and cyan with black ink on white paper (both multiplied
        // by the view's alpha, which keeps them gray).
        #expect(drawn.allSatisfy { abs($0.red - $0.blue) <= 3 && abs($0.green - $0.blue) <= 3 })
        #expect(drawn.contains { $0.alpha == 255 && $0.red < 40 })
        #expect(drawn.contains { $0.alpha == 255 && $0.red > 215 })
    }

    @Test("The loading placeholder draws its shapes")
    func loadingRow() throws {
        let pixels = try Pixels(LoadingRowSample(), width: 240, height: 60)
        #expect(pixels.all.contains { $0.alpha > 0 })
    }

    @Test("The ripple card draws the card before any tap")
    func rippleCard() throws {
        let pixels = try Pixels(RippleCardSample(), width: 280, height: 180)
        #expect(pixels[10, 90].alpha == 255 && pixels[10, 90].blue > pixels[10, 90].red)
    }

    @Test("The transition sample shows the symbol before it is hidden")
    func dissolveTransition() throws {
        let pixels = try Pixels(DissolveTransitionSample(), width: 200, height: 160)
        #expect(pixels.all.contains { $0.alpha == 255 && $0.blue > 200 && $0.red < 100 })
    }

    @Test("The flag's stripes are bent by the wave")
    func wavingFlag() throws {
        let pixels = try Pixels(WavingFlagSample(), width: 240, height: 150)
        // Where the first blue stripe ends differs from row to row.
        let edges = Set([0, 30, 60, 90].map { y in (0..<240).first { pixels[$0, y].red > 128 } })
        #expect(edges.count > 1)
    }

    @Test("The retro screen splits the colors of the text")
    func retroScreen() throws {
        let pixels = try Pixels(RetroScreenSample(), width: 320, height: 120)
        // Cyan text whose blue channel moved away shows pure green at the edges of the letters.
        #expect(pixels.all.contains { $0.green > 120 && $0.blue < 40 })
    }

    @Test("Calling the checkerboard shader directly fills the shape with two colors")
    func directShader() throws {
        let pixels = try Pixels(DirectShaderSample(), width: 200, height: 120)
        #expect(pixels[25, 60] == RGBA(255, 255, 255))
        #expect(pixels[35, 60] != pixels[25, 60] && pixels[35, 60].blue > pixels[35, 60].red)
    }
}

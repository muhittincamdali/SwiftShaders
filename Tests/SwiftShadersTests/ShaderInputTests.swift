import Foundation
import SwiftUI
import Testing
@testable import SwiftShaders

@Suite("Argument checking")
struct ShaderInputTests {
    @Test("Clamping keeps values in range and turns NaN into 0 or the lower bound")
    func clamping() {
        #expect(ShaderInput.clamped(0.5, to: 0...1) == 0.5)
        #expect(ShaderInput.clamped(-3, to: 0...1) == 0)
        #expect(ShaderInput.clamped(7, to: 0...1) == 1)
        #expect(ShaderInput.clamped(.nan, to: 0...1) == 0)
        #expect(ShaderInput.clamped(.nan, to: -500...500) == 0)
        #expect(ShaderInput.clamped(.nan, to: 2...200) == 2)
        #expect(ShaderInput.clamped(.infinity, to: 0...1) == 1)
        #expect(ShaderInput.clamped(-.infinity, to: 0...1) == 0)
    }

    @Test("Color levels stay between 2 and 256", arguments: [
        (Int.min, 2.0), (0, 2.0), (1, 2.0), (2, 2.0), (16, 16.0), (256, 256.0), (10_000, 256.0),
    ])
    func levels(input: Int, expected: Double) {
        #expect(ShaderInput.levels(input) == expected)
    }

    @Test("Lengths that shaders divide by are never zero or negative")
    func lengths() {
        #expect(ShaderInput.length(0) == 1)
        #expect(ShaderInput.length(-20) == 1)
        #expect(ShaderInput.length(.nan) == 1)
        #expect(ShaderInput.length(12.5) == 12.5)
        #expect(ShaderInput.length(0.2, minimum: 0.5) == 0.5)
    }

    @Test("Unit points and radii are converted to points in the view")
    func geometry() {
        let size = CGSize(width: 200, height: 100)
        #expect(ShaderInput.position(.center, in: size) == CGPoint(x: 100, y: 50))
        #expect(ShaderInput.position(.bottomTrailing, in: size) == CGPoint(x: 200, y: 100))
        // Radii are relative to the shorter side.
        #expect(ShaderInput.radius(0.5, in: size) == 50)
        #expect(ShaderInput.radius(-1, in: size) == 0)
    }

    @Test("Directions point where the angle says, with y growing downward")
    func vectors() {
        let right = ShaderInput.vector(length: 4, angle: .zero)
        #expect(abs(right.width - 4) < 1e-9 && abs(right.height) < 1e-9)
        let down = ShaderInput.vector(length: 4, angle: .degrees(90))
        #expect(abs(down.width) < 1e-9 && abs(down.height - 4) < 1e-9)
    }

    @Test("Sample offsets round up and ignore the sign")
    func sampleOffsets() {
        let size = CGSize(width: 300, height: 400)
        #expect(ShaderInput.sampleOffset(2.2, in: size) == CGSize(width: 3, height: 3))
        #expect(ShaderInput.sampleOffset(-5, in: size) == CGSize(width: 5, height: 5))
        #expect(ShaderInput.sampleOffset(.nan, in: size) == .zero)
    }
}

@Suite("Shader time")
struct ShaderTimeTests {
    @Test("Elapsed time is measured from the start and scaled by speed")
    func elapsed() {
        let start = Date(timeIntervalSinceReferenceDate: 1_000)
        let later = start.addingTimeInterval(2.5)
        #expect(ShaderClock.elapsed(from: start, to: later, speed: 1) == 2.5)
        #expect(ShaderClock.elapsed(from: start, to: later, speed: 2) == 5)
    }

    @Test("A clock that runs backward does not produce negative time")
    func neverNegative() {
        let start = Date(timeIntervalSinceReferenceDate: 1_000)
        #expect(ShaderClock.elapsed(from: start, to: start.addingTimeInterval(-10), speed: 1) == 0)
    }

    @Test("Long-running effects wrap every hour so 32-bit floats stay precise")
    func wrapsEveryHour() {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let elapsed = ShaderClock.elapsed(from: start, to: start.addingTimeInterval(3 * 3600 + 12), speed: 1)
        #expect(abs(elapsed - 12) < 1e-6)
    }

    @Test("A negative speed runs the animation backward within one period")
    func negativeSpeed() {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let elapsed = ShaderClock.elapsed(from: start, to: start.addingTimeInterval(10), speed: -1)
        #expect(abs(elapsed - (ShaderClock.period - 10)) < 1e-6)
    }

    @Test("Fixed and animated times report the values the effect uses")
    func timeModes() {
        #expect(ShaderTime.fixed(1.5).stillTime == 1.5)
        #expect(ShaderTime.fixed(1.5).animationSpeed == nil)
        #expect(ShaderTime.animated.animationSpeed == 1)
        #expect(ShaderTime.animated.stillTime == 0)
        #expect(ShaderTime.animated(speed: 3).animationSpeed == 3)
        #expect(ShaderTime.fixed(.nan).stillTime == 0)
        #expect(ShaderTime.animated(speed: .infinity).animationSpeed == 1)
    }
}

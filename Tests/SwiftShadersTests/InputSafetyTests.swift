import SwiftUI
import Testing
@testable import SwiftShaders

/// The sample offset an effect asks SwiftUI for, for a view of `size`; `nil` if `view` is not a
/// single shader effect applied to a color.
@MainActor
private func sampleOffset(of view: some View, in size: CGSize) -> CGSize? {
    (view as? ModifiedContent<Color, ShaderEffect>)?.modifier.maxSampleOffset(size)
}

/// Shaders run in 32-bit floats and have no error handling, so values that are NaN, infinite or
/// too large for a float must be replaced before they reach the GPU, and nothing a caller passes
/// may make SwiftUI allocate an offscreen layer much larger than the view.
@MainActor
@Suite("Unsafe input")
struct InputSafetyTests {
    let size = CGSize(width: 300, height: 400)  // diagonal: 500

    @Test("Sample offsets never exceed the view's diagonal, whatever the arguments")
    func sampleOffsetsAreBounded() throws {
        let base = Color.red
        let effects: [(String, CGSize?)] = [
            ("wave", sampleOffset(of: base.wave(amplitude: .infinity, time: .fixed(0)), in: size)),
            ("swirl", sampleOffset(of: base.swirl(radius: .infinity), in: size)),
            ("bulge", sampleOffset(of: base.bulge(radius: 1e12), in: size)),
            ("water", sampleOffset(of: base.water(amplitude: 1e12, time: .fixed(0)), in: size)),
            ("loupe", sampleOffset(of: base.loupe(radius: .infinity), in: size)),
            ("chromaticAberration", sampleOffset(of: base.chromaticAberration(offset: 1e12), in: size)),
            ("glitch", sampleOffset(of: base.glitch(intensity: .infinity, time: .fixed(0)), in: size)),
            ("ripple", sampleOffset(of: base.ripple(origin: .zero, elapsedTime: 1, style: RippleStyle(amplitude: 1e12)), in: size)),
        ]
        for (name, offset) in effects {
            let offset = try #require(offset, "\(name) is not a single shader effect")
            #expect(offset.width <= 500 && offset.height <= 500, "\(name): \(offset)")
            #expect(offset.width >= 0, "\(name): \(offset)")
        }
    }

    @Test("Effects that read only inside the view ask for no extra room")
    func inViewEffectsNeedNoOffset() throws {
        let base = Color.red
        let effects: [(String, CGSize?)] = [
            ("pixelate", sampleOffset(of: base.pixelate(cellSize: 1e12), in: size)),
            ("sketch", sampleOffset(of: base.sketch(lineWidth: 1e12), in: size)),
            ("emboss", sampleOffset(of: base.emboss(distance: 1e12), in: size)),
            ("sharpen", sampleOffset(of: base.sharpen(radius: 1e12), in: size)),
            ("halftone", sampleOffset(of: base.halftone(dotSize: 1e12), in: size)),
            ("kaleidoscope", sampleOffset(of: base.kaleidoscope(segments: .max), in: size)),
        ]
        for (name, offset) in effects {
            #expect(try #require(offset, "\(name)") == .zero, "\(name)")
        }
    }

    @Test("A NaN or infinite angle draws the same as no rotation")
    func nonFiniteAngles() throws {
        let source = whiteSquare(side: 12)
        for angle in [Angle.radians(.nan), .radians(.infinity), .radians(-.infinity)] {
            let pairs: [(AnyView, AnyView)] = [
                (AnyView(source.chromaticAberration(offset: 2, angle: angle)), AnyView(source.chromaticAberration(offset: 2, angle: .zero))),
                (AnyView(source.halftone(angle: angle)), AnyView(source.halftone(angle: .zero))),
                (AnyView(source.kaleidoscope(rotation: angle)), AnyView(source.kaleidoscope(rotation: .zero))),
                (AnyView(source.emboss(angle: angle)), AnyView(source.emboss(angle: .zero))),
                (AnyView(Rectangle().fill(.stripes(angle: angle))), AnyView(Rectangle().fill(.stripes(angle: .zero)))),
            ]
            for (unsafe, reference) in pairs {
                let drawn = try Pixels(unsafe, width: 32, height: 32)
                #expect(drawn.maxDifference(from: try Pixels(reference, width: 32, height: 32)) == 0)
            }
        }
    }

    @Test("A huge direction angle stays precise: 2π·10¹² is the same direction as 0")
    func hugeAngles() {
        let turned = ShaderInput.direction(.radians(2 * .pi * 1e12))
        #expect(abs(turned) < 2 * .pi)
        #expect(abs(cos(turned) - 1) < 1e-3)
        #expect(ShaderInput.direction(.radians(1e300)).isFinite)
    }

    @Test("NaN positions fall back to the center or the origin")
    func nonFinitePositions() throws {
        let source = HStack(spacing: 0) { srgb(255, 0, 0); srgb(0, 0, 255) }
        let unsafe = try Pixels(source.swirl(center: UnitPoint(x: .nan, y: .nan)), width: 32, height: 32)
        let centered = try Pixels(source.swirl(center: .center), width: 32, height: 32)
        #expect(unsafe.maxDifference(from: centered) == 0)

        let style = RippleStyle(amplitude: 6, frequency: 15, decay: 2, speed: 100)
        let rippled = try Pixels(grayRamp().ripple(origin: CGPoint(x: CGFloat.nan, y: CGFloat.nan), elapsedTime: 0.1, style: style), width: 32, height: 32)
        let atOrigin = try Pixels(grayRamp().ripple(origin: .zero, elapsedTime: 0.1, style: style), width: 32, height: 32)
        #expect(rippled.maxDifference(from: atOrigin) == 0)

        let far = ShaderInput.position(UnitPoint(x: .infinity, y: -.infinity), in: CGSize(width: 10, height: 10))
        // Unit coordinates are limited to ±1,000 view sizes.
        #expect(far == CGPoint(x: 10_000, y: -10_000))
        let huge = ShaderInput.point(CGPoint(x: CGFloat.infinity, y: -1e300))
        #expect(huge == CGPoint(x: ShaderInput.coordinateLimit, y: -ShaderInput.coordinateLimit))
    }

    @Test("NaN strengths switch an effect off instead of drawing garbage")
    func nonFiniteStrengths() throws {
        let original = try Pixels(grayRamp(), width: 32, height: 32)
        let views: [AnyView] = [
            AnyView(grayRamp().wave(amplitude: .nan, time: .fixed(1))),
            AnyView(grayRamp().sepia(.nan)),
            AnyView(grayRamp().vignette(intensity: .nan)),
            AnyView(grayRamp().bulge(strength: .nan)),
            AnyView(grayRamp().swirl(angle: .radians(.nan))),
            AnyView(grayRamp().water(amplitude: .nan, time: .fixed(1))),
            AnyView(grayRamp().shimmer(intensity: .nan, time: .fixed(0.5))),
            AnyView(grayRamp().progressiveBlur(radius: .nan)),
        ]
        for view in views {
            #expect(try Pixels(view, width: 32, height: 32).maxDifference(from: original) <= 1)
        }
    }

    @Test("Times too large for a 32-bit float still draw a valid frame")
    func hugeTimes() throws {
        #expect((0..<ShaderClock.period).contains(ShaderTime.fixed(1e300).stillTime))
        #expect(ShaderTime.fixed(-.infinity).stillTime == 0)
        #expect(ShaderTime.fixed(3_605).stillTime == 5)
        #expect(ShaderTime.animated(speed: 1e300).animationSpeed == 1_000)
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let elapsed = ShaderClock.elapsed(from: start, to: .distantFuture, speed: 1_000)
        #expect((0..<ShaderClock.period).contains(elapsed))

        // A NaN time on the GPU would turn the grain into NaN; the mean shows it is still noise.
        let gray = srgb(128, 128, 128)
        let grain = try Pixels(gray.filmGrain(intensity: 0.3, time: .fixed(1e300)), width: 24, height: 24)
        let mean = Double(grain.all.map(\.red).reduce(0, +)) / Double(24 * 24)
        #expect(abs(mean - 128) < 8)
        #expect(Set(grain.all.map(\.red)).count > 10)

        let plasma = try Pixels(Rectangle().fill(.plasma(time: .infinity)), width: 16, height: 16)
        #expect(plasma.maxDifference(from: try Pixels(Rectangle().fill(.plasma(time: 0)), width: 16, height: 16)) == 0)
    }

    @Test("Extreme counts are limited instead of trapping")
    func extremeCounts() throws {
        let original = try Pixels(grayRamp(), width: 32, height: 8)
        _ = try Pixels(grayRamp().posterize(levels: .min), width: 32, height: 8)
        _ = try Pixels(grayRamp().dither(levels: .max), width: 32, height: 8)
        let single = try Pixels(grayRamp().kaleidoscope(segments: .min), width: 32, height: 8)
        #expect(single.all.allSatisfy { $0.alpha == 255 })
        // A cell larger than the view makes the whole view one color.
        let pixelated = try Pixels(grayRamp().pixelate(cellSize: .infinity), width: 32, height: 8)
        #expect(Set(pixelated.all).count == 1)
        #expect(pixelated.maxDifference(from: original) > 0)
    }

    @Test("Gradient maps accept any number of colors")
    func gradientMapColorCounts() throws {
        #expect(ShaderInput.gradientColors([]) == nil)
        #expect(ShaderInput.gradientColors([.red])?.count == 2)
        #expect(ShaderInput.gradientColors(Array(repeating: .red, count: 10_000))?.count == ShaderInput.colorLimit)

        let original = try Pixels(grayRamp(), width: 32, height: 8)
        #expect(try Pixels(grayRamp().gradientMap([]), width: 32, height: 8).maxDifference(from: original) == 0)
        let flat = try Pixels(grayRamp().gradientMap([srgb(10, 200, 30)]), width: 32, height: 8)
        #expect(flat.all.allSatisfy { $0.isClose(to: RGBA(10, 200, 30)) })
        let many = (0..<1_000).map { srgb($0 % 256, 0, 0) }
        _ = try Pixels(grayRamp().gradientMap(many), width: 32, height: 8)
    }
}

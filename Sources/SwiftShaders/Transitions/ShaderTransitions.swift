import SwiftUI

extension AnyTransition {
    /// Breaks the view into growing squares while fading it out, and reverses on insertion.
    public static var pixelate: AnyTransition { pixelate(maxCellSize: 24) }

    /// Breaks the view into squares that grow to `maxCellSize` points while fading it out.
    public static func pixelate(maxCellSize: Double) -> AnyTransition {
        let maxCellSize = ShaderInput.clamped(maxCellSize, to: 1...500)
        return .modifier(
            active: PixelateTransition(progress: 1, maxCellSize: maxCellSize),
            identity: PixelateTransition(progress: 0, maxCellSize: maxCellSize)
        )
    }

    /// Hides the view grain by grain in random order, and shows it the same way on insertion.
    public static var dissolve: AnyTransition { dissolve(grainSize: 3) }

    /// Hides the view in random grains of `grainSize` points.
    ///
    /// - Parameters:
    ///   - grainSize: The side of each grain, in points.
    ///   - seed: Changes the order in which grains disappear.
    public static func dissolve(grainSize: Double, seed: Double = 0) -> AnyTransition {
        let grainSize = ShaderInput.length(grainSize)
        // The seed only picks an order; keeping it small keeps the hash precise in 32-bit floats.
        let seed = ShaderInput.finite(seed, otherwise: 0).truncatingRemainder(dividingBy: 4_096)
        return .modifier(
            active: DissolveTransition(progress: 1, grainSize: grainSize, seed: seed),
            identity: DissolveTransition(progress: 0, grainSize: grainSize, seed: seed)
        )
    }

    /// Twists the view by a full turn while fading it out, and untwists it on insertion.
    public static var swirl: AnyTransition { swirl(angle: .degrees(360)) }

    /// Twists the view by `angle` while fading it out.
    public static func swirl(angle: Angle) -> AnyTransition {
        .modifier(
            active: SwirlTransition(progress: 1, angle: angle),
            identity: SwirlTransition(progress: 0, angle: angle)
        )
    }
}

extension AnyTransition {
    /// Hides the view behind a circle that shrinks toward `center`, and grows it back on
    /// insertion.
    ///
    /// - Parameter center: Where the circle closes, as a fraction of the view's size.
    public static func circleReveal(center: UnitPoint = .center) -> AnyTransition {
        .modifier(
            active: CircleRevealTransition(progress: 1, center: center),
            identity: CircleRevealTransition(progress: 0, center: center)
        )
    }

    /// Hides the view with a sweeping clock hand, and reveals it the same way on insertion.
    ///
    /// - Parameters:
    ///   - center: The center of the sweep, as a fraction of the view's size.
    ///   - startAngle: Where the hand starts; the default is twelve o'clock. The hand turns
    ///     clockwise.
    public static func radialWipe(center: UnitPoint = .center, startAngle: Angle = .degrees(-90)) -> AnyTransition {
        .modifier(
            active: RadialWipeTransition(progress: 1, center: center, startAngle: startAngle),
            identity: RadialWipeTransition(progress: 0, center: center, startAngle: startAngle)
        )
    }
}

// Each transition animates `progress` from 0 (the view as it is) to 1 (gone). At 0 the shader is
// switched off rather than removed, so the view keeps its identity and state when the transition
// ends.

struct PixelateTransition: ViewModifier, Animatable {
    var progress: Double
    let maxCellSize: Double

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .pixelate(cellSize: 1 + (maxCellSize - 1) * progress)
            .opacity(1 - progress)
    }
}

struct DissolveTransition: ViewModifier, Animatable {
    var progress: Double
    let grainSize: Double
    let seed: Double

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let progress = ShaderInput.clamped(progress, to: 0...1)
        let grainSize = grainSize
        let seed = seed
        return content.modifier(ShaderEffect(kind: .color, isEnabled: progress > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssDissolve(.float2(size), .float(progress), .float(grainSize), .float(seed))
        })
    }
}

struct SwirlTransition: ViewModifier, Animatable {
    var progress: Double
    let angle: Angle

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .swirl(angle: angle * progress, radius: 0.75)
            .opacity(1 - progress)
    }
}

struct CircleRevealTransition: ViewModifier, Animatable {
    var progress: Double
    let center: UnitPoint

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let progress = ShaderInput.clamped(progress, to: 0...1)
        let center = center
        return content.modifier(ShaderEffect(kind: .color, isEnabled: progress > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssCircleReveal(
                .float2(size), .float2(ShaderInput.position(center, in: size)), .float(progress)
            )
        })
    }
}

struct RadialWipeTransition: ViewModifier, Animatable {
    var progress: Double
    let center: UnitPoint
    let startAngle: Angle

    nonisolated var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        let progress = ShaderInput.clamped(progress, to: 0...1)
        let center = center
        let start = ShaderInput.direction(startAngle)
        return content.modifier(ShaderEffect(kind: .color, isEnabled: progress > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssRadialWipe(
                .float2(size), .float2(ShaderInput.position(center, in: size)), .float(progress), .float(start)
            )
        })
    }
}

import SwiftUI

/// The shape of a ripple: how far it moves the view, how fast it oscillates, fades and spreads.
public struct RippleStyle: Sendable, Hashable {
    /// The largest displacement, in points.
    public var amplitude: Double
    /// How fast each point oscillates, in radians per second.
    public var frequency: Double
    /// How fast the ripple fades; higher values fade sooner.
    public var decay: Double
    /// How fast the ring spreads, in points per second.
    public var speed: Double

    /// Creates a ripple style.
    public init(amplitude: Double = 12, frequency: Double = 15, decay: Double = 8, speed: Double = 1200) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
    }

    /// A ripple like a drop in water: 12 points high, fading within about half a second.
    public static let `default` = RippleStyle()
}

extension View {
    /// Draws one frame of a ripple that started at `origin`, `elapsedTime` seconds ago.
    ///
    /// Drive `elapsedTime` yourself, for example with `keyframeAnimator`, or use
    /// ``SwiftUICore/View/rippleOnTap(style:duration:)`` to start a ripple wherever the view is
    /// tapped.
    ///
    /// - Parameters:
    ///   - origin: The ripple's starting point, in the view's coordinate space.
    ///   - elapsedTime: Seconds since the ripple started. At 0 the view is unchanged.
    ///   - style: The ripple's amplitude, frequency, decay and speed.
    nonisolated public func ripple(origin: CGPoint, elapsedTime: TimeInterval, style: RippleStyle = .default) -> some View {
        let elapsed = ShaderInput.clamped(elapsedTime, to: 0...3600)
        let amplitude = ShaderInput.clamped(style.amplitude, to: -500...500)
        let frequency = ShaderInput.clamped(style.frequency, to: 0...1000)
        let decay = ShaderInput.clamped(style.decay, to: 0...1000)
        let speed = ShaderInput.length(style.speed)
        let origin = ShaderInput.point(origin)
        return modifier(ShaderEffect(
            kind: .layer,
            isEnabled: elapsed > 0 && amplitude != 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(amplitude, in: size) },
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssRipple(
                    .float2(size),
                    .float2(origin),
                    .float(elapsed),
                    .float(amplitude),
                    .float(frequency),
                    .float(decay),
                    .float(speed)
                )
            }
        ))
    }

    /// Starts a ripple wherever the view is tapped.
    ///
    /// The tap is recognized alongside the view's own gestures, so buttons inside keep working.
    /// When Reduce Motion is on, taps do not start a ripple.
    ///
    /// ```swift
    /// Image("pond")
    ///     .resizable()
    ///     .scaledToFill()
    ///     .rippleOnTap()
    /// ```
    ///
    /// - Parameters:
    ///   - style: The ripple's amplitude, frequency, decay and speed.
    ///   - duration: How long each ripple is animated, in seconds.
    nonisolated public func rippleOnTap(style: RippleStyle = .default, duration: TimeInterval = 2) -> some View {
        modifier(RippleOnTap(style: style, duration: ShaderInput.clamped(duration, to: 0.1...60)))
    }
}

/// Starts a ripple at each tap location and animates it with a keyframe animator.
struct RippleOnTap: ViewModifier {
    let style: RippleStyle
    let duration: TimeInterval

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var origin = CGPoint.zero
    @State private var tapCount = 0

    nonisolated init(style: RippleStyle, duration: TimeInterval) {
        self.style = style
        self.duration = duration
    }

    func body(content: Content) -> some View {
        content
            .keyframeAnimator(initialValue: 0.0, trigger: tapCount) { [origin, style, duration] view, elapsed in
                // A finished ripple turns the effect off instead of drawing an invisible one.
                view.ripple(origin: origin, elapsedTime: elapsed < duration ? elapsed : 0, style: style)
            } keyframes: { [duration] _ in
                MoveKeyframe(0)
                LinearKeyframe(duration, duration: duration)
            }
            .simultaneousGesture(
                SpatialTapGesture().onEnded { tap in
                    guard !reduceMotion else { return }
                    origin = tap.location
                    tapCount += 1
                }
            )
    }
}

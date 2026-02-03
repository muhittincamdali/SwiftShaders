import SwiftUI

// MARK: - RippleModifier

/// A view modifier that applies a water ripple distortion effect.
///
/// The ripple modifier creates concentric wave patterns that emanate from
/// a specified origin point, simulating water surface disturbance.
///
/// ## Overview
///
/// Apply the ripple effect to any view:
///
/// ```swift
/// Image("photo")
///     .modifier(RippleModifier(
///         time: animationTime,
///         origin: CGPoint(x: 0.5, y: 0.5),
///         amplitude: 0.02,
///         frequency: 15.0,
///         decay: 8.0
///     ))
/// ```
///
/// ## Animation
///
/// The effect animates based on the `time` parameter. Use a `TimelineView`
/// or animation timer to drive the animation:
///
/// ```swift
/// @State private var time: Double = 0.0
///
/// TimelineView(.animation) { timeline in
///     let elapsed = timeline.date.timeIntervalSinceReferenceDate
///     Image("photo")
///         .modifier(RippleModifier(time: elapsed))
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RippleModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time driving the ripple motion.
    public var time: Double
    
    /// Center point of the ripple (normalized 0-1 coordinates).
    public var origin: CGPoint
    
    /// Strength of the distortion effect.
    public var amplitude: Double
    
    /// Number of wave cycles.
    public var frequency: Double
    
    /// Rate at which ripples fade with distance.
    public var decay: Double
    
    /// Maximum sample offset for distortion.
    private let maxSampleOffset: CGSize
    
    // MARK: - Initialization
    
    /// Creates a ripple modifier with the specified parameters.
    /// - Parameters:
    ///   - time: Animation time value.
    ///   - origin: Center point of the ripple (normalized 0-1).
    ///   - amplitude: Distortion strength (default: 0.02).
    ///   - frequency: Wave frequency (default: 15.0).
    ///   - decay: Distance decay rate (default: 8.0).
    ///   - maxSampleOffset: Maximum distortion offset.
    public init(
        time: Double,
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        amplitude: Double = 0.02,
        frequency: Double = 15.0,
        decay: Double = 8.0,
        maxSampleOffset: CGSize = CGSize(width: 50, height: 50)
    ) {
        self.time = time
        self.origin = origin
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.maxSampleOffset = maxSampleOffset
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.ripple(
                .float(time),
                .float(origin.x),
                .float(origin.y),
                .float(amplitude),
                .float(frequency),
                .float(decay)
            ),
            maxSampleOffset: maxSampleOffset
        )
    }
}

// MARK: - MultiRippleModifier

/// A modifier that creates multiple overlapping ripple effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MultiRippleModifier: ViewModifier {
    
    public var time: Double
    public var rippleCount: Double
    public var amplitude: Double
    public var frequency: Double
    public var decay: Double
    
    /// Creates a multi-ripple modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - rippleCount: Number of ripple sources.
    ///   - amplitude: Distortion strength.
    ///   - frequency: Wave frequency.
    ///   - decay: Distance decay.
    public init(
        time: Double,
        rippleCount: Double = 3.0,
        amplitude: Double = 0.03,
        frequency: Double = 12.0,
        decay: Double = 6.0
    ) {
        self.time = time
        self.rippleCount = rippleCount
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.multiRipple(
                .float(time),
                .float(rippleCount),
                .float(amplitude),
                .float(frequency),
                .float(decay)
            ),
            maxSampleOffset: CGSize(width: 60, height: 60)
        )
    }
}

// MARK: - AnimatedRippleModifier

/// A self-animating ripple modifier that doesn't require external time tracking.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct AnimatedRippleModifier: ViewModifier {
    
    public var origin: CGPoint
    public var amplitude: Double
    public var frequency: Double
    public var decay: Double
    public var speed: Double
    
    /// Creates an animated ripple modifier.
    /// - Parameters:
    ///   - origin: Center point of the ripple.
    ///   - amplitude: Distortion strength.
    ///   - frequency: Wave frequency.
    ///   - decay: Distance decay.
    ///   - speed: Animation speed multiplier.
    public init(
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        amplitude: Double = 0.02,
        frequency: Double = 15.0,
        decay: Double = 8.0,
        speed: Double = 1.0
    ) {
        self.origin = origin
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * speed
            content.distortionEffect(
                ShaderLibrary.ripple(
                    .float(time),
                    .float(origin.x),
                    .float(origin.y),
                    .float(amplitude),
                    .float(frequency),
                    .float(decay)
                ),
                maxSampleOffset: CGSize(width: 50, height: 50)
            )
        }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies a multi-ripple effect with multiple wave sources.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - count: Number of ripple sources.
    ///   - amplitude: Distortion strength.
    ///   - frequency: Wave frequency.
    ///   - decay: Distance decay.
    /// - Returns: A view with multi-ripple effect.
    func multiRippleEffect(
        time: Double,
        count: Double = 3.0,
        amplitude: Double = 0.03,
        frequency: Double = 12.0,
        decay: Double = 6.0
    ) -> some View {
        modifier(MultiRippleModifier(
            time: time,
            rippleCount: count,
            amplitude: amplitude,
            frequency: frequency,
            decay: decay
        ))
    }
    
    /// Applies a self-animating ripple effect.
    /// - Parameters:
    ///   - origin: Center point of the ripple.
    ///   - amplitude: Distortion strength.
    ///   - frequency: Wave frequency.
    ///   - decay: Distance decay.
    ///   - speed: Animation speed.
    /// - Returns: A view with animated ripple effect.
    func animatedRipple(
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        amplitude: Double = 0.02,
        frequency: Double = 15.0,
        decay: Double = 8.0,
        speed: Double = 1.0
    ) -> some View {
        modifier(AnimatedRippleModifier(
            origin: origin,
            amplitude: amplitude,
            frequency: frequency,
            decay: decay,
            speed: speed
        ))
    }
}

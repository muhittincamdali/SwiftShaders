import Foundation

/// The time an animated effect is drawn at.
///
/// Animated effects such as ``SwiftUICore/View/wave(amplitude:wavelength:speed:time:)`` take a
/// `time` argument. With ``animated`` the effect runs by itself; with ``fixed(_:)`` it shows a
/// single frame, which is useful for previews, snapshots and effects you drive yourself.
///
/// ```swift
/// Text("Breaking news")
///     .glitch(intensity: 0.4)                  // animates
///
/// Text("Breaking news")
///     .glitch(intensity: 0.4, time: .fixed(2)) // the frame at two seconds
/// ```
///
/// When Reduce Motion is on, animated effects stop and show their first frame.
public struct ShaderTime: Sendable, Hashable {
    enum Mode: Sendable, Hashable {
        case animated(speed: Double)
        case fixed(TimeInterval)
    }

    let mode: Mode

    /// Runs the effect from the moment the view appears, at normal speed.
    public static let animated = ShaderTime(mode: .animated(speed: 1))

    /// Runs the effect from the moment the view appears; `speed` 2 runs it twice as fast and
    /// negative speeds run it backward. The speed is limited to -1,000...1,000.
    public static func animated(speed: Double) -> ShaderTime {
        let speed = ShaderInput.finite(speed, otherwise: 1)
        return ShaderTime(mode: .animated(speed: ShaderInput.clamped(speed, to: -1_000...1_000)))
    }

    /// Shows the frame `seconds` after the start of the effect.
    ///
    /// Like animated time, fixed time repeats every hour: `.fixed(3_605)` shows the same frame as
    /// `.fixed(5)`.
    public static func fixed(_ seconds: TimeInterval) -> ShaderTime {
        ShaderTime(mode: .fixed(ShaderClock.wrapped(ShaderInput.finite(seconds, otherwise: 0))))
    }

    /// The speed of an animated time, or `nil` for a fixed one.
    var animationSpeed: Double? {
        if case .animated(let speed) = mode { return speed }
        return nil
    }

    /// The time to draw when the effect is not running: the fixed time, or 0.
    var stillTime: TimeInterval {
        if case .fixed(let seconds) = mode { return seconds }
        return 0
    }
}

/// Converts wall-clock dates into the time value passed to shaders.
enum ShaderClock {
    /// Shaders compute in 32-bit floats, which lose precision as numbers grow. Wrapping the time
    /// every hour keeps the step between frames accurate to well under a millisecond.
    static let period: TimeInterval = 3600

    /// Seconds since `start`, scaled by `speed` and wrapped to ``period``. Never negative.
    static func elapsed(from start: Date, to now: Date, speed: Double) -> Double {
        let seconds = ShaderInput.finite(max(0, now.timeIntervalSince(start)), otherwise: 0)
        // Wrapping before multiplying keeps the product finite for any speed.
        return wrapped(wrapped(seconds) * ShaderInput.finite(speed, otherwise: 1))
    }

    /// `seconds` wrapped into `0..<period`.
    static func wrapped(_ seconds: Double) -> Double {
        guard seconds.isFinite else { return 0 }
        let remainder = seconds.truncatingRemainder(dividingBy: period)
        return remainder < 0 ? remainder + period : remainder
    }
}

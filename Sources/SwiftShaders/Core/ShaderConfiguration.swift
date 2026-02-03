import SwiftUI

// MARK: - ShaderConfiguration

/// Configuration options for shader effects.
///
/// Use `ShaderConfiguration` to customize shader behavior, performance settings,
/// and rendering options.
///
/// ## Overview
///
/// ```swift
/// let config = ShaderConfiguration(
///     quality: .high,
///     samplingMode: .bilinear,
///     blendMode: .normal
/// )
///
/// Image("photo")
///     .rippleEffect(time: time, configuration: config)
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderConfiguration: Sendable, Equatable {
    
    // MARK: - Quality Levels
    
    /// Quality presets for shader rendering.
    public enum Quality: String, CaseIterable, Sendable {
        /// Low quality, best performance.
        case low
        /// Balanced quality and performance.
        case medium
        /// High quality, may impact performance.
        case high
        /// Maximum quality, slowest performance.
        case ultra
        
        /// The sampling multiplier for this quality level.
        public var samplingMultiplier: Double {
            switch self {
            case .low: return 0.5
            case .medium: return 1.0
            case .high: return 1.5
            case .ultra: return 2.0
            }
        }
        
        /// The iteration count for multi-pass effects.
        public var iterationCount: Int {
            switch self {
            case .low: return 4
            case .medium: return 8
            case .high: return 16
            case .ultra: return 32
            }
        }
    }
    
    // MARK: - Sampling Modes
    
    /// Texture sampling modes for shader effects.
    public enum SamplingMode: String, CaseIterable, Sendable {
        /// Nearest neighbor sampling (pixelated).
        case nearest
        /// Bilinear interpolation (smooth).
        case bilinear
        /// Bicubic interpolation (smoother, slower).
        case bicubic
    }
    
    // MARK: - Blend Modes
    
    /// Blend modes for combining shader output with original content.
    public enum BlendMode: String, CaseIterable, Sendable {
        /// Normal blending (replace).
        case normal
        /// Additive blending.
        case additive
        /// Multiplicative blending.
        case multiply
        /// Screen blending.
        case screen
        /// Overlay blending.
        case overlay
        /// Soft light blending.
        case softLight
        /// Hard light blending.
        case hardLight
        /// Difference blending.
        case difference
        /// Exclusion blending.
        case exclusion
        
        /// The blend factor array for this mode.
        public var blendFactors: [Float] {
            switch self {
            case .normal: return [1, 0, 0, 0]
            case .additive: return [1, 1, 0, 0]
            case .multiply: return [0, 0, 1, 0]
            case .screen: return [1, 1, -1, 0]
            case .overlay: return [2, -1, 0, 1]
            case .softLight: return [1, 0.5, 0.5, 0]
            case .hardLight: return [2, 0, -1, 1]
            case .difference: return [1, -1, 0, 1]
            case .exclusion: return [1, 1, -2, 0]
            }
        }
    }
    
    // MARK: - Edge Handling
    
    /// How to handle edges when sampling outside bounds.
    public enum EdgeMode: String, CaseIterable, Sendable {
        /// Clamp to edge color.
        case clamp
        /// Repeat texture.
        case `repeat`
        /// Mirror texture at edges.
        case mirror
        /// Transparent outside bounds.
        case transparent
    }
    
    // MARK: - Properties
    
    /// The rendering quality level.
    public var quality: Quality
    
    /// The texture sampling mode.
    public var samplingMode: SamplingMode
    
    /// The blend mode for output.
    public var blendMode: BlendMode
    
    /// How to handle texture edges.
    public var edgeMode: EdgeMode
    
    /// The opacity of the shader effect (0-1).
    public var opacity: Double
    
    /// Whether to enable high dynamic range.
    public var enableHDR: Bool
    
    /// Maximum distortion offset for distortion effects.
    public var maxDistortionOffset: CGSize
    
    /// Custom parameters dictionary for shader-specific settings.
    public var customParameters: [String: Double]
    
    // MARK: - Initialization
    
    /// Creates a shader configuration with the specified options.
    /// - Parameters:
    ///   - quality: Rendering quality level.
    ///   - samplingMode: Texture sampling mode.
    ///   - blendMode: Output blend mode.
    ///   - edgeMode: Edge handling mode.
    ///   - opacity: Effect opacity.
    ///   - enableHDR: Whether to enable HDR.
    ///   - maxDistortionOffset: Maximum distortion offset.
    ///   - customParameters: Custom shader parameters.
    public init(
        quality: Quality = .medium,
        samplingMode: SamplingMode = .bilinear,
        blendMode: BlendMode = .normal,
        edgeMode: EdgeMode = .clamp,
        opacity: Double = 1.0,
        enableHDR: Bool = false,
        maxDistortionOffset: CGSize = CGSize(width: 100, height: 100),
        customParameters: [String: Double] = [:]
    ) {
        self.quality = quality
        self.samplingMode = samplingMode
        self.blendMode = blendMode
        self.edgeMode = edgeMode
        self.opacity = opacity.clamped(to: 0...1)
        self.enableHDR = enableHDR
        self.maxDistortionOffset = maxDistortionOffset
        self.customParameters = customParameters
    }
    
    // MARK: - Presets
    
    /// Default configuration with balanced settings.
    public static let `default` = ShaderConfiguration()
    
    /// Configuration optimized for performance.
    public static let performance = ShaderConfiguration(
        quality: .low,
        samplingMode: .nearest,
        blendMode: .normal,
        edgeMode: .clamp
    )
    
    /// Configuration optimized for quality.
    public static let highQuality = ShaderConfiguration(
        quality: .high,
        samplingMode: .bicubic,
        blendMode: .normal,
        edgeMode: .clamp,
        enableHDR: true
    )
    
    /// Configuration for retro/pixel art effects.
    public static let pixelArt = ShaderConfiguration(
        quality: .low,
        samplingMode: .nearest,
        blendMode: .normal,
        edgeMode: .clamp
    )
    
    /// Configuration for smooth gradients.
    public static let smooth = ShaderConfiguration(
        quality: .high,
        samplingMode: .bicubic,
        blendMode: .normal,
        edgeMode: .mirror
    )
}

// MARK: - Comparable Extension for Clamping

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - AnimationConfiguration

/// Configuration for shader animations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct AnimationConfiguration: Sendable, Equatable {
    
    // MARK: - Animation Curves
    
    /// Easing curves for shader animations.
    public enum EasingCurve: String, CaseIterable, Sendable {
        /// Linear interpolation.
        case linear
        /// Ease in (slow start).
        case easeIn
        /// Ease out (slow end).
        case easeOut
        /// Ease in and out.
        case easeInOut
        /// Elastic bounce effect.
        case elastic
        /// Bounce effect.
        case bounce
        /// Back overshoot effect.
        case back
        
        /// Applies the easing function to a normalized time value.
        /// - Parameter t: Normalized time (0-1).
        /// - Returns: Eased value (0-1).
        public func apply(_ t: Double) -> Double {
            switch self {
            case .linear:
                return t
            case .easeIn:
                return t * t
            case .easeOut:
                return 1 - (1 - t) * (1 - t)
            case .easeInOut:
                return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
            case .elastic:
                let c4 = (2 * .pi) / 3
                return t == 0 ? 0 : t == 1 ? 1 : pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
            case .bounce:
                let n1 = 7.5625
                let d1 = 2.75
                var t = t
                if t < 1 / d1 {
                    return n1 * t * t
                } else if t < 2 / d1 {
                    t -= 1.5 / d1
                    return n1 * t * t + 0.75
                } else if t < 2.5 / d1 {
                    t -= 2.25 / d1
                    return n1 * t * t + 0.9375
                } else {
                    t -= 2.625 / d1
                    return n1 * t * t + 0.984375
                }
            case .back:
                let c1 = 1.70158
                let c3 = c1 + 1
                return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2)
            }
        }
    }
    
    // MARK: - Properties
    
    /// Duration of the animation in seconds.
    public var duration: Double
    
    /// Delay before starting the animation.
    public var delay: Double
    
    /// The easing curve to use.
    public var easingCurve: EasingCurve
    
    /// Whether the animation should loop.
    public var loops: Bool
    
    /// Number of times to loop (0 = infinite).
    public var loopCount: Int
    
    /// Whether to reverse the animation on completion.
    public var autoReverse: Bool
    
    // MARK: - Initialization
    
    /// Creates an animation configuration.
    /// - Parameters:
    ///   - duration: Animation duration.
    ///   - delay: Start delay.
    ///   - easingCurve: Easing curve.
    ///   - loops: Whether to loop.
    ///   - loopCount: Number of loops.
    ///   - autoReverse: Whether to auto-reverse.
    public init(
        duration: Double = 1.0,
        delay: Double = 0.0,
        easingCurve: EasingCurve = .easeInOut,
        loops: Bool = false,
        loopCount: Int = 0,
        autoReverse: Bool = false
    ) {
        self.duration = max(0, duration)
        self.delay = max(0, delay)
        self.easingCurve = easingCurve
        self.loops = loops
        self.loopCount = max(0, loopCount)
        self.autoReverse = autoReverse
    }
    
    // MARK: - Presets
    
    /// Quick animation (0.3s).
    public static let quick = AnimationConfiguration(duration: 0.3)
    
    /// Default animation (0.5s).
    public static let `default` = AnimationConfiguration(duration: 0.5)
    
    /// Slow animation (1.0s).
    public static let slow = AnimationConfiguration(duration: 1.0)
    
    /// Continuous looping animation.
    public static let continuous = AnimationConfiguration(
        duration: 2.0,
        loops: true
    )
    
    /// Pulsing animation that loops and reverses.
    public static let pulse = AnimationConfiguration(
        duration: 1.0,
        loops: true,
        autoReverse: true
    )
}

import SwiftUI

// MARK: - WaveModifier

/// A view modifier that applies wave distortion effects.
///
/// Creates smooth, periodic wave patterns that can animate horizontally
/// or vertically through the view.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(WaveModifier(
///         time: animationTime,
///         amplitude: 0.02,
///         frequency: 10.0,
///         direction: 0.0
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct WaveModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Wave height/strength.
    public var amplitude: Double
    
    /// Number of wave cycles.
    public var frequency: Double
    
    /// Wave direction (0 = horizontal, 1 = vertical).
    public var direction: Double
    
    // MARK: - Initialization
    
    /// Creates a wave modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - amplitude: Wave strength (default: 0.02).
    ///   - frequency: Wave frequency (default: 10.0).
    ///   - direction: 0 for horizontal, 1 for vertical (default: 0).
    public init(
        time: Double,
        amplitude: Double = 0.02,
        frequency: Double = 10.0,
        direction: Double = 0.0
    ) {
        self.time = time
        self.amplitude = amplitude
        self.frequency = frequency
        self.direction = direction
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.wave(
                .float(time),
                .float(amplitude),
                .float(frequency),
                .float(direction)
            ),
            maxSampleOffset: CGSize(width: 30, height: 30)
        )
    }
}

// MARK: - MultiWaveModifier

/// Combines horizontal and vertical waves.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MultiWaveModifier: ViewModifier {
    
    public var time: Double
    public var amplitudeX: Double
    public var amplitudeY: Double
    public var frequencyX: Double
    public var frequencyY: Double
    public var speed: Double
    
    /// Creates a multi-wave modifier.
    public init(
        time: Double,
        amplitudeX: Double = 0.02,
        amplitudeY: Double = 0.02,
        frequencyX: Double = 8.0,
        frequencyY: Double = 6.0,
        speed: Double = 3.0
    ) {
        self.time = time
        self.amplitudeX = amplitudeX
        self.amplitudeY = amplitudeY
        self.frequencyX = frequencyX
        self.frequencyY = frequencyY
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.multiWave(
                .float(time),
                .float(amplitudeX),
                .float(amplitudeY),
                .float(frequencyX),
                .float(frequencyY),
                .float(speed)
            ),
            maxSampleOffset: CGSize(width: 40, height: 40)
        )
    }
}

// MARK: - RadialWaveModifier

/// Creates circular waves from a center point.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RadialWaveModifier: ViewModifier {
    
    public var time: Double
    public var amplitude: Double
    public var frequency: Double
    public var center: CGPoint
    
    /// Creates a radial wave modifier.
    public init(
        time: Double,
        amplitude: Double = 0.5,
        frequency: Double = 1.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) {
        self.time = time
        self.amplitude = amplitude
        self.frequency = frequency
        self.center = center
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.radialWave(
                .float(time),
                .float(amplitude),
                .float(frequency),
                .float(center.x),
                .float(center.y)
            ),
            maxSampleOffset: CGSize(width: 50, height: 50)
        )
    }
}

// MARK: - FlagWaveModifier

/// Simulates flag/cloth waving in wind.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FlagWaveModifier: ViewModifier {
    
    public var time: Double
    public var amplitude: Double
    public var frequency: Double
    public var windSpeed: Double
    
    /// Creates a flag wave modifier.
    public init(
        time: Double,
        amplitude: Double = 0.03,
        frequency: Double = 2.0,
        windSpeed: Double = 5.0
    ) {
        self.time = time
        self.amplitude = amplitude
        self.frequency = frequency
        self.windSpeed = windSpeed
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.flagWave(
                .float(time),
                .float(amplitude),
                .float(frequency),
                .float(windSpeed)
            ),
            maxSampleOffset: CGSize(width: 10, height: 60)
        )
    }
}

// MARK: - LiquidWaveModifier

/// Simulates liquid surface distortion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct LiquidWaveModifier: ViewModifier {
    
    public var time: Double
    public var amplitude: Double
    public var turbulence: Double
    public var viscosity: Double
    
    /// Creates a liquid wave modifier.
    public init(
        time: Double,
        amplitude: Double = 0.3,
        turbulence: Double = 0.1,
        viscosity: Double = 0.5
    ) {
        self.time = time
        self.amplitude = amplitude
        self.turbulence = turbulence
        self.viscosity = viscosity
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.liquidWave(
                .float(time),
                .float(amplitude),
                .float(turbulence),
                .float(viscosity)
            ),
            maxSampleOffset: CGSize(width: 30, height: 30)
        )
    }
}

// MARK: - JellyWaveModifier

/// Creates jelly/gelatin wobble effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct JellyWaveModifier: ViewModifier {
    
    public var time: Double
    public var amplitude: Double
    public var stiffness: Double
    public var damping: Double
    
    /// Creates a jelly wave modifier.
    public init(
        time: Double,
        amplitude: Double = 0.1,
        stiffness: Double = 2.0,
        damping: Double = 0.5
    ) {
        self.time = time
        self.amplitude = amplitude
        self.stiffness = stiffness
        self.damping = damping
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.jellyWave(
                .float(time),
                .float(amplitude),
                .float(stiffness),
                .float(damping)
            ),
            maxSampleOffset: CGSize(width: 40, height: 40)
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies multi-directional wave effect.
    func multiWave(
        time: Double,
        amplitudeX: Double = 0.02,
        amplitudeY: Double = 0.02,
        frequencyX: Double = 8.0,
        frequencyY: Double = 6.0,
        speed: Double = 3.0
    ) -> some View {
        modifier(MultiWaveModifier(
            time: time,
            amplitudeX: amplitudeX,
            amplitudeY: amplitudeY,
            frequencyX: frequencyX,
            frequencyY: frequencyY,
            speed: speed
        ))
    }
    
    /// Applies radial wave effect.
    func radialWave(
        time: Double,
        amplitude: Double = 0.5,
        frequency: Double = 1.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) -> some View {
        modifier(RadialWaveModifier(
            time: time,
            amplitude: amplitude,
            frequency: frequency,
            center: center
        ))
    }
    
    /// Applies flag wave effect.
    func flagWave(
        time: Double,
        amplitude: Double = 0.03,
        frequency: Double = 2.0,
        windSpeed: Double = 5.0
    ) -> some View {
        modifier(FlagWaveModifier(
            time: time,
            amplitude: amplitude,
            frequency: frequency,
            windSpeed: windSpeed
        ))
    }
    
    /// Applies liquid wave effect.
    func liquidWave(
        time: Double,
        amplitude: Double = 0.3,
        turbulence: Double = 0.1,
        viscosity: Double = 0.5
    ) -> some View {
        modifier(LiquidWaveModifier(
            time: time,
            amplitude: amplitude,
            turbulence: turbulence,
            viscosity: viscosity
        ))
    }
    
    /// Applies jelly wobble effect.
    func jellyWave(
        time: Double,
        amplitude: Double = 0.1,
        stiffness: Double = 2.0,
        damping: Double = 0.5
    ) -> some View {
        modifier(JellyWaveModifier(
            time: time,
            amplitude: amplitude,
            stiffness: stiffness,
            damping: damping
        ))
    }
}

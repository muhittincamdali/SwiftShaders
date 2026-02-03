import SwiftUI

// MARK: - WaterSurfaceModifier

/// A view modifier that applies water surface distortion.
///
/// Creates realistic water ripple and wave patterns.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct WaterSurfaceModifier: ViewModifier {
    
    public var time: Double
    public var amplitude: Double
    public var frequency: Double
    public var speed: Double
    
    /// Creates a water surface modifier.
    public init(
        time: Double,
        amplitude: Double = 0.5,
        frequency: Double = 1.0,
        speed: Double = 1.0
    ) {
        self.time = time
        self.amplitude = amplitude
        self.frequency = frequency
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.waterSurface(
                .float(time),
                .float(amplitude),
                .float(frequency),
                .float(speed)
            ),
            maxSampleOffset: CGSize(width: 20, height: 20)
        )
    }
}

// MARK: - WaterReflectionModifier

/// Adds water reflection effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct WaterReflectionModifier: ViewModifier {
    
    public var time: Double
    public var reflectivity: Double
    public var distortion: Double
    
    /// Creates a water reflection modifier.
    public init(
        time: Double,
        reflectivity: Double = 0.5,
        distortion: Double = 0.3
    ) {
        self.time = time
        self.reflectivity = reflectivity
        self.distortion = distortion
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.waterReflection(
                .float(time),
                .float(reflectivity),
                .float(distortion)
            )
        )
    }
}

// MARK: - CausticsModifier

/// Applies underwater caustic light patterns.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct CausticsModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var intensity: Double
    
    /// Creates a caustics modifier.
    public init(
        time: Double,
        scale: Double = 5.0,
        intensity: Double = 0.5
    ) {
        self.time = time
        self.scale = scale
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.caustics(
                .float(time),
                .float(scale),
                .float(intensity)
            )
        )
    }
}

// MARK: - OceanWavesModifier

/// Creates ocean wave patterns.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct OceanWavesModifier: ViewModifier {
    
    public var time: Double
    public var waveHeight: Double
    public var waveLength: Double
    public var foamThreshold: Double
    
    /// Creates an ocean waves modifier.
    public init(
        time: Double,
        waveHeight: Double = 0.3,
        waveLength: Double = 1.0,
        foamThreshold: Double = 0.5
    ) {
        self.time = time
        self.waveHeight = waveHeight
        self.waveLength = waveLength
        self.foamThreshold = foamThreshold
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.oceanWaves(
                .float(time),
                .float(waveHeight),
                .float(waveLength),
                .float(foamThreshold)
            )
        )
    }
}

// MARK: - RainDropsModifier

/// Creates rain drop ripple effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RainDropsModifier: ViewModifier {
    
    public var time: Double
    public var dropDensity: Double
    public var dropSize: Double
    public var rippleSpeed: Double
    
    /// Creates a rain drops modifier.
    public init(
        time: Double,
        dropDensity: Double = 10.0,
        dropSize: Double = 0.1,
        rippleSpeed: Double = 0.5
    ) {
        self.time = time
        self.dropDensity = dropDensity
        self.dropSize = dropSize
        self.rippleSpeed = rippleSpeed
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.rainDrops(
                .float(time),
                .float(dropDensity),
                .float(dropSize),
                .float(rippleSpeed)
            )
        )
    }
}

// MARK: - UnderwaterModifier

/// Creates underwater view effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct UnderwaterModifier: ViewModifier {
    
    public var time: Double
    public var depth: Double
    public var murkiness: Double
    
    /// Creates an underwater modifier.
    public init(
        time: Double,
        depth: Double = 0.5,
        murkiness: Double = 0.3
    ) {
        self.time = time
        self.depth = depth
        self.murkiness = murkiness
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.underwater(
                .float(time),
                .float(depth),
                .float(murkiness)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies water surface distortion.
    func waterSurface(
        time: Double,
        amplitude: Double = 0.5,
        frequency: Double = 1.0,
        speed: Double = 1.0
    ) -> some View {
        modifier(WaterSurfaceModifier(
            time: time,
            amplitude: amplitude,
            frequency: frequency,
            speed: speed
        ))
    }
    
    /// Applies water reflection.
    func waterReflection(
        time: Double,
        reflectivity: Double = 0.5,
        distortion: Double = 0.3
    ) -> some View {
        modifier(WaterReflectionModifier(
            time: time,
            reflectivity: reflectivity,
            distortion: distortion
        ))
    }
    
    /// Applies caustics effect.
    func caustics(
        time: Double,
        scale: Double = 5.0,
        intensity: Double = 0.5
    ) -> some View {
        modifier(CausticsModifier(time: time, scale: scale, intensity: intensity))
    }
    
    /// Applies ocean waves effect.
    func oceanWaves(
        time: Double,
        waveHeight: Double = 0.3,
        waveLength: Double = 1.0,
        foamThreshold: Double = 0.5
    ) -> some View {
        modifier(OceanWavesModifier(
            time: time,
            waveHeight: waveHeight,
            waveLength: waveLength,
            foamThreshold: foamThreshold
        ))
    }
    
    /// Applies rain drops effect.
    func rainDrops(
        time: Double,
        density: Double = 10.0,
        size: Double = 0.1,
        rippleSpeed: Double = 0.5
    ) -> some View {
        modifier(RainDropsModifier(
            time: time,
            dropDensity: density,
            dropSize: size,
            rippleSpeed: rippleSpeed
        ))
    }
    
    /// Applies underwater effect.
    func underwater(
        time: Double,
        depth: Double = 0.5,
        murkiness: Double = 0.3
    ) -> some View {
        modifier(UnderwaterModifier(
            time: time,
            depth: depth,
            murkiness: murkiness
        ))
    }
}

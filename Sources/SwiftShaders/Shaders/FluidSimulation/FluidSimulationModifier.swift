import SwiftUI

// MARK: - FluidSimulationModifier

/// A view modifier that applies fluid dynamics simulation effects.
///
/// Simulates realistic fluid behavior including flow, turbulence,
/// and interaction patterns.
///
/// ## Overview
///
/// ```swift
/// Rectangle()
///     .modifier(FluidSimulationModifier(
///         time: animationTime,
///         viscosity: 0.5,
///         turbulence: 0.3
///     ))
/// ```
///
/// ## Topics
///
/// ### Creating Effects
/// - ``init(time:viscosity:turbulence:flowSpeed:)``
/// - ``SmokeModifier``
/// - ``WaterSurfaceModifier``
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FluidSimulationModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time for fluid motion.
    public var time: Double
    
    /// Fluid viscosity (thickness).
    public var viscosity: Double
    
    /// Turbulence intensity.
    public var turbulence: Double
    
    /// Base flow speed.
    public var flowSpeed: Double
    
    /// Primary fluid hue.
    public var hue: Double
    
    /// Flow direction angle in radians.
    public var flowAngle: Double
    
    // MARK: - Initialization
    
    /// Creates a fluid simulation modifier.
    /// - Parameters:
    ///   - time: Animation time value.
    ///   - viscosity: Fluid viscosity 0-1 (default: 0.5).
    ///   - turbulence: Turbulence intensity (default: 0.3).
    ///   - flowSpeed: Base flow speed (default: 1.0).
    ///   - hue: Primary hue 0-1 (default: 0.6).
    ///   - flowAngle: Flow direction angle (default: 0).
    public init(
        time: Double,
        viscosity: Double = 0.5,
        turbulence: Double = 0.3,
        flowSpeed: Double = 1.0,
        hue: Double = 0.6,
        flowAngle: Double = 0.0
    ) {
        self.time = time
        self.viscosity = viscosity
        self.turbulence = turbulence
        self.flowSpeed = flowSpeed
        self.hue = hue
        self.flowAngle = flowAngle
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.fluidSimulation(
                .float(time),
                .float(viscosity),
                .float(turbulence),
                .float(flowSpeed),
                .float(hue),
                .float(flowAngle)
            )
        )
    }
}

// MARK: - SmokeModifier

/// Creates realistic smoke and vapor effects.
///
/// Simulates rising smoke particles with proper diffusion
/// and turbulent motion patterns.
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .modifier(SmokeModifier(
///         time: animationTime,
///         density: 0.5,
///         riseSpeed: 0.3
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SmokeModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Smoke density.
    public var density: Double
    
    /// Upward rise speed.
    public var riseSpeed: Double
    
    /// Horizontal spread rate.
    public var spread: Double
    
    /// Turbulence intensity.
    public var turbulence: Double
    
    /// Smoke color darkness.
    public var darkness: Double
    
    // MARK: - Initialization
    
    /// Creates a smoke modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - density: Smoke density (default: 0.5).
    ///   - riseSpeed: Rise speed (default: 0.3).
    ///   - spread: Horizontal spread (default: 0.2).
    ///   - turbulence: Turbulence intensity (default: 0.5).
    ///   - darkness: Smoke darkness 0-1 (default: 0.3).
    public init(
        time: Double,
        density: Double = 0.5,
        riseSpeed: Double = 0.3,
        spread: Double = 0.2,
        turbulence: Double = 0.5,
        darkness: Double = 0.3
    ) {
        self.time = time
        self.density = density
        self.riseSpeed = riseSpeed
        self.spread = spread
        self.turbulence = turbulence
        self.darkness = darkness
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.smoke(
                .float(time),
                .float(density),
                .float(riseSpeed),
                .float(spread),
                .float(turbulence),
                .float(darkness)
            )
        )
    }
}

// MARK: - WaterSurfaceModifier

/// Creates realistic water surface effects.
///
/// Simulates water with waves, reflections, and caustics
/// for realistic aquatic scenes.
///
/// ## Usage
///
/// ```swift
/// Image("background")
///     .modifier(WaterSurfaceModifier(
///         time: animationTime,
///         waveHeight: 0.05,
///         waveFrequency: 3.0
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct WaterSurfaceModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Wave height amplitude.
    public var waveHeight: Double
    
    /// Wave frequency.
    public var waveFrequency: Double
    
    /// Wave propagation speed.
    public var waveSpeed: Double
    
    /// Surface reflection intensity.
    public var reflectivity: Double
    
    /// Water tint hue.
    public var waterHue: Double
    
    // MARK: - Initialization
    
    /// Creates a water surface modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - waveHeight: Wave amplitude (default: 0.03).
    ///   - waveFrequency: Wave frequency (default: 5.0).
    ///   - waveSpeed: Wave speed (default: 1.0).
    ///   - reflectivity: Reflection strength (default: 0.3).
    ///   - waterHue: Water tint hue (default: 0.55).
    public init(
        time: Double,
        waveHeight: Double = 0.03,
        waveFrequency: Double = 5.0,
        waveSpeed: Double = 1.0,
        reflectivity: Double = 0.3,
        waterHue: Double = 0.55
    ) {
        self.time = time
        self.waveHeight = waveHeight
        self.waveFrequency = waveFrequency
        self.waveSpeed = waveSpeed
        self.reflectivity = reflectivity
        self.waterHue = waterHue
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.waterSurface(
                .float(time),
                .float(waveHeight),
                .float(waveFrequency),
                .float(waveSpeed),
                .float(reflectivity),
                .float(waterHue)
            )
        )
    }
}

// MARK: - InkDiffusionModifier

/// Creates ink diffusion in water effect.
///
/// Simulates the organic spreading pattern of ink or dye
/// diffusing through liquid medium.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct InkDiffusionModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Ink drop position.
    public var dropPosition: CGPoint
    
    /// Diffusion rate.
    public var diffusionRate: Double
    
    /// Ink concentration.
    public var concentration: Double
    
    /// Ink color hue.
    public var inkHue: Double
    
    /// Turbulent mixing intensity.
    public var mixing: Double
    
    // MARK: - Initialization
    
    /// Creates an ink diffusion modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - dropPosition: Ink drop center (default: center).
    ///   - diffusionRate: Spread rate (default: 0.5).
    ///   - concentration: Ink density (default: 0.8).
    ///   - inkHue: Ink color hue (default: 0.7).
    ///   - mixing: Turbulent mixing (default: 0.3).
    public init(
        time: Double,
        dropPosition: CGPoint = CGPoint(x: 0.5, y: 0.5),
        diffusionRate: Double = 0.5,
        concentration: Double = 0.8,
        inkHue: Double = 0.7,
        mixing: Double = 0.3
    ) {
        self.time = time
        self.dropPosition = dropPosition
        self.diffusionRate = diffusionRate
        self.concentration = concentration
        self.inkHue = inkHue
        self.mixing = mixing
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.inkDiffusion(
                .float(time),
                .float(dropPosition.x),
                .float(dropPosition.y),
                .float(diffusionRate),
                .float(concentration),
                .float(inkHue),
                .float(mixing)
            )
        )
    }
}

// MARK: - PlasmaFluidModifier

/// Creates plasma-like fluid effects.
///
/// Generates colorful, organic plasma patterns with
/// smooth color transitions and flowing motion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PlasmaFluidModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Pattern complexity.
    public var complexity: Double
    
    /// Color cycling speed.
    public var colorSpeed: Double
    
    /// Pattern scale.
    public var scale: Double
    
    /// Color saturation.
    public var saturation: Double
    
    /// Brightness level.
    public var brightness: Double
    
    // MARK: - Initialization
    
    /// Creates a plasma fluid modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - complexity: Pattern complexity (default: 3.0).
    ///   - colorSpeed: Color change speed (default: 0.5).
    ///   - scale: Pattern scale (default: 1.0).
    ///   - saturation: Color saturation (default: 1.0).
    ///   - brightness: Brightness level (default: 1.0).
    public init(
        time: Double,
        complexity: Double = 3.0,
        colorSpeed: Double = 0.5,
        scale: Double = 1.0,
        saturation: Double = 1.0,
        brightness: Double = 1.0
    ) {
        self.time = time
        self.complexity = complexity
        self.colorSpeed = colorSpeed
        self.scale = scale
        self.saturation = saturation
        self.brightness = brightness
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.plasmaFluid(
                .float(time),
                .float(complexity),
                .float(colorSpeed),
                .float(scale),
                .float(saturation),
                .float(brightness)
            )
        )
    }
}

// MARK: - MagneticFieldModifier

/// Creates magnetic field visualization effects.
///
/// Visualizes magnetic field lines with flowing particles
/// and proper field behavior around poles.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MagneticFieldModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Number of field poles.
    public var poleCount: Int
    
    /// Field line density.
    public var lineDensity: Double
    
    /// Particle flow speed.
    public var flowSpeed: Double
    
    /// Field strength.
    public var strength: Double
    
    /// Line color hue.
    public var hue: Double
    
    // MARK: - Initialization
    
    /// Creates a magnetic field modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - poleCount: Number of poles (default: 2).
    ///   - lineDensity: Line density (default: 20.0).
    ///   - flowSpeed: Flow speed (default: 1.0).
    ///   - strength: Field strength (default: 1.0).
    ///   - hue: Line color hue (default: 0.6).
    public init(
        time: Double,
        poleCount: Int = 2,
        lineDensity: Double = 20.0,
        flowSpeed: Double = 1.0,
        strength: Double = 1.0,
        hue: Double = 0.6
    ) {
        self.time = time
        self.poleCount = min(max(poleCount, 1), 8)
        self.lineDensity = lineDensity
        self.flowSpeed = flowSpeed
        self.strength = strength
        self.hue = hue
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.magneticField(
                .float(time),
                .float(Double(poleCount)),
                .float(lineDensity),
                .float(flowSpeed),
                .float(strength),
                .float(hue)
            )
        )
    }
}

// MARK: - OilSlickModifier

/// Creates oil slick / thin film interference effects.
///
/// Simulates the iridescent color patterns seen in thin
/// oil films on water, creating rainbow-like reflections.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct OilSlickModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Film thickness variation.
    public var thicknessVariation: Double
    
    /// Surface movement speed.
    public var flowSpeed: Double
    
    /// Color intensity.
    public var colorIntensity: Double
    
    /// Pattern scale.
    public var scale: Double
    
    /// Distortion amount.
    public var distortion: Double
    
    // MARK: - Initialization
    
    /// Creates an oil slick modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - thicknessVariation: Film thickness range (default: 0.5).
    ///   - flowSpeed: Flow speed (default: 0.2).
    ///   - colorIntensity: Color intensity (default: 1.0).
    ///   - scale: Pattern scale (default: 3.0).
    ///   - distortion: Distortion amount (default: 0.3).
    public init(
        time: Double,
        thicknessVariation: Double = 0.5,
        flowSpeed: Double = 0.2,
        colorIntensity: Double = 1.0,
        scale: Double = 3.0,
        distortion: Double = 0.3
    ) {
        self.time = time
        self.thicknessVariation = thicknessVariation
        self.flowSpeed = flowSpeed
        self.colorIntensity = colorIntensity
        self.scale = scale
        self.distortion = distortion
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.oilSlick(
                .float(time),
                .float(thicknessVariation),
                .float(flowSpeed),
                .float(colorIntensity),
                .float(scale),
                .float(distortion)
            )
        )
    }
}

// MARK: - VortexModifier

/// Creates swirling vortex effects.
///
/// Generates spiral vortex patterns with configurable
/// rotation and suction strength.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VortexModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Vortex center position.
    public var center: CGPoint
    
    /// Rotation speed.
    public var rotationSpeed: Double
    
    /// Suction strength toward center.
    public var suctionStrength: Double
    
    /// Spiral arm count.
    public var spiralArms: Int
    
    /// Color hue.
    public var hue: Double
    
    // MARK: - Initialization
    
    /// Creates a vortex modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - center: Vortex center (default: center).
    ///   - rotationSpeed: Rotation speed (default: 1.0).
    ///   - suctionStrength: Suction strength (default: 0.5).
    ///   - spiralArms: Number of spiral arms (default: 3).
    ///   - hue: Color hue (default: 0.6).
    public init(
        time: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        rotationSpeed: Double = 1.0,
        suctionStrength: Double = 0.5,
        spiralArms: Int = 3,
        hue: Double = 0.6
    ) {
        self.time = time
        self.center = center
        self.rotationSpeed = rotationSpeed
        self.suctionStrength = suctionStrength
        self.spiralArms = min(max(spiralArms, 1), 12)
        self.hue = hue
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.vortex(
                .float(time),
                .float(center.x),
                .float(center.y),
                .float(rotationSpeed),
                .float(suctionStrength),
                .float(Double(spiralArms)),
                .float(hue)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies fluid simulation effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - viscosity: Fluid viscosity.
    ///   - turbulence: Turbulence intensity.
    /// - Returns: Modified view with fluid effect.
    func fluidSimulation(
        time: Double,
        viscosity: Double = 0.5,
        turbulence: Double = 0.3
    ) -> some View {
        modifier(FluidSimulationModifier(
            time: time,
            viscosity: viscosity,
            turbulence: turbulence
        ))
    }
    
    /// Applies smoke effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - density: Smoke density.
    ///   - riseSpeed: Upward speed.
    /// - Returns: Modified view with smoke effect.
    func smoke(
        time: Double,
        density: Double = 0.5,
        riseSpeed: Double = 0.3
    ) -> some View {
        modifier(SmokeModifier(
            time: time,
            density: density,
            riseSpeed: riseSpeed
        ))
    }
    
    /// Applies water surface effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - waveHeight: Wave amplitude.
    ///   - waveFrequency: Wave frequency.
    /// - Returns: Modified view with water surface effect.
    func waterSurface(
        time: Double,
        waveHeight: Double = 0.03,
        waveFrequency: Double = 5.0
    ) -> some View {
        modifier(WaterSurfaceModifier(
            time: time,
            waveHeight: waveHeight,
            waveFrequency: waveFrequency
        ))
    }
    
    /// Applies ink diffusion effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - dropPosition: Ink drop center.
    ///   - diffusionRate: Spread rate.
    /// - Returns: Modified view with ink diffusion effect.
    func inkDiffusion(
        time: Double,
        dropPosition: CGPoint = CGPoint(x: 0.5, y: 0.5),
        diffusionRate: Double = 0.5
    ) -> some View {
        modifier(InkDiffusionModifier(
            time: time,
            dropPosition: dropPosition,
            diffusionRate: diffusionRate
        ))
    }
    
    /// Applies plasma fluid effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - complexity: Pattern complexity.
    ///   - colorSpeed: Color cycling speed.
    /// - Returns: Modified view with plasma effect.
    func plasmaFluid(
        time: Double,
        complexity: Double = 3.0,
        colorSpeed: Double = 0.5
    ) -> some View {
        modifier(PlasmaFluidModifier(
            time: time,
            complexity: complexity,
            colorSpeed: colorSpeed
        ))
    }
    
    /// Applies magnetic field effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - poleCount: Number of magnetic poles.
    ///   - lineDensity: Field line density.
    /// - Returns: Modified view with magnetic field effect.
    func magneticField(
        time: Double,
        poleCount: Int = 2,
        lineDensity: Double = 20.0
    ) -> some View {
        modifier(MagneticFieldModifier(
            time: time,
            poleCount: poleCount,
            lineDensity: lineDensity
        ))
    }
    
    /// Applies oil slick effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - thicknessVariation: Film thickness variation.
    ///   - flowSpeed: Surface flow speed.
    /// - Returns: Modified view with oil slick effect.
    func oilSlick(
        time: Double,
        thicknessVariation: Double = 0.5,
        flowSpeed: Double = 0.2
    ) -> some View {
        modifier(OilSlickModifier(
            time: time,
            thicknessVariation: thicknessVariation,
            flowSpeed: flowSpeed
        ))
    }
    
    /// Applies vortex effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - center: Vortex center position.
    ///   - rotationSpeed: Rotation speed.
    /// - Returns: Modified view with vortex effect.
    func vortex(
        time: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        rotationSpeed: Double = 1.0
    ) -> some View {
        modifier(VortexModifier(
            time: time,
            center: center,
            rotationSpeed: rotationSpeed
        ))
    }
}

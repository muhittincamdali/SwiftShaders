import SwiftUI

// MARK: - FireModifier

/// A view modifier that applies procedural fire effects.
///
/// Creates realistic flame patterns using noise-based generation.
///
/// ## Overview
///
/// ```swift
/// Rectangle()
///     .modifier(FireModifier(
///         time: animationTime,
///         intensity: 1.0,
///         scale: 5.0,
///         speed: 1.0
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FireModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Fire brightness intensity.
    public var intensity: Double
    
    /// Fire pattern scale.
    public var scale: Double
    
    /// Upward animation speed.
    public var speed: Double
    
    // MARK: - Initialization
    
    /// Creates a fire modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - intensity: Fire intensity (default: 1.0).
    ///   - scale: Pattern scale (default: 5.0).
    ///   - speed: Animation speed (default: 1.0).
    public init(
        time: Double,
        intensity: Double = 1.0,
        scale: Double = 5.0,
        speed: Double = 1.0
    ) {
        self.time = time
        self.intensity = intensity
        self.scale = scale
        self.speed = speed
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.fire(
                .float(time),
                .float(intensity),
                .float(scale),
                .float(speed)
            )
        )
    }
}

// MARK: - TorchFlameModifier

/// Creates a torch/candle flame effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct TorchFlameModifier: ViewModifier {
    
    public var time: Double
    public var flameHeight: Double
    public var flameWidth: Double
    public var flickerSpeed: Double
    
    /// Creates a torch flame modifier.
    public init(
        time: Double,
        flameHeight: Double = 0.5,
        flameWidth: Double = 0.3,
        flickerSpeed: Double = 3.0
    ) {
        self.time = time
        self.flameHeight = flameHeight
        self.flameWidth = flameWidth
        self.flickerSpeed = flickerSpeed
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.torchFlame(
                .float(time),
                .float(flameHeight),
                .float(flameWidth),
                .float(flickerSpeed)
            )
        )
    }
}

// MARK: - FireballModifier

/// Creates an explosion fireball effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FireballModifier: ViewModifier {
    
    public var time: Double
    public var center: CGPoint
    public var radius: Double
    public var turbulence: Double
    
    /// Creates a fireball modifier.
    public init(
        time: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 0.3,
        turbulence: Double = 0.5
    ) {
        self.time = time
        self.center = center
        self.radius = radius
        self.turbulence = turbulence
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.fireball(
                .float(time),
                .float(center.x),
                .float(center.y),
                .float(radius),
                .float(turbulence)
            )
        )
    }
}

// MARK: - EmbersModifier

/// Creates floating ember particles.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct EmbersModifier: ViewModifier {
    
    public var time: Double
    public var density: Double
    public var speed: Double
    public var size: Double
    
    /// Creates an embers modifier.
    public init(
        time: Double,
        density: Double = 20.0,
        speed: Double = 0.3,
        size: Double = 0.05
    ) {
        self.time = time
        self.density = density
        self.speed = speed
        self.size = size
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.embers(
                .float(time),
                .float(density),
                .float(speed),
                .float(size)
            )
        )
    }
}

// MARK: - LavaModifier

/// Creates a lava/magma flow effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct LavaModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var flowSpeed: Double
    public var coolAmount: Double
    
    /// Creates a lava modifier.
    public init(
        time: Double,
        scale: Double = 3.0,
        flowSpeed: Double = 0.2,
        coolAmount: Double = 0.5
    ) {
        self.time = time
        self.scale = scale
        self.flowSpeed = flowSpeed
        self.coolAmount = coolAmount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.lava(
                .float(time),
                .float(scale),
                .float(flowSpeed),
                .float(coolAmount)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies fire effect.
    func fireEffect(
        time: Double,
        intensity: Double = 1.0,
        scale: Double = 5.0,
        speed: Double = 1.0
    ) -> some View {
        modifier(FireModifier(
            time: time,
            intensity: intensity,
            scale: scale,
            speed: speed
        ))
    }
    
    /// Applies torch flame effect.
    func torchFlame(
        time: Double,
        height: Double = 0.5,
        width: Double = 0.3,
        flickerSpeed: Double = 3.0
    ) -> some View {
        modifier(TorchFlameModifier(
            time: time,
            flameHeight: height,
            flameWidth: width,
            flickerSpeed: flickerSpeed
        ))
    }
    
    /// Applies fireball effect.
    func fireball(
        time: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Double = 0.3,
        turbulence: Double = 0.5
    ) -> some View {
        modifier(FireballModifier(
            time: time,
            center: center,
            radius: radius,
            turbulence: turbulence
        ))
    }
    
    /// Applies embers effect.
    func embers(
        time: Double,
        density: Double = 20.0,
        speed: Double = 0.3,
        size: Double = 0.05
    ) -> some View {
        modifier(EmbersModifier(
            time: time,
            density: density,
            speed: speed,
            size: size
        ))
    }
    
    /// Applies lava effect.
    func lavaEffect(
        time: Double,
        scale: Double = 3.0,
        flowSpeed: Double = 0.2,
        coolAmount: Double = 0.5
    ) -> some View {
        modifier(LavaModifier(
            time: time,
            scale: scale,
            flowSpeed: flowSpeed,
            coolAmount: coolAmount
        ))
    }
}

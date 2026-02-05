// Particles Effect Modifier
// SwiftUI wrapper for particle shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Particles Configuration

/// Particle effect type presets
public enum ParticleType: String, CaseIterable, Sendable {
    case sparkle    // Twinkling sparkles
    case snow       // Falling snowflakes
    case rain       // Falling rain
    case bubbles    // Rising bubbles
    case embers     // Rising embers
    case stars      // Star field
    case confetti   // Falling confetti
    case fireflies  // Wandering fireflies
    case dust       // Floating dust motes
}

/// Particles shader configuration
public struct ParticlesConfiguration: Sendable {
    /// Particle density
    public var density: Float
    
    /// Animation speed
    public var speed: Float
    
    /// Particle size
    public var particleSize: Float
    
    /// Particle color
    public var particleColor: Color
    
    /// Glow intensity
    public var intensity: Float
    
    /// Particle count (for fireflies)
    public var count: Float
    
    public init(
        density: Float = 50.0,
        speed: Float = 0.5,
        particleSize: Float = 0.05,
        particleColor: Color = .white,
        intensity: Float = 1.0,
        count: Float = 20.0
    ) {
        self.density = density
        self.speed = speed
        self.particleSize = particleSize
        self.particleColor = particleColor
        self.intensity = intensity
        self.count = count
    }
    
    // Presets
    public static let snow = ParticlesConfiguration(
        density: 30.0,
        speed: 0.3,
        particleSize: 0.08,
        particleColor: .white
    )
    
    public static let rain = ParticlesConfiguration(
        density: 50.0,
        speed: 1.0,
        particleSize: 0.03,
        particleColor: Color(white: 0.7)
    )
    
    public static let sparkle = ParticlesConfiguration(
        density: 40.0,
        particleColor: Color(red: 1.0, green: 0.95, blue: 0.8),
        intensity: 1.5
    )
    
    public static let embers = ParticlesConfiguration(
        density: 25.0,
        speed: 0.2,
        particleSize: 0.04,
        particleColor: .orange
    )
    
    public static let fireflies = ParticlesConfiguration(
        particleColor: Color(red: 0.8, green: 1.0, blue: 0.3),
        count: 15.0
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Sparkle particles
public struct SparkleModifier: ViewModifier {
    let configuration: ParticlesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ParticlesConfiguration = .sparkle) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.particleColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesSparkle(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.density),
                            .float3(r, g, b),
                            .float(configuration.intensity)
                        )
                    )
                }
        }
    }
}

/// Falling particles (snow/rain)
public struct FallingParticlesModifier: ViewModifier {
    let configuration: ParticlesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ParticlesConfiguration = .snow) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.particleColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesFalling(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.speed),
                            .float(configuration.density),
                            .float(configuration.particleSize),
                            .float3(r, g, b)
                        )
                    )
                }
        }
    }
}

/// Rising particles (bubbles/embers)
public struct RisingParticlesModifier: ViewModifier {
    let configuration: ParticlesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ParticlesConfiguration = .embers) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.particleColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesRising(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.speed),
                            .float(configuration.density),
                            .float(configuration.particleSize),
                            .float3(r, g, b)
                        )
                    )
                }
        }
    }
}

/// Star field
public struct StarFieldModifier: ViewModifier {
    let density: Float
    let travelSpeed: Float
    @State private var startTime = Date.now
    
    public init(density: Float = 50.0, travelSpeed: Float = 0.1) {
        self.density = density
        self.travelSpeed = travelSpeed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesStarField(
                            .float2(proxy.size),
                            .float(time),
                            .float(density),
                            .float(travelSpeed)
                        )
                    )
                }
        }
    }
}

/// Confetti
public struct ConfettiModifier: ViewModifier {
    let density: Float
    let fallSpeed: Float
    @State private var startTime = Date.now
    
    public init(density: Float = 20.0, fallSpeed: Float = 0.3) {
        self.density = density
        self.fallSpeed = fallSpeed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesConfetti(
                            .float2(proxy.size),
                            .float(time),
                            .float(density),
                            .float(fallSpeed)
                        )
                    )
                }
        }
    }
}

/// Fireflies
public struct FirefliesModifier: ViewModifier {
    let configuration: ParticlesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ParticlesConfiguration = .fireflies) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.particleColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.particlesFireflies(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.count),
                            .float3(r, g, b),
                            .float(0.05)
                        )
                    )
                }
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds sparkle particles
    func sparkle(density: Float = 40.0, intensity: Float = 1.5) -> some View {
        modifier(SparkleModifier(configuration: ParticlesConfiguration(
            density: density,
            intensity: intensity
        )))
    }
    
    /// Adds falling snow
    func snow(density: Float = 30.0, speed: Float = 0.3) -> some View {
        modifier(FallingParticlesModifier(configuration: ParticlesConfiguration(
            density: density,
            speed: speed,
            particleSize: 0.08,
            particleColor: .white
        )))
    }
    
    /// Adds falling rain
    func rain(density: Float = 50.0, speed: Float = 1.0) -> some View {
        modifier(FallingParticlesModifier(configuration: ParticlesConfiguration(
            density: density,
            speed: speed,
            particleSize: 0.03,
            particleColor: Color(white: 0.7)
        )))
    }
    
    /// Adds rising embers
    func embers(density: Float = 25.0, speed: Float = 0.2) -> some View {
        modifier(RisingParticlesModifier(configuration: ParticlesConfiguration(
            density: density,
            speed: speed,
            particleColor: .orange
        )))
    }
    
    /// Adds rising bubbles
    func bubbles(density: Float = 20.0) -> some View {
        modifier(RisingParticlesModifier(configuration: ParticlesConfiguration(
            density: density,
            speed: 0.15,
            particleSize: 0.06,
            particleColor: Color(white: 0.9, opacity: 0.5)
        )))
    }
    
    /// Adds star field
    func starField(density: Float = 50.0, travelSpeed: Float = 0.1) -> some View {
        modifier(StarFieldModifier(density: density, travelSpeed: travelSpeed))
    }
    
    /// Adds confetti
    func confetti(density: Float = 20.0) -> some View {
        modifier(ConfettiModifier(density: density))
    }
    
    /// Adds fireflies
    func fireflies(count: Float = 15.0) -> some View {
        modifier(FirefliesModifier(configuration: ParticlesConfiguration(
            count: count
        )))
    }
}

// MARK: - Preview

#if DEBUG
struct ParticlesModifier_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("MAGIC")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.white)
            }
            .sparkle()
        }
        .ignoresSafeArea()
    }
}
#endif

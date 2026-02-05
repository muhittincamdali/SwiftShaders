// Swirl Effect Modifier
// SwiftUI wrapper for swirl and vortex shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Swirl Configuration

/// Swirl effect style presets
public enum SwirlStyle: String, CaseIterable, Sendable {
    case basic    // Simple swirl
    case animated // Rotating swirl
    case vortex   // Sucking vortex
    case pinch    // Pinch distortion
    case bulge    // Bulge distortion
    case twirl    // Smooth twirl
}

/// Swirl shader configuration
public struct SwirlConfiguration: Sendable {
    /// Center point (normalized 0-1)
    public var center: CGPoint
    
    /// Twist angle in degrees
    public var angle: Float
    
    /// Effect radius (normalized)
    public var radius: Float
    
    /// Animation speed
    public var speed: Float
    
    /// Strength for pinch/bulge
    public var strength: Float
    
    /// Falloff for smooth effects
    public var falloff: Float
    
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        angle: Float = 180.0,
        radius: Float = 0.5,
        speed: Float = 1.0,
        strength: Float = 1.0,
        falloff: Float = 5.0
    ) {
        self.center = center
        self.angle = angle
        self.radius = radius
        self.speed = speed
        self.strength = strength
        self.falloff = falloff
    }
    
    /// Angle in radians
    var angleRadians: Float {
        angle * .pi / 180.0
    }
    
    // Presets
    public static let subtle = SwirlConfiguration(angle: 90.0, radius: 0.3)
    public static let medium = SwirlConfiguration(angle: 180.0, radius: 0.5)
    public static let strong = SwirlConfiguration(angle: 360.0, radius: 0.6)
    public static let vortex = SwirlConfiguration(angle: 720.0, radius: 0.4)
}

// MARK: - View Modifiers

/// Basic swirl effect
public struct SwirlModifier: ViewModifier {
    let configuration: SwirlConfiguration
    
    public init(configuration: SwirlConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.swirl(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.angleRadians),
                        .float(configuration.radius)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Animated swirl
public struct SwirlAnimatedModifier: ViewModifier {
    let configuration: SwirlConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: SwirlConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.layerEffect(
                        ShaderLibrary.swirlAnimated(
                            .float2(proxy.size),
                            .float2(Float(configuration.center.x), Float(configuration.center.y)),
                            .float(time),
                            .float(configuration.speed),
                            .float(configuration.radius)
                        ),
                        maxSampleOffset: proxy.size
                    )
                }
        }
    }
}

/// Vortex effect
public struct VortexModifier: ViewModifier {
    let configuration: SwirlConfiguration
    let pullStrength: Float
    
    public init(configuration: SwirlConfiguration = .vortex, pullStrength: Float = 2.0) {
        self.configuration = configuration
        self.pullStrength = pullStrength
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.vortex(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.angleRadians),
                        .float(pullStrength),
                        .float(configuration.radius)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Pinch effect
public struct PinchModifier: ViewModifier {
    let center: CGPoint
    let strength: Float
    let radius: Float
    
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        strength: Float = 2.0,
        radius: Float = 0.5
    ) {
        self.center = center
        self.strength = strength
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.pinch(
                        .float2(proxy.size),
                        .float2(Float(center.x), Float(center.y)),
                        .float(strength),
                        .float(radius)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Bulge effect
public struct BulgeModifier: ViewModifier {
    let center: CGPoint
    let strength: Float
    let radius: Float
    
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        strength: Float = 2.0,
        radius: Float = 0.5
    ) {
        self.center = center
        self.strength = strength
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.bulge(
                        .float2(proxy.size),
                        .float2(Float(center.x), Float(center.y)),
                        .float(strength),
                        .float(radius)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Smooth twirl effect
public struct TwirlModifier: ViewModifier {
    let center: CGPoint
    let angle: Float
    let falloff: Float
    
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        angle: Float = 180.0,
        falloff: Float = 5.0
    ) {
        self.center = center
        self.angle = angle
        self.falloff = falloff
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.twirl(
                        .float2(proxy.size),
                        .float2(Float(center.x), Float(center.y)),
                        .float(angle * .pi / 180.0),
                        .float(falloff)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies swirl effect
    func swirl(
        angle: Float = 180.0,
        radius: Float = 0.5,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) -> some View {
        modifier(SwirlModifier(configuration: SwirlConfiguration(
            center: center,
            angle: angle,
            radius: radius
        )))
    }
    
    /// Applies animated swirl
    func swirlAnimated(speed: Float = 1.0, radius: Float = 0.5) -> some View {
        modifier(SwirlAnimatedModifier(configuration: SwirlConfiguration(
            radius: radius,
            speed: speed
        )))
    }
    
    /// Applies vortex effect
    func vortex(angle: Float = 360.0, pullStrength: Float = 2.0) -> some View {
        modifier(VortexModifier(
            configuration: SwirlConfiguration(angle: angle),
            pullStrength: pullStrength
        ))
    }
    
    /// Applies pinch effect
    func pinch(strength: Float = 2.0, radius: Float = 0.5) -> some View {
        modifier(PinchModifier(strength: strength, radius: radius))
    }
    
    /// Applies bulge effect
    func bulge(strength: Float = 2.0, radius: Float = 0.5) -> some View {
        modifier(BulgeModifier(strength: strength, radius: radius))
    }
    
    /// Applies smooth twirl
    func twirl(angle: Float = 180.0) -> some View {
        modifier(TwirlModifier(angle: angle))
    }
}

// MARK: - Preview

#if DEBUG
struct SwirlModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
                .frame(width: 200, height: 200)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .swirl(angle: 270)
        }
        .padding()
    }
}
#endif

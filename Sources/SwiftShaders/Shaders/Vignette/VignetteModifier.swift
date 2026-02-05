// Vignette Effect Modifier
// SwiftUI wrapper for vignette shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Vignette Configuration

/// Vignette shape presets
public enum VignetteShape: String, CaseIterable, Sendable {
    case circular    // Round vignette
    case oval        // Aspect-ratio aware oval
    case rectangular // Box-shaped vignette
    case filmBorder  // Rounded rectangle border
}

/// Vignette shader configuration
public struct VignetteConfiguration: Sendable {
    /// Inner radius of full brightness
    public var radius: Float
    
    /// Falloff softness
    public var softness: Float
    
    /// Darkening intensity
    public var intensity: Float
    
    /// Horizontal radius for oval
    public var radiusX: Float
    
    /// Vertical radius for oval
    public var radiusY: Float
    
    /// Vignette color (for colored vignette)
    public var color: Color
    
    /// Focus point (for spotlight effect)
    public var focusPoint: CGPoint
    
    /// Animation speed
    public var animationSpeed: Float
    
    public init(
        radius: Float = 0.5,
        softness: Float = 0.5,
        intensity: Float = 0.5,
        radiusX: Float = 0.6,
        radiusY: Float = 0.5,
        color: Color = .black,
        focusPoint: CGPoint = CGPoint(x: 0.5, y: 0.5),
        animationSpeed: Float = 1.0
    ) {
        self.radius = radius
        self.softness = softness
        self.intensity = intensity
        self.radiusX = radiusX
        self.radiusY = radiusY
        self.color = color
        self.focusPoint = focusPoint
        self.animationSpeed = animationSpeed
    }
    
    // Presets
    public static let subtle = VignetteConfiguration(
        radius: 0.6,
        softness: 0.4,
        intensity: 0.3
    )
    
    public static let strong = VignetteConfiguration(
        radius: 0.4,
        softness: 0.3,
        intensity: 0.7
    )
    
    public static let cinematic = VignetteConfiguration(
        radius: 0.5,
        softness: 0.5,
        intensity: 0.5,
        radiusX: 0.7,
        radiusY: 0.5
    )
    
    public static let spotlight = VignetteConfiguration(
        radius: 0.3,
        softness: 0.4,
        intensity: 0.8
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Classic circular vignette
public struct VignetteModifier: ViewModifier {
    let configuration: VignetteConfiguration
    
    public init(configuration: VignetteConfiguration = .subtle) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.vignette(
                        .float2(proxy.size),
                        .float(configuration.radius),
                        .float(configuration.softness),
                        .float(configuration.intensity)
                    )
                )
            }
    }
}

/// Oval vignette for widescreen content
public struct VignetteOvalModifier: ViewModifier {
    let configuration: VignetteConfiguration
    
    public init(configuration: VignetteConfiguration = .cinematic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.vignetteOval(
                        .float2(proxy.size),
                        .float(configuration.radiusX),
                        .float(configuration.radiusY),
                        .float(configuration.softness),
                        .float(configuration.intensity)
                    )
                )
            }
    }
}

/// Colored vignette
public struct VignetteColoredModifier: ViewModifier {
    let configuration: VignetteConfiguration
    
    public init(configuration: VignetteConfiguration) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.color)
        
        return content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.vignetteColored(
                        .float2(proxy.size),
                        .float3(r, g, b),
                        .float(configuration.radius),
                        .float(configuration.softness),
                        .float(configuration.intensity)
                    )
                )
            }
    }
}

/// Spotlight focus vignette
public struct VignetteFocusModifier: ViewModifier {
    let focusPoint: CGPoint
    let focusRadius: Float
    let falloff: Float
    let dimAmount: Float
    
    public init(
        focusPoint: CGPoint = CGPoint(x: 0.5, y: 0.5),
        focusRadius: Float = 0.3,
        falloff: Float = 0.3,
        dimAmount: Float = 0.7
    ) {
        self.focusPoint = focusPoint
        self.focusRadius = focusRadius
        self.falloff = falloff
        self.dimAmount = dimAmount
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.vignetteFocus(
                        .float2(proxy.size),
                        .float2(Float(focusPoint.x), Float(focusPoint.y)),
                        .float(focusRadius),
                        .float(falloff),
                        .float(dimAmount)
                    )
                )
            }
    }
}

/// Animated breathing vignette
public struct VignetteAnimatedModifier: ViewModifier {
    let configuration: VignetteConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: VignetteConfiguration = .subtle) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.vignetteAnimated(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.radius),
                            .float(0.1), // pulse amount
                            .float(configuration.animationSpeed),
                            .float(configuration.intensity)
                        )
                    )
                }
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies classic circular vignette
    func vignette(
        radius: Float = 0.5,
        softness: Float = 0.5,
        intensity: Float = 0.5
    ) -> some View {
        modifier(VignetteModifier(configuration: VignetteConfiguration(
            radius: radius,
            softness: softness,
            intensity: intensity
        )))
    }
    
    /// Applies subtle vignette preset
    func vignetteSubtle() -> some View {
        modifier(VignetteModifier(configuration: .subtle))
    }
    
    /// Applies strong vignette preset
    func vignetteStrong() -> some View {
        modifier(VignetteModifier(configuration: .strong))
    }
    
    /// Applies cinematic oval vignette
    func vignetteCinematic() -> some View {
        modifier(VignetteOvalModifier(configuration: .cinematic))
    }
    
    /// Applies colored vignette
    func vignetteColored(
        color: Color,
        radius: Float = 0.5,
        intensity: Float = 0.5
    ) -> some View {
        modifier(VignetteColoredModifier(configuration: VignetteConfiguration(
            radius: radius,
            intensity: intensity,
            color: color
        )))
    }
    
    /// Applies spotlight focus effect
    func vignetteSpotlight(
        at point: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Float = 0.3,
        dimAmount: Float = 0.7
    ) -> some View {
        modifier(VignetteFocusModifier(
            focusPoint: point,
            focusRadius: radius,
            dimAmount: dimAmount
        ))
    }
    
    /// Applies animated breathing vignette
    func vignetteAnimated(speed: Float = 1.0) -> some View {
        modifier(VignetteAnimatedModifier(configuration: VignetteConfiguration(
            animationSpeed: speed
        )))
    }
}

// MARK: - Preview

#if DEBUG
struct VignetteModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.fill")
                .font(.system(size: 100))
                .foregroundStyle(.blue)
                .frame(width: 200, height: 150)
                .background(.gray.opacity(0.2))
                .vignette()
            
            Image(systemName: "film")
                .font(.system(size: 100))
                .foregroundStyle(.red)
                .frame(width: 200, height: 150)
                .background(.gray.opacity(0.2))
                .vignetteCinematic()
        }
        .padding()
    }
}
#endif

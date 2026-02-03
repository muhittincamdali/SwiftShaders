// ModifierTemplate.swift
// SwiftShaders
//
// Template for creating shader view modifiers

import SwiftUI

// MARK: - Basic Modifier Template

/// A view modifier that applies a custom shader effect.
public struct CustomShaderModifier: ViewModifier {
    // MARK: - Properties
    
    /// The intensity of the effect (0.0 to 1.0)
    let intensity: Double
    
    /// Whether the effect is animated
    let isAnimated: Bool
    
    // MARK: - State
    
    @State private var time: Double = 0
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1/60, paused: !isAnimated)) { timeline in
            content
                .colorEffect(
                    ShaderLibrary.templateShader(
                        .float(intensity)
                    )
                )
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a custom shader effect to the view.
    ///
    /// - Parameters:
    ///   - intensity: The effect intensity from 0.0 to 1.0
    ///   - isAnimated: Whether to animate the effect
    /// - Returns: A view with the shader effect applied
    public func customShader(
        intensity: Double = 1.0,
        isAnimated: Bool = false
    ) -> some View {
        modifier(CustomShaderModifier(
            intensity: intensity,
            isAnimated: isAnimated
        ))
    }
}

// MARK: - Animated Modifier Template

/// A view modifier with time-based animation.
public struct AnimatedShaderModifier: ViewModifier {
    let speed: Double
    
    @State private var startDate = Date()
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            
            content
                .colorEffect(
                    ShaderLibrary.animatedShader(
                        .float(elapsed),
                        .float(speed)
                    )
                )
        }
    }
}

extension View {
    /// Applies an animated shader effect.
    ///
    /// - Parameter speed: Animation speed multiplier
    public func animatedShader(speed: Double = 1.0) -> some View {
        modifier(AnimatedShaderModifier(speed: speed))
    }
}

// MARK: - Layer Effect Modifier Template

/// A view modifier that uses layer sampling (for blur/distortion).
public struct LayerShaderModifier: ViewModifier {
    let radius: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .layerEffect(
                ShaderLibrary.simpleBlurShader(
                    .float(radius)
                ),
                maxSampleOffset: CGSize(width: radius, height: radius)
            )
    }
}

extension View {
    /// Applies a layer-based shader effect.
    ///
    /// - Parameter radius: The effect radius
    public func layerShader(radius: CGFloat = 10) -> some View {
        modifier(LayerShaderModifier(radius: radius))
    }
}

// MARK: - Distortion Modifier Template

/// A view modifier for distortion effects.
public struct DistortionShaderModifier: ViewModifier {
    let center: UnitPoint
    let amount: CGFloat
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .distortionEffect(
                    ShaderLibrary.distortionShader(
                        .float2(
                            geometry.size.width * center.x,
                            geometry.size.height * center.y
                        ),
                        .float(amount)
                    ),
                    maxSampleOffset: CGSize(
                        width: amount * 100,
                        height: amount * 100
                    )
                )
        }
    }
}

extension View {
    /// Applies a distortion shader effect.
    ///
    /// - Parameters:
    ///   - center: The center point of distortion
    ///   - amount: The distortion amount
    public func distortionShader(
        center: UnitPoint = .center,
        amount: CGFloat = 0.5
    ) -> some View {
        modifier(DistortionShaderModifier(center: center, amount: amount))
    }
}

// MARK: - Configurable Modifier Template

/// A highly configurable shader modifier.
public struct ConfigurableShaderModifier: ViewModifier {
    // MARK: - Configuration
    
    public struct Configuration {
        var intensity: Double
        var hueShift: Angle
        var saturation: Double
        var brightness: Double
        var isAnimated: Bool
        var animationSpeed: Double
        
        public static let `default` = Configuration(
            intensity: 1.0,
            hueShift: .zero,
            saturation: 1.0,
            brightness: 0.0,
            isAnimated: false,
            animationSpeed: 1.0
        )
    }
    
    let configuration: Configuration
    
    @State private var startDate = Date()
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        TimelineView(.animation(paused: !configuration.isAnimated)) { timeline in
            let elapsed = configuration.isAnimated 
                ? timeline.date.timeIntervalSince(startDate) 
                : 0
            
            content
                .colorEffect(
                    ShaderLibrary.colorManipulationShader(
                        .float(configuration.hueShift.radians + elapsed * configuration.animationSpeed),
                        .float(configuration.saturation),
                        .float(configuration.brightness)
                    )
                )
                .opacity(configuration.intensity)
        }
    }
}

extension View {
    /// Applies a configurable shader effect.
    ///
    /// - Parameter configuration: The shader configuration
    public func configurableShader(
        _ configuration: ConfigurableShaderModifier.Configuration = .default
    ) -> some View {
        modifier(ConfigurableShaderModifier(configuration: configuration))
    }
}

// MARK: - Preview

#Preview("Custom Shader") {
    VStack(spacing: 20) {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .customShader(intensity: 0.5)
        
        Text("Animated Shader")
            .font(.title)
            .animatedShader(speed: 2.0)
        
        RoundedRectangle(cornerRadius: 12)
            .fill(.blue.gradient)
            .frame(width: 200, height: 100)
            .distortionShader(center: .center, amount: 0.3)
    }
    .padding()
}

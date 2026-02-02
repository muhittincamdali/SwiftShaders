import SwiftUI

/// The type of shader effect applied to a view.
public enum ShaderEffectType: Sendable {
    /// A color effect — transforms pixel colors without moving them.
    case color
    /// A distortion effect — displaces pixel positions.
    case distortion
    /// A layer effect — operates on the entire rendered layer.
    case layer
}

/// A protocol that all SwiftShaders view modifiers conform to.
///
/// Provides a uniform interface for applying shader effects,
/// including the shader name, effect type, and uniform bindings.
public protocol ShaderModifierProtocol: ViewModifier {
    /// The Metal function name for this shader.
    var shaderName: String { get }
    
    /// The type of shader effect.
    var effectType: ShaderEffectType { get }
    
    /// Whether the shader is currently enabled.
    var isEnabled: Bool { get }
}

extension ShaderModifierProtocol {
    /// Default: the shader is enabled.
    public var isEnabled: Bool { true }
}

// MARK: - Animated Time Provider

/// A view that provides a continuously updating time value
/// for driving shader animations via `TimelineView`.
public struct AnimatedTimeProvider<Content: View>: View {
    private let speed: Double
    private let content: (Double) -> Content
    
    /// Creates an animated time provider.
    ///
    /// - Parameters:
    ///   - speed: Multiplier for the time value (1.0 = real-time).
    ///   - content: A closure receiving the elapsed time in seconds.
    public init(
        speed: Double = 1.0,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.speed = speed
        self.content = content
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate * speed
            content(elapsed)
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a shader as a color effect.
    @ViewBuilder
    func applyColorShader(_ shader: Shader, isEnabled: Bool = true) -> some View {
        if isEnabled {
            self.colorEffect(shader, isEnabled: isEnabled)
        } else {
            self
        }
    }
    
    /// Applies a shader as a distortion effect.
    @ViewBuilder
    func applyDistortionShader(
        _ shader: Shader,
        maxSampleOffset: CGSize,
        isEnabled: Bool = true
    ) -> some View {
        if isEnabled {
            self.distortionEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
        } else {
            self
        }
    }
    
    /// Applies a shader as a layer effect.
    @ViewBuilder
    func applyLayerShader(
        _ shader: Shader,
        maxSampleOffset: CGSize,
        isEnabled: Bool = true
    ) -> some View {
        if isEnabled {
            self.layerEffect(shader, maxSampleOffset: maxSampleOffset, isEnabled: isEnabled)
        } else {
            self
        }
    }
}

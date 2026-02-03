import SwiftUI

// MARK: - ShaderModifierProtocol

/// Protocol defining the interface for shader-based view modifiers.
///
/// Implement this protocol to create custom shader effects that can be
/// applied to any SwiftUI view.
///
/// ## Overview
///
/// ```swift
/// struct MyCustomShader: ShaderModifierProtocol {
///     var shaderName: String { "myShader" }
///     var shaderFunction: String { "myShaderFunction" }
///
///     func makeShader(boundingRect: CGRect) -> Shader {
///         // Build and return shader
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public protocol ShaderModifierProtocol: ViewModifier {
    /// The name of the Metal shader bundle.
    var shaderName: String { get }
    
    /// The name of the shader function to call.
    var shaderFunction: String { get }
    
    /// Creates the shader with the given bounding rect.
    /// - Parameter boundingRect: The bounding rectangle of the view.
    /// - Returns: A configured shader instance.
    func makeShader(boundingRect: CGRect) -> Shader
}

// MARK: - BaseShaderModifier

/// Base implementation for shader modifiers providing common functionality.
///
/// Subclass this modifier to create custom shader effects with minimal boilerplate.
///
/// ## Overview
///
/// The base modifier handles:
/// - Metal shader loading and caching
/// - Bounding rectangle tracking
/// - Animation support
/// - Error handling
///
/// ```swift
/// struct CustomModifier: BaseShaderModifier {
///     let intensity: Double
///
///     override func makeShader(boundingRect: CGRect) -> Shader {
///         ShaderLibrary.bundle(.module)
///             .customShader(.float(intensity))
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct BaseShaderModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// The shader to apply.
    private let shader: Shader
    
    /// Whether to use color effect or distortion effect.
    private let isColorEffect: Bool
    
    /// Maximum sample offset for distortion effects.
    private let maxSampleOffset: CGSize
    
    // MARK: - Initialization
    
    /// Creates a base shader modifier.
    /// - Parameters:
    ///   - shader: The shader to apply.
    ///   - isColorEffect: Whether this is a color effect (vs distortion).
    ///   - maxSampleOffset: Maximum sample offset for distortion.
    public init(
        shader: Shader,
        isColorEffect: Bool = true,
        maxSampleOffset: CGSize = CGSize(width: 100, height: 100)
    ) {
        self.shader = shader
        self.isColorEffect = isColorEffect
        self.maxSampleOffset = maxSampleOffset
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        if isColorEffect {
            content.colorEffect(shader)
        } else {
            content.distortionEffect(shader, maxSampleOffset: maxSampleOffset)
        }
    }
}

// MARK: - AnimatedShaderModifier

/// A modifier that automatically animates shader parameters over time.
///
/// Use this modifier when you need continuous shader animation without
/// managing your own timer.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(AnimatedShaderModifier(
///         duration: 2.0,
///         shaderBuilder: { time in
///             ShaderLibrary.ripple(.float(time))
///         }
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct AnimatedShaderModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Current animation time.
    @State private var time: Double = 0.0
    
    /// The animation duration in seconds.
    private let duration: Double
    
    /// Whether the animation should loop.
    private let loops: Bool
    
    /// Whether to auto-reverse the animation.
    private let autoReverse: Bool
    
    /// Closure that builds the shader given the current time.
    private let shaderBuilder: (Double) -> Shader
    
    /// Whether this is a color effect.
    private let isColorEffect: Bool
    
    /// Maximum sample offset for distortion effects.
    private let maxSampleOffset: CGSize
    
    // MARK: - Initialization
    
    /// Creates an animated shader modifier.
    /// - Parameters:
    ///   - duration: Animation cycle duration in seconds.
    ///   - loops: Whether to loop the animation.
    ///   - autoReverse: Whether to reverse after completing.
    ///   - isColorEffect: Whether this is a color effect.
    ///   - maxSampleOffset: Maximum distortion offset.
    ///   - shaderBuilder: Closure that builds the shader.
    public init(
        duration: Double = 1.0,
        loops: Bool = true,
        autoReverse: Bool = false,
        isColorEffect: Bool = true,
        maxSampleOffset: CGSize = CGSize(width: 100, height: 100),
        shaderBuilder: @escaping (Double) -> Shader
    ) {
        self.duration = duration
        self.loops = loops
        self.autoReverse = autoReverse
        self.isColorEffect = isColorEffect
        self.maxSampleOffset = maxSampleOffset
        self.shaderBuilder = shaderBuilder
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate
            let normalizedTime = normalizeTime(elapsed)
            let shader = shaderBuilder(normalizedTime)
            
            if isColorEffect {
                content.colorEffect(shader)
            } else {
                content.distortionEffect(shader, maxSampleOffset: maxSampleOffset)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func normalizeTime(_ elapsed: Double) -> Double {
        if duration <= 0 { return 0 }
        
        let cycleTime = elapsed.truncatingRemainder(dividingBy: duration * (autoReverse ? 2 : 1))
        
        if autoReverse {
            if cycleTime > duration {
                return duration - (cycleTime - duration)
            }
        }
        
        if loops {
            return cycleTime.truncatingRemainder(dividingBy: duration)
        } else {
            return min(cycleTime, duration)
        }
    }
}

// MARK: - ConditionalShaderModifier

/// A modifier that conditionally applies a shader based on a boolean flag.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(ConditionalShaderModifier(
///         isActive: showEffect,
///         shader: glitchShader
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ConditionalShaderModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Whether the shader is active.
    private let isActive: Bool
    
    /// The shader to apply when active.
    private let shader: Shader
    
    /// Whether this is a color effect.
    private let isColorEffect: Bool
    
    /// Maximum sample offset for distortion.
    private let maxSampleOffset: CGSize
    
    // MARK: - Initialization
    
    /// Creates a conditional shader modifier.
    /// - Parameters:
    ///   - isActive: Whether to apply the shader.
    ///   - shader: The shader to apply.
    ///   - isColorEffect: Whether this is a color effect.
    ///   - maxSampleOffset: Maximum distortion offset.
    public init(
        isActive: Bool,
        shader: Shader,
        isColorEffect: Bool = true,
        maxSampleOffset: CGSize = CGSize(width: 100, height: 100)
    ) {
        self.isActive = isActive
        self.shader = shader
        self.isColorEffect = isColorEffect
        self.maxSampleOffset = maxSampleOffset
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        if isActive {
            if isColorEffect {
                content.colorEffect(shader)
            } else {
                content.distortionEffect(shader, maxSampleOffset: maxSampleOffset)
            }
        } else {
            content
        }
    }
}

// MARK: - ChainedShaderModifier

/// A modifier that chains multiple shaders together.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(ChainedShaderModifier(shaders: [
///         (shader: chromaticShader, isColor: true),
///         (shader: rippleShader, isColor: false)
///     ]))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ChainedShaderModifier: ViewModifier {
    
    /// A shader configuration for chaining.
    public struct ShaderConfig: Sendable {
        let shader: Shader
        let isColorEffect: Bool
        let maxSampleOffset: CGSize
        
        /// Creates a shader configuration.
        /// - Parameters:
        ///   - shader: The shader to apply.
        ///   - isColorEffect: Whether this is a color effect.
        ///   - maxSampleOffset: Maximum distortion offset.
        public init(
            shader: Shader,
            isColorEffect: Bool = true,
            maxSampleOffset: CGSize = CGSize(width: 100, height: 100)
        ) {
            self.shader = shader
            self.isColorEffect = isColorEffect
            self.maxSampleOffset = maxSampleOffset
        }
    }
    
    // MARK: - Properties
    
    private let shaders: [ShaderConfig]
    
    // MARK: - Initialization
    
    /// Creates a chained shader modifier.
    /// - Parameter shaders: Array of shader configurations to chain.
    public init(shaders: [ShaderConfig]) {
        self.shaders = shaders
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        shaders.reduce(AnyView(content)) { view, config in
            if config.isColorEffect {
                AnyView(view.colorEffect(config.shader))
            } else {
                AnyView(view.distortionEffect(config.shader, maxSampleOffset: config.maxSampleOffset))
            }
        }
    }
}

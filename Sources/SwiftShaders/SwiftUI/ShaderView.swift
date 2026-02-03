import SwiftUI

// MARK: - ShaderView

/// A view that renders content with a shader effect applied.
///
/// `ShaderView` provides a convenient wrapper for applying shader effects
/// to any SwiftUI content with built-in animation support.
///
/// ## Overview
///
/// ```swift
/// ShaderView(shader: .ripple, isAnimated: true) {
///     Image("photo")
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderView<Content: View>: View {
    
    // MARK: - Shader Types
    
    /// Available shader presets.
    public enum ShaderPreset {
        case ripple(amplitude: Double = 0.02, frequency: Double = 15.0)
        case chromatic(intensity: Double = 0.02)
        case glitch(intensity: Double = 0.5, blockSize: Double = 0.1)
        case pixelate(size: Double = 10.0)
        case wave(amplitude: Double = 0.02, frequency: Double = 10.0)
        case noise(intensity: Double = 0.1, scale: Double = 5.0)
        case dissolve(scale: Double = 10.0)
        case hologram(scanlineIntensity: Double = 0.3)
        case fire(intensity: Double = 1.0, scale: Double = 5.0)
        case water(amplitude: Double = 0.5, frequency: Double = 1.0)
        case electric(intensity: Double = 1.0)
        case custom(modifier: (Double, Content) -> AnyView)
    }
    
    // MARK: - Properties
    
    private let shader: ShaderPreset
    private let isAnimated: Bool
    private let animationSpeed: Double
    private let content: () -> Content
    
    @State private var animationTime: Double = 0
    
    // MARK: - Initialization
    
    /// Creates a shader view with the specified preset.
    /// - Parameters:
    ///   - shader: The shader preset to apply.
    ///   - isAnimated: Whether to animate the shader.
    ///   - animationSpeed: Animation speed multiplier.
    ///   - content: The content to render.
    public init(
        shader: ShaderPreset,
        isAnimated: Bool = true,
        animationSpeed: Double = 1.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.shader = shader
        self.isAnimated = isAnimated
        self.animationSpeed = animationSpeed
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if isAnimated {
                TimelineView(.animation) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate * animationSpeed
                    applyShader(time: time)
                }
            } else {
                applyShader(time: animationTime)
            }
        }
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private func applyShader(time: Double) -> some View {
        switch shader {
        case .ripple(let amplitude, let frequency):
            content()
                .rippleEffect(time: time, amplitude: amplitude, frequency: frequency)
            
        case .chromatic(let intensity):
            content()
                .chromaticAberration(intensity: intensity)
            
        case .glitch(let intensity, let blockSize):
            content()
                .glitchEffect(time: time, intensity: intensity, blockSize: blockSize)
            
        case .pixelate(let size):
            content()
                .pixelateEffect(pixelSize: size)
            
        case .wave(let amplitude, let frequency):
            content()
                .waveEffect(time: time, amplitude: amplitude, frequency: frequency)
            
        case .noise(let intensity, let scale):
            content()
                .noiseEffect(time: time, intensity: intensity, scale: scale)
            
        case .dissolve(let scale):
            let progress = (sin(time) + 1) / 2
            content()
                .dissolveEffect(progress: progress, scale: scale)
            
        case .hologram(let scanlineIntensity):
            content()
                .hologramEffect(time: time, scanlineIntensity: scanlineIntensity)
            
        case .fire(let intensity, let scale):
            content()
                .fireEffect(time: time, intensity: intensity, scale: scale)
            
        case .water(let amplitude, let frequency):
            content()
                .waterSurface(time: time, amplitude: amplitude, frequency: frequency)
            
        case .electric(let intensity):
            content()
                .lightning(time: time, intensity: intensity)
            
        case .custom(let modifier):
            modifier(time, content())
        }
    }
}

// MARK: - ShaderStack

/// A view that stacks multiple shader effects.
///
/// ## Overview
///
/// ```swift
/// ShaderStack {
///     Image("photo")
/// } shaders: {
///     RippleModifier(time: time)
///     ChromaticModifier(intensity: 0.02)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderStack<Content: View>: View {
    
    private let content: Content
    private let modifiers: [any ViewModifier]
    
    /// Creates a shader stack with multiple effects.
    public init(
        @ViewBuilder content: () -> Content,
        modifiers: [any ViewModifier]
    ) {
        self.content = content()
        self.modifiers = modifiers
    }
    
    public var body: some View {
        modifiers.reduce(AnyView(content)) { view, modifier in
            AnyView(view.modifier(AnyViewModifier(modifier)))
        }
    }
}

/// Type-erased view modifier wrapper.
private struct AnyViewModifier: ViewModifier {
    private let _body: (Content) -> AnyView
    
    init(_ modifier: any ViewModifier) {
        self._body = { content in
            AnyView(content.modifier(modifier as! (any ViewModifier)))
        }
    }
    
    func body(content: Content) -> some View {
        _body(content)
    }
}

// MARK: - ShaderPreview

/// A view for previewing shader effects with controls.
///
/// ## Overview
///
/// ```swift
/// ShaderPreview {
///     Image("photo")
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderPreview<Content: View>: View {
    
    @State private var selectedShader: String = "ripple"
    @State private var intensity: Double = 0.5
    @State private var isAnimating: Bool = true
    @State private var time: Double = 0
    
    private let content: () -> Content
    
    private let shaderNames = [
        "ripple", "chromatic", "glitch", "pixelate", "wave",
        "noise", "dissolve", "hologram", "fire", "water", "electric"
    ]
    
    /// Creates a shader preview.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Preview area
            Group {
                if isAnimating {
                    TimelineView(.animation) { timeline in
                        let time = timeline.date.timeIntervalSinceReferenceDate
                        previewContent(time: time)
                    }
                } else {
                    previewContent(time: time)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .clipped()
            
            // Controls
            VStack(spacing: 12) {
                Picker("Shader", selection: $selectedShader) {
                    ForEach(shaderNames, id: \.self) { name in
                        Text(name.capitalized).tag(name)
                    }
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Text("Intensity")
                    Slider(value: $intensity, in: 0...1)
                }
                
                Toggle("Animate", isOn: $isAnimating)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func previewContent(time: Double) -> some View {
        switch selectedShader {
        case "ripple":
            content().rippleEffect(time: time, amplitude: intensity * 0.05)
        case "chromatic":
            content().chromaticAberration(intensity: intensity * 0.05)
        case "glitch":
            content().glitchEffect(time: time, intensity: intensity)
        case "pixelate":
            content().pixelateEffect(pixelSize: intensity * 20 + 1)
        case "wave":
            content().waveEffect(time: time, amplitude: intensity * 0.05)
        case "noise":
            content().noiseEffect(time: time, intensity: intensity * 0.3)
        case "dissolve":
            content().dissolveEffect(progress: intensity)
        case "hologram":
            content().hologramEffect(time: time, scanlineIntensity: intensity)
        case "fire":
            content().fireEffect(time: time, intensity: intensity * 2)
        case "water":
            content().waterSurface(time: time, amplitude: intensity)
        case "electric":
            content().lightning(time: time, intensity: intensity * 2)
        default:
            content()
        }
    }
}

// MARK: - ConditionalShader

/// Applies a shader effect conditionally.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ConditionalShader<Content: View, ModifiedContent: View>: View {
    
    private let condition: Bool
    private let content: Content
    private let modifier: (Content) -> ModifiedContent
    
    /// Creates a conditional shader.
    /// - Parameters:
    ///   - condition: Whether to apply the shader.
    ///   - content: The base content.
    ///   - modifier: The shader modifier to apply.
    public init(
        _ condition: Bool,
        content: Content,
        @ViewBuilder modifier: @escaping (Content) -> ModifiedContent
    ) {
        self.condition = condition
        self.content = content
        self.modifier = modifier
    }
    
    public var body: some View {
        if condition {
            modifier(content)
        } else {
            content
        }
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies a shader effect conditionally.
    /// - Parameters:
    ///   - condition: Whether to apply the effect.
    ///   - transform: The shader transform to apply.
    /// - Returns: The view with optional shader applied.
    @ViewBuilder
    func shaderIf<T: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> T
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

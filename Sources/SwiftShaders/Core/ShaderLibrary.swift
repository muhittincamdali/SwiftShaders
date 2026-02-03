import SwiftUI

// MARK: - ShaderLibrary

/// Central registry for all available Metal shaders in the SwiftShaders framework.
///
/// The `ShaderLibrary` provides a unified interface for accessing and managing
/// Metal shaders that can be applied as SwiftUI view modifiers.
///
/// ## Overview
///
/// Use the shader library to discover available shaders, create shader instances,
/// and apply them to your SwiftUI views:
///
/// ```swift
/// Image("photo")
///     .modifier(ShaderLibrary.ripple(time: animationTime))
/// ```
///
/// ## Topics
///
/// ### Accessing Shaders
/// - ``shared``
/// - ``availableShaders``
/// - ``shader(named:)``
///
/// ### Effect Categories
/// - ``distortionShaders``
/// - ``colorShaders``
/// - ``particleShaders``
/// - ``transitionShaders``
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public final class ShaderLibrary: Sendable {
    
    // MARK: - Singleton
    
    /// The shared shader library instance.
    public static let shared = ShaderLibrary()
    
    // MARK: - Shader Categories
    
    /// Categories of available shader effects.
    public enum ShaderCategory: String, CaseIterable, Sendable {
        /// Distortion effects that warp and transform geometry.
        case distortion
        /// Color manipulation effects like grading, filters, and adjustments.
        case color
        /// Particle and procedural generation effects.
        case particle
        /// Transition effects for animating between states.
        case transition
        /// Blur and focus effects.
        case blur
        /// Stylization effects like sketch, emboss, and artistic filters.
        case stylization
        /// Retro and vintage effects.
        case retro
        /// Environmental effects like fire, water, and electricity.
        case environmental
    }
    
    // MARK: - Shader Info
    
    /// Information about a registered shader.
    public struct ShaderInfo: Identifiable, Sendable {
        /// Unique identifier for the shader.
        public let id: String
        /// Display name of the shader.
        public let name: String
        /// Description of what the shader does.
        public let description: String
        /// Category this shader belongs to.
        public let category: ShaderCategory
        /// Whether this shader supports animation.
        public let isAnimatable: Bool
        /// Minimum iOS version required.
        public let minimumVersion: String
        
        /// Creates shader info with the specified parameters.
        /// - Parameters:
        ///   - id: Unique identifier
        ///   - name: Display name
        ///   - description: Shader description
        ///   - category: Shader category
        ///   - isAnimatable: Whether shader supports animation
        ///   - minimumVersion: Minimum iOS version
        public init(
            id: String,
            name: String,
            description: String,
            category: ShaderCategory,
            isAnimatable: Bool = true,
            minimumVersion: String = "17.0"
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.category = category
            self.isAnimatable = isAnimatable
            self.minimumVersion = minimumVersion
        }
    }
    
    // MARK: - Properties
    
    /// All registered shaders in the library.
    private let registeredShaders: [ShaderInfo]
    
    // MARK: - Initialization
    
    private init() {
        self.registeredShaders = Self.buildShaderRegistry()
    }
    
    // MARK: - Public API
    
    /// Returns all available shaders in the library.
    public var availableShaders: [ShaderInfo] {
        registeredShaders
    }
    
    /// Returns shaders filtered by category.
    /// - Parameter category: The category to filter by.
    /// - Returns: Array of shaders in the specified category.
    public func shaders(in category: ShaderCategory) -> [ShaderInfo] {
        registeredShaders.filter { $0.category == category }
    }
    
    /// Returns all distortion shaders.
    public var distortionShaders: [ShaderInfo] {
        shaders(in: .distortion)
    }
    
    /// Returns all color manipulation shaders.
    public var colorShaders: [ShaderInfo] {
        shaders(in: .color)
    }
    
    /// Returns all particle and procedural shaders.
    public var particleShaders: [ShaderInfo] {
        shaders(in: .particle)
    }
    
    /// Returns all transition shaders.
    public var transitionShaders: [ShaderInfo] {
        shaders(in: .transition)
    }
    
    /// Returns all blur shaders.
    public var blurShaders: [ShaderInfo] {
        shaders(in: .blur)
    }
    
    /// Returns all stylization shaders.
    public var stylizationShaders: [ShaderInfo] {
        shaders(in: .stylization)
    }
    
    /// Returns all retro shaders.
    public var retroShaders: [ShaderInfo] {
        shaders(in: .retro)
    }
    
    /// Returns all environmental shaders.
    public var environmentalShaders: [ShaderInfo] {
        shaders(in: .environmental)
    }
    
    /// Finds a shader by its identifier.
    /// - Parameter name: The shader identifier.
    /// - Returns: The shader info if found, nil otherwise.
    public func shader(named name: String) -> ShaderInfo? {
        registeredShaders.first { $0.id == name }
    }
    
    /// Returns the total number of registered shaders.
    public var count: Int {
        registeredShaders.count
    }
    
    // MARK: - Registry Builder
    
    private static func buildShaderRegistry() -> [ShaderInfo] {
        [
            // Distortion Shaders
            ShaderInfo(id: "ripple", name: "Ripple", description: "Creates water ripple distortion effects", category: .distortion),
            ShaderInfo(id: "wave", name: "Wave", description: "Applies wave-like distortion patterns", category: .distortion),
            ShaderInfo(id: "swirl", name: "Swirl", description: "Creates spiral swirl distortion", category: .distortion),
            ShaderInfo(id: "barrel", name: "Barrel Distortion", description: "Barrel and pincushion lens distortion", category: .distortion),
            ShaderInfo(id: "kaleidoscope", name: "Kaleidoscope", description: "Mirror and kaleidoscope patterns", category: .distortion),
            
            // Color Shaders
            ShaderInfo(id: "chromatic", name: "Chromatic Aberration", description: "RGB channel separation effect", category: .color),
            ShaderInfo(id: "colorGrading", name: "Color Grading", description: "Professional color grading controls", category: .color),
            ShaderInfo(id: "sepia", name: "Sepia", description: "Vintage sepia tone effect", category: .color),
            ShaderInfo(id: "invert", name: "Invert", description: "Color inversion effect", category: .color),
            ShaderInfo(id: "threshold", name: "Threshold", description: "Binary threshold effect", category: .color),
            ShaderInfo(id: "posterize", name: "Posterize", description: "Reduce color levels for poster effect", category: .color),
            ShaderInfo(id: "vignette", name: "Vignette", description: "Darkened corners vignette effect", category: .color),
            
            // Blur Shaders
            ShaderInfo(id: "gaussianBlur", name: "Gaussian Blur", description: "High-quality Gaussian blur", category: .blur),
            ShaderInfo(id: "frost", name: "Frost", description: "Frosted glass blur effect", category: .blur),
            
            // Particle Shaders
            ShaderInfo(id: "noise", name: "Noise", description: "Procedural noise generation", category: .particle),
            ShaderInfo(id: "particles", name: "Particles", description: "GPU-accelerated particle system", category: .particle),
            
            // Transition Shaders
            ShaderInfo(id: "dissolve", name: "Dissolve", description: "Noise-based dissolve transition", category: .transition),
            ShaderInfo(id: "pixelate", name: "Pixelate", description: "Pixelation transition effect", category: .transition),
            ShaderInfo(id: "glitch", name: "Glitch", description: "Digital glitch transition", category: .transition),
            
            // Stylization Shaders
            ShaderInfo(id: "sketch", name: "Sketch", description: "Pencil sketch artistic effect", category: .stylization),
            ShaderInfo(id: "emboss", name: "Emboss", description: "3D emboss relief effect", category: .stylization),
            ShaderInfo(id: "sharpen", name: "Sharpen", description: "Image sharpening effect", category: .stylization),
            ShaderInfo(id: "mosaic", name: "Mosaic", description: "Mosaic tile pattern effect", category: .stylization),
            ShaderInfo(id: "hologram", name: "Hologram", description: "Futuristic hologram effect", category: .stylization),
            ShaderInfo(id: "neon", name: "Neon", description: "Neon glow edge effect", category: .stylization),
            
            // Retro Shaders
            ShaderInfo(id: "scanlines", name: "Scanlines", description: "CRT monitor scanlines", category: .retro),
            ShaderInfo(id: "crt", name: "CRT", description: "Complete CRT monitor simulation", category: .retro),
            
            // Environmental Shaders
            ShaderInfo(id: "fire", name: "Fire", description: "Procedural fire effect", category: .environmental),
            ShaderInfo(id: "water", name: "Water", description: "Water surface simulation", category: .environmental),
            ShaderInfo(id: "electric", name: "Electric", description: "Electric discharge effect", category: .environmental),
        ]
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies a ripple effect to the view.
    /// - Parameters:
    ///   - time: Animation time for the ripple.
    ///   - origin: Center point of the ripple (normalized 0-1).
    ///   - amplitude: Strength of the ripple distortion.
    ///   - frequency: Number of ripple waves.
    ///   - decay: How quickly ripples fade out.
    /// - Returns: A view with the ripple effect applied.
    func rippleEffect(
        time: Double,
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        amplitude: Double = 0.02,
        frequency: Double = 15.0,
        decay: Double = 8.0
    ) -> some View {
        modifier(RippleModifier(
            time: time,
            origin: origin,
            amplitude: amplitude,
            frequency: frequency,
            decay: decay
        ))
    }
    
    /// Applies chromatic aberration to the view.
    /// - Parameters:
    ///   - intensity: Strength of the aberration.
    ///   - angle: Direction angle of the separation.
    /// - Returns: A view with chromatic aberration applied.
    func chromaticAberration(
        intensity: Double = 0.01,
        angle: Double = 0.0
    ) -> some View {
        modifier(ChromaticModifier(intensity: intensity, angle: angle))
    }
    
    /// Applies a glitch effect to the view.
    /// - Parameters:
    ///   - time: Animation time for the glitch.
    ///   - intensity: Strength of the glitch effect.
    ///   - blockSize: Size of glitch blocks.
    /// - Returns: A view with the glitch effect applied.
    func glitchEffect(
        time: Double,
        intensity: Double = 0.5,
        blockSize: Double = 0.1
    ) -> some View {
        modifier(GlitchModifier(time: time, intensity: intensity, blockSize: blockSize))
    }
    
    /// Applies pixelation to the view.
    /// - Parameter pixelSize: Size of each pixel block.
    /// - Returns: A view with pixelation applied.
    func pixelateEffect(pixelSize: Double = 10.0) -> some View {
        modifier(PixelateModifier(pixelSize: pixelSize))
    }
    
    /// Applies a wave distortion to the view.
    /// - Parameters:
    ///   - time: Animation time for the wave.
    ///   - amplitude: Height of the waves.
    ///   - frequency: Number of waves.
    ///   - direction: Wave direction (0 = horizontal, 1 = vertical).
    /// - Returns: A view with wave distortion applied.
    func waveEffect(
        time: Double,
        amplitude: Double = 0.02,
        frequency: Double = 10.0,
        direction: Double = 0.0
    ) -> some View {
        modifier(WaveModifier(time: time, amplitude: amplitude, frequency: frequency, direction: direction))
    }
}

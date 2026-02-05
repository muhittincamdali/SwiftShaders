// Emboss Effect Modifier
// SwiftUI wrapper for emboss/relief shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Emboss Configuration

/// Emboss effect style presets
public enum EmbossStyle: String, CaseIterable, Sendable {
    case classic       // Grayscale emboss
    case colored       // Preserves color
    case metallic      // Metallic finish
    case deboss        // Sunken effect
    case subtle        // Light emboss
}

/// Emboss shader configuration
public struct EmbossConfiguration: Sendable {
    /// Emboss strength (0.0-3.0)
    public var strength: Float
    
    /// Light angle in degrees (0-360)
    public var lightAngle: Float
    
    /// Color preservation (0.0 = grayscale, 1.0 = full color)
    public var colorMix: Float
    
    /// Metallic tint color
    public var metalColor: Color
    
    public init(
        strength: Float = 1.0,
        lightAngle: Float = 45.0,
        colorMix: Float = 0.0,
        metalColor: Color = .gray
    ) {
        self.strength = strength
        self.lightAngle = lightAngle
        self.colorMix = colorMix
        self.metalColor = metalColor
    }
    
    /// Light angle in radians
    var lightAngleRadians: Float {
        lightAngle * .pi / 180.0
    }
    
    // Presets
    public static let classic = EmbossConfiguration()
    
    public static let strong = EmbossConfiguration(strength: 2.0)
    
    public static let subtle = EmbossConfiguration(strength: 0.5)
    
    public static let colored = EmbossConfiguration(
        strength: 1.0,
        colorMix: 0.7
    )
    
    public static let gold = EmbossConfiguration(
        strength: 1.5,
        metalColor: Color(red: 1.0, green: 0.84, blue: 0.0)
    )
    
    public static let silver = EmbossConfiguration(
        strength: 1.5,
        metalColor: Color(red: 0.75, green: 0.75, blue: 0.75)
    )
    
    public static let bronze = EmbossConfiguration(
        strength: 1.5,
        metalColor: Color(red: 0.8, green: 0.5, blue: 0.2)
    )
}

// MARK: - Emboss View Modifier

/// Applies classic emboss effect
public struct EmbossModifier: ViewModifier {
    let configuration: EmbossConfiguration
    
    public init(configuration: EmbossConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .layerEffect(
                ShaderLibrary.emboss(
                    .float2(1.0, 1.0), // Will be replaced by proxy
                    .float(configuration.strength),
                    .float(configuration.lightAngleRadians)
                ),
                maxSampleOffset: .zero
            )
    }
}

/// Applies color-preserving emboss effect
public struct EmbossColorModifier: ViewModifier {
    let configuration: EmbossConfiguration
    
    public init(configuration: EmbossConfiguration = .colored) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.embossColor(
                        .float2(proxy.size),
                        .float(configuration.strength),
                        .float(configuration.lightAngleRadians),
                        .float(configuration.colorMix)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Applies deboss (sunken) effect
public struct DebossModifier: ViewModifier {
    let strength: Float
    
    public init(strength: Float = 1.0) {
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.deboss(
                        .float2(proxy.size),
                        .float(strength)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Applies metallic emboss effect
public struct MetallicEmbossModifier: ViewModifier {
    let configuration: EmbossConfiguration
    
    public init(configuration: EmbossConfiguration = .silver) {
        self.configuration = configuration
    }
    
    private func colorToHalf3(_ color: Color) -> (Float, Float, Float) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (resolved.red, resolved.green, resolved.blue)
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToHalf3(configuration.metalColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.embossMetallic(
                        .float2(proxy.size),
                        .float(configuration.strength),
                        .float(configuration.lightAngleRadians),
                        .float3(r, g, b)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Animated bump map effect
public struct BumpMapModifier: ViewModifier {
    let depth: Float
    @State private var startTime = Date.now
    
    public init(depth: Float = 1.0) {
        self.depth = depth
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.bumpMap(
                            .float2(proxy.size),
                            .float(time),
                            .float(depth)
                        )
                    )
                }
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies classic emboss effect
    func emboss(strength: Float = 1.0, lightAngle: Float = 45.0) -> some View {
        modifier(EmbossModifier(configuration: EmbossConfiguration(
            strength: strength,
            lightAngle: lightAngle
        )))
    }
    
    /// Applies color-preserving emboss
    func embossColor(
        strength: Float = 1.0,
        lightAngle: Float = 45.0,
        colorMix: Float = 0.7
    ) -> some View {
        modifier(EmbossColorModifier(configuration: EmbossConfiguration(
            strength: strength,
            lightAngle: lightAngle,
            colorMix: colorMix
        )))
    }
    
    /// Applies deboss (sunken) effect
    func deboss(strength: Float = 1.0) -> some View {
        modifier(DebossModifier(strength: strength))
    }
    
    /// Applies metallic emboss with preset
    func metallicEmboss(_ style: EmbossConfiguration = .silver) -> some View {
        modifier(MetallicEmbossModifier(configuration: style))
    }
    
    /// Applies gold emboss effect
    func goldEmboss() -> some View {
        modifier(MetallicEmbossModifier(configuration: .gold))
    }
    
    /// Applies silver emboss effect
    func silverEmboss() -> some View {
        modifier(MetallicEmbossModifier(configuration: .silver))
    }
    
    /// Applies animated bump map
    func bumpMap(depth: Float = 1.0) -> some View {
        modifier(BumpMapModifier(depth: depth))
    }
}

// MARK: - Preview

#if DEBUG
struct EmbossModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("EMBOSS")
                .font(.system(size: 48, weight: .black))
                .foregroundStyle(.blue)
                .emboss(strength: 1.5)
            
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
                .goldEmboss()
        }
        .padding()
    }
}
#endif

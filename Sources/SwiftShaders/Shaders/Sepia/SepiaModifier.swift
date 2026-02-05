// Sepia & Vintage Effect Modifier
// SwiftUI wrapper for sepia and vintage shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Sepia Configuration

/// Vintage effect style presets
public enum VintageStyle: String, CaseIterable, Sendable {
    case sepia         // Classic sepia tone
    case vintage       // Vintage photograph
    case aged          // Aged film with grain
    case polaroid      // Polaroid instant camera
    case crossProcess  // Cross-processed film
    case faded         // Faded memory effect
}

/// Sepia and vintage shader configuration
public struct SepiaConfiguration: Sendable {
    /// Effect intensity (0.0-1.0)
    public var intensity: Float
    
    /// Warmth amount
    public var warmth: Float
    
    /// Contrast adjustment
    public var contrast: Float
    
    /// Fade amount
    public var fadeAmount: Float
    
    /// Film grain intensity
    public var grainIntensity: Float
    
    /// Scratch intensity for aged effect
    public var scratchIntensity: Float
    
    /// Tint color for faded effect
    public var tintColor: Color
    
    /// Saturation level
    public var saturation: Float
    
    /// Exposure adjustment
    public var exposure: Float
    
    public init(
        intensity: Float = 1.0,
        warmth: Float = 0.5,
        contrast: Float = 1.1,
        fadeAmount: Float = 0.2,
        grainIntensity: Float = 0.1,
        scratchIntensity: Float = 0.05,
        tintColor: Color = Color(red: 1.0, green: 0.95, blue: 0.8),
        saturation: Float = 0.8,
        exposure: Float = 1.0
    ) {
        self.intensity = intensity
        self.warmth = warmth
        self.contrast = contrast
        self.fadeAmount = fadeAmount
        self.grainIntensity = grainIntensity
        self.scratchIntensity = scratchIntensity
        self.tintColor = tintColor
        self.saturation = saturation
        self.exposure = exposure
    }
    
    // Presets
    public static let classic = SepiaConfiguration()
    
    public static let light = SepiaConfiguration(intensity: 0.5)
    
    public static let strong = SepiaConfiguration(
        intensity: 1.0,
        contrast: 1.2,
        fadeAmount: 0.1
    )
    
    public static let aged = SepiaConfiguration(
        intensity: 1.0,
        grainIntensity: 0.15,
        scratchIntensity: 0.1,
        fadeAmount: 0.3
    )
    
    public static let polaroid = SepiaConfiguration(
        saturation: 0.9,
        exposure: 1.1
    )
    
    public static let faded = SepiaConfiguration(
        fadeAmount: 0.5,
        contrast: 0.9
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Classic sepia tone effect
public struct SepiaModifier: ViewModifier {
    let intensity: Float
    
    public init(intensity: Float = 1.0) {
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.sepia(
                    .float(intensity)
                )
            )
    }
}

/// Vintage photo effect
public struct VintagePhotoModifier: ViewModifier {
    let configuration: SepiaConfiguration
    
    public init(configuration: SepiaConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.vintagePhoto(
                        .float2(proxy.size),
                        .float(configuration.fadeAmount),
                        .float(configuration.warmth),
                        .float(configuration.contrast)
                    )
                )
            }
    }
}

/// Aged film effect with grain and scratches
public struct AgedFilmModifier: ViewModifier {
    let configuration: SepiaConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: SepiaConfiguration = .aged) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.agedFilm(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.grainIntensity),
                            .float(configuration.scratchIntensity),
                            .float(configuration.fadeAmount)
                        )
                    )
                }
        }
    }
}

/// Polaroid instant camera effect
public struct PolaroidModifier: ViewModifier {
    let configuration: SepiaConfiguration
    
    public init(configuration: SepiaConfiguration = .polaroid) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.polaroid(
                    .float2(1, 1),
                    .float(configuration.exposure),
                    .float(configuration.saturation)
                )
            )
    }
}

/// Cross-process film effect
public struct CrossProcessModifier: ViewModifier {
    let intensity: Float
    
    public init(intensity: Float = 1.0) {
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.crossProcess(
                    .float(intensity)
                )
            )
    }
}

/// Faded memory effect
public struct FadedMemoryModifier: ViewModifier {
    let configuration: SepiaConfiguration
    
    public init(configuration: SepiaConfiguration = .faded) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.tintColor)
        
        return content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.fadedMemory(
                        .float2(proxy.size),
                        .float(configuration.fadeAmount),
                        .float3(r, g, b)
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies classic sepia tone
    func sepia(intensity: Float = 1.0) -> some View {
        modifier(SepiaModifier(intensity: intensity))
    }
    
    /// Applies vintage photo effect
    func vintagePhoto(
        fadeAmount: Float = 0.2,
        warmth: Float = 0.5,
        contrast: Float = 1.1
    ) -> some View {
        modifier(VintagePhotoModifier(configuration: SepiaConfiguration(
            warmth: warmth,
            contrast: contrast,
            fadeAmount: fadeAmount
        )))
    }
    
    /// Applies aged film effect with grain
    func agedFilm(
        grainIntensity: Float = 0.1,
        scratchIntensity: Float = 0.05
    ) -> some View {
        modifier(AgedFilmModifier(configuration: SepiaConfiguration(
            grainIntensity: grainIntensity,
            scratchIntensity: scratchIntensity
        )))
    }
    
    /// Applies Polaroid camera effect
    func polaroid(exposure: Float = 1.0, saturation: Float = 0.8) -> some View {
        modifier(PolaroidModifier(configuration: SepiaConfiguration(
            saturation: saturation,
            exposure: exposure
        )))
    }
    
    /// Applies cross-process film effect
    func crossProcess(intensity: Float = 1.0) -> some View {
        modifier(CrossProcessModifier(intensity: intensity))
    }
    
    /// Applies faded memory effect
    func fadedMemory(fadeAmount: Float = 0.5) -> some View {
        modifier(FadedMemoryModifier(configuration: SepiaConfiguration(
            fadeAmount: fadeAmount
        )))
    }
}

// MARK: - Preview

#if DEBUG
struct SepiaModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
                .sepia()
            
            Text("VINTAGE")
                .font(.title.bold())
                .vintagePhoto()
            
            Image(systemName: "film")
                .font(.system(size: 60))
                .foregroundStyle(.red)
                .agedFilm()
        }
        .padding()
    }
}
#endif

// Posterize Effect Modifier
// SwiftUI wrapper for posterize and pop art shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Posterize Configuration

/// Posterize effect style presets
public enum PosterizeStyle: String, CaseIterable, Sendable {
    case basic       // Simple level reduction
    case smooth      // With dithering
    case popArt      // High contrast pop art
    case duotone     // Two-color
    case tritone     // Three-color
    case palette     // Custom palette
}

/// Posterize shader configuration
public struct PosterizeConfiguration: Sendable {
    /// Number of color levels
    public var levels: Float
    
    /// Per-channel levels
    public var levelsRed: Float
    public var levelsGreen: Float
    public var levelsBlue: Float
    
    /// Dither amount for smooth mode
    public var ditherAmount: Float
    
    /// Saturation boost for pop art
    public var saturationBoost: Float
    
    /// Contrast boost for pop art
    public var contrastBoost: Float
    
    /// Color preservation (0 = full posterize, 1 = lightness only)
    public var preserveColor: Float
    
    /// Palette colors
    public var darkColor: Color
    public var midColor: Color
    public var lightColor: Color
    
    public init(
        levels: Float = 4.0,
        levelsRed: Float = 4.0,
        levelsGreen: Float = 4.0,
        levelsBlue: Float = 4.0,
        ditherAmount: Float = 0.5,
        saturationBoost: Float = 1.5,
        contrastBoost: Float = 1.3,
        preserveColor: Float = 0.0,
        darkColor: Color = .black,
        midColor: Color = .gray,
        lightColor: Color = .white
    ) {
        self.levels = levels
        self.levelsRed = levelsRed
        self.levelsGreen = levelsGreen
        self.levelsBlue = levelsBlue
        self.ditherAmount = ditherAmount
        self.saturationBoost = saturationBoost
        self.contrastBoost = contrastBoost
        self.preserveColor = preserveColor
        self.darkColor = darkColor
        self.midColor = midColor
        self.lightColor = lightColor
    }
    
    // Presets
    public static let subtle = PosterizeConfiguration(levels: 8)
    public static let medium = PosterizeConfiguration(levels: 4)
    public static let strong = PosterizeConfiguration(levels: 2)
    
    public static let popArt = PosterizeConfiguration(
        levels: 4,
        saturationBoost: 2.0,
        contrastBoost: 1.5
    )
    
    public static let comic = PosterizeConfiguration(
        levels: 5,
        saturationBoost: 1.8,
        contrastBoost: 1.4
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Basic posterize effect
public struct PosterizeModifier: ViewModifier {
    let levels: Float
    
    public init(levels: Float = 4.0) {
        self.levels = levels
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.posterize(
                    .float(levels)
                )
            )
    }
}

/// Channel-specific posterize
public struct PosterizeChannelsModifier: ViewModifier {
    let configuration: PosterizeConfiguration
    
    public init(configuration: PosterizeConfiguration) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.posterizeChannels(
                    .float(configuration.levelsRed),
                    .float(configuration.levelsGreen),
                    .float(configuration.levelsBlue)
                )
            )
    }
}

/// Pop art posterize
public struct PosterizePopArtModifier: ViewModifier {
    let configuration: PosterizeConfiguration
    
    public init(configuration: PosterizeConfiguration = .popArt) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.posterizePopArt(
                        .float2(proxy.size),
                        .float(configuration.levels),
                        .float(configuration.saturationBoost),
                        .float(configuration.contrastBoost)
                    )
                )
            }
    }
}

/// Duotone posterize
public struct PosterizeDuotoneModifier: ViewModifier {
    let darkColor: Color
    let lightColor: Color
    let levels: Float
    
    public init(darkColor: Color = .black, lightColor: Color = .white, levels: Float = 4.0) {
        self.darkColor = darkColor
        self.lightColor = lightColor
        self.levels = levels
    }
    
    public func body(content: Content) -> some View {
        let (dr, dg, db) = colorToFloat3(darkColor)
        let (lr, lg, lb) = colorToFloat3(lightColor)
        
        return content
            .colorEffect(
                ShaderLibrary.posterizeDuotone(
                    .float3(dr, dg, db),
                    .float3(lr, lg, lb),
                    .float(levels)
                )
            )
    }
}

/// Tritone posterize
public struct PosterizeTritoneModifier: ViewModifier {
    let shadowColor: Color
    let midColor: Color
    let highlightColor: Color
    let levels: Float
    
    public init(
        shadowColor: Color = .black,
        midColor: Color = .red,
        highlightColor: Color = .white,
        levels: Float = 4.0
    ) {
        self.shadowColor = shadowColor
        self.midColor = midColor
        self.highlightColor = highlightColor
        self.levels = levels
    }
    
    public func body(content: Content) -> some View {
        let (sr, sg, sb) = colorToFloat3(shadowColor)
        let (mr, mg, mb) = colorToFloat3(midColor)
        let (hr, hg, hb) = colorToFloat3(highlightColor)
        
        return content
            .colorEffect(
                ShaderLibrary.posterizeTritone(
                    .float3(sr, sg, sb),
                    .float3(mr, mg, mb),
                    .float3(hr, hg, hb),
                    .float(levels)
                )
            )
    }
}

/// Animated posterize
public struct PosterizeAnimatedModifier: ViewModifier {
    let minLevels: Float
    let maxLevels: Float
    let speed: Float
    @State private var startTime = Date.now
    
    public init(minLevels: Float = 2.0, maxLevels: Float = 8.0, speed: Float = 2.0) {
        self.minLevels = minLevels
        self.maxLevels = maxLevels
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .colorEffect(
                    ShaderLibrary.posterizeAnimated(
                        .float(time),
                        .float(minLevels),
                        .float(maxLevels),
                        .float(speed)
                    )
                )
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies basic posterize effect
    func posterize(levels: Float = 4.0) -> some View {
        modifier(PosterizeModifier(levels: levels))
    }
    
    /// Applies pop art style posterize
    func posterizePopArt(levels: Float = 4.0) -> some View {
        modifier(PosterizePopArtModifier(configuration: PosterizeConfiguration(
            levels: levels,
            saturationBoost: 2.0,
            contrastBoost: 1.5
        )))
    }
    
    /// Applies duotone posterize
    func posterizeDuotone(
        dark: Color = .black,
        light: Color = .cyan,
        levels: Float = 4.0
    ) -> some View {
        modifier(PosterizeDuotoneModifier(
            darkColor: dark,
            lightColor: light,
            levels: levels
        ))
    }
    
    /// Applies tritone posterize
    func posterizeTritone(
        shadow: Color = .black,
        mid: Color = .red,
        highlight: Color = .yellow,
        levels: Float = 4.0
    ) -> some View {
        modifier(PosterizeTritoneModifier(
            shadowColor: shadow,
            midColor: mid,
            highlightColor: highlight,
            levels: levels
        ))
    }
    
    /// Applies animated posterize
    func posterizeAnimated(speed: Float = 2.0) -> some View {
        modifier(PosterizeAnimatedModifier(speed: speed))
    }
    
    /// Applies comic book style
    func comicBook() -> some View {
        modifier(PosterizePopArtModifier(configuration: .comic))
    }
}

// MARK: - Preview

#if DEBUG
struct PosterizeModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange, .yellow],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .posterize(levels: 4)
            
            Image(systemName: "person.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .posterizePopArt()
        }
        .padding()
    }
}
#endif

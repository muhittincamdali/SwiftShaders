// Neon Glow Effect Modifier
// SwiftUI wrapper for neon shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Neon Configuration

/// Neon glow style presets
public enum NeonStyle: String, CaseIterable, Sendable {
    case classic       // Single color glow
    case multiColor    // Inner + outer glow
    case electric      // Flickering electric
    case rainbow       // Color shifting
    case subtle        // Light glow
}

/// Neon shader configuration
public struct NeonConfiguration: Sendable {
    /// Primary glow color
    public var glowColor: Color
    
    /// Secondary glow color (for multi-glow)
    public var secondaryColor: Color
    
    /// Glow intensity (0.0-3.0)
    public var intensity: Float
    
    /// Brightness threshold for glow
    public var threshold: Float
    
    /// Glow width in pixels
    public var glowWidth: Float
    
    /// Animation speed
    public var speed: Float
    
    public init(
        glowColor: Color = .cyan,
        secondaryColor: Color = .purple,
        intensity: Float = 1.5,
        threshold: Float = 0.3,
        glowWidth: Float = 5.0,
        speed: Float = 1.0
    ) {
        self.glowColor = glowColor
        self.secondaryColor = secondaryColor
        self.intensity = intensity
        self.threshold = threshold
        self.glowWidth = glowWidth
        self.speed = speed
    }
    
    // Preset configurations
    public static let cyan = NeonConfiguration(glowColor: .cyan)
    
    public static let pink = NeonConfiguration(glowColor: .pink)
    
    public static let green = NeonConfiguration(
        glowColor: Color(red: 0.2, green: 1.0, blue: 0.3)
    )
    
    public static let purple = NeonConfiguration(glowColor: .purple)
    
    public static let orange = NeonConfiguration(
        glowColor: Color(red: 1.0, green: 0.5, blue: 0.0)
    )
    
    public static let electric = NeonConfiguration(
        glowColor: .cyan,
        secondaryColor: .white,
        intensity: 2.0,
        speed: 2.0
    )
    
    public static let subtle = NeonConfiguration(
        glowColor: .white,
        intensity: 0.5,
        threshold: 0.5
    )
}

// MARK: - Helper Functions

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - Neon View Modifiers

/// Basic neon glow effect
public struct NeonGlowModifier: ViewModifier {
    let configuration: NeonConfiguration
    
    public init(configuration: NeonConfiguration = .cyan) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.glowColor)
        
        return content
            .colorEffect(
                ShaderLibrary.neonGlow(
                    .float3(r, g, b),
                    .float(configuration.intensity),
                    .float(configuration.threshold)
                )
            )
    }
}

/// Neon outline effect
public struct NeonOutlineModifier: ViewModifier {
    let configuration: NeonConfiguration
    
    public init(configuration: NeonConfiguration = .cyan) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.glowColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.neonOutline(
                        .float2(proxy.size),
                        .float3(r, g, b),
                        .float(configuration.glowWidth),
                        .float(configuration.intensity)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.glowWidth,
                        height: configuration.glowWidth
                    )
                )
            }
    }
}

/// Animated neon color shift
public struct NeonColorShiftModifier: ViewModifier {
    let speed: Float
    @State private var startTime = Date.now
    
    public init(speed: Float = 1.0) {
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.neonColorShift(
                            .float2(proxy.size),
                            .float(time),
                            .float(speed)
                        )
                    )
                }
        }
    }
}

/// Electric neon with flicker
public struct NeonElectricModifier: ViewModifier {
    let configuration: NeonConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: NeonConfiguration = .electric) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r1, g1, b1) = colorToFloat3(configuration.glowColor)
        let (r2, g2, b2) = colorToFloat3(configuration.secondaryColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.neonElectric(
                            .float2(proxy.size),
                            .float(time),
                            .float3(r1, g1, b1),
                            .float3(r2, g2, b2),
                            .float(configuration.speed)
                        )
                    )
                }
        }
    }
}

/// Simple neon tint
public struct NeonTintModifier: ViewModifier {
    let color: Color
    let intensity: Float
    
    public init(color: Color = .cyan, intensity: Float = 0.7) {
        self.color = color
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(color)
        
        return content
            .colorEffect(
                ShaderLibrary.neonTint(
                    .float3(r, g, b),
                    .float(intensity)
                )
            )
    }
}

// MARK: - View Extension

public extension View {
    /// Applies neon glow effect
    func neonGlow(_ configuration: NeonConfiguration = .cyan) -> some View {
        modifier(NeonGlowModifier(configuration: configuration))
    }
    
    /// Applies neon glow with custom color
    func neonGlow(
        color: Color,
        intensity: Float = 1.5,
        threshold: Float = 0.3
    ) -> some View {
        modifier(NeonGlowModifier(configuration: NeonConfiguration(
            glowColor: color,
            intensity: intensity,
            threshold: threshold
        )))
    }
    
    /// Applies neon outline effect
    func neonOutline(
        color: Color = .cyan,
        width: Float = 5.0,
        intensity: Float = 1.5
    ) -> some View {
        modifier(NeonOutlineModifier(configuration: NeonConfiguration(
            glowColor: color,
            intensity: intensity,
            glowWidth: width
        )))
    }
    
    /// Applies animated rainbow neon
    func neonRainbow(speed: Float = 1.0) -> some View {
        modifier(NeonColorShiftModifier(speed: speed))
    }
    
    /// Applies electric neon with flicker
    func neonElectric(
        color: Color = .cyan,
        intensity: Float = 2.0
    ) -> some View {
        modifier(NeonElectricModifier(configuration: NeonConfiguration(
            glowColor: color,
            intensity: intensity
        )))
    }
    
    /// Applies subtle neon tint
    func neonTint(color: Color = .cyan, intensity: Float = 0.7) -> some View {
        modifier(NeonTintModifier(color: color, intensity: intensity))
    }
}

// MARK: - Preview

#if DEBUG
struct NeonModifier_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 30) {
                Text("NEON")
                    .font(.system(size: 60, weight: .black))
                    .foregroundStyle(.white)
                    .neonGlow(color: .cyan, intensity: 2.0)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)
                    .neonElectric(color: .yellow)
            }
        }
        .ignoresSafeArea()
    }
}
#endif

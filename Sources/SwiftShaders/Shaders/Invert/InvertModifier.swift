// Invert Effect Modifier
// SwiftUI wrapper for invert and negative shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Invert Configuration

/// Invert effect style presets
public enum InvertStyle: String, CaseIterable, Sendable {
    case basic       // Simple color inversion
    case smart       // Preserve images
    case luminance   // Invert brightness only
    case hue         // Complementary colors
    case negative    // Film negative look
    case xray        // X-ray effect
    case solarize    // Partial inversion
}

/// Invert shader configuration
public struct InvertConfiguration: Sendable {
    /// Inversion amount (0.0-1.0)
    public var amount: Float
    
    /// Threshold for smart/solarize modes
    public var threshold: Float
    
    /// Orange mask for film negative
    public var orangeMask: Float
    
    /// Channel-specific inversion
    public var invertRed: Bool
    public var invertGreen: Bool
    public var invertBlue: Bool
    
    public init(
        amount: Float = 1.0,
        threshold: Float = 0.5,
        orangeMask: Float = 0.3,
        invertRed: Bool = true,
        invertGreen: Bool = true,
        invertBlue: Bool = true
    ) {
        self.amount = amount
        self.threshold = threshold
        self.orangeMask = orangeMask
        self.invertRed = invertRed
        self.invertGreen = invertGreen
        self.invertBlue = invertBlue
    }
    
    // Presets
    public static let full = InvertConfiguration()
    public static let partial = InvertConfiguration(amount: 0.5)
    public static let filmNegative = InvertConfiguration(orangeMask: 0.4)
    public static let redOnly = InvertConfiguration(invertGreen: false, invertBlue: false)
    public static let cyanOnly = InvertConfiguration(invertRed: false)
}

// MARK: - View Modifiers

/// Basic color inversion
public struct InvertModifier: ViewModifier {
    let amount: Float
    
    public init(amount: Float = 1.0) {
        self.amount = amount
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.invert(
                    .float(amount)
                )
            )
    }
}

/// Smart invert (preserves images)
public struct SmartInvertModifier: ViewModifier {
    let threshold: Float
    
    public init(threshold: Float = 0.3) {
        self.threshold = threshold
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.invertSmart(
                    .float(threshold)
                )
            )
    }
}

/// Channel-specific inversion
public struct ChannelInvertModifier: ViewModifier {
    let configuration: InvertConfiguration
    
    public init(configuration: InvertConfiguration) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.invertChannels(
                    .float(configuration.invertRed ? 1.0 : 0.0),
                    .float(configuration.invertGreen ? 1.0 : 0.0),
                    .float(configuration.invertBlue ? 1.0 : 0.0)
                )
            )
    }
}

/// Film negative effect
public struct NegativeFilmModifier: ViewModifier {
    let orangeMask: Float
    
    public init(orangeMask: Float = 0.3) {
        self.orangeMask = orangeMask
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.negativeFilm(
                        .float2(proxy.size),
                        .float(orangeMask)
                    )
                )
            }
    }
}

/// X-Ray effect
public struct XRayModifier: ViewModifier {
    let intensity: Float
    let edgeEnhance: Float
    
    public init(intensity: Float = 1.0, edgeEnhance: Float = 0.5) {
        self.intensity = intensity
        self.edgeEnhance = edgeEnhance
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.xrayEffect(
                    .float(intensity),
                    .float(edgeEnhance)
                )
            )
    }
}

/// Solarize effect
public struct SolarizeModifier: ViewModifier {
    let threshold: Float
    
    public init(threshold: Float = 0.5) {
        self.threshold = threshold
    }
    
    public func body(content: Content) -> some View {
        content
            .colorEffect(
                ShaderLibrary.solarize(
                    .float(threshold)
                )
            )
    }
}

/// Animated inversion
public struct InvertAnimatedModifier: ViewModifier {
    let speed: Float
    let waveScale: Float
    @State private var startTime = Date.now
    
    public init(speed: Float = 2.0, waveScale: Float = 5.0) {
        self.speed = speed
        self.waveScale = waveScale
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.invertAnimated(
                            .float2(proxy.size),
                            .float(time),
                            .float(speed),
                            .float(waveScale)
                        )
                    )
                }
        }
    }
}

/// Region-based inversion
public struct InvertRegionModifier: ViewModifier {
    let center: CGPoint
    let radius: Float
    let feather: Float
    
    public init(
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Float = 0.3,
        feather: Float = 0.1
    ) {
        self.center = center
        self.radius = radius
        self.feather = feather
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.invertRegion(
                        .float2(proxy.size),
                        .float2(Float(center.x), Float(center.y)),
                        .float(radius),
                        .float(feather)
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies basic color inversion
    func invert(amount: Float = 1.0) -> some View {
        modifier(InvertModifier(amount: amount))
    }
    
    /// Applies smart invert (preserves images)
    func invertSmart(threshold: Float = 0.3) -> some View {
        modifier(SmartInvertModifier(threshold: threshold))
    }
    
    /// Inverts specific color channels
    func invertChannels(red: Bool = true, green: Bool = true, blue: Bool = true) -> some View {
        modifier(ChannelInvertModifier(configuration: InvertConfiguration(
            invertRed: red,
            invertGreen: green,
            invertBlue: blue
        )))
    }
    
    /// Applies film negative effect
    func negativeFilm(orangeMask: Float = 0.3) -> some View {
        modifier(NegativeFilmModifier(orangeMask: orangeMask))
    }
    
    /// Applies X-ray effect
    func xray(intensity: Float = 1.0) -> some View {
        modifier(XRayModifier(intensity: intensity))
    }
    
    /// Applies solarize effect
    func solarize(threshold: Float = 0.5) -> some View {
        modifier(SolarizeModifier(threshold: threshold))
    }
    
    /// Applies animated wave inversion
    func invertAnimated(speed: Float = 2.0) -> some View {
        modifier(InvertAnimatedModifier(speed: speed))
    }
    
    /// Inverts a circular region
    func invertRegion(
        at center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        radius: Float = 0.3
    ) -> some View {
        modifier(InvertRegionModifier(center: center, radius: radius))
    }
}

// MARK: - Preview

#if DEBUG
struct InvertModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("INVERT")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.blue)
                .invert()
            
            Image(systemName: "photo.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
                .xray()
            
            Image(systemName: "sun.max.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
                .solarize(threshold: 0.6)
        }
        .padding()
    }
}
#endif

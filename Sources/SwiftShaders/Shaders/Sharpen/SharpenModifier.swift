// Sharpen Effect Modifier
// SwiftUI wrapper for sharpen and clarity shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Sharpen Configuration

/// Sharpen effect style presets
public enum SharpenStyle: String, CaseIterable, Sendable {
    case basic       // Simple kernel sharpen
    case unsharp     // Unsharp mask
    case highPass    // High-pass overlay
    case edges       // Edge enhancement
    case clarity     // Midtone contrast
}

/// Sharpen shader configuration
public struct SharpenConfiguration: Sendable {
    /// Sharpen intensity
    public var amount: Float
    
    /// Blur radius for unsharp mask
    public var radius: Float
    
    /// Threshold for unsharp mask
    public var threshold: Float
    
    public init(
        amount: Float = 1.0,
        radius: Float = 2.0,
        threshold: Float = 0.0
    ) {
        self.amount = amount
        self.radius = radius
        self.threshold = threshold
    }
    
    // Presets
    public static let subtle = SharpenConfiguration(amount: 0.5)
    public static let medium = SharpenConfiguration(amount: 1.0)
    public static let strong = SharpenConfiguration(amount: 2.0)
    
    public static let portrait = SharpenConfiguration(
        amount: 0.7,
        radius: 1.0,
        threshold: 0.1
    )
    
    public static let landscape = SharpenConfiguration(
        amount: 1.2,
        radius: 2.0,
        threshold: 0.05
    )
}

// MARK: - View Modifiers

/// Basic kernel sharpen
public struct SharpenModifier: ViewModifier {
    let amount: Float
    
    public init(amount: Float = 1.0) {
        self.amount = amount
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sharpen(
                        .float2(proxy.size),
                        .float(amount)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Unsharp mask sharpen
public struct UnsharpMaskModifier: ViewModifier {
    let configuration: SharpenConfiguration
    
    public init(configuration: SharpenConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.unsharpMask(
                        .float2(proxy.size),
                        .float(configuration.radius),
                        .float(configuration.amount),
                        .float(configuration.threshold)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.radius + 1,
                        height: configuration.radius + 1
                    )
                )
            }
    }
}

/// High-pass sharpen
public struct HighPassSharpenModifier: ViewModifier {
    let radius: Float
    let strength: Float
    
    public init(radius: Float = 3.0, strength: Float = 1.0) {
        self.radius = radius
        self.strength = strength
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sharpenHighPass(
                        .float2(proxy.size),
                        .float(radius),
                        .float(strength)
                    ),
                    maxSampleOffset: CGSize(
                        width: radius + 1,
                        height: radius + 1
                    )
                )
            }
    }
}

/// Edge enhancement
public struct EdgeEnhanceModifier: ViewModifier {
    let amount: Float
    
    public init(amount: Float = 1.0) {
        self.amount = amount
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sharpenEdges(
                        .float2(proxy.size),
                        .float(amount)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Clarity (midtone contrast)
public struct ClarityModifier: ViewModifier {
    let amount: Float
    let radius: Float
    
    public init(amount: Float = 1.0, radius: Float = 3.0) {
        self.amount = amount
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sharpenClarity(
                        .float2(proxy.size),
                        .float(radius),
                        .float(amount)
                    ),
                    maxSampleOffset: CGSize(
                        width: radius + 1,
                        height: radius + 1
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies basic sharpen effect
    func sharpen(amount: Float = 1.0) -> some View {
        modifier(SharpenModifier(amount: amount))
    }
    
    /// Applies unsharp mask
    func unsharpMask(
        radius: Float = 2.0,
        amount: Float = 1.0,
        threshold: Float = 0.0
    ) -> some View {
        modifier(UnsharpMaskModifier(configuration: SharpenConfiguration(
            amount: amount,
            radius: radius,
            threshold: threshold
        )))
    }
    
    /// Applies high-pass sharpen
    func highPassSharpen(radius: Float = 3.0, strength: Float = 1.0) -> some View {
        modifier(HighPassSharpenModifier(radius: radius, strength: strength))
    }
    
    /// Applies edge enhancement
    func enhanceEdges(amount: Float = 1.0) -> some View {
        modifier(EdgeEnhanceModifier(amount: amount))
    }
    
    /// Applies clarity (midtone contrast)
    func clarity(amount: Float = 1.0) -> some View {
        modifier(ClarityModifier(amount: amount))
    }
    
    /// Applies portrait-optimized sharpening
    func sharpenPortrait() -> some View {
        modifier(UnsharpMaskModifier(configuration: .portrait))
    }
    
    /// Applies landscape-optimized sharpening
    func sharpenLandscape() -> some View {
        modifier(UnsharpMaskModifier(configuration: .landscape))
    }
}

// MARK: - Preview

#if DEBUG
struct SharpenModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("SHARP")
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(.blue)
                .sharpen(amount: 1.5)
            
            Image(systemName: "photo.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
                .clarity(amount: 2.0)
        }
        .padding()
    }
}
#endif

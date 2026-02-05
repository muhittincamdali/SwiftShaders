// Frost Effect Modifier
// SwiftUI wrapper for frost and ice shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Frost Configuration

/// Frost effect style presets
public enum FrostStyle: String, CaseIterable, Sendable {
    case glass      // Frosted glass effect
    case window     // Window frost from edges
    case crystal    // Ice crystal overlay
    case breath     // Breath on cold glass
    case frozen     // Frozen surface
}

/// Frost shader configuration
public struct FrostConfiguration: Sendable {
    /// Frost coverage/intensity
    public var amount: Float
    
    /// Crystal pattern scale
    public var crystalScale: Float
    
    /// Blur amount
    public var blurAmount: Float
    
    /// Ice thickness
    public var thickness: Float
    
    /// Breath center point
    public var breathCenter: CGPoint
    
    /// Animation enabled
    public var animated: Bool
    
    public init(
        amount: Float = 0.5,
        crystalScale: Float = 10.0,
        blurAmount: Float = 5.0,
        thickness: Float = 0.5,
        breathCenter: CGPoint = CGPoint(x: 0.5, y: 0.5),
        animated: Bool = false
    ) {
        self.amount = amount
        self.crystalScale = crystalScale
        self.blurAmount = blurAmount
        self.thickness = thickness
        self.breathCenter = breathCenter
        self.animated = animated
    }
    
    // Presets
    public static let light = FrostConfiguration(amount: 0.3, blurAmount: 3.0)
    public static let medium = FrostConfiguration(amount: 0.5, blurAmount: 5.0)
    public static let heavy = FrostConfiguration(amount: 0.8, blurAmount: 8.0)
    public static let window = FrostConfiguration(amount: 0.4, thickness: 6.0)
}

// MARK: - View Modifiers

/// Frosted glass effect
public struct FrostedGlassModifier: ViewModifier {
    let configuration: FrostConfiguration
    
    public init(configuration: FrostConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.frostedGlass(
                        .float2(proxy.size),
                        .float(configuration.amount),
                        .float(configuration.crystalScale),
                        .float(configuration.blurAmount)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.blurAmount * 2,
                        height: configuration.blurAmount * 2
                    )
                )
            }
    }
}

/// Ice crystal overlay
public struct IceCrystalsModifier: ViewModifier {
    let crystalDensity: Float
    let shimmerSpeed: Float
    @State private var startTime = Date.now
    
    public init(crystalDensity: Float = 10.0, shimmerSpeed: Float = 2.0) {
        self.crystalDensity = crystalDensity
        self.shimmerSpeed = shimmerSpeed
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.iceCrystals(
                            .float2(proxy.size),
                            .float(time),
                            .float(crystalDensity),
                            .float(shimmerSpeed)
                        )
                    )
                }
        }
    }
}

/// Window frost effect (from edges)
public struct WindowFrostModifier: ViewModifier {
    let coverage: Float
    let thickness: Float
    
    public init(coverage: Float = 0.3, thickness: Float = 5.0) {
        self.coverage = coverage
        self.thickness = thickness
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.windowFrost(
                        .float2(proxy.size),
                        .float(coverage),
                        .float(thickness)
                    ),
                    maxSampleOffset: CGSize(width: thickness, height: thickness)
                )
            }
    }
}

/// Breath on cold glass effect
public struct BreathFrostModifier: ViewModifier {
    let center: CGPoint
    let size: Float
    @State private var fadeAmount: Float = 0.0
    
    public init(center: CGPoint = CGPoint(x: 0.5, y: 0.5), size: Float = 0.3) {
        self.center = center
        self.size = size
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.breathFrost(
                        .float2(proxy.size),
                        .float2(Float(center.x), Float(center.y)),
                        .float(size),
                        .float(fadeAmount)
                    )
                )
            }
    }
}

/// Frozen surface effect
public struct FrozenSurfaceModifier: ViewModifier {
    let crackDensity: Float
    let thickness: Float
    
    public init(crackDensity: Float = 15.0, thickness: Float = 0.7) {
        self.crackDensity = crackDensity
        self.thickness = thickness
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.frozenSurface(
                        .float2(proxy.size),
                        .float(crackDensity),
                        .float(thickness)
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies frosted glass effect
    func frostedGlass(
        amount: Float = 0.5,
        blurAmount: Float = 5.0
    ) -> some View {
        modifier(FrostedGlassModifier(configuration: FrostConfiguration(
            amount: amount,
            blurAmount: blurAmount
        )))
    }
    
    /// Applies light frost preset
    func frostLight() -> some View {
        modifier(FrostedGlassModifier(configuration: .light))
    }
    
    /// Applies heavy frost preset
    func frostHeavy() -> some View {
        modifier(FrostedGlassModifier(configuration: .heavy))
    }
    
    /// Applies animated ice crystals
    func iceCrystals(density: Float = 10.0) -> some View {
        modifier(IceCrystalsModifier(crystalDensity: density))
    }
    
    /// Applies window frost effect
    func windowFrost(coverage: Float = 0.3) -> some View {
        modifier(WindowFrostModifier(coverage: coverage))
    }
    
    /// Applies breath on glass effect
    func breathFrost(at center: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> some View {
        modifier(BreathFrostModifier(center: center))
    }
    
    /// Applies frozen surface effect
    func frozen(thickness: Float = 0.7) -> some View {
        modifier(FrozenSurfaceModifier(thickness: thickness))
    }
}

// MARK: - Preview

#if DEBUG
struct FrostModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("FROST")
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(.blue)
                .padding(30)
                .background(.white)
                .frostedGlass()
            
            Image(systemName: "snowflake")
                .font(.system(size: 60))
                .foregroundStyle(.cyan)
                .iceCrystals()
        }
        .padding()
        .background(Color.blue.opacity(0.3))
    }
}
#endif

// Kaleidoscope Effect Modifier
// SwiftUI wrapper for kaleidoscope shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Kaleidoscope Configuration

/// Kaleidoscope pattern types
public enum KaleidoscopePattern: String, CaseIterable, Sendable {
    case classic     // Radial mirror segments
    case triangle    // Triangular tessellation
    case square      // 4-fold symmetry
    case hexagonal   // Hexagonal pattern
    case radial      // Spiral kaleidoscope
}

/// Kaleidoscope shader configuration
public struct KaleidoscopeConfiguration: Sendable {
    /// Number of mirror segments
    public var segments: Float
    
    /// Center point (normalized)
    public var center: CGPoint
    
    /// Pattern scale
    public var scale: Float
    
    /// Rotation angle in degrees
    public var rotation: Float
    
    /// Animation speed
    public var animationSpeed: Float
    
    /// Spiral amount for radial mode
    public var spiralAmount: Float
    
    /// Zoom animation speed
    public var zoomSpeed: Float
    
    public init(
        segments: Float = 6.0,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        scale: Float = 1.0,
        rotation: Float = 0.0,
        animationSpeed: Float = 1.0,
        spiralAmount: Float = 0.0,
        zoomSpeed: Float = 0.5
    ) {
        self.segments = segments
        self.center = center
        self.scale = scale
        self.rotation = rotation
        self.animationSpeed = animationSpeed
        self.spiralAmount = spiralAmount
        self.zoomSpeed = zoomSpeed
    }
    
    /// Rotation in radians
    var rotationRadians: Float {
        rotation * .pi / 180.0
    }
    
    // Presets
    public static let simple = KaleidoscopeConfiguration(segments: 4)
    public static let classic = KaleidoscopeConfiguration(segments: 6)
    public static let complex = KaleidoscopeConfiguration(segments: 12)
    public static let snowflake = KaleidoscopeConfiguration(segments: 6, scale: 2.0)
    public static let spiral = KaleidoscopeConfiguration(segments: 8, spiralAmount: 2.0)
}

// MARK: - View Modifiers

/// Classic radial kaleidoscope
public struct KaleidoscopeModifier: ViewModifier {
    let configuration: KaleidoscopeConfiguration
    
    public init(configuration: KaleidoscopeConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.kaleidoscope(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.segments),
                        .float(configuration.rotationRadians)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Animated kaleidoscope
public struct KaleidoscopeAnimatedModifier: ViewModifier {
    let configuration: KaleidoscopeConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: KaleidoscopeConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.layerEffect(
                        ShaderLibrary.kaleidoscopeAnimated(
                            .float2(proxy.size),
                            .float2(Float(configuration.center.x), Float(configuration.center.y)),
                            .float(configuration.segments),
                            .float(time),
                            .float(configuration.animationSpeed),
                            .float(configuration.zoomSpeed)
                        ),
                        maxSampleOffset: proxy.size
                    )
                }
        }
    }
}

/// Triangle kaleidoscope
public struct KaleidoscopeTriangleModifier: ViewModifier {
    let configuration: KaleidoscopeConfiguration
    
    public init(configuration: KaleidoscopeConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.kaleidoscopeTriangle(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.scale),
                        .float(configuration.rotationRadians)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Square kaleidoscope
public struct KaleidoscopeSquareModifier: ViewModifier {
    let configuration: KaleidoscopeConfiguration
    
    public init(configuration: KaleidoscopeConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.kaleidoscopeSquare(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.scale),
                        .float(configuration.rotationRadians)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

/// Hexagonal kaleidoscope
public struct KaleidoscopeHexModifier: ViewModifier {
    let configuration: KaleidoscopeConfiguration
    
    public init(configuration: KaleidoscopeConfiguration = .classic) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.kaleidoscopeHex(
                        .float2(proxy.size),
                        .float2(Float(configuration.center.x), Float(configuration.center.y)),
                        .float(configuration.scale),
                        .float(configuration.rotationRadians)
                    ),
                    maxSampleOffset: proxy.size
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies classic kaleidoscope effect
    func kaleidoscope(
        segments: Float = 6,
        rotation: Float = 0
    ) -> some View {
        modifier(KaleidoscopeModifier(configuration: KaleidoscopeConfiguration(
            segments: segments,
            rotation: rotation
        )))
    }
    
    /// Applies animated kaleidoscope
    func kaleidoscopeAnimated(
        segments: Float = 6,
        speed: Float = 1.0
    ) -> some View {
        modifier(KaleidoscopeAnimatedModifier(configuration: KaleidoscopeConfiguration(
            segments: segments,
            animationSpeed: speed
        )))
    }
    
    /// Applies triangle kaleidoscope
    func kaleidoscopeTriangle(scale: Float = 3.0) -> some View {
        modifier(KaleidoscopeTriangleModifier(configuration: KaleidoscopeConfiguration(
            scale: scale
        )))
    }
    
    /// Applies square kaleidoscope
    func kaleidoscopeSquare(scale: Float = 3.0) -> some View {
        modifier(KaleidoscopeSquareModifier(configuration: KaleidoscopeConfiguration(
            scale: scale
        )))
    }
    
    /// Applies hexagonal kaleidoscope
    func kaleidoscopeHex(scale: Float = 3.0) -> some View {
        modifier(KaleidoscopeHexModifier(configuration: KaleidoscopeConfiguration(
            scale: scale
        )))
    }
    
    /// Applies snowflake-like kaleidoscope
    func kaleidoscopeSnowflake() -> some View {
        modifier(KaleidoscopeModifier(configuration: .snowflake))
    }
}

// MARK: - Preview

#if DEBUG
struct KaleidoscopeModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
                .frame(width: 200, height: 200)
                .background(
                    LinearGradient(
                        colors: [.red, .blue, .green],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .kaleidoscope(segments: 8)
        }
        .padding()
    }
}
#endif

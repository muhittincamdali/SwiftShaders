// CRT Monitor Effect Modifier
// SwiftUI wrapper for CRT shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - CRT Shader Types

/// CRT effect style presets
public enum CRTStyle: String, CaseIterable, Sendable {
    case classic       // Classic CRT with all effects
    case simple        // Just scanlines
    case arcade        // Arcade monitor style
    case television    // Old TV style with more flicker
    case monitor       // Computer monitor style
}

/// CRT shader configuration
public struct CRTConfiguration: Sendable {
    /// Screen curvature amount (0.0 = flat, 0.5 = very curved)
    public var curvature: Float
    
    /// Scanline intensity (0.0 = none, 1.0 = very dark)
    public var scanlineIntensity: Float
    
    /// Phosphor dot scale
    public var phosphorScale: Float
    
    /// Edge vignette intensity
    public var vignetteIntensity: Float
    
    /// Chromatic aberration amount
    public var chromaticAberration: Float
    
    /// Enable flicker animation
    public var flickerEnabled: Bool
    
    /// Scanline count for simple mode
    public var scanlineCount: Float
    
    public init(
        curvature: Float = 0.1,
        scanlineIntensity: Float = 0.3,
        phosphorScale: Float = 800.0,
        vignetteIntensity: Float = 0.3,
        chromaticAberration: Float = 2.0,
        flickerEnabled: Bool = true,
        scanlineCount: Float = 240.0
    ) {
        self.curvature = curvature
        self.scanlineIntensity = scanlineIntensity
        self.phosphorScale = phosphorScale
        self.vignetteIntensity = vignetteIntensity
        self.chromaticAberration = chromaticAberration
        self.flickerEnabled = flickerEnabled
        self.scanlineCount = scanlineCount
    }
    
    /// Preset configurations
    public static let classic = CRTConfiguration()
    
    public static let arcade = CRTConfiguration(
        curvature: 0.15,
        scanlineIntensity: 0.4,
        phosphorScale: 600.0,
        vignetteIntensity: 0.4
    )
    
    public static let television = CRTConfiguration(
        curvature: 0.2,
        scanlineIntensity: 0.25,
        phosphorScale: 400.0,
        vignetteIntensity: 0.5,
        flickerEnabled: true
    )
    
    public static let monitor = CRTConfiguration(
        curvature: 0.05,
        scanlineIntensity: 0.15,
        phosphorScale: 1000.0,
        vignetteIntensity: 0.2
    )
    
    public static let simple = CRTConfiguration(
        curvature: 0.0,
        scanlineIntensity: 0.2,
        phosphorScale: 0.0,
        vignetteIntensity: 0.1
    )
}

// MARK: - CRT View Modifier

/// Applies CRT monitor effect to any SwiftUI view
public struct CRTModifier: ViewModifier {
    let configuration: CRTConfiguration
    let style: CRTStyle
    
    @State private var startTime = Date.now
    
    public init(configuration: CRTConfiguration = .classic, style: CRTStyle = .classic) {
        self.configuration = configuration
        self.style = style
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1/60, paused: !configuration.flickerEnabled)) { timeline in
            let time = configuration.flickerEnabled ? 
                startTime.distance(to: timeline.date) : 0.0
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.crtEffect(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.curvature),
                            .float(configuration.scanlineIntensity),
                            .float(configuration.phosphorScale),
                            .float(configuration.vignetteIntensity)
                        )
                    )
                }
        }
    }
}

/// Simple CRT modifier with just scanlines
public struct CRTSimpleModifier: ViewModifier {
    let scanlineCount: Float
    
    public init(scanlineCount: Float = 240.0) {
        self.scanlineCount = scanlineCount
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.crtSimple(
                        .float2(proxy.size),
                        .float(scanlineCount)
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies CRT monitor effect
    /// - Parameters:
    ///   - configuration: CRT effect configuration
    ///   - style: CRT style preset
    func crtEffect(
        configuration: CRTConfiguration = .classic,
        style: CRTStyle = .classic
    ) -> some View {
        modifier(CRTModifier(configuration: configuration, style: style))
    }
    
    /// Applies simple CRT scanlines
    /// - Parameter scanlineCount: Number of scanlines
    func crtScanlines(count: Float = 240.0) -> some View {
        modifier(CRTSimpleModifier(scanlineCount: count))
    }
    
    /// Applies arcade-style CRT effect
    func arcadeCRT() -> some View {
        modifier(CRTModifier(configuration: .arcade, style: .arcade))
    }
    
    /// Applies old television CRT effect
    func televisionCRT() -> some View {
        modifier(CRTModifier(configuration: .television, style: .television))
    }
}

// MARK: - Preview

#if DEBUG
struct CRTModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("CRT EFFECT")
                .font(.largeTitle.bold())
                .foregroundStyle(.green)
                .padding()
                .background(.black)
                .crtEffect()
            
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundStyle(.cyan)
                .padding()
                .background(.black)
                .arcadeCRT()
        }
        .padding()
        .background(.black)
    }
}
#endif

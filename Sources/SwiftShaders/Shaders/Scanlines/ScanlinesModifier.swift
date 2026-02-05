// Scanlines Effect Modifier
// SwiftUI wrapper for scanline shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Scanlines Configuration

/// Scanline style presets
public enum ScanlinesStyle: String, CaseIterable, Sendable {
    case basic       // Simple horizontal scanlines
    case interlaced  // Alternating lines (CRT simulation)
    case vhs         // VHS tape effect
    case lcd         // LCD pixel grid
    case rolling     // Animated rolling band
    case diagonal    // Angled lines
}

/// Scanlines shader configuration
public struct ScanlinesConfiguration: Sendable {
    /// Number of scanlines
    public var lineCount: Float
    
    /// Line darkness intensity
    public var intensity: Float
    
    /// Overall brightness
    public var brightness: Float
    
    /// Animation speed
    public var speed: Float
    
    /// VHS noise amount
    public var noiseAmount: Float
    
    /// LCD pixel size
    public var pixelSize: Float
    
    /// Line angle for diagonal mode (radians)
    public var angle: Float
    
    public init(
        lineCount: Float = 240.0,
        intensity: Float = 0.3,
        brightness: Float = 1.0,
        speed: Float = 1.0,
        noiseAmount: Float = 0.2,
        pixelSize: Float = 3.0,
        angle: Float = 0.785
    ) {
        self.lineCount = lineCount
        self.intensity = intensity
        self.brightness = brightness
        self.speed = speed
        self.noiseAmount = noiseAmount
        self.pixelSize = pixelSize
        self.angle = angle
    }
    
    // Presets
    public static let subtle = ScanlinesConfiguration(
        lineCount: 200,
        intensity: 0.15
    )
    
    public static let retro = ScanlinesConfiguration(
        lineCount: 240,
        intensity: 0.35
    )
    
    public static let crt = ScanlinesConfiguration(
        lineCount: 480,
        intensity: 0.25
    )
    
    public static let vhs = ScanlinesConfiguration(
        intensity: 0.3,
        noiseAmount: 0.3
    )
    
    public static let arcade = ScanlinesConfiguration(
        lineCount: 240,
        intensity: 0.4,
        brightness: 1.1
    )
}

// MARK: - View Modifiers

/// Basic horizontal scanlines
public struct ScanlinesModifier: ViewModifier {
    let configuration: ScanlinesConfiguration
    
    public init(configuration: ScanlinesConfiguration = .subtle) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.scanlines(
                        .float2(proxy.size),
                        .float(configuration.lineCount),
                        .float(configuration.intensity),
                        .float(configuration.brightness)
                    )
                )
            }
    }
}

/// Interlaced scanlines (animated)
public struct ScanlinesInterlacedModifier: ViewModifier {
    let configuration: ScanlinesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ScanlinesConfiguration = .retro) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.scanlinesInterlaced(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.lineCount),
                            .float(configuration.intensity)
                        )
                    )
                }
        }
    }
}

/// VHS-style scanlines with noise
public struct ScanlinesVHSModifier: ViewModifier {
    let configuration: ScanlinesConfiguration
    @State private var startTime = Date.now
    
    public init(configuration: ScanlinesConfiguration = .vhs) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.scanlinesVHS(
                            .float2(proxy.size),
                            .float(time),
                            .float(configuration.intensity),
                            .float(configuration.noiseAmount)
                        )
                    )
                }
        }
    }
}

/// LCD pixel grid effect
public struct ScanlinesLCDModifier: ViewModifier {
    let configuration: ScanlinesConfiguration
    
    public init(pixelSize: Float = 3.0, intensity: Float = 0.5) {
        self.configuration = ScanlinesConfiguration(
            intensity: intensity,
            pixelSize: pixelSize
        )
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.scanlinesLCD(
                        .float2(proxy.size),
                        .float(configuration.pixelSize),
                        .float(1.0), // gap size
                        .float(configuration.intensity)
                    )
                )
            }
    }
}

/// Rolling scanline animation
public struct ScanlinesRollingModifier: ViewModifier {
    let speed: Float
    let intensity: Float
    @State private var startTime = Date.now
    
    public init(speed: Float = 0.5, intensity: Float = 0.3) {
        self.speed = speed
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .visualEffect { view, proxy in
                    view.colorEffect(
                        ShaderLibrary.scanlinesRolling(
                            .float2(proxy.size),
                            .float(time),
                            .float(speed),
                            .float(0.1), // width
                            .float(intensity)
                        )
                    )
                }
        }
    }
}

/// Diagonal line pattern
public struct ScanlinesDiagonalModifier: ViewModifier {
    let angle: Float
    let spacing: Float
    let intensity: Float
    
    public init(angle: Float = 0.785, spacing: Float = 5.0, intensity: Float = 0.3) {
        self.angle = angle
        self.spacing = spacing
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.scanlinesDiagonal(
                        .float2(proxy.size),
                        .float(angle),
                        .float(spacing),
                        .float(intensity)
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies basic scanlines
    func scanlines(
        count: Float = 240,
        intensity: Float = 0.3
    ) -> some View {
        modifier(ScanlinesModifier(configuration: ScanlinesConfiguration(
            lineCount: count,
            intensity: intensity
        )))
    }
    
    /// Applies subtle scanlines preset
    func scanlinesSubtle() -> some View {
        modifier(ScanlinesModifier(configuration: .subtle))
    }
    
    /// Applies retro CRT scanlines
    func scanlinesCRT() -> some View {
        modifier(ScanlinesModifier(configuration: .crt))
    }
    
    /// Applies interlaced scanlines (animated)
    func scanlinesInterlaced(intensity: Float = 0.3) -> some View {
        modifier(ScanlinesInterlacedModifier(configuration: ScanlinesConfiguration(
            intensity: intensity
        )))
    }
    
    /// Applies VHS tape effect
    func scanlinesVHS(noiseAmount: Float = 0.2) -> some View {
        modifier(ScanlinesVHSModifier(configuration: ScanlinesConfiguration(
            noiseAmount: noiseAmount
        )))
    }
    
    /// Applies LCD pixel grid
    func scanlinesLCD(pixelSize: Float = 3.0) -> some View {
        modifier(ScanlinesLCDModifier(pixelSize: pixelSize))
    }
    
    /// Applies rolling scanline animation
    func scanlinesRolling(speed: Float = 0.5) -> some View {
        modifier(ScanlinesRollingModifier(speed: speed))
    }
    
    /// Applies diagonal line pattern
    func scanlinesDiagonal(angle: Float = 0.785) -> some View {
        modifier(ScanlinesDiagonalModifier(angle: angle))
    }
}

// MARK: - Preview

#if DEBUG
struct ScanlinesModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("RETRO")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.green)
                .padding()
                .background(.black)
                .scanlines()
            
            Image(systemName: "tv.fill")
                .font(.system(size: 60))
                .foregroundStyle(.cyan)
                .padding()
                .background(.black)
                .scanlinesCRT()
        }
        .padding()
    }
}
#endif

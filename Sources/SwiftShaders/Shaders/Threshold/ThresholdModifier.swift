// Threshold Effect Modifier
// SwiftUI wrapper for threshold shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Threshold Configuration

/// Threshold effect style presets
public enum ThresholdStyle: String, CaseIterable, Sendable {
    case binary    // Simple black/white
    case dithered  // Bayer dithering
    case smooth    // Soft transition
    case halftone  // Dot pattern
    case multi     // Multiple levels
}

/// Threshold shader configuration
public struct ThresholdConfiguration: Sendable {
    /// Threshold cutoff (0.0-1.0)
    public var threshold: Float
    
    /// Softness for smooth threshold
    public var softness: Float
    
    /// Number of levels for multi-level
    public var levels: Float
    
    /// Low (dark) color
    public var lowColor: Color
    
    /// High (bright) color
    public var highColor: Color
    
    /// Mid color for triple threshold
    public var midColor: Color
    
    /// Halftone dot size
    public var dotSize: Float
    
    /// Halftone angle in degrees
    public var angle: Float
    
    public init(
        threshold: Float = 0.5,
        softness: Float = 0.1,
        levels: Float = 4.0,
        lowColor: Color = .black,
        highColor: Color = .white,
        midColor: Color = .gray,
        dotSize: Float = 8.0,
        angle: Float = 45.0
    ) {
        self.threshold = threshold
        self.softness = softness
        self.levels = levels
        self.lowColor = lowColor
        self.highColor = highColor
        self.midColor = midColor
        self.dotSize = dotSize
        self.angle = angle
    }
    
    /// Angle in radians
    var angleRadians: Float {
        angle * .pi / 180.0
    }
    
    // Presets
    public static let binary = ThresholdConfiguration()
    public static let highContrast = ThresholdConfiguration(threshold: 0.4)
    public static let lowContrast = ThresholdConfiguration(threshold: 0.6)
    public static let newspaper = ThresholdConfiguration(dotSize: 6.0, angle: 45.0)
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Basic binary threshold
public struct ThresholdModifier: ViewModifier {
    let configuration: ThresholdConfiguration
    
    public init(configuration: ThresholdConfiguration = .binary) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (lr, lg, lb) = colorToFloat3(configuration.lowColor)
        let (hr, hg, hb) = colorToFloat3(configuration.highColor)
        
        return content
            .colorEffect(
                ShaderLibrary.threshold(
                    .float(configuration.threshold),
                    .float3(lr, lg, lb),
                    .float3(hr, hg, hb)
                )
            )
    }
}

/// Dithered threshold
public struct ThresholdDitheredModifier: ViewModifier {
    let configuration: ThresholdConfiguration
    
    public init(configuration: ThresholdConfiguration = .binary) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (lr, lg, lb) = colorToFloat3(configuration.lowColor)
        let (hr, hg, hb) = colorToFloat3(configuration.highColor)
        
        return content
            .colorEffect(
                ShaderLibrary.thresholdDithered(
                    .float(configuration.threshold),
                    .float3(lr, lg, lb),
                    .float3(hr, hg, hb)
                )
            )
    }
}

/// Smooth threshold with soft edges
public struct ThresholdSmoothModifier: ViewModifier {
    let configuration: ThresholdConfiguration
    
    public init(configuration: ThresholdConfiguration = .binary) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (lr, lg, lb) = colorToFloat3(configuration.lowColor)
        let (hr, hg, hb) = colorToFloat3(configuration.highColor)
        
        return content
            .colorEffect(
                ShaderLibrary.thresholdSmooth(
                    .float(configuration.threshold),
                    .float(configuration.softness),
                    .float3(lr, lg, lb),
                    .float3(hr, hg, hb)
                )
            )
    }
}

/// Halftone dot pattern
public struct ThresholdHalftoneModifier: ViewModifier {
    let configuration: ThresholdConfiguration
    
    public init(configuration: ThresholdConfiguration = .newspaper) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.colorEffect(
                    ShaderLibrary.thresholdHalftone(
                        .float2(proxy.size),
                        .float(configuration.dotSize),
                        .float(configuration.angleRadians)
                    )
                )
            }
    }
}

/// Multi-level threshold
public struct ThresholdMultiLevelModifier: ViewModifier {
    let levels: Float
    let tintColor: Color
    
    public init(levels: Float = 4.0, tintColor: Color = .white) {
        self.levels = levels
        self.tintColor = tintColor
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(tintColor)
        
        return content
            .colorEffect(
                ShaderLibrary.thresholdMultiLevel(
                    .float(levels),
                    .float3(r, g, b)
                )
            )
    }
}

/// Animated threshold
public struct ThresholdAnimatedModifier: ViewModifier {
    let configuration: ThresholdConfiguration
    let speed: Float
    let amplitude: Float
    @State private var startTime = Date.now
    
    public init(
        configuration: ThresholdConfiguration = .binary,
        speed: Float = 2.0,
        amplitude: Float = 0.3
    ) {
        self.configuration = configuration
        self.speed = speed
        self.amplitude = amplitude
    }
    
    public func body(content: Content) -> some View {
        let (lr, lg, lb) = colorToFloat3(configuration.lowColor)
        let (hr, hg, hb) = colorToFloat3(configuration.highColor)
        
        return TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            content
                .colorEffect(
                    ShaderLibrary.thresholdAnimated(
                        .float(time),
                        .float(speed),
                        .float(amplitude),
                        .float3(lr, lg, lb),
                        .float3(hr, hg, hb)
                    )
                )
        }
    }
}

/// Triple threshold (three tones)
public struct ThresholdTripleModifier: ViewModifier {
    let threshold1: Float
    let threshold2: Float
    let darkColor: Color
    let midColor: Color
    let lightColor: Color
    
    public init(
        threshold1: Float = 0.33,
        threshold2: Float = 0.66,
        darkColor: Color = .black,
        midColor: Color = .gray,
        lightColor: Color = .white
    ) {
        self.threshold1 = threshold1
        self.threshold2 = threshold2
        self.darkColor = darkColor
        self.midColor = midColor
        self.lightColor = lightColor
    }
    
    public func body(content: Content) -> some View {
        let (dr, dg, db) = colorToFloat3(darkColor)
        let (mr, mg, mb) = colorToFloat3(midColor)
        let (lr, lg, lb) = colorToFloat3(lightColor)
        
        return content
            .colorEffect(
                ShaderLibrary.thresholdTriple(
                    .float(threshold1),
                    .float(threshold2),
                    .float3(dr, dg, db),
                    .float3(mr, mg, mb),
                    .float3(lr, lg, lb)
                )
            )
    }
}

// MARK: - View Extension

public extension View {
    /// Applies binary threshold
    func threshold(_ value: Float = 0.5) -> some View {
        modifier(ThresholdModifier(configuration: ThresholdConfiguration(
            threshold: value
        )))
    }
    
    /// Applies threshold with custom colors
    func threshold(
        _ value: Float = 0.5,
        low: Color = .black,
        high: Color = .white
    ) -> some View {
        modifier(ThresholdModifier(configuration: ThresholdConfiguration(
            threshold: value,
            lowColor: low,
            highColor: high
        )))
    }
    
    /// Applies dithered threshold
    func thresholdDithered(_ value: Float = 0.5) -> some View {
        modifier(ThresholdDitheredModifier(configuration: ThresholdConfiguration(
            threshold: value
        )))
    }
    
    /// Applies smooth threshold
    func thresholdSmooth(_ value: Float = 0.5, softness: Float = 0.1) -> some View {
        modifier(ThresholdSmoothModifier(configuration: ThresholdConfiguration(
            threshold: value,
            softness: softness
        )))
    }
    
    /// Applies halftone effect
    func halftone(dotSize: Float = 8.0, angle: Float = 45.0) -> some View {
        modifier(ThresholdHalftoneModifier(configuration: ThresholdConfiguration(
            dotSize: dotSize,
            angle: angle
        )))
    }
    
    /// Applies multi-level threshold
    func thresholdLevels(_ levels: Float = 4.0) -> some View {
        modifier(ThresholdMultiLevelModifier(levels: levels))
    }
    
    /// Applies animated threshold
    func thresholdAnimated(speed: Float = 2.0) -> some View {
        modifier(ThresholdAnimatedModifier(speed: speed))
    }
    
    /// Applies triple threshold (three tones)
    func thresholdTriple(
        dark: Color = .black,
        mid: Color = .gray,
        light: Color = .white
    ) -> some View {
        modifier(ThresholdTripleModifier(
            darkColor: dark,
            midColor: mid,
            lightColor: light
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct ThresholdModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .threshold(0.5)
            
            Image(systemName: "person.fill")
                .font(.system(size: 80))
                .foregroundStyle(.gray)
                .halftone()
        }
        .padding()
    }
}
#endif

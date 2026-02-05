// Sketch Effect Modifier
// SwiftUI wrapper for sketch and drawing shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Sketch Configuration

/// Sketch effect style presets
public enum SketchStyle: String, CaseIterable, Sendable {
    case pencil      // Pencil drawing
    case crossHatch  // Cross-hatching
    case ink         // Ink drawing
    case charcoal    // Charcoal sketch
    case watercolor  // Watercolor effect
}

/// Sketch shader configuration
public struct SketchConfiguration: Sendable {
    /// Line intensity
    public var lineIntensity: Float
    
    /// Line spacing for hatching
    public var lineSpacing: Float
    
    /// Line width
    public var lineWidth: Float
    
    /// Edge threshold
    public var threshold: Float
    
    /// Paper color
    public var paperColor: Color
    
    /// Ink/pencil color
    public var inkColor: Color
    
    /// Smudge amount for charcoal
    public var smudgeAmount: Float
    
    public init(
        lineIntensity: Float = 1.0,
        lineSpacing: Float = 5.0,
        lineWidth: Float = 1.0,
        threshold: Float = 0.1,
        paperColor: Color = Color(white: 0.95),
        inkColor: Color = Color(white: 0.1),
        smudgeAmount: Float = 5.0
    ) {
        self.lineIntensity = lineIntensity
        self.lineSpacing = lineSpacing
        self.lineWidth = lineWidth
        self.threshold = threshold
        self.paperColor = paperColor
        self.inkColor = inkColor
        self.smudgeAmount = smudgeAmount
    }
    
    // Presets
    public static let pencil = SketchConfiguration()
    public static let pen = SketchConfiguration(lineIntensity: 1.5, inkColor: .black)
    public static let charcoal = SketchConfiguration(
        smudgeAmount: 8.0,
        inkColor: Color(white: 0.15)
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Pencil sketch effect
public struct SketchPencilModifier: ViewModifier {
    let configuration: SketchConfiguration
    
    public init(configuration: SketchConfiguration = .pencil) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (pr, pg, pb) = colorToFloat3(configuration.paperColor)
        let (ir, ig, ib) = colorToFloat3(configuration.inkColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sketchPencil(
                        .float2(proxy.size),
                        .float(configuration.lineIntensity),
                        .float3(pr, pg, pb),
                        .float3(ir, ig, ib)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Cross-hatch sketch effect
public struct SketchCrossHatchModifier: ViewModifier {
    let configuration: SketchConfiguration
    
    public init(configuration: SketchConfiguration = .pencil) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (pr, pg, pb) = colorToFloat3(configuration.paperColor)
        let (ir, ig, ib) = colorToFloat3(configuration.inkColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sketchCrossHatch(
                        .float2(proxy.size),
                        .float(configuration.lineSpacing),
                        .float(configuration.lineWidth),
                        .float3(pr, pg, pb),
                        .float3(ir, ig, ib)
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
            }
    }
}

/// Ink drawing effect
public struct SketchInkModifier: ViewModifier {
    let configuration: SketchConfiguration
    
    public init(configuration: SketchConfiguration = .pen) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (pr, pg, pb) = colorToFloat3(configuration.paperColor)
        let (ir, ig, ib) = colorToFloat3(configuration.inkColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sketchInk(
                        .float2(proxy.size),
                        .float(configuration.threshold),
                        .float(configuration.lineWidth),
                        .float3(pr, pg, pb),
                        .float3(ir, ig, ib)
                    ),
                    maxSampleOffset: CGSize(width: 5, height: 5)
                )
            }
    }
}

/// Charcoal sketch effect
public struct SketchCharcoalModifier: ViewModifier {
    let configuration: SketchConfiguration
    
    public init(configuration: SketchConfiguration = .charcoal) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (pr, pg, pb) = colorToFloat3(configuration.paperColor)
        let (ir, ig, ib) = colorToFloat3(configuration.inkColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sketchCharcoal(
                        .float2(proxy.size),
                        .float(configuration.smudgeAmount),
                        .float3(pr, pg, pb),
                        .float3(ir, ig, ib)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.smudgeAmount,
                        height: configuration.smudgeAmount
                    )
                )
            }
    }
}

/// Watercolor sketch effect
public struct SketchWatercolorModifier: ViewModifier {
    let bleedAmount: Float
    let edgeDarkening: Float
    
    public init(bleedAmount: Float = 5.0, edgeDarkening: Float = 1.0) {
        self.bleedAmount = bleedAmount
        self.edgeDarkening = edgeDarkening
    }
    
    public func body(content: Content) -> some View {
        content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.sketchWatercolor(
                        .float2(proxy.size),
                        .float(bleedAmount),
                        .float(edgeDarkening)
                    ),
                    maxSampleOffset: CGSize(
                        width: bleedAmount * 2,
                        height: bleedAmount * 2
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies pencil sketch effect
    func sketchPencil(intensity: Float = 1.0) -> some View {
        modifier(SketchPencilModifier(configuration: SketchConfiguration(
            lineIntensity: intensity
        )))
    }
    
    /// Applies cross-hatch sketch
    func sketchCrossHatch(
        spacing: Float = 5.0,
        lineWidth: Float = 1.0
    ) -> some View {
        modifier(SketchCrossHatchModifier(configuration: SketchConfiguration(
            lineSpacing: spacing,
            lineWidth: lineWidth
        )))
    }
    
    /// Applies ink drawing effect
    func sketchInk(threshold: Float = 0.1) -> some View {
        modifier(SketchInkModifier(configuration: SketchConfiguration(
            threshold: threshold
        )))
    }
    
    /// Applies charcoal sketch effect
    func sketchCharcoal(smudge: Float = 5.0) -> some View {
        modifier(SketchCharcoalModifier(configuration: SketchConfiguration(
            smudgeAmount: smudge
        )))
    }
    
    /// Applies watercolor effect
    func sketchWatercolor(bleed: Float = 5.0) -> some View {
        modifier(SketchWatercolorModifier(bleedAmount: bleed))
    }
}

// MARK: - Preview

#if DEBUG
struct SketchModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .frame(width: 150, height: 150)
                .background(.white)
                .sketchPencil()
            
            Image(systemName: "house.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
                .frame(width: 150, height: 150)
                .background(.white)
                .sketchCrossHatch()
        }
        .padding()
    }
}
#endif

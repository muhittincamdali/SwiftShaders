// Every effect in the package with one adjustable parameter. The gallery app builds its list
// from this catalog, and the package's tests render it into the README screenshots through the
// symlink Tests/SwiftShadersTests/EffectCatalog.swift.

import SwiftShaders
import SwiftUI

enum EffectGroup: String, CaseIterable, Identifiable {
    case color = "Color"
    case layer = "Layer"
    case distortion = "Distortion"

    var id: Self { self }
}

struct EffectDemo: Identifiable, Sendable {
    typealias Apply = @MainActor @Sendable (_ content: AnyView, _ value: Double, _ time: ShaderTime) -> AnyView

    let name: String
    let group: EffectGroup
    /// What the slider changes.
    let parameter: String
    let range: ClosedRange<Double>
    let initialValue: Double
    let apply: Apply

    var id: String { name }

    @MainActor
    func view(_ content: some View, value: Double? = nil, time: ShaderTime = .animated) -> AnyView {
        apply(AnyView(content), value ?? initialValue, time)
    }
}

extension EffectDemo {
    static let all: [EffectDemo] = [
        // Color effects.
        EffectDemo(name: "Sepia", group: .color, parameter: "Amount", range: 0...1, initialValue: 1) { content, value, _ in
            AnyView(content.sepia(value))
        },
        EffectDemo(name: "Duotone", group: .color, parameter: "Amount", range: 0...1, initialValue: 1) { content, value, _ in
            AnyView(content.duotone(shadows: Color(red: 0.05, green: 0.1, blue: 0.35), highlights: Color(red: 0.6, green: 0.9, blue: 1), amount: value))
        },
        EffectDemo(name: "Gradient map", group: .color, parameter: "Amount", range: 0...1, initialValue: 1) { content, value, _ in
            AnyView(content.gradientMap([.black, .indigo, .pink, .orange, .yellow], amount: value))
        },
        EffectDemo(name: "Posterize", group: .color, parameter: "Levels", range: 2...12, initialValue: 4) { content, value, _ in
            AnyView(content.posterize(levels: Int(value)))
        },
        EffectDemo(name: "Threshold", group: .color, parameter: "Cutoff", range: 0...1, initialValue: 0.4) { content, value, _ in
            AnyView(content.threshold(value, dark: Color(red: 0.03, green: 0.1, blue: 0.3), light: Color(red: 0.75, green: 0.9, blue: 1)))
        },
        EffectDemo(name: "Dither", group: .color, parameter: "Levels", range: 2...8, initialValue: 2) { content, value, _ in
            AnyView(content.dither(levels: Int(value)))
        },
        EffectDemo(name: "Vignette", group: .color, parameter: "Intensity", range: 0...1, initialValue: 0.8) { content, value, _ in
            AnyView(content.vignette(intensity: value))
        },
        EffectDemo(name: "Scanlines", group: .color, parameter: "Intensity", range: 0...1, initialValue: 0.4) { content, value, _ in
            AnyView(content.scanlines(spacing: 4, intensity: value))
        },
        EffectDemo(name: "Film grain", group: .color, parameter: "Intensity", range: 0...0.6, initialValue: 0.25) { content, value, time in
            AnyView(content.filmGrain(intensity: value, time: time))
        },
        EffectDemo(name: "Shimmer", group: .color, parameter: "Intensity", range: 0...1, initialValue: 0.6) { content, value, time in
            AnyView(content.shimmer(intensity: value, time: time))
        },

        // Layer effects.
        EffectDemo(name: "Pixelate", group: .layer, parameter: "Cell size", range: 1...40, initialValue: 10) { content, value, _ in
            AnyView(content.pixelate(cellSize: value))
        },
        EffectDemo(name: "Halftone", group: .layer, parameter: "Dot size", range: 3...24, initialValue: 7) { content, value, _ in
            AnyView(content.halftone(dotSize: value, ink: Color(red: 0.02, green: 0.15, blue: 0.4), paper: Color(red: 0.92, green: 0.96, blue: 1)))
        },
        EffectDemo(name: "Sketch", group: .layer, parameter: "Strength", range: 0.5...8, initialValue: 3) { content, value, _ in
            AnyView(content.sketch(strength: value, lineColor: Color(red: 0.02, green: 0.15, blue: 0.4)))
        },
        EffectDemo(name: "Emboss", group: .layer, parameter: "Strength", range: 0...4, initialValue: 1.5) { content, value, _ in
            AnyView(content.emboss(strength: value))
        },
        EffectDemo(name: "Sharpen", group: .layer, parameter: "Amount", range: 0...3, initialValue: 1) { content, value, _ in
            AnyView(content.sharpen(value))
        },
        EffectDemo(name: "Progressive blur", group: .layer, parameter: "Radius", range: 0...40, initialValue: 14) { content, value, _ in
            AnyView(content.progressiveBlur(radius: value, from: .center, to: .bottom))
        },
        EffectDemo(name: "Chromatic aberration", group: .layer, parameter: "Offset", range: 0...12, initialValue: 4) { content, value, _ in
            AnyView(content.chromaticAberration(offset: value))
        },
        EffectDemo(name: "Kaleidoscope", group: .layer, parameter: "Segments", range: 1...16, initialValue: 6) { content, value, _ in
            AnyView(content.kaleidoscope(segments: Int(value)))
        },
        EffectDemo(name: "Glitch", group: .layer, parameter: "Intensity", range: 0...1, initialValue: 0.6) { content, value, time in
            AnyView(content.glitch(intensity: value, time: time))
        },

        // Distortion effects.
        EffectDemo(name: "Wave", group: .distortion, parameter: "Amplitude", range: 0...20, initialValue: 6) { content, value, time in
            AnyView(content.wave(amplitude: value, wavelength: 90, time: time))
        },
        EffectDemo(name: "Water", group: .distortion, parameter: "Amplitude", range: 0...12, initialValue: 4) { content, value, time in
            AnyView(content.water(amplitude: value, time: time))
        },
        EffectDemo(name: "Swirl", group: .distortion, parameter: "Angle", range: -360...360, initialValue: 180) { content, value, _ in
            AnyView(content.swirl(angle: .degrees(value), radius: 0.5))
        },
        EffectDemo(name: "Bulge", group: .distortion, parameter: "Strength", range: -1...1, initialValue: 0.6) { content, value, _ in
            AnyView(content.bulge(strength: value, radius: 0.45))
        },
    ]
}

import SwiftUI

// Effects that read neighboring pixels. Most of them read only inside the view (the shaders clamp
// their sample positions), so SwiftUI needs no extra room around it. The effects that move content
// past the edges tell SwiftUI how far (maxSampleOffset), limited to the view's diagonal.

extension View {
    /// Draws the view as large square pixels.
    ///
    /// - Parameter cellSize: The side of each square, in points. 1 or less leaves the view as it
    ///   is.
    nonisolated public func pixelate(cellSize: Double = 8) -> some View {
        let cellSize = ShaderInput.length(cellSize)
        return modifier(ShaderEffect(
            kind: .layer,
            isEnabled: cellSize > 1,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssPixelate(.float2(size), .float(cellSize))
            }
        ))
    }

    /// Splits the red and blue channels apart, like a cheap lens.
    ///
    /// - Parameters:
    ///   - offset: How far red and blue move from green, in points (in opposite directions).
    ///   - angle: The direction red moves in; 0 is to the right.
    nonisolated public func chromaticAberration(offset: Double = 3, angle: Angle = .zero) -> some View {
        let offset = ShaderInput.clamped(offset, to: 0...500)
        let vector = ShaderInput.vector(length: offset, angle: angle)
        return modifier(ShaderEffect(
            kind: .layer,
            isEnabled: offset > 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(offset, in: size) },
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssChromaticAberration(.float2(size), .float2(vector))
            }
        ))
    }

    /// Draws the view's outlines, like a pencil sketch: edges in `lineColor`, flat areas in
    /// `paperColor`.
    ///
    /// - Parameters:
    ///   - strength: How dark weak edges get; higher values show more detail.
    ///   - lineWidth: How far apart the compared pixels are, in points.
    ///   - lineColor: The color of the lines.
    ///   - paperColor: The color of everything else.
    nonisolated public func sketch(
        strength: Double = 2,
        lineWidth: Double = 1,
        lineColor: Color = .black,
        paperColor: Color = .white
    ) -> some View {
        let strength = ShaderInput.clamped(strength, to: 0...100)
        let lineWidth = ShaderInput.clamped(lineWidth, to: 0.5...50)
        return modifier(ShaderEffect(
            kind: .layer,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssSketch(
                    .float2(size), .float(strength), .float(lineWidth), .color(lineColor), .color(paperColor)
                )
            }
        ))
    }

    /// Makes the view look pressed into metal: edges facing the light get brighter, edges facing
    /// away get darker, and flat areas keep their color.
    ///
    /// - Parameters:
    ///   - strength: How much the edges change, from 0 (no change) upward.
    ///   - distance: How far apart the compared pixels are, in points.
    ///   - angle: The direction the light comes from; the default is the top left.
    nonisolated public func emboss(strength: Double = 1, distance: Double = 1.5, angle: Angle = .degrees(225)) -> some View {
        let strength = ShaderInput.clamped(strength, to: 0...20)
        let distance = ShaderInput.clamped(distance, to: 0.5...50)
        let vector = ShaderInput.vector(length: distance, angle: angle)
        return modifier(ShaderEffect(
            kind: .layer,
            isEnabled: strength > 0,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssEmboss(.float2(size), .float(strength), .float2(vector))
            }
        ))
    }

    /// Makes edges crisper with an unsharp mask.
    ///
    /// - Parameters:
    ///   - amount: How much to sharpen, from 0 (no change) upward; 0.5 is noticeable.
    ///   - radius: How far apart the compared pixels are, in points.
    nonisolated public func sharpen(_ amount: Double = 0.5, radius: Double = 1) -> some View {
        let amount = ShaderInput.clamped(amount, to: 0...10)
        let radius = ShaderInput.clamped(radius, to: 0.5...20)
        return modifier(ShaderEffect(
            kind: .layer,
            isEnabled: amount > 0,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssSharpen(.float2(size), .float(amount), .float(radius))
            }
        ))
    }

    /// Prints the view as a grid of dots, larger where the view is darker.
    ///
    /// - Parameters:
    ///   - dotSize: The distance between dot centers, in points.
    ///   - angle: The rotation of the grid; print traditionally uses 45 degrees.
    ///   - ink: The color of the dots.
    ///   - paper: The color between the dots.
    nonisolated public func halftone(
        dotSize: Double = 8,
        angle: Angle = .degrees(45),
        ink: Color = .black,
        paper: Color = .white
    ) -> some View {
        let dotSize = ShaderInput.clamped(dotSize, to: 2...200)
        let angle = ShaderInput.direction(angle)
        return modifier(ShaderEffect(
            kind: .layer,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssHalftone(
                    .float2(size), .float(dotSize), .float(angle), .color(ink), .color(paper)
                )
            }
        ))
    }

    /// Repeats one wedge of the view around a center point, like a kaleidoscope.
    ///
    /// - Parameters:
    ///   - segments: The number of wedges, limited to 1...64. Each wedge is mirrored, so the
    ///     pattern is symmetric.
    ///   - center: The center of the pattern, as a fraction of the view's size.
    ///   - rotation: The rotation of the pattern.
    nonisolated public func kaleidoscope(segments: Int = 6, center: UnitPoint = .center, rotation: Angle = .zero) -> some View {
        let segments = Double(min(max(segments, 1), 64))
        let rotation = ShaderInput.direction(rotation)
        return modifier(ShaderEffect(
            kind: .layer,
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssKaleidoscope(
                    .float2(size),
                    .float2(ShaderInput.position(center, in: size)),
                    .float(segments),
                    .float(rotation)
                )
            }
        ))
    }

    /// Shifts random horizontal bands sideways and splits their colors, like a damaged video
    /// signal. The pattern changes 12 times a second.
    ///
    /// - Parameters:
    ///   - intensity: How many bands move and how far, from 0 (no change) to 1.
    ///   - time: ``ShaderTime/animated`` for a running glitch, or a fixed time for one frame.
    nonisolated public func glitch(intensity: Double = 0.5, time: ShaderTime = .animated) -> some View {
        let intensity = ShaderInput.clamped(intensity, to: 0...1)
        return modifier(ShaderEffect(
            kind: .layer,
            time: time,
            isEnabled: intensity > 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(size.width * 0.1 * intensity + 4 * intensity, in: size) },
            shader: { size, time in
                ShaderLibrary.swiftShaders.ssGlitch(.float2(size), .float(time), .float(intensity))
            }
        ))
    }
}

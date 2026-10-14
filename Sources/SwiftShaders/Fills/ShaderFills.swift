import SwiftUI

// Shaders that fill a shape, used anywhere SwiftUI takes a ShapeStyle:
//
//     RoundedRectangle(cornerRadius: 16).fill(.checkerboard(cellSize: 8))

extension ShapeStyle where Self == Shader {
    /// Alternating squares of two colors, `first` in the top-left corner.
    ///
    /// - Parameters:
    ///   - cellSize: The side of each square, in points.
    ///   - first: The color of the top-left square.
    ///   - second: The other color.
    public static func checkerboard(
        cellSize: Double = 16,
        _ first: Color = .white,
        _ second: Color = Color(white: 0.85)
    ) -> Shader {
        ShaderLibrary.swiftShaders.ssCheckerboard(
            .float(ShaderInput.length(cellSize)), .color(first), .color(second)
        )
    }

    /// Alternating stripes of two colors.
    ///
    /// - Parameters:
    ///   - width: The width of each stripe, in points.
    ///   - angle: The direction of the stripes; 0 gives vertical stripes.
    ///   - first: The color of the first stripe.
    ///   - second: The other color.
    public static func stripes(
        width: Double = 10,
        angle: Angle = .degrees(45),
        _ first: Color = .yellow,
        _ second: Color = .black
    ) -> Shader {
        ShaderLibrary.swiftShaders.ssStripes(
            .float(ShaderInput.length(width)),
            .float(ShaderInput.direction(angle)),
            .color(first),
            .color(second)
        )
    }

    /// A soft, flowing pattern that blends three colors. Pass a changing `time` to animate it:
    ///
    /// ```swift
    /// TimelineView(.animation) { context in
    ///     let time = context.date.timeIntervalSince(start)
    ///     Rectangle().fill(.plasma(time: time))
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - time: Seconds since the start of the animation.
    ///   - scale: How many waves fit in the shape; higher values give a busier pattern.
    ///   - colors: The three colors, from the lowest to the highest value of the pattern.
    public static func plasma(
        time: TimeInterval,
        scale: Double = 3,
        colors: (Color, Color, Color) = (.indigo, .blue, .cyan)
    ) -> Shader {
        ShaderLibrary.swiftShaders.ssPlasma(
            .boundingRect,
            .float(ShaderClock.wrapped(time)),
            .float(ShaderInput.clamped(scale, to: 0.1...100)),
            .color(colors.0),
            .color(colors.1),
            .color(colors.2)
        )
    }
}

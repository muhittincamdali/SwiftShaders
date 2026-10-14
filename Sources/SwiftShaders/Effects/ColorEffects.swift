import SwiftUI

// Effects that recolor each pixel on its own. They keep the view's alpha, so they work on text,
// symbols and translucent views as well as on images.

extension View {
    /// Tints the view in warm brown tones, like an old photograph.
    ///
    /// ```swift
    /// Image("harbor")
    ///     .resizable()
    ///     .scaledToFit()
    ///     .sepia(0.8)
    /// ```
    ///
    /// - Parameter amount: How much of the sepia color to use, from 0 (the original) to 1.
    nonisolated public func sepia(_ amount: Double = 1) -> some View {
        let amount = ShaderInput.clamped(amount, to: 0...1)
        return modifier(ShaderEffect(kind: .color, isEnabled: amount > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssSepia(.float2(size), .float(amount))
        })
    }

    /// Recolors the view with two colors: dark areas take `shadows`, light areas `highlights`, and
    /// the tones in between are blended from the two.
    ///
    /// - Parameters:
    ///   - shadows: The color for black.
    ///   - highlights: The color for white.
    ///   - amount: How much of the two-color version to use, from 0 (the original) to 1.
    nonisolated public func duotone(shadows: Color, highlights: Color, amount: Double = 1) -> some View {
        let amount = ShaderInput.clamped(amount, to: 0...1)
        return modifier(ShaderEffect(kind: .color, isEnabled: amount > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssDuotone(.float2(size), .color(shadows), .color(highlights), .float(amount))
        })
    }

    /// Reduces every color channel to a few levels, which gives flat poster-like areas.
    ///
    /// - Parameter levels: Values per channel, 0 and 1 included. 2 leaves 8 colors; the value is
    ///   limited to 2...256.
    nonisolated public func posterize(levels: Int = 4) -> some View {
        let levels = ShaderInput.levels(levels)
        return modifier(ShaderEffect(kind: .color) { size, _ in
            ShaderLibrary.swiftShaders.ssPosterize(.float2(size), .float(levels))
        })
    }

    /// Draws the view in two colors: `dark` where it is darker than `cutoff`, `light` elsewhere.
    ///
    /// - Parameters:
    ///   - cutoff: The luminance, from 0 to 1, where `dark` changes to `light`.
    ///   - dark: The color for darker pixels.
    ///   - light: The color for lighter pixels.
    nonisolated public func threshold(_ cutoff: Double = 0.5, dark: Color = .black, light: Color = .white) -> some View {
        let cutoff = ShaderInput.clamped(cutoff, to: 0...1)
        return modifier(ShaderEffect(kind: .color) { size, _ in
            ShaderLibrary.swiftShaders.ssThreshold(.float2(size), .float(cutoff), .color(dark), .color(light))
        })
    }

    /// Darkens the view toward its edges.
    ///
    /// Distances are measured from the center, where 1 is the middle of each edge (the shape
    /// follows the view's aspect ratio) and about 1.41 is a corner.
    ///
    /// - Parameters:
    ///   - intensity: How dark the edges get, from 0 (no change) to 1 (black).
    ///   - radius: The distance where darkening starts.
    ///   - softness: The distance over which it grows to full `intensity`.
    nonisolated public func vignette(intensity: Double = 0.6, radius: Double = 0.5, softness: Double = 0.9) -> some View {
        let intensity = ShaderInput.clamped(intensity, to: 0...1)
        let radius = ShaderInput.clamped(radius, to: 0...2)
        let softness = ShaderInput.clamped(softness, to: 0.001...4)
        return modifier(ShaderEffect(kind: .color, isEnabled: intensity > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssVignette(.float2(size), .float(intensity), .float(radius), .float(softness))
        })
    }

    /// Darkens every other band of rows, like the lines of an old monitor.
    ///
    /// - Parameters:
    ///   - spacing: The height of one bright and one dark band together, in points.
    ///   - intensity: How much darker the dark bands are, from 0 to 1.
    nonisolated public func scanlines(spacing: Double = 4, intensity: Double = 0.3) -> some View {
        let spacing = ShaderInput.length(spacing)
        let intensity = ShaderInput.clamped(intensity, to: 0...1)
        return modifier(ShaderEffect(kind: .color, isEnabled: intensity > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssScanlines(.float2(size), .float(spacing), .float(intensity))
        })
    }

    /// Adds monochrome noise that changes 24 times a second, like film grain.
    ///
    /// - Parameters:
    ///   - intensity: The largest brightness change, from 0 to 1.
    ///   - time: ``ShaderTime/animated`` for moving grain, or a fixed time for still grain.
    nonisolated public func filmGrain(intensity: Double = 0.15, time: ShaderTime = .animated) -> some View {
        let intensity = ShaderInput.clamped(intensity, to: 0...1)
        return modifier(ShaderEffect(kind: .color, time: time, isEnabled: intensity > 0) { size, time in
            ShaderLibrary.swiftShaders.ssFilmGrain(.float2(size), .float(time), .float(intensity))
        })
    }

    /// Reduces every channel to `levels` values with an ordered (Bayer) dither pattern, which
    /// keeps the average brightness of each area, like a retro display or print.
    ///
    /// - Parameter levels: Values per channel, at least 2.
    nonisolated public func dither(levels: Int = 2) -> some View {
        let levels = ShaderInput.levels(levels)
        return modifier(ShaderEffect(kind: .color) { size, _ in
            ShaderLibrary.swiftShaders.ssDither(.float2(size), .float(levels))
        })
    }

    /// Recolors the view along a gradient by brightness: black takes the first color, white the
    /// last, and the tones in between are blended along the list.
    ///
    /// ```swift
    /// Image("skyline")
    ///     .resizable()
    ///     .scaledToFit()
    ///     .gradientMap([.black, .indigo, .orange, .yellow])   // a thermal look
    /// ```
    ///
    /// - Parameters:
    ///   - colors: The gradient, from black to white. One color recolors the whole view; an empty
    ///     list leaves the view unchanged. Only the first 256 colors are used.
    ///   - amount: How much of the recolored version to use, from 0 (the original) to 1.
    nonisolated public func gradientMap(_ colors: [Color], amount: Double = 1) -> some View {
        let amount = ShaderInput.clamped(amount, to: 0...1)
        let colors = ShaderInput.gradientColors(colors)
        return modifier(ShaderEffect(kind: .color, isEnabled: amount > 0 && colors != nil) { size, _ in
            ShaderLibrary.swiftShaders.ssGradientMap(.float2(size), .colorArray(colors ?? [.clear, .clear]), .float(amount))
        })
    }

    /// Sweeps a band of light across the view, the usual sign that content is loading.
    ///
    /// The band only brightens what is already drawn, so a placeholder shape shimmers and the
    /// transparent space around it stays empty:
    ///
    /// ```swift
    /// RoundedRectangle(cornerRadius: 8)
    ///     .fill(.gray.opacity(0.3))
    ///     .frame(height: 20)
    ///     .shimmer()
    /// ```
    ///
    /// With Reduce Motion on, the band is not shown.
    ///
    /// - Parameters:
    ///   - color: The color of the band.
    ///   - intensity: How strongly the band shows, from 0 to 1.
    ///   - width: Half the band's width, as a fraction of the distance it travels.
    ///   - angle: The direction the band travels in; 0 is to the right.
    ///   - duration: Seconds for one sweep, at least 0.1.
    ///   - time: ``ShaderTime/animated`` to sweep repeatedly, or a fixed time for one frame.
    nonisolated public func shimmer(
        color: Color = .white,
        intensity: Double = 0.6,
        width: Double = 0.2,
        angle: Angle = .degrees(20),
        duration: Double = 1.5,
        time: ShaderTime = .animated
    ) -> some View {
        let intensity = ShaderInput.clamped(intensity, to: 0...1)
        let width = ShaderInput.clamped(width, to: 0.01...1)
        let angle = ShaderInput.direction(angle)
        let duration = ShaderInput.clamped(duration, to: 0.1...3_600)
        return modifier(ShaderEffect(kind: .color, time: time, isEnabled: intensity > 0) { size, time in
            ShaderLibrary.swiftShaders.ssShimmer(
                .float2(size), .float(time), .color(color), .float(intensity), .float(width), .float(angle), .float(duration)
            )
        })
    }
}

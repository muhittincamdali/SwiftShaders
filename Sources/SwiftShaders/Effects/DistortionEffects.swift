import SwiftUI

// Effects that move pixels around without changing their colors.

extension View {
    /// Shifts rows of the view sideways along a sine wave that travels downward, like a flag or a
    /// reflection in water.
    ///
    /// - Parameters:
    ///   - amplitude: The largest sideways shift, in points.
    ///   - wavelength: The distance between two crests, in points.
    ///   - speed: Crests passing a point per second; negative values move the wave upward.
    ///   - time: ``ShaderTime/animated`` for a moving wave, or a fixed time for one frame.
    nonisolated public func wave(
        amplitude: Double = 6,
        wavelength: Double = 80,
        speed: Double = 1,
        time: ShaderTime = .animated
    ) -> some View {
        let amplitude = ShaderInput.clamped(amplitude, to: -500...500)
        let wavelength = ShaderInput.length(wavelength)
        let speed = ShaderInput.clamped(speed, to: -100...100)
        return modifier(ShaderEffect(
            kind: .distortion,
            time: time,
            isEnabled: amplitude != 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(amplitude, in: size) },
            shader: { size, time in
                ShaderLibrary.swiftShaders.ssWave(
                    .float2(size), .float(time), .float(amplitude), .float(wavelength), .float(speed)
                )
            }
        ))
    }

    /// Twists the view around a center point, most at the center and not at all at `radius`.
    ///
    /// - Parameters:
    ///   - angle: The twist at the center. Positive angles turn clockwise.
    ///   - radius: The size of the twisted area, as a fraction of the view's shorter side.
    ///   - center: The center of the twist, as a fraction of the view's size.
    nonisolated public func swirl(angle: Angle = .degrees(180), radius: Double = 0.5, center: UnitPoint = .center) -> some View {
        // Not wrapped to one turn: a swirl of two turns twists twice as far as one.
        let radians = ShaderInput.clamped(angle.radians, to: -100 * .pi...100 * .pi)
        return modifier(ShaderEffect(
            kind: .distortion,
            isEnabled: radians != 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(2 * ShaderInput.radius(radius, in: size), in: size) },
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssSwirl(
                    .float2(size),
                    .float2(ShaderInput.position(center, in: size)),
                    .float(ShaderInput.radius(radius, in: size)),
                    // Each pixel reads from a point turned the other way, so the content turns by
                    // the requested angle.
                    .float(-radians)
                )
            }
        ))
    }

    /// Magnifies the view around a center point like a lens, or pinches it with a negative
    /// strength.
    ///
    /// - Parameters:
    ///   - strength: From -1 (pinch) through 0 (no change) to 1 (strongest magnification).
    ///   - radius: The size of the affected area, as a fraction of the view's shorter side.
    ///   - center: The center of the lens, as a fraction of the view's size.
    nonisolated public func bulge(strength: Double = 0.5, radius: Double = 0.5, center: UnitPoint = .center) -> some View {
        let strength = ShaderInput.clamped(strength, to: -1...1)
        return modifier(ShaderEffect(
            kind: .distortion,
            isEnabled: strength != 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(ShaderInput.radius(radius, in: size), in: size) },
            shader: { size, _ in
                ShaderLibrary.swiftShaders.ssBulge(
                    .float2(size),
                    .float2(ShaderInput.position(center, in: size)),
                    .float(ShaderInput.radius(radius, in: size)),
                    .float(strength)
                )
            }
        ))
    }

    /// Moves the view on overlapping waves, like something seen through the surface of a pool.
    ///
    /// - Parameters:
    ///   - amplitude: The largest distance a pixel moves, in points.
    ///   - scale: The size of the larger waves, in points.
    ///   - speed: How fast the surface moves; 0 stops it.
    ///   - time: ``ShaderTime/animated`` for moving water, or a fixed time for one frame.
    nonisolated public func water(
        amplitude: Double = 4,
        scale: Double = 120,
        speed: Double = 1,
        time: ShaderTime = .animated
    ) -> some View {
        let amplitude = ShaderInput.clamped(amplitude, to: 0...500)
        let scale = ShaderInput.length(scale)
        let speed = ShaderInput.clamped(speed, to: -100...100)
        return modifier(ShaderEffect(
            kind: .distortion,
            time: time,
            isEnabled: amplitude > 0,
            maxSampleOffset: { size in ShaderInput.sampleOffset(amplitude, in: size) },
            shader: { size, time in
                ShaderLibrary.swiftShaders.ssWater(
                    .float2(size), .float(time), .float(amplitude), .float(scale), .float(speed)
                )
            }
        ))
    }
}

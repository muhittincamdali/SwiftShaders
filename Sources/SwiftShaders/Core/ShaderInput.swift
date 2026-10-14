import CoreGraphics
import SwiftUI

/// Turns the values passed to the public modifiers into values the shaders can use safely.
///
/// Shaders have no error handling: a NaN, a zero divisor or a negative size draws garbage or
/// nothing, and a value too large for a 32-bit float becomes infinity on the GPU. Every public
/// argument goes through one of these functions first.
enum ShaderInput {
    /// The largest coordinate passed to a shader. Shaders compute in 32-bit floats; beyond this
    /// they cannot tell neighboring pixels apart, and values above about 3.4e38 become infinity.
    static let coordinateLimit: Double = 1_000_000

    /// The most colors a gradient map uses. More stops than 8-bit channels can show only cost
    /// memory: the array is copied to the GPU for every frame.
    static let colorLimit = 256

    /// `value`, or `fallback` when `value` is NaN or infinite.
    static func finite(_ value: Double, otherwise fallback: Double) -> Double {
        value.isFinite ? value : fallback
    }

    /// `value` limited to `range`. NaN becomes 0 when the range contains 0, so a broken value
    /// switches an effect off, and the lower bound otherwise.
    static func clamped(_ value: Double, to range: ClosedRange<Double>) -> Double {
        if value.isNaN { return range.contains(0) ? 0 : range.lowerBound }
        return min(max(value, range.lowerBound), range.upperBound)
    }

    /// A count of color levels per channel: at least 2 (black and white), at most 256.
    static func levels(_ value: Int) -> Double {
        Double(min(max(value, 2), 256))
    }

    /// A length in points that the shaders divide by: at least `minimum`.
    static func length(_ value: Double, minimum: Double = 1) -> Double {
        clamped(value, to: minimum...100_000)
    }

    /// An angle for a direction, in radians within one turn. Directions repeat every turn, and
    /// a huge angle would turn into infinity when converted to a 32-bit float.
    static func direction(_ angle: Angle) -> Double {
        finite(angle.radians, otherwise: 0).truncatingRemainder(dividingBy: 2 * .pi)
    }

    /// The position of `point` in a view of `size`, in points. A NaN coordinate becomes the
    /// center, and points far outside the view are pulled in to ``coordinateLimit``.
    static func position(_ point: UnitPoint, in size: CGSize) -> CGPoint {
        CGPoint(x: coordinate(unit(point.x) * size.width), y: coordinate(unit(point.y) * size.height))
    }

    /// A point in the view's coordinate space that a shader can use: NaN coordinates become 0
    /// and the others are limited to ±``coordinateLimit``.
    static func point(_ point: CGPoint) -> CGPoint {
        CGPoint(x: coordinate(point.x), y: coordinate(point.y))
    }

    /// A radius given as a fraction of the view's shorter side, in points.
    static func radius(_ fraction: Double, in size: CGSize) -> Double {
        clamped(fraction, to: 0...10) * min(size.width, size.height)
    }

    /// A vector of `length` points pointing in the direction of `angle`.
    static func vector(length: Double, angle: Angle) -> CGSize {
        let radians = direction(angle)
        return CGSize(width: length * cos(radians), height: length * sin(radians))
    }

    /// A sample offset large enough for a shader that reads up to `distance` points away, but
    /// never more than the diagonal of a view of `size`.
    ///
    /// SwiftUI draws a distortion or layer effect into an offscreen layer that is larger than the
    /// view by this offset on every side, so an unbounded offset can allocate gigabytes. Content
    /// read from farther away than the view's diagonal lies outside the view and is transparent.
    static func sampleOffset(_ distance: Double, in size: CGSize) -> CGSize {
        let diagonal = ceil(hypot(size.width, size.height))
        let value = min(ceil(abs(finite(distance, otherwise: 0))), finite(diagonal, otherwise: 0))
        return CGSize(width: value, height: value)
    }

    /// Colors for a gradient map: at most ``colorLimit``, and at least two, so the shader always
    /// has a pair to blend. One color is repeated; an empty array gives `nil`.
    static func gradientColors(_ colors: [Color]) -> [Color]? {
        guard let first = colors.first else { return nil }
        if colors.count == 1 { return [first, first] }
        return Array(colors.prefix(colorLimit))
    }

    private static func coordinate(_ value: Double) -> Double {
        value.isNaN ? 0 : clamped(value, to: -coordinateLimit...coordinateLimit)
    }

    /// A unit coordinate: NaN becomes the center, and the value stays within 1,000 view sizes.
    private static func unit(_ value: Double) -> Double {
        value.isNaN ? 0.5 : clamped(value, to: -1_000...1_000)
    }
}

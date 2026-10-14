import CoreGraphics
import SwiftUI
import Testing

/// An RGBA color with 8-bit sRGB channels, as read back from a rendered view.
struct RGBA: Hashable, CustomStringConvertible {
    var red: Int
    var green: Int
    var blue: Int
    var alpha: Int

    init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int = 255) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var description: String { "RGBA(\(red), \(green), \(blue), \(alpha))" }

    /// Rec. 709 luma, 0...255.
    var luma: Double { 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue) }

    /// Whether every channel is within `tolerance` of `other`.
    func isClose(to other: RGBA, tolerance: Int = 3) -> Bool {
        abs(red - other.red) <= tolerance && abs(green - other.green) <= tolerance
            && abs(blue - other.blue) <= tolerance && abs(alpha - other.alpha) <= tolerance
    }
}

/// The pixels of a view rendered with `ImageRenderer` at scale 1, so one pixel is one point.
/// Row 0 is the top of the view.
struct Pixels {
    let width: Int
    let height: Int
    private let bytes: [UInt8]

    @MainActor
    init(_ view: some View, width: Int, height: Int) throws {
        // `ImageRenderer` can return the pixels of an earlier rendering when a view draws nothing
        // at all (for example at opacity 0), so the view is drawn over opaque black and over
        // opaque white instead. Over black each channel is the premultiplied value; over white
        // it is that value plus 255 - alpha.
        let overBlack = try Self.render(ZStack { Color.black; view }, width: width, height: height)
        let overWhite = try Self.render(ZStack { Color.white; view }, width: width, height: height)
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        for pixel in 0..<(width * height) {
            let index = pixel * 4
            let coverage = (0..<3).map { Int(overWhite[index + $0]) - Int(overBlack[index + $0]) }
            let alpha = 255 - Int((Double(coverage.reduce(0, +)) / 3).rounded())
            bytes[index] = overBlack[index]
            bytes[index + 1] = overBlack[index + 1]
            bytes[index + 2] = overBlack[index + 2]
            bytes[index + 3] = UInt8(min(max(alpha, 0), 255))
        }
        self.width = width
        self.height = height
        self.bytes = bytes
    }

    /// The RGBA bytes of an opaque view, row by row from the top.
    @MainActor
    private static func render(_ view: some View, width: Int, height: Int) throws -> [UInt8] {
        let renderer = ImageRenderer(content: view.frame(width: CGFloat(width), height: CGFloat(height)))
        renderer.scale = 1
        let image = try #require(renderer.cgImage, "ImageRenderer produced no image")
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        let space = try #require(CGColorSpace(name: CGColorSpace.sRGB))
        let drawn = bytes.withUnsafeMutableBytes { buffer -> Bool in
            guard let context = CGContext(
                data: buffer.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: space,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        try #require(drawn, "Could not create a bitmap context")
        return bytes
    }

    /// The pixel in column `x` and row `y`, counted from the top left.
    subscript(x: Int, y: Int) -> RGBA {
        let index = (y * width + x) * 4
        return RGBA(Int(bytes[index]), Int(bytes[index + 1]), Int(bytes[index + 2]), Int(bytes[index + 3]))
    }

    /// All pixels, row by row.
    var all: [RGBA] {
        (0..<height).flatMap { y in (0..<width).map { x in self[x, y] } }
    }

    /// The largest difference in any channel between two renderings of the same size.
    func maxDifference(from other: Pixels) -> Int {
        zip(all, other.all).map { a, b in
            max(abs(a.red - b.red), abs(a.green - b.green), abs(a.blue - b.blue), abs(a.alpha - b.alpha))
        }.max() ?? 0
    }
}

/// An opaque sRGB color from 8-bit channel values, so expected values can be written as integers.
func srgb(_ red: Int, _ green: Int, _ blue: Int, opacity: Double = 1) -> Color {
    Color(.sRGB, red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255, opacity: opacity)
}

/// A black view of `width` x `height` with a white square of `side` points centered in it.
func whiteSquare(side: CGFloat, width: CGFloat = 32, height: CGFloat = 32) -> some View {
    ZStack {
        Color.black
        Color.white.frame(width: side, height: side)
    }
    .frame(width: width, height: height)
}

/// A horizontal ramp from black to white, one shade per column of points.
///
/// Not a `LinearGradient`: SwiftUI dithers gradients, and the dither pattern is not the same in
/// every rendering, so two renderings of one gradient can differ by a step in some pixels.
func grayRamp() -> some View {
    Canvas { context, size in
        let columns = max(Int(size.width), 2)
        for column in 0..<columns {
            let value = Int((Double(column) / Double(columns - 1) * 255).rounded())
            let rect = CGRect(x: CGFloat(column), y: 0, width: 1, height: size.height)
            context.fill(Path(rect), with: .color(srgb(value, value, value)))
        }
    }
}

/// A view whose red grows from left to right and whose green grows from top to bottom, so every
/// point has a different color. Drawn per point for the same reason as ``grayRamp()``.
func colorField() -> some View {
    Canvas { context, size in
        let width = max(Int(size.width), 2)
        let height = max(Int(size.height), 2)
        for y in 0..<height {
            for x in 0..<width {
                let color = srgb(x * 255 / (width - 1), y * 255 / (height - 1), 128)
                context.fill(Path(CGRect(x: x, y: y, width: 1, height: 1)), with: .color(color))
            }
        }
    }
}

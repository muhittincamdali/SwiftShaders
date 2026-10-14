import Foundation
import ImageIO
import SwiftUI
import Testing
import UniformTypeIdentifiers
@testable import SwiftShaders

/// Renders the README images into `SCREENSHOT_DIR`. Run it with scripts/generate-screenshots.sh;
/// without the variable the suite is skipped.
@MainActor
@Suite("README images", .enabled(if: ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] != nil))
struct Screenshots {
    let directory = URL(fileURLWithPath: ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] ?? ".")

    /// Colors of the kit's blue palette for the page behind the tiles.
    enum Appearance: String, CaseIterable {
        case light, dark

        var background: Color { self == .light ? srgb(245, 249, 255) : srgb(4, 17, 31) }
        var label: Color { self == .light ? srgb(0, 88, 212) : srgb(100, 210, 255) }
    }

    @Test("Effect grids", arguments: Appearance.allCases)
    func effectGrids(appearance: Appearance) throws {
        let groups: [(EffectGroup, columns: Int)] = [(.color, 4), (.layer, 3), (.distortion, 4)]
        for (group, columns) in groups {
            var tiles: [AnyView] = []
            if group == .color {
                tiles.append(tile("Original", SampleScene(), appearance))
            }
            for demo in EffectDemo.all where demo.group == group {
                tiles.append(tile(demo.name, demo.view(SampleScene(), time: .fixed(1.3)), appearance))
            }
            let grid = page(appearance) {
                Grid(horizontalSpacing: 14, verticalSpacing: 14) {
                    ForEach(Array(stride(from: 0, to: tiles.count, by: columns)), id: \.self) { start in
                        GridRow {
                            ForEach(start..<min(start + columns, tiles.count), id: \.self) { tiles[$0] }
                        }
                    }
                }
            }
            try writePNG(grid, name: "effects-\(group.rawValue.lowercased())-\(appearance.rawValue)")
        }
    }

    @Test("Transition frames", arguments: Appearance.allCases)
    func transitionFrames(appearance: Appearance) throws {
        let progresses = [0.0, 0.25, 0.5, 0.75]
        let rows: [(String, (Double) -> AnyView)] = [
            ("Dissolve", { AnyView(SampleScene().modifier(DissolveTransition(progress: $0, grainSize: 3, seed: 0))) }),
            ("Pixelate", { AnyView(SampleScene().modifier(PixelateTransition(progress: $0, maxCellSize: 24))) }),
            ("Swirl", { AnyView(SampleScene().modifier(SwirlTransition(progress: $0, angle: .degrees(360)))) }),
            ("Circle reveal", { AnyView(SampleScene().modifier(CircleRevealTransition(progress: $0, center: .center))) }),
            ("Radial wipe", { AnyView(SampleScene().modifier(RadialWipeTransition(progress: $0, center: .center, startAngle: .degrees(-90)))) }),
        ]
        let grid = page(appearance) {
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(rows.indices, id: \.self) { row in
                    GridRow {
                        Text(rows[row].0)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(appearance.label)
                            .frame(width: 104, alignment: .leading)
                        ForEach(progresses, id: \.self) { progress in
                            rows[row].1(progress)
                                .frame(width: 150, height: 100)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
            }
        }
        try writePNG(grid, name: "transitions-\(appearance.rawValue)")
    }

    @Test("Animated preview")
    func animatedPreview() throws {
        let frameCount = 40
        let duration = 2.0  // the wave and the shimmer below repeat every 2 seconds
        var frames: [CGImage] = []
        for frame in 0..<frameCount {
            let time = duration * Double(frame) / Double(frameCount)
            let strip = HStack(spacing: 8) {
                // Drawn a little larger and clipped, so the rows the wave moves sideways never
                // uncover the space beside the picture.
                SampleScene()
                    .frame(width: 256, height: 170)
                    .wave(amplitude: 5, wavelength: 80, speed: 0.5, time: .fixed(time))
                    .frame(width: 240, height: 160)
                    .clipped()
                SampleScene()
                    .ripple(origin: CGPoint(x: 120, y: 80), elapsedTime: time * 0.6, style: RippleStyle(amplitude: 8, frequency: 14, decay: 2.5, speed: 220))
                    .frame(width: 240, height: 160)
                    .clipped()
                SampleScene()
                    .shimmer(intensity: 0.7, width: 0.15, duration: duration, time: .fixed(time))
                    .frame(width: 240, height: 160)
            }
            .padding(8)
            .background(srgb(4, 17, 31))  // the kit's dark navy, which reads on light and dark pages
            let renderer = ImageRenderer(content: strip)
            renderer.scale = 1
            frames.append(try opaque(try #require(renderer.cgImage)))
        }
        try writeGIF(frames, delay: duration / Double(frameCount), name: "animated")
    }

    // MARK: - Drawing

    private func tile(_ name: String, _ content: some View, _ appearance: Appearance) -> AnyView {
        AnyView(
            VStack(spacing: 6) {
                content
                    .frame(width: 180, height: 120)
                    .clipShape(.rect(cornerRadius: 10))
                Text(name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(appearance.label)
            }
        )
    }

    private func page(_ appearance: Appearance, @ViewBuilder content: () -> some View) -> some View {
        content()
            .padding(18)
            .background(appearance.background)
            .environment(\.colorScheme, appearance == .light ? .light : .dark)
    }

    /// `image` without an alpha channel. ImageIO's GIF encoder stores later frames as changes
    /// to the previous one and mixes those up when the frames have alpha.
    private func opaque(_ image: CGImage) throws -> CGImage {
        let space = try #require(CGColorSpace(name: CGColorSpace.sRGB))
        let context = try #require(CGContext(
            data: nil,
            width: image.width,
            height: image.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: space,
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ))
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        return try #require(context.makeImage())
    }

    private func writePNG(_ view: some View, name: String) throws {
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        let image = try #require(renderer.cgImage)
        try write([image], type: .png, delay: nil, to: directory.appendingPathComponent("\(name).png"))
    }

    private func writeGIF(_ frames: [CGImage], delay: Double, name: String) throws {
        try write(frames, type: .gif, delay: delay, to: directory.appendingPathComponent("\(name).gif"))
    }

    private func write(_ images: [CGImage], type: UTType, delay: Double?, to url: URL) throws {
        let destination = try #require(CGImageDestinationCreateWithURL(url as CFURL, type.identifier as CFString, images.count, nil))
        if let delay {
            let loop = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary
            CGImageDestinationSetProperties(destination, loop)
            let frame = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: delay]] as CFDictionary
            images.forEach { CGImageDestinationAddImage(destination, $0, frame) }
        } else {
            images.forEach { CGImageDestinationAddImage(destination, $0, nil) }
        }
        #expect(CGImageDestinationFinalize(destination), "Could not write \(url.path)")
    }
}

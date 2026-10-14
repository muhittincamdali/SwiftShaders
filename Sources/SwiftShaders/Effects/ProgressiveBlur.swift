import SwiftUI

extension View {
    /// Blurs the view more and more along a line: not at all at `start`, by `radius` points at
    /// `end` and beyond.
    ///
    /// Use it to let content fade into a toolbar or a caption, the way system bars blur what
    /// scrolls under them:
    ///
    /// ```swift
    /// Image("forest")
    ///     .resizable()
    ///     .scaledToFill()
    ///     .progressiveBlur(radius: 16, from: .center, to: .bottom)
    /// ```
    ///
    /// The blur reads only inside the view, so the view's edges stay opaque instead of fading
    /// out. Each pixel costs the same whatever the radius.
    ///
    /// - Parameters:
    ///   - radius: The blur radius at `end`, in points, from 0 (no blur) to 100.
    ///   - start: Where the blur begins, as a fraction of the view's size.
    ///   - end: Where it reaches `radius`.
    nonisolated public func progressiveBlur(radius: Double = 12, from start: UnitPoint = .top, to end: UnitPoint = .bottom) -> some View {
        let radius = ShaderInput.clamped(radius, to: 0...100)
        return modifier(ProgressiveBlurPass(radius: radius, start: start, end: end, step: CGPoint(x: 1, y: 0)))
            .modifier(ProgressiveBlurPass(radius: radius, start: start, end: end, step: CGPoint(x: 0, y: 1)))
    }
}

/// One direction of the blur. A Gaussian blur is separable, so a horizontal and a vertical pass
/// of 49 samples each replace one pass of 49 x 49.
private struct ProgressiveBlurPass: ViewModifier {
    let radius: Double
    let start: UnitPoint
    let end: UnitPoint
    let step: CGPoint

    nonisolated init(radius: Double, start: UnitPoint, end: UnitPoint, step: CGPoint) {
        self.radius = radius
        self.start = start
        self.end = end
        self.step = step
    }

    func body(content: Content) -> some View {
        let radius = radius
        let start = start
        let end = end
        let step = step
        return content.modifier(ShaderEffect(kind: .layer, isEnabled: radius > 0) { size, _ in
            ShaderLibrary.swiftShaders.ssProgressiveBlur(
                .float2(size),
                .float2(ShaderInput.position(start, in: size)),
                .float2(ShaderInput.position(end, in: size)),
                .float(radius),
                .float2(step)
            )
        })
    }
}

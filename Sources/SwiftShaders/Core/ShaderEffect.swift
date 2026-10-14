import SwiftUI

/// Which of SwiftUI's three shader modifiers an effect uses.
enum ShaderEffectKind: Sendable {
    /// `colorEffect`: the shader gets one pixel's color.
    case color
    /// `distortionEffect`: the shader returns the position to read from.
    case distortion
    /// `layerEffect`: the shader can read any pixel of the view.
    case layer
}

/// Applies one shader to a view, with the view's size and, for animated effects, the time.
///
/// Every public effect is built on this modifier. It measures the view with `visualEffect`, so a
/// shader can work in points relative to the view, and drives animated effects with a
/// `TimelineView` that stops when Reduce Motion is on.
struct ShaderEffect: ViewModifier {
    typealias MakeShader = @Sendable (_ size: CGSize, _ time: Double) -> Shader
    typealias SampleOffset = @Sendable (_ size: CGSize) -> CGSize

    let kind: ShaderEffectKind
    /// `nil` for effects that do not change over time.
    let time: ShaderTime?
    let isEnabled: Bool
    let maxSampleOffset: SampleOffset
    let shader: MakeShader

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var start = Date()

    // Nonisolated like SwiftUI's own modifiers, so effects can be applied from any context,
    // including the content closures of keyframeAnimator and visualEffect.
    nonisolated init(
        kind: ShaderEffectKind,
        time: ShaderTime? = nil,
        isEnabled: Bool = true,
        maxSampleOffset: @escaping SampleOffset = { _ in .zero },
        shader: @escaping MakeShader
    ) {
        self.kind = kind
        self.time = time
        self.isEnabled = isEnabled
        self.maxSampleOffset = maxSampleOffset
        self.shader = shader
    }

    func body(content: Content) -> some View {
        if isEnabled, let speed = time?.animationSpeed, !reduceMotion {
            TimelineView(.animation) { context in
                effect(content, time: ShaderClock.elapsed(from: start, to: context.date, speed: speed))
            }
        } else {
            effect(content, time: time?.stillTime ?? 0)
        }
    }

    @ViewBuilder
    private func effect(_ content: Content, time: Double) -> some View {
        let shader = self.shader
        let maxSampleOffset = self.maxSampleOffset
        let isEnabled = self.isEnabled
        switch kind {
        case .color:
            content.visualEffect { view, proxy in
                view.colorEffect(shader(proxy.size, time), isEnabled: isEnabled)
            }
        case .distortion:
            content.visualEffect { view, proxy in
                view.distortionEffect(
                    shader(proxy.size, time),
                    maxSampleOffset: maxSampleOffset(proxy.size),
                    isEnabled: isEnabled
                )
            }
        case .layer:
            // Without a compositing group SwiftUI applies a layer effect to each part of the view
            // on its own (for example to a background and to the text in front of it), so a
            // shader could not see across the parts and would find edges between them that are
            // not there.
            content.compositingGroup().visualEffect { view, proxy in
                view.layerEffect(
                    shader(proxy.size, time),
                    maxSampleOffset: maxSampleOffset(proxy.size),
                    isEnabled: isEnabled
                )
            }
        }
    }
}

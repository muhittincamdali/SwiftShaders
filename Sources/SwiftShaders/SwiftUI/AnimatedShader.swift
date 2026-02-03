import SwiftUI
import Combine

// MARK: - AnimatedShaderView

/// A view wrapper that provides automatic animation for shader effects.
///
/// This view handles all animation timing internally, making it easy
/// to create animated shader effects without managing timers.
///
/// ## Overview
///
/// ```swift
/// AnimatedShaderView(speed: 1.0) { time in
///     Image("photo")
///         .rippleEffect(time: time)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct AnimatedShaderView<Content: View>: View {
    
    // MARK: - Properties
    
    private let speed: Double
    private let paused: Bool
    private let content: (Double) -> Content
    
    // MARK: - Initialization
    
    /// Creates an animated shader view.
    /// - Parameters:
    ///   - speed: Animation speed multiplier.
    ///   - paused: Whether animation is paused.
    ///   - content: Content builder receiving current time.
    public init(
        speed: Double = 1.0,
        paused: Bool = false,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.speed = speed
        self.paused = paused
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        TimelineView(.animation(paused: paused)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * speed
            content(time)
        }
    }
}

// MARK: - PulsingShaderView

/// A view that pulses a shader effect on and off.
///
/// ## Overview
///
/// ```swift
/// PulsingShaderView(
///     pulseDuration: 1.0,
///     shader: { progress in
///         Image("photo")
///             .chromaticAberration(intensity: progress * 0.05)
///     }
/// )
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PulsingShaderView<Content: View>: View {
    
    private let pulseDuration: Double
    private let shader: (Double) -> Content
    
    /// Creates a pulsing shader view.
    /// - Parameters:
    ///   - pulseDuration: Duration of one pulse cycle.
    ///   - shader: Shader builder receiving pulse progress (0-1).
    public init(
        pulseDuration: Double = 1.0,
        @ViewBuilder shader: @escaping (Double) -> Content
    ) {
        self.pulseDuration = pulseDuration
        self.shader = shader
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let progress = (sin(time * .pi * 2 / pulseDuration) + 1) / 2
            shader(progress)
        }
    }
}

// MARK: - TriggeredShaderView

/// A view that triggers a shader animation on demand.
///
/// ## Overview
///
/// ```swift
/// @State private var trigger = false
///
/// TriggeredShaderView(trigger: $trigger, duration: 0.5) { progress in
///     Image("photo")
///         .rippleEffect(time: progress * 10)
/// }
/// .onTapGesture { trigger = true }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct TriggeredShaderView<Content: View>: View {
    
    @Binding private var trigger: Bool
    @State private var progress: Double = 0
    @State private var isAnimating: Bool = false
    
    private let duration: Double
    private let shader: (Double) -> Content
    
    /// Creates a triggered shader view.
    /// - Parameters:
    ///   - trigger: Binding to trigger the animation.
    ///   - duration: Animation duration.
    ///   - shader: Shader builder receiving progress (0-1).
    public init(
        trigger: Binding<Bool>,
        duration: Double = 0.5,
        @ViewBuilder shader: @escaping (Double) -> Content
    ) {
        self._trigger = trigger
        self.duration = duration
        self.shader = shader
    }
    
    public var body: some View {
        shader(progress)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        guard !isAnimating else { return }
        
        isAnimating = true
        progress = 0
        
        withAnimation(.linear(duration: duration)) {
            progress = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isAnimating = false
            trigger = false
            progress = 0
        }
    }
}

// MARK: - InteractiveShaderView

/// A view that responds to user interaction with shader effects.
///
/// ## Overview
///
/// ```swift
/// InteractiveShaderView { location, isPressed in
///     Image("photo")
///         .sphereBulge(
///             center: location,
///             radius: isPressed ? 100 : 0,
///             strength: 0.5
///         )
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct InteractiveShaderView<Content: View>: View {
    
    @State private var touchLocation: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @State private var isPressed: Bool = false
    
    private let content: (CGPoint, Bool) -> Content
    
    /// Creates an interactive shader view.
    /// - Parameter content: Content builder receiving touch location and press state.
    public init(
        @ViewBuilder content: @escaping (CGPoint, Bool) -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            content(touchLocation, isPressed)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let normalized = CGPoint(
                                x: value.location.x / geometry.size.width,
                                y: value.location.y / geometry.size.height
                            )
                            touchLocation = normalized
                            isPressed = true
                        }
                        .onEnded { _ in
                            isPressed = false
                        }
                )
        }
    }
}

// MARK: - SequencedShaderView

/// A view that plays through a sequence of shader effects.
///
/// ## Overview
///
/// ```swift
/// SequencedShaderView(
///     effects: [.ripple, .chromatic, .glitch],
///     effectDuration: 2.0
/// ) { effect, time in
///     Image("photo")
///         .applyEffect(effect, time: time)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SequencedShaderView<Effect, Content: View>: View {
    
    @State private var currentIndex: Int = 0
    
    private let effects: [Effect]
    private let effectDuration: Double
    private let transition: AnyTransition
    private let content: (Effect, Double) -> Content
    
    /// Creates a sequenced shader view.
    /// - Parameters:
    ///   - effects: Array of effects to cycle through.
    ///   - effectDuration: Duration of each effect.
    ///   - transition: Transition between effects.
    ///   - content: Content builder for each effect.
    public init(
        effects: [Effect],
        effectDuration: Double = 2.0,
        transition: AnyTransition = .opacity,
        @ViewBuilder content: @escaping (Effect, Double) -> Content
    ) {
        self.effects = effects
        self.effectDuration = effectDuration
        self.transition = transition
        self.content = content
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let totalDuration = effectDuration * Double(effects.count)
            let cycleTime = time.truncatingRemainder(dividingBy: totalDuration)
            let index = Int(cycleTime / effectDuration) % effects.count
            let localTime = cycleTime.truncatingRemainder(dividingBy: effectDuration)
            
            content(effects[index], localTime)
                .id(index)
                .transition(transition)
        }
    }
}

// MARK: - ShaderTransitionView

/// A view that transitions between two states using a shader effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderTransitionView<FromContent: View, ToContent: View>: View {
    
    private let progress: Double
    private let fromContent: FromContent
    private let toContent: ToContent
    
    /// Creates a shader transition view.
    /// - Parameters:
    ///   - progress: Transition progress (0 = from, 1 = to).
    ///   - from: The starting content.
    ///   - to: The ending content.
    public init(
        progress: Double,
        @ViewBuilder from: () -> FromContent,
        @ViewBuilder to: () -> ToContent
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.fromContent = from()
        self.toContent = to()
    }
    
    public var body: some View {
        ZStack {
            toContent
                .opacity(progress)
            
            fromContent
                .dissolveEffect(progress: progress)
        }
    }
}

// MARK: - Private Extensions

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

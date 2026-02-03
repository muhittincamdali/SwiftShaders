import SwiftUI

// MARK: - ShaderAnimator

/// A class that manages shader animation timing.
///
/// Provides utilities for animating shader parameters with various
/// easing functions and timing options.
///
/// ## Overview
///
/// ```swift
/// struct AnimatedShaderView: View {
///     @StateObject private var animator = ShaderAnimator()
///
///     var body: some View {
///         Image("photo")
///             .rippleEffect(time: animator.time)
///             .onAppear { animator.start() }
///     }
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
@MainActor
public final class ShaderAnimator: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current animation time value.
    @Published public private(set) var time: Double = 0.0
    
    /// Current normalized progress (0-1 for looping animations).
    @Published public private(set) var progress: Double = 0.0
    
    /// Whether the animation is currently running.
    @Published public private(set) var isRunning: Bool = false
    
    // MARK: - Configuration
    
    /// Animation playback speed multiplier.
    public var speed: Double = 1.0
    
    /// Duration of one animation cycle (for looping).
    public var duration: Double = 1.0
    
    /// Whether to loop the animation.
    public var loops: Bool = true
    
    /// Number of loops (0 = infinite).
    public var loopCount: Int = 0
    
    /// Whether to reverse on each loop.
    public var autoReverse: Bool = false
    
    // MARK: - Private Properties
    
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    private var pausedTime: Double = 0
    private var completedLoops: Int = 0
    private var isReversing: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a shader animator with default settings.
    public init() {}
    
    /// Creates a shader animator with the specified configuration.
    /// - Parameters:
    ///   - speed: Playback speed multiplier.
    ///   - duration: Cycle duration for looping.
    ///   - loops: Whether to loop.
    ///   - autoReverse: Whether to auto-reverse.
    public init(
        speed: Double = 1.0,
        duration: Double = 1.0,
        loops: Bool = true,
        autoReverse: Bool = false
    ) {
        self.speed = speed
        self.duration = duration
        self.loops = loops
        self.autoReverse = autoReverse
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Control Methods
    
    /// Starts or resumes the animation.
    public func start() {
        guard !isRunning else { return }
        
        isRunning = true
        startTime = CACurrentMediaTime() - pausedTime / speed
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    /// Pauses the animation.
    public func pause() {
        guard isRunning else { return }
        
        isRunning = false
        pausedTime = time
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    /// Stops and resets the animation.
    public func stop() {
        isRunning = false
        time = 0
        progress = 0
        pausedTime = 0
        completedLoops = 0
        isReversing = false
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    /// Resets animation to beginning without stopping.
    public func reset() {
        startTime = CACurrentMediaTime()
        time = 0
        progress = 0
        pausedTime = 0
        completedLoops = 0
        isReversing = false
    }
    
    /// Seeks to a specific time.
    /// - Parameter targetTime: The time to seek to.
    public func seek(to targetTime: Double) {
        let wasRunning = isRunning
        if wasRunning { pause() }
        
        time = targetTime
        pausedTime = targetTime
        
        if duration > 0 {
            progress = targetTime.truncatingRemainder(dividingBy: duration) / duration
        }
        
        if wasRunning { start() }
    }
    
    // MARK: - Private Methods
    
    @objc private func update(_ displayLink: CADisplayLink) {
        let elapsed = (CACurrentMediaTime() - startTime) * speed
        
        if loops {
            if duration > 0 {
                let rawProgress = elapsed / duration
                let loopIndex = Int(rawProgress)
                
                // Check loop count
                if loopCount > 0 && loopIndex >= loopCount {
                    time = Double(loopCount) * duration
                    progress = 1.0
                    stop()
                    return
                }
                
                var localProgress = rawProgress.truncatingRemainder(dividingBy: 1.0)
                
                if autoReverse {
                    let isOddLoop = loopIndex % 2 == 1
                    if isOddLoop {
                        localProgress = 1.0 - localProgress
                    }
                }
                
                progress = localProgress
                time = elapsed
            } else {
                time = elapsed
                progress = 0
            }
        } else {
            time = min(elapsed, duration)
            progress = duration > 0 ? time / duration : 0
            
            if time >= duration {
                stop()
            }
        }
    }
}

// MARK: - ShaderTimeline

/// A view that provides time-based animation for shader effects.
///
/// ## Overview
///
/// ```swift
/// ShaderTimeline { time in
///     Image("photo")
///         .rippleEffect(time: time)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderTimeline<Content: View>: View {
    
    private let speed: Double
    private let content: (Double) -> Content
    
    /// Creates a shader timeline.
    /// - Parameters:
    ///   - speed: Animation speed multiplier.
    ///   - content: Content builder receiving animation time.
    public init(
        speed: Double = 1.0,
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.speed = speed
        self.content = content
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate * speed
            content(time)
        }
    }
}

// MARK: - ShaderTransition

/// A transition view that animates between two states using shaders.
///
/// ## Overview
///
/// ```swift
/// ShaderTransition(progress: transitionProgress) { progress in
///     Image("photo")
///         .dissolveEffect(progress: progress)
/// }
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ShaderTransition<Content: View>: View {
    
    @State private var animatedProgress: Double = 0
    
    private let progress: Double
    private let animation: Animation?
    private let content: (Double) -> Content
    
    /// Creates a shader transition.
    /// - Parameters:
    ///   - progress: Transition progress (0-1).
    ///   - animation: Optional animation for progress changes.
    ///   - content: Content builder receiving progress.
    public init(
        progress: Double,
        animation: Animation? = .easeInOut(duration: 0.5),
        @ViewBuilder content: @escaping (Double) -> Content
    ) {
        self.progress = progress
        self.animation = animation
        self.content = content
    }
    
    public var body: some View {
        content(animatedProgress)
            .onChange(of: progress) { _, newValue in
                if let animation {
                    withAnimation(animation) {
                        animatedProgress = newValue
                    }
                } else {
                    animatedProgress = newValue
                }
            }
            .onAppear {
                animatedProgress = progress
            }
    }
}

// MARK: - Easing Functions

/// Collection of easing functions for shader animations.
public enum ShaderEasing {
    
    /// Linear interpolation.
    public static func linear(_ t: Double) -> Double { t }
    
    /// Quadratic ease in.
    public static func easeInQuad(_ t: Double) -> Double { t * t }
    
    /// Quadratic ease out.
    public static func easeOutQuad(_ t: Double) -> Double { 1 - (1 - t) * (1 - t) }
    
    /// Quadratic ease in-out.
    public static func easeInOutQuad(_ t: Double) -> Double {
        t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
    
    /// Cubic ease in.
    public static func easeInCubic(_ t: Double) -> Double { t * t * t }
    
    /// Cubic ease out.
    public static func easeOutCubic(_ t: Double) -> Double { 1 - pow(1 - t, 3) }
    
    /// Cubic ease in-out.
    public static func easeInOutCubic(_ t: Double) -> Double {
        t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2
    }
    
    /// Sine ease in.
    public static func easeInSine(_ t: Double) -> Double {
        1 - cos(t * .pi / 2)
    }
    
    /// Sine ease out.
    public static func easeOutSine(_ t: Double) -> Double {
        sin(t * .pi / 2)
    }
    
    /// Sine ease in-out.
    public static func easeInOutSine(_ t: Double) -> Double {
        -(cos(.pi * t) - 1) / 2
    }
    
    /// Exponential ease in.
    public static func easeInExpo(_ t: Double) -> Double {
        t == 0 ? 0 : pow(2, 10 * t - 10)
    }
    
    /// Exponential ease out.
    public static func easeOutExpo(_ t: Double) -> Double {
        t == 1 ? 1 : 1 - pow(2, -10 * t)
    }
    
    /// Elastic ease out.
    public static func easeOutElastic(_ t: Double) -> Double {
        let c4 = (2 * .pi) / 3
        return t == 0 ? 0 : t == 1 ? 1 : pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
    }
    
    /// Bounce ease out.
    public static func easeOutBounce(_ t: Double) -> Double {
        let n1 = 7.5625
        let d1 = 2.75
        var t = t
        
        if t < 1 / d1 {
            return n1 * t * t
        } else if t < 2 / d1 {
            t -= 1.5 / d1
            return n1 * t * t + 0.75
        } else if t < 2.5 / d1 {
            t -= 2.25 / d1
            return n1 * t * t + 0.9375
        } else {
            t -= 2.625 / d1
            return n1 * t * t + 0.984375
        }
    }
    
    /// Back ease out (overshoot).
    public static func easeOutBack(_ t: Double) -> Double {
        let c1 = 1.70158
        let c3 = c1 + 1
        return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2)
    }
}

// MARK: - AnimationKeyframe

/// Represents a keyframe for shader animation.
public struct ShaderKeyframe<Value> {
    /// The time of this keyframe (0-1 normalized).
    public let time: Double
    /// The value at this keyframe.
    public let value: Value
    /// The easing function to the next keyframe.
    public let easing: (Double) -> Double
    
    /// Creates a shader keyframe.
    public init(
        time: Double,
        value: Value,
        easing: @escaping (Double) -> Double = ShaderEasing.linear
    ) {
        self.time = time
        self.value = value
        self.easing = easing
    }
}

// MARK: - KeyframeAnimator

/// Animates between keyframes for shader parameters.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct KeyframeAnimator {
    
    /// Interpolates between Double keyframes.
    /// - Parameters:
    ///   - keyframes: Array of keyframes.
    ///   - progress: Current progress (0-1).
    /// - Returns: Interpolated value.
    public static func interpolate(
        keyframes: [ShaderKeyframe<Double>],
        at progress: Double
    ) -> Double {
        guard !keyframes.isEmpty else { return 0 }
        guard keyframes.count > 1 else { return keyframes[0].value }
        
        let sorted = keyframes.sorted { $0.time < $1.time }
        
        // Find surrounding keyframes
        var fromIndex = 0
        for (index, keyframe) in sorted.enumerated() {
            if keyframe.time <= progress {
                fromIndex = index
            }
        }
        
        let toIndex = min(fromIndex + 1, sorted.count - 1)
        
        if fromIndex == toIndex {
            return sorted[fromIndex].value
        }
        
        let from = sorted[fromIndex]
        let to = sorted[toIndex]
        
        let localProgress = (progress - from.time) / (to.time - from.time)
        let easedProgress = from.easing(localProgress)
        
        return from.value + (to.value - from.value) * easedProgress
    }
}

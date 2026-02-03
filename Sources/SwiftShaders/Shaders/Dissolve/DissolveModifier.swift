import SwiftUI

// MARK: - DissolveModifier

/// A view modifier that applies dissolve transition effects.
///
/// Creates noise-based dissolve patterns for animated view transitions.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(DissolveModifier(
///         progress: transitionProgress,
///         scale: 10.0,
///         edgeWidth: 0.1
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DissolveModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Dissolve progress (0.0 = fully visible, 1.0 = fully dissolved).
    public var progress: Double
    
    /// Noise pattern scale.
    public var scale: Double
    
    /// Width of the dissolve edge glow.
    public var edgeWidth: Double
    
    // MARK: - Initialization
    
    /// Creates a dissolve modifier.
    /// - Parameters:
    ///   - progress: Transition progress (0-1).
    ///   - scale: Noise scale (default: 10.0).
    ///   - edgeWidth: Edge glow width (default: 0.05).
    public init(
        progress: Double,
        scale: Double = 10.0,
        edgeWidth: Double = 0.05
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.scale = scale
        self.edgeWidth = edgeWidth
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.dissolve(
                .float(progress),
                .float(scale),
                .float(edgeWidth)
            )
        )
    }
}

// MARK: - DirectionalDissolveModifier

/// Dissolve that sweeps from a direction.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DirectionalDissolveModifier: ViewModifier {
    
    public var progress: Double
    public var angle: Double
    public var edgeWidth: Double
    
    /// Creates a directional dissolve modifier.
    /// - Parameters:
    ///   - progress: Transition progress.
    ///   - angle: Sweep direction angle in radians.
    ///   - edgeWidth: Edge glow width.
    public init(
        progress: Double,
        angle: Double = 0.0,
        edgeWidth: Double = 0.05
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.angle = angle
        self.edgeWidth = edgeWidth
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.directionalDissolve(
                .float(progress),
                .float(angle),
                .float(edgeWidth)
            )
        )
    }
}

// MARK: - RadialDissolveModifier

/// Dissolve that expands from a center point.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RadialDissolveModifier: ViewModifier {
    
    public var progress: Double
    public var center: CGPoint
    public var edgeWidth: Double
    
    /// Creates a radial dissolve modifier.
    /// - Parameters:
    ///   - progress: Transition progress.
    ///   - center: Center point (normalized 0-1).
    ///   - edgeWidth: Edge glow width.
    public init(
        progress: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        edgeWidth: Double = 0.05
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.center = center
        self.edgeWidth = edgeWidth
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.radialDissolve(
                .float(progress),
                .float(center.x),
                .float(center.y),
                .float(edgeWidth)
            )
        )
    }
}

// MARK: - BurnDissolveModifier

/// Dissolve with fire-like burning edge.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct BurnDissolveModifier: ViewModifier {
    
    public var progress: Double
    public var scale: Double
    public var burnWidth: Double
    
    /// Creates a burn dissolve modifier.
    /// - Parameters:
    ///   - progress: Transition progress.
    ///   - scale: Burn pattern scale.
    ///   - burnWidth: Width of burn edge.
    public init(
        progress: Double,
        scale: Double = 8.0,
        burnWidth: Double = 0.15
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.scale = scale
        self.burnWidth = burnWidth
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.burnDissolve(
                .float(progress),
                .float(scale),
                .float(burnWidth)
            )
        )
    }
}

// MARK: - PixelDissolveModifier

/// Dissolve with pixelated blocks.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PixelDissolveModifier: ViewModifier {
    
    public var progress: Double
    public var pixelSize: Double
    
    /// Creates a pixel dissolve modifier.
    /// - Parameters:
    ///   - progress: Transition progress.
    ///   - pixelSize: Size of pixel blocks.
    public init(
        progress: Double,
        pixelSize: Double = 0.02
    ) {
        self.progress = progress.clamped(to: 0...1)
        self.pixelSize = pixelSize
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.pixelDissolve(
                .float(progress),
                .float(pixelSize)
            )
        )
    }
}

// MARK: - Private Extensions

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies dissolve transition effect.
    func dissolveEffect(
        progress: Double,
        scale: Double = 10.0,
        edgeWidth: Double = 0.05
    ) -> some View {
        modifier(DissolveModifier(
            progress: progress,
            scale: scale,
            edgeWidth: edgeWidth
        ))
    }
    
    /// Applies directional dissolve.
    func directionalDissolve(
        progress: Double,
        angle: Double = 0.0,
        edgeWidth: Double = 0.05
    ) -> some View {
        modifier(DirectionalDissolveModifier(
            progress: progress,
            angle: angle,
            edgeWidth: edgeWidth
        ))
    }
    
    /// Applies radial dissolve.
    func radialDissolve(
        progress: Double,
        center: CGPoint = CGPoint(x: 0.5, y: 0.5),
        edgeWidth: Double = 0.05
    ) -> some View {
        modifier(RadialDissolveModifier(
            progress: progress,
            center: center,
            edgeWidth: edgeWidth
        ))
    }
    
    /// Applies burn dissolve.
    func burnDissolve(
        progress: Double,
        scale: Double = 8.0,
        burnWidth: Double = 0.15
    ) -> some View {
        modifier(BurnDissolveModifier(
            progress: progress,
            scale: scale,
            burnWidth: burnWidth
        ))
    }
    
    /// Applies pixel dissolve.
    func pixelDissolve(
        progress: Double,
        pixelSize: Double = 0.02
    ) -> some View {
        modifier(PixelDissolveModifier(
            progress: progress,
            pixelSize: pixelSize
        ))
    }
}

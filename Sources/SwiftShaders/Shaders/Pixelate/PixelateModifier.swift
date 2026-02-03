import SwiftUI

// MARK: - PixelateModifier

/// A view modifier that applies pixelation effects.
///
/// Reduces the apparent resolution by grouping pixels into larger blocks,
/// creating retro game aesthetics or transition effects.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(PixelateModifier(pixelSize: 10.0))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PixelateModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Size of each pixel block in points.
    public var pixelSize: Double
    
    // MARK: - Initialization
    
    /// Creates a pixelate modifier.
    /// - Parameter pixelSize: Size of pixel blocks (default: 10.0).
    public init(pixelSize: Double = 10.0) {
        self.pixelSize = max(1.0, pixelSize)
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.pixelate(.float(pixelSize)),
            maxSampleOffset: CGSize(width: pixelSize, height: pixelSize)
        )
    }
}

// MARK: - PixelateTransitionModifier

/// Animated pixelation transition effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct PixelateTransitionModifier: ViewModifier {
    
    public var progress: Double
    public var maxPixelSize: Double
    
    /// Creates a pixelate transition modifier.
    /// - Parameters:
    ///   - progress: Transition progress (0.0 - 1.0).
    ///   - maxPixelSize: Maximum pixel size at full transition.
    public init(progress: Double, maxPixelSize: Double = 50.0) {
        self.progress = progress.clamped(to: 0...1)
        self.maxPixelSize = maxPixelSize
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.pixelateTransition(
                .float(progress),
                .float(maxPixelSize)
            ),
            maxSampleOffset: CGSize(width: maxPixelSize, height: maxPixelSize)
        )
    }
}

// MARK: - HexPixelateModifier

/// Hexagonal grid pixelation effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct HexPixelateModifier: ViewModifier {
    
    public var hexSize: Double
    
    /// Creates a hexagonal pixelate modifier.
    /// - Parameter hexSize: Size of hexagonal cells.
    public init(hexSize: Double = 0.05) {
        self.hexSize = hexSize
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.hexPixelate(.float(hexSize)),
            maxSampleOffset: CGSize(width: 50, height: 50)
        )
    }
}

// MARK: - DiamondPixelateModifier

/// Diamond/rhombus grid pixelation effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DiamondPixelateModifier: ViewModifier {
    
    public var diamondSize: Double
    
    /// Creates a diamond pixelate modifier.
    /// - Parameter diamondSize: Size of diamond cells.
    public init(diamondSize: Double = 0.05) {
        self.diamondSize = diamondSize
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.diamondPixelate(.float(diamondSize)),
            maxSampleOffset: CGSize(width: 50, height: 50)
        )
    }
}

// MARK: - DotMatrixModifier

/// Halftone dot matrix effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DotMatrixModifier: ViewModifier {
    
    public var dotSize: Double
    public var dotSpacing: Double
    
    /// Creates a dot matrix modifier.
    /// - Parameters:
    ///   - dotSize: Maximum dot size.
    ///   - dotSpacing: Spacing between dots.
    public init(dotSize: Double = 1.0, dotSpacing: Double = 0.02) {
        self.dotSize = dotSize
        self.dotSpacing = dotSpacing
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.dotMatrix(
                .float(dotSize),
                .float(dotSpacing)
            )
        )
    }
}

// MARK: - LEDMatrixModifier

/// LED display matrix effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct LEDMatrixModifier: ViewModifier {
    
    public var ledSize: Double
    public var ledGap: Double
    public var brightness: Double
    
    /// Creates an LED matrix modifier.
    /// - Parameters:
    ///   - ledSize: Size of each LED.
    ///   - ledGap: Gap between LEDs.
    ///   - brightness: LED brightness multiplier.
    public init(
        ledSize: Double = 8.0,
        ledGap: Double = 2.0,
        brightness: Double = 1.2
    ) {
        self.ledSize = ledSize
        self.ledGap = ledGap
        self.brightness = brightness
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.ledMatrix(
                .float(ledSize),
                .float(ledGap),
                .float(brightness)
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
    
    /// Applies pixelation transition effect.
    /// - Parameters:
    ///   - progress: Transition progress.
    ///   - maxPixelSize: Maximum pixel size.
    /// - Returns: A view with pixelate transition.
    func pixelateTransition(
        progress: Double,
        maxPixelSize: Double = 50.0
    ) -> some View {
        modifier(PixelateTransitionModifier(
            progress: progress,
            maxPixelSize: maxPixelSize
        ))
    }
    
    /// Applies hexagonal pixelation.
    /// - Parameter hexSize: Hexagon cell size.
    /// - Returns: A view with hex pixelation.
    func hexPixelate(hexSize: Double = 0.05) -> some View {
        modifier(HexPixelateModifier(hexSize: hexSize))
    }
    
    /// Applies diamond pixelation.
    /// - Parameter diamondSize: Diamond cell size.
    /// - Returns: A view with diamond pixelation.
    func diamondPixelate(diamondSize: Double = 0.05) -> some View {
        modifier(DiamondPixelateModifier(diamondSize: diamondSize))
    }
    
    /// Applies dot matrix effect.
    /// - Parameters:
    ///   - dotSize: Dot size.
    ///   - spacing: Dot spacing.
    /// - Returns: A view with dot matrix effect.
    func dotMatrix(
        dotSize: Double = 1.0,
        spacing: Double = 0.02
    ) -> some View {
        modifier(DotMatrixModifier(dotSize: dotSize, dotSpacing: spacing))
    }
    
    /// Applies LED matrix effect.
    /// - Parameters:
    ///   - ledSize: LED size.
    ///   - gap: Gap between LEDs.
    ///   - brightness: Brightness multiplier.
    /// - Returns: A view with LED matrix effect.
    func ledMatrix(
        ledSize: Double = 8.0,
        gap: Double = 2.0,
        brightness: Double = 1.2
    ) -> some View {
        modifier(LEDMatrixModifier(
            ledSize: ledSize,
            ledGap: gap,
            brightness: brightness
        ))
    }
}

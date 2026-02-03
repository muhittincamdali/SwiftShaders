import SwiftUI

// MARK: - HologramModifier

/// A view modifier that applies futuristic hologram effects.
///
/// Creates sci-fi holographic display aesthetics with scan lines,
/// color shifts, and flickering.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(HologramModifier(
///         time: animationTime,
///         scanlineIntensity: 0.3,
///         flickerSpeed: 2.0,
///         colorShift: 0.1
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct HologramModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Intensity of scan line effect.
    public var scanlineIntensity: Double
    
    /// Speed of flicker animation.
    public var flickerSpeed: Double
    
    /// Amount of color channel shifting.
    public var colorShift: Double
    
    // MARK: - Initialization
    
    /// Creates a hologram modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scanlineIntensity: Scan line strength (default: 0.3).
    ///   - flickerSpeed: Flicker speed (default: 2.0).
    ///   - colorShift: Color shift amount (default: 0.1).
    public init(
        time: Double,
        scanlineIntensity: Double = 0.3,
        flickerSpeed: Double = 2.0,
        colorShift: Double = 0.1
    ) {
        self.time = time
        self.scanlineIntensity = scanlineIntensity
        self.flickerSpeed = flickerSpeed
        self.colorShift = colorShift
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.hologram(
                .float(time),
                .float(scanlineIntensity),
                .float(flickerSpeed),
                .float(colorShift)
            )
        )
    }
}

// MARK: - GlitchyHologramModifier

/// Hologram with glitch artifacts.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct GlitchyHologramModifier: ViewModifier {
    
    public var time: Double
    public var glitchIntensity: Double
    public var noiseAmount: Double
    
    /// Creates a glitchy hologram modifier.
    public init(
        time: Double,
        glitchIntensity: Double = 0.3,
        noiseAmount: Double = 0.1
    ) {
        self.time = time
        self.glitchIntensity = glitchIntensity
        self.noiseAmount = noiseAmount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.glitchyHologram(
                .float(time),
                .float(glitchIntensity),
                .float(noiseAmount)
            )
        )
    }
}

// MARK: - WireframeHologramModifier

/// Wireframe grid hologram effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct WireframeHologramModifier: ViewModifier {
    
    public var time: Double
    public var gridSize: Double
    public var lineWidth: Double
    
    /// Creates a wireframe hologram modifier.
    public init(
        time: Double,
        gridSize: Double = 20.0,
        lineWidth: Double = 0.02
    ) {
        self.time = time
        self.gridSize = gridSize
        self.lineWidth = lineWidth
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.wireframeHologram(
                .float(time),
                .float(gridSize),
                .float(lineWidth)
            )
        )
    }
}

// MARK: - ProjectionHologramModifier

/// Projection-style hologram with perspective lines.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ProjectionHologramModifier: ViewModifier {
    
    public var time: Double
    public var lineSpacing: Double
    public var perspectiveAmount: Double
    
    /// Creates a projection hologram modifier.
    public init(
        time: Double,
        lineSpacing: Double = 0.02,
        perspectiveAmount: Double = 0.3
    ) {
        self.time = time
        self.lineSpacing = lineSpacing
        self.perspectiveAmount = perspectiveAmount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.projectionHologram(
                .float(time),
                .float(lineSpacing),
                .float(perspectiveAmount)
            )
        )
    }
}

// MARK: - DataStreamHologramModifier

/// Hologram with animated data streams.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct DataStreamHologramModifier: ViewModifier {
    
    public var time: Double
    public var streamSpeed: Double
    public var density: Double
    
    /// Creates a data stream hologram modifier.
    public init(
        time: Double,
        streamSpeed: Double = 1.0,
        density: Double = 10.0
    ) {
        self.time = time
        self.streamSpeed = streamSpeed
        self.density = density
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.dataStreamHologram(
                .float(time),
                .float(streamSpeed),
                .float(density)
            )
        )
    }
}

// MARK: - RetroHologramModifier

/// Retro-style hologram with color bands.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RetroHologramModifier: ViewModifier {
    
    public var time: Double
    public var bandCount: Double
    public var speed: Double
    
    /// Creates a retro hologram modifier.
    public init(
        time: Double,
        bandCount: Double = 10.0,
        speed: Double = 2.0
    ) {
        self.time = time
        self.bandCount = bandCount
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.retroHologram(
                .float(time),
                .float(bandCount),
                .float(speed)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies hologram effect.
    func hologramEffect(
        time: Double,
        scanlineIntensity: Double = 0.3,
        flickerSpeed: Double = 2.0,
        colorShift: Double = 0.1
    ) -> some View {
        modifier(HologramModifier(
            time: time,
            scanlineIntensity: scanlineIntensity,
            flickerSpeed: flickerSpeed,
            colorShift: colorShift
        ))
    }
    
    /// Applies glitchy hologram effect.
    func glitchyHologram(
        time: Double,
        glitchIntensity: Double = 0.3,
        noiseAmount: Double = 0.1
    ) -> some View {
        modifier(GlitchyHologramModifier(
            time: time,
            glitchIntensity: glitchIntensity,
            noiseAmount: noiseAmount
        ))
    }
    
    /// Applies wireframe hologram effect.
    func wireframeHologram(
        time: Double,
        gridSize: Double = 20.0,
        lineWidth: Double = 0.02
    ) -> some View {
        modifier(WireframeHologramModifier(
            time: time,
            gridSize: gridSize,
            lineWidth: lineWidth
        ))
    }
    
    /// Applies projection hologram effect.
    func projectionHologram(
        time: Double,
        lineSpacing: Double = 0.02,
        perspectiveAmount: Double = 0.3
    ) -> some View {
        modifier(ProjectionHologramModifier(
            time: time,
            lineSpacing: lineSpacing,
            perspectiveAmount: perspectiveAmount
        ))
    }
    
    /// Applies data stream hologram effect.
    func dataStreamHologram(
        time: Double,
        streamSpeed: Double = 1.0,
        density: Double = 10.0
    ) -> some View {
        modifier(DataStreamHologramModifier(
            time: time,
            streamSpeed: streamSpeed,
            density: density
        ))
    }
    
    /// Applies retro hologram effect.
    func retroHologram(
        time: Double,
        bandCount: Double = 10.0,
        speed: Double = 2.0
    ) -> some View {
        modifier(RetroHologramModifier(
            time: time,
            bandCount: bandCount,
            speed: speed
        ))
    }
}

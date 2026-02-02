import SwiftUI

/// A view modifier that applies a digital glitch distortion.
public struct GlitchModifier: ViewModifier {
    public var time: Double
    public var intensity: Double
    public var speed: Double
    public var blockSize: Double
    public var isEnabled: Bool
    
    public init(
        time: Double = 0,
        intensity: Double = 0.5,
        speed: Double = 2,
        blockSize: Double = 8,
        isEnabled: Bool = true
    ) {
        self.time = time
        self.intensity = intensity
        self.speed = speed
        self.blockSize = blockSize
        self.isEnabled = isEnabled
    }
    
    public func body(content: Content) -> some View {
        content.layerEffect(
            ShaderLibrary.glitch(
                .float(time),
                .float(intensity),
                .float(speed),
                .float(blockSize)
            ),
            maxSampleOffset: CGSize(width: 50, height: 0),
            isEnabled: isEnabled
        )
    }
}

extension View {
    /// Applies a digital glitch distortion effect.
    public func glitchEffect(
        time: Double = 0,
        intensity: Double = 0.5,
        speed: Double = 2,
        blockSize: Double = 8,
        isEnabled: Bool = true
    ) -> some View {
        modifier(GlitchModifier(
            time: time,
            intensity: intensity,
            speed: speed,
            blockSize: blockSize,
            isEnabled: isEnabled
        ))
    }
}

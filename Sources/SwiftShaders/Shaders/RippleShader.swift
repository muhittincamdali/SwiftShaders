import SwiftUI

/// A view modifier that applies a ripple distortion effect.
public struct RippleModifier: ViewModifier {
    public var origin: CGPoint
    public var time: Double
    public var frequency: Double
    public var amplitude: Double
    public var decay: Double
    public var isEnabled: Bool
    
    public init(
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        time: Double = 0,
        frequency: Double = 15,
        amplitude: Double = 12,
        decay: Double = 4,
        isEnabled: Bool = true
    ) {
        self.origin = origin
        self.time = time
        self.frequency = frequency
        self.amplitude = amplitude
        self.decay = decay
        self.isEnabled = isEnabled
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.ripple(
                .float2(origin.x, origin.y),
                .float(time),
                .float(frequency),
                .float(amplitude),
                .float(decay)
            ),
            maxSampleOffset: CGSize(width: amplitude, height: amplitude),
            isEnabled: isEnabled
        )
    }
}

extension View {
    /// Applies a ripple distortion emanating from the given origin.
    public func rippleEffect(
        origin: CGPoint = CGPoint(x: 0.5, y: 0.5),
        time: Double = 0,
        frequency: Double = 15,
        amplitude: Double = 12,
        decay: Double = 4,
        isEnabled: Bool = true
    ) -> some View {
        modifier(RippleModifier(
            origin: origin,
            time: time,
            frequency: frequency,
            amplitude: amplitude,
            decay: decay,
            isEnabled: isEnabled
        ))
    }
}

import SwiftUI

/// A view modifier that applies chromatic aberration (RGB channel split).
public struct ChromaticAberrationModifier: ViewModifier {
    public var intensity: Double
    public var angle: Angle
    public var isEnabled: Bool
    
    public init(
        intensity: Double = 5,
        angle: Angle = .zero,
        isEnabled: Bool = true
    ) {
        self.intensity = intensity
        self.angle = angle
        self.isEnabled = isEnabled
    }
    
    public func body(content: Content) -> some View {
        content.layerEffect(
            ShaderLibrary.chromatic_aberration(
                .float(intensity),
                .float(angle.radians)
            ),
            maxSampleOffset: CGSize(width: intensity, height: intensity),
            isEnabled: isEnabled
        )
    }
}

extension View {
    /// Applies a chromatic aberration effect that splits RGB channels.
    public func chromaticAberration(
        intensity: Double = 5,
        angle: Angle = .zero,
        isEnabled: Bool = true
    ) -> some View {
        modifier(ChromaticAberrationModifier(
            intensity: intensity,
            angle: angle,
            isEnabled: isEnabled
        ))
    }
}

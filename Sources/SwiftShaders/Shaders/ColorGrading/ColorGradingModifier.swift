import SwiftUI

// MARK: - ColorGradingModifier

/// A view modifier for professional color grading controls.
///
/// Provides comprehensive color adjustment including brightness, contrast,
/// saturation, hue, temperature, and tint.
///
/// ## Overview
///
/// ```swift
/// Image("photo")
///     .modifier(ColorGradingModifier(
///         brightness: 0.1,
///         contrast: 1.2,
///         saturation: 1.1,
///         temperature: 0.2
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct ColorGradingModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Brightness adjustment (-1 to 1).
    public var brightness: Double
    
    /// Contrast multiplier (0 to 2, 1 = normal).
    public var contrast: Double
    
    /// Saturation multiplier (0 to 2, 1 = normal).
    public var saturation: Double
    
    /// Hue rotation (0 to 1, wraps around).
    public var hueShift: Double
    
    /// Temperature (negative = cool, positive = warm).
    public var temperature: Double
    
    /// Tint (negative = green, positive = magenta).
    public var tint: Double
    
    // MARK: - Initialization
    
    /// Creates a color grading modifier.
    public init(
        brightness: Double = 0.0,
        contrast: Double = 1.0,
        saturation: Double = 1.0,
        hueShift: Double = 0.0,
        temperature: Double = 0.0,
        tint: Double = 0.0
    ) {
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.hueShift = hueShift
        self.temperature = temperature
        self.tint = tint
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.colorGrading(
                .float(brightness),
                .float(contrast),
                .float(saturation),
                .float(hueShift),
                .float(temperature),
                .float(tint)
            )
        )
    }
}

// MARK: - LevelsModifier

/// Photoshop-style levels adjustment.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct LevelsModifier: ViewModifier {
    
    public var inputBlack: Double
    public var inputWhite: Double
    public var gamma: Double
    public var outputBlack: Double
    public var outputWhite: Double
    
    /// Creates a levels modifier.
    public init(
        inputBlack: Double = 0.0,
        inputWhite: Double = 1.0,
        gamma: Double = 1.0,
        outputBlack: Double = 0.0,
        outputWhite: Double = 1.0
    ) {
        self.inputBlack = inputBlack
        self.inputWhite = inputWhite
        self.gamma = gamma
        self.outputBlack = outputBlack
        self.outputWhite = outputWhite
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.levels(
                .float(inputBlack),
                .float(inputWhite),
                .float(gamma),
                .float(outputBlack),
                .float(outputWhite)
            )
        )
    }
}

// MARK: - CurvesModifier

/// Simplified curves adjustment.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct CurvesModifier: ViewModifier {
    
    public var shadowLift: Double
    public var midtoneContrast: Double
    public var highlightCompress: Double
    
    /// Creates a curves modifier.
    public init(
        shadowLift: Double = 0.0,
        midtoneContrast: Double = 0.0,
        highlightCompress: Double = 0.0
    ) {
        self.shadowLift = shadowLift
        self.midtoneContrast = midtoneContrast
        self.highlightCompress = highlightCompress
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.curves(
                .float(shadowLift),
                .float(midtoneContrast),
                .float(highlightCompress)
            )
        )
    }
}

// MARK: - SplitToningModifier

/// Split toning for shadows and highlights.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SplitToningModifier: ViewModifier {
    
    public var shadowHue: Double
    public var shadowSaturation: Double
    public var highlightHue: Double
    public var highlightSaturation: Double
    public var balance: Double
    
    /// Creates a split toning modifier.
    public init(
        shadowHue: Double = 0.1,
        shadowSaturation: Double = 0.2,
        highlightHue: Double = 0.6,
        highlightSaturation: Double = 0.2,
        balance: Double = 0.0
    ) {
        self.shadowHue = shadowHue
        self.shadowSaturation = shadowSaturation
        self.highlightHue = highlightHue
        self.highlightSaturation = highlightSaturation
        self.balance = balance
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.splitToning(
                .float(shadowHue),
                .float(shadowSaturation),
                .float(highlightHue),
                .float(highlightSaturation),
                .float(balance)
            )
        )
    }
}

// MARK: - VibranceModifier

/// Smart saturation boost.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VibranceModifier: ViewModifier {
    
    public var amount: Double
    
    /// Creates a vibrance modifier.
    /// - Parameter amount: Vibrance amount (-1 to 1).
    public init(amount: Double = 0.3) {
        self.amount = amount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.vibrance(.float(amount))
        )
    }
}

// MARK: - FilmEmulationModifier

/// Film stock emulation effect.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FilmEmulationModifier: ViewModifier {
    
    /// Film stock types.
    public enum FilmType: Double {
        case portra = 0.0
        case velvia = 0.5
        case cinestill = 1.0
    }
    
    public var filmType: FilmType
    public var intensity: Double
    
    /// Creates a film emulation modifier.
    public init(filmType: FilmType = .portra, intensity: Double = 1.0) {
        self.filmType = filmType
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.filmEmulation(
                .float(filmType.rawValue),
                .float(intensity)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies color grading.
    func colorGrading(
        brightness: Double = 0.0,
        contrast: Double = 1.0,
        saturation: Double = 1.0,
        hueShift: Double = 0.0,
        temperature: Double = 0.0,
        tint: Double = 0.0
    ) -> some View {
        modifier(ColorGradingModifier(
            brightness: brightness,
            contrast: contrast,
            saturation: saturation,
            hueShift: hueShift,
            temperature: temperature,
            tint: tint
        ))
    }
    
    /// Applies levels adjustment.
    func levels(
        inputBlack: Double = 0.0,
        inputWhite: Double = 1.0,
        gamma: Double = 1.0,
        outputBlack: Double = 0.0,
        outputWhite: Double = 1.0
    ) -> some View {
        modifier(LevelsModifier(
            inputBlack: inputBlack,
            inputWhite: inputWhite,
            gamma: gamma,
            outputBlack: outputBlack,
            outputWhite: outputWhite
        ))
    }
    
    /// Applies curves adjustment.
    func curves(
        shadowLift: Double = 0.0,
        midtoneContrast: Double = 0.0,
        highlightCompress: Double = 0.0
    ) -> some View {
        modifier(CurvesModifier(
            shadowLift: shadowLift,
            midtoneContrast: midtoneContrast,
            highlightCompress: highlightCompress
        ))
    }
    
    /// Applies split toning.
    func splitToning(
        shadowHue: Double = 0.1,
        shadowSaturation: Double = 0.2,
        highlightHue: Double = 0.6,
        highlightSaturation: Double = 0.2,
        balance: Double = 0.0
    ) -> some View {
        modifier(SplitToningModifier(
            shadowHue: shadowHue,
            shadowSaturation: shadowSaturation,
            highlightHue: highlightHue,
            highlightSaturation: highlightSaturation,
            balance: balance
        ))
    }
    
    /// Applies vibrance.
    func vibrance(_ amount: Double = 0.3) -> some View {
        modifier(VibranceModifier(amount: amount))
    }
    
    /// Applies film emulation.
    func filmEmulation(
        _ filmType: FilmEmulationModifier.FilmType = .portra,
        intensity: Double = 1.0
    ) -> some View {
        modifier(FilmEmulationModifier(filmType: filmType, intensity: intensity))
    }
}

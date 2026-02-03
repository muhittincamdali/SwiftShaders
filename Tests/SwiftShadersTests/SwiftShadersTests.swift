import XCTest
import SwiftUI
@testable import SwiftShaders

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class SwiftShadersTests: XCTestCase {
    
    // MARK: - ShaderLibrary Tests
    
    func testShaderLibrarySingleton() {
        let library1 = ShaderLibrary.shared
        let library2 = ShaderLibrary.shared
        XCTAssertTrue(library1 === library2)
    }
    
    func testShaderLibraryCount() {
        let library = ShaderLibrary.shared
        XCTAssertGreaterThan(library.count, 0)
        XCTAssertGreaterThanOrEqual(library.count, 30)
    }
    
    func testShaderCategories() {
        let library = ShaderLibrary.shared
        
        XCTAssertFalse(library.distortionShaders.isEmpty)
        XCTAssertFalse(library.colorShaders.isEmpty)
        XCTAssertFalse(library.particleShaders.isEmpty)
        XCTAssertFalse(library.transitionShaders.isEmpty)
    }
    
    func testShaderLookup() {
        let library = ShaderLibrary.shared
        
        let ripple = library.shader(named: "ripple")
        XCTAssertNotNil(ripple)
        XCTAssertEqual(ripple?.name, "Ripple")
        
        let nonExistent = library.shader(named: "nonexistent")
        XCTAssertNil(nonExistent)
    }
    
    func testShaderInfo() {
        let info = ShaderLibrary.ShaderInfo(
            id: "test",
            name: "Test Shader",
            description: "A test shader",
            category: .distortion,
            isAnimatable: true,
            minimumVersion: "17.0"
        )
        
        XCTAssertEqual(info.id, "test")
        XCTAssertEqual(info.name, "Test Shader")
        XCTAssertEqual(info.category, .distortion)
        XCTAssertTrue(info.isAnimatable)
    }
    
    // MARK: - ShaderConfiguration Tests
    
    func testShaderConfigurationDefaults() {
        let config = ShaderConfiguration.default
        
        XCTAssertEqual(config.quality, .medium)
        XCTAssertEqual(config.samplingMode, .bilinear)
        XCTAssertEqual(config.blendMode, .normal)
        XCTAssertEqual(config.opacity, 1.0)
    }
    
    func testShaderConfigurationPresets() {
        let performance = ShaderConfiguration.performance
        XCTAssertEqual(performance.quality, .low)
        XCTAssertEqual(performance.samplingMode, .nearest)
        
        let highQuality = ShaderConfiguration.highQuality
        XCTAssertEqual(highQuality.quality, .high)
        XCTAssertTrue(highQuality.enableHDR)
    }
    
    func testQualitySamplingMultiplier() {
        XCTAssertEqual(ShaderConfiguration.Quality.low.samplingMultiplier, 0.5)
        XCTAssertEqual(ShaderConfiguration.Quality.medium.samplingMultiplier, 1.0)
        XCTAssertEqual(ShaderConfiguration.Quality.high.samplingMultiplier, 1.5)
        XCTAssertEqual(ShaderConfiguration.Quality.ultra.samplingMultiplier, 2.0)
    }
    
    func testQualityIterationCount() {
        XCTAssertEqual(ShaderConfiguration.Quality.low.iterationCount, 4)
        XCTAssertEqual(ShaderConfiguration.Quality.medium.iterationCount, 8)
        XCTAssertEqual(ShaderConfiguration.Quality.high.iterationCount, 16)
        XCTAssertEqual(ShaderConfiguration.Quality.ultra.iterationCount, 32)
    }
    
    func testOpacityClamping() {
        let config1 = ShaderConfiguration(opacity: 2.0)
        XCTAssertEqual(config1.opacity, 1.0)
        
        let config2 = ShaderConfiguration(opacity: -0.5)
        XCTAssertEqual(config2.opacity, 0.0)
    }
    
    // MARK: - AnimationConfiguration Tests
    
    func testAnimationConfigurationDefaults() {
        let config = AnimationConfiguration.default
        
        XCTAssertEqual(config.duration, 0.5)
        XCTAssertEqual(config.delay, 0.0)
        XCTAssertEqual(config.easingCurve, .easeInOut)
        XCTAssertFalse(config.loops)
    }
    
    func testAnimationPresets() {
        let quick = AnimationConfiguration.quick
        XCTAssertEqual(quick.duration, 0.3)
        
        let slow = AnimationConfiguration.slow
        XCTAssertEqual(slow.duration, 1.0)
        
        let continuous = AnimationConfiguration.continuous
        XCTAssertTrue(continuous.loops)
        
        let pulse = AnimationConfiguration.pulse
        XCTAssertTrue(pulse.loops)
        XCTAssertTrue(pulse.autoReverse)
    }
    
    func testEasingCurves() {
        // Linear
        XCTAssertEqual(AnimationConfiguration.EasingCurve.linear.apply(0.0), 0.0)
        XCTAssertEqual(AnimationConfiguration.EasingCurve.linear.apply(0.5), 0.5)
        XCTAssertEqual(AnimationConfiguration.EasingCurve.linear.apply(1.0), 1.0)
        
        // Ease In (slow start)
        let easeIn = AnimationConfiguration.EasingCurve.easeIn.apply(0.5)
        XCTAssertLessThan(easeIn, 0.5)
        
        // Ease Out (slow end)
        let easeOut = AnimationConfiguration.EasingCurve.easeOut.apply(0.5)
        XCTAssertGreaterThan(easeOut, 0.5)
        
        // Boundaries
        XCTAssertEqual(AnimationConfiguration.EasingCurve.easeIn.apply(0.0), 0.0)
        XCTAssertEqual(AnimationConfiguration.EasingCurve.easeIn.apply(1.0), 1.0)
    }
    
    // MARK: - ShaderEasing Tests
    
    func testShaderEasingFunctions() {
        // Linear
        XCTAssertEqual(ShaderEasing.linear(0.5), 0.5)
        
        // Quad
        XCTAssertEqual(ShaderEasing.easeInQuad(0.0), 0.0)
        XCTAssertEqual(ShaderEasing.easeInQuad(1.0), 1.0)
        XCTAssertEqual(ShaderEasing.easeOutQuad(0.0), 0.0)
        XCTAssertEqual(ShaderEasing.easeOutQuad(1.0), 1.0)
        
        // Cubic
        XCTAssertEqual(ShaderEasing.easeInCubic(0.0), 0.0)
        XCTAssertEqual(ShaderEasing.easeInCubic(1.0), 1.0)
        
        // Sine
        XCTAssertEqual(ShaderEasing.easeInSine(0.0), 0.0, accuracy: 0.0001)
        XCTAssertEqual(ShaderEasing.easeInSine(1.0), 1.0, accuracy: 0.0001)
        
        // Bounce
        XCTAssertEqual(ShaderEasing.easeOutBounce(0.0), 0.0, accuracy: 0.0001)
        XCTAssertEqual(ShaderEasing.easeOutBounce(1.0), 1.0, accuracy: 0.0001)
    }
    
    // MARK: - ShaderMath Tests
    
    func testLerp() {
        XCTAssertEqual(ShaderMath.lerp(0, 100, 0), 0)
        XCTAssertEqual(ShaderMath.lerp(0, 100, 0.5), 50)
        XCTAssertEqual(ShaderMath.lerp(0, 100, 1), 100)
    }
    
    func testSmoothstep() {
        XCTAssertEqual(ShaderMath.smoothstep(0, 1, -0.5), 0)
        XCTAssertEqual(ShaderMath.smoothstep(0, 1, 0.5), 0.5)
        XCTAssertEqual(ShaderMath.smoothstep(0, 1, 1.5), 1)
    }
    
    func testMap() {
        let mapped = ShaderMath.map(5, from: 0...10, to: 0...100)
        XCTAssertEqual(mapped, 50)
        
        let mapped2 = ShaderMath.map(0, from: 0...10, to: 100...200)
        XCTAssertEqual(mapped2, 100)
    }
    
    func testPingPong() {
        XCTAssertEqual(ShaderMath.pingPong(0, 1), 0, accuracy: 0.0001)
        XCTAssertEqual(ShaderMath.pingPong(0.5, 1), 0.5, accuracy: 0.0001)
        XCTAssertEqual(ShaderMath.pingPong(1.5, 1), 0.5, accuracy: 0.0001)
    }
    
    func testNormalizedSinCos() {
        let sin0 = ShaderMath.normalizedSin(0)
        XCTAssertGreaterThanOrEqual(sin0, 0)
        XCTAssertLessThanOrEqual(sin0, 1)
        
        let cos0 = ShaderMath.normalizedCos(0)
        XCTAssertGreaterThanOrEqual(cos0, 0)
        XCTAssertLessThanOrEqual(cos0, 1)
    }
    
    // MARK: - ShaderColor Tests
    
    func testHSLToRGB() {
        // Red
        let red = ShaderColor.hslToRGB(h: 0, s: 1, l: 0.5)
        XCTAssertEqual(red.r, 1.0, accuracy: 0.01)
        XCTAssertEqual(red.g, 0.0, accuracy: 0.01)
        XCTAssertEqual(red.b, 0.0, accuracy: 0.01)
        
        // White
        let white = ShaderColor.hslToRGB(h: 0, s: 0, l: 1)
        XCTAssertEqual(white.r, 1.0, accuracy: 0.01)
        XCTAssertEqual(white.g, 1.0, accuracy: 0.01)
        XCTAssertEqual(white.b, 1.0, accuracy: 0.01)
        
        // Black
        let black = ShaderColor.hslToRGB(h: 0, s: 0, l: 0)
        XCTAssertEqual(black.r, 0.0, accuracy: 0.01)
        XCTAssertEqual(black.g, 0.0, accuracy: 0.01)
        XCTAssertEqual(black.b, 0.0, accuracy: 0.01)
    }
    
    func testRGBToHSL() {
        // Red
        let red = ShaderColor.rgbToHSL(r: 1, g: 0, b: 0)
        XCTAssertEqual(red.h, 0.0, accuracy: 0.01)
        XCTAssertEqual(red.s, 1.0, accuracy: 0.01)
        XCTAssertEqual(red.l, 0.5, accuracy: 0.01)
        
        // Gray
        let gray = ShaderColor.rgbToHSL(r: 0.5, g: 0.5, b: 0.5)
        XCTAssertEqual(gray.s, 0.0, accuracy: 0.01)
        XCTAssertEqual(gray.l, 0.5, accuracy: 0.01)
    }
    
    // MARK: - MetalDevice Tests
    
    func testMetalDeviceSupport() {
        // Metal should be supported on modern Apple devices
        #if targetEnvironment(simulator)
        // Simulator may not support Metal
        #else
        XCTAssertTrue(MetalDevice.isSupported)
        XCTAssertNotNil(MetalDevice.device)
        #endif
    }
    
    func testFeatureSupport() {
        let features = MetalDevice.checkFeatureSupport()
        XCTAssertFalse(features.isEmpty)
    }
    
    // MARK: - Modifier Tests
    
    func testRippleModifierCreation() {
        let modifier = RippleModifier(
            time: 1.0,
            origin: CGPoint(x: 0.5, y: 0.5),
            amplitude: 0.02,
            frequency: 15.0,
            decay: 8.0
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.origin, CGPoint(x: 0.5, y: 0.5))
        XCTAssertEqual(modifier.amplitude, 0.02)
    }
    
    func testChromaticModifierCreation() {
        let modifier = ChromaticModifier(
            intensity: 0.05,
            angle: 0.0
        )
        
        XCTAssertEqual(modifier.intensity, 0.05)
        XCTAssertEqual(modifier.angle, 0.0)
    }
    
    func testGlitchModifierCreation() {
        let modifier = GlitchModifier(
            time: 1.0,
            intensity: 0.5,
            blockSize: 0.1
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.intensity, 0.5)
    }
    
    func testPixelateModifierCreation() {
        let modifier = PixelateModifier(pixelSize: 10.0)
        XCTAssertEqual(modifier.pixelSize, 10.0)
        
        // Test minimum clamping
        let modifier2 = PixelateModifier(pixelSize: 0.5)
        XCTAssertGreaterThanOrEqual(modifier2.pixelSize, 1.0)
    }
    
    func testDissolveModifierCreation() {
        let modifier = DissolveModifier(
            progress: 0.5,
            scale: 10.0,
            edgeWidth: 0.05
        )
        
        XCTAssertEqual(modifier.progress, 0.5)
        
        // Test clamping
        let modifier2 = DissolveModifier(progress: 1.5)
        XCTAssertEqual(modifier2.progress, 1.0)
        
        let modifier3 = DissolveModifier(progress: -0.5)
        XCTAssertEqual(modifier3.progress, 0.0)
    }
    
    // MARK: - KeyframeAnimator Tests
    
    func testKeyframeInterpolation() {
        let keyframes = [
            ShaderKeyframe(time: 0.0, value: 0.0),
            ShaderKeyframe(time: 1.0, value: 100.0)
        ]
        
        XCTAssertEqual(KeyframeAnimator.interpolate(keyframes: keyframes, at: 0.0), 0.0)
        XCTAssertEqual(KeyframeAnimator.interpolate(keyframes: keyframes, at: 0.5), 50.0)
        XCTAssertEqual(KeyframeAnimator.interpolate(keyframes: keyframes, at: 1.0), 100.0)
    }
    
    func testEmptyKeyframes() {
        let empty: [ShaderKeyframe<Double>] = []
        XCTAssertEqual(KeyframeAnimator.interpolate(keyframes: empty, at: 0.5), 0.0)
        
        let single = [ShaderKeyframe(time: 0.5, value: 42.0)]
        XCTAssertEqual(KeyframeAnimator.interpolate(keyframes: single, at: 0.0), 42.0)
    }
    
    // MARK: - BlendMode Tests
    
    func testBlendModeFactors() {
        XCTAssertEqual(ShaderConfiguration.BlendMode.normal.blendFactors.count, 4)
        XCTAssertEqual(ShaderConfiguration.BlendMode.additive.blendFactors.count, 4)
        XCTAssertEqual(ShaderConfiguration.BlendMode.multiply.blendFactors.count, 4)
    }
}

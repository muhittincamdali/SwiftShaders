import XCTest
import SwiftUI
@testable import SwiftShaders

// MARK: - Voronoi Shader Tests

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class VoronoiShaderTests: XCTestCase {
    
    // MARK: - VoronoiNoiseModifier Tests
    
    func testVoronoiNoiseModifierCreation() {
        let modifier = VoronoiNoiseModifier(
            time: 1.0,
            scale: 8.0,
            jitter: 1.0,
            edgeWidth: 0.1
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.jitter, 1.0)
        XCTAssertEqual(modifier.edgeWidth, 0.1)
    }
    
    func testVoronoiNoiseModifierDefaults() {
        let modifier = VoronoiNoiseModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.jitter, 1.0)
        XCTAssertEqual(modifier.edgeWidth, 0.1)
    }
    
    func testVoronoiNoiseModifierExtremeValues() {
        let modifier = VoronoiNoiseModifier(
            time: 1000.0,
            scale: 100.0,
            jitter: 0.0,
            edgeWidth: 0.0
        )
        
        XCTAssertEqual(modifier.time, 1000.0)
        XCTAssertEqual(modifier.scale, 100.0)
        XCTAssertEqual(modifier.jitter, 0.0)
        XCTAssertEqual(modifier.edgeWidth, 0.0)
    }
    
    // MARK: - VoronoiCellsModifier Tests
    
    func testVoronoiCellsModifierCreation() {
        let modifier = VoronoiCellsModifier(
            time: 2.0,
            scale: 10.0,
            jitter: 0.8,
            colorVariation: 0.6
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.scale, 10.0)
        XCTAssertEqual(modifier.jitter, 0.8)
        XCTAssertEqual(modifier.colorVariation, 0.6)
    }
    
    func testVoronoiCellsModifierDefaults() {
        let modifier = VoronoiCellsModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.jitter, 1.0)
        XCTAssertEqual(modifier.colorVariation, 0.5)
    }
    
    // MARK: - VoronoiEdgeGlowModifier Tests
    
    func testVoronoiEdgeGlowModifierCreation() {
        let modifier = VoronoiEdgeGlowModifier(
            time: 1.5,
            scale: 6.0,
            jitter: 0.9,
            glowWidth: 0.2,
            glowColor: .blue
        )
        
        XCTAssertEqual(modifier.time, 1.5)
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.jitter, 0.9)
        XCTAssertEqual(modifier.glowWidth, 0.2)
    }
    
    func testVoronoiEdgeGlowModifierDefaults() {
        let modifier = VoronoiEdgeGlowModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.jitter, 1.0)
        XCTAssertEqual(modifier.glowWidth, 0.15)
    }
    
    // MARK: - VoronoiCrystalModifier Tests
    
    func testVoronoiCrystalModifierCreation() {
        let modifier = VoronoiCrystalModifier(
            time: 3.0,
            scale: 5.0,
            facetSharpness: 0.7,
            refractAmount: 0.3
        )
        
        XCTAssertEqual(modifier.time, 3.0)
        XCTAssertEqual(modifier.scale, 5.0)
        XCTAssertEqual(modifier.facetSharpness, 0.7)
        XCTAssertEqual(modifier.refractAmount, 0.3)
    }
    
    func testVoronoiCrystalModifierDefaults() {
        let modifier = VoronoiCrystalModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.facetSharpness, 0.5)
        XCTAssertEqual(modifier.refractAmount, 0.2)
    }
    
    // MARK: - VoronoiShatteredModifier Tests
    
    func testVoronoiShatteredModifierCreation() {
        let modifier = VoronoiShatteredModifier(
            time: 0.5,
            scale: 12.0,
            crackWidth: 0.03,
            crackColor: .white
        )
        
        XCTAssertEqual(modifier.time, 0.5)
        XCTAssertEqual(modifier.scale, 12.0)
        XCTAssertEqual(modifier.crackWidth, 0.03)
    }
    
    func testVoronoiShatteredModifierDefaults() {
        let modifier = VoronoiShatteredModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 10.0)
        XCTAssertEqual(modifier.crackWidth, 0.02)
    }
    
    // MARK: - VoronoiCellularModifier Tests
    
    func testVoronoiCellularModifierCreation() {
        let modifier = VoronoiCellularModifier(
            time: 2.5,
            scale: 5.0,
            membraneWidth: 0.15,
            membraneColor: .red
        )
        
        XCTAssertEqual(modifier.time, 2.5)
        XCTAssertEqual(modifier.scale, 5.0)
        XCTAssertEqual(modifier.membraneWidth, 0.15)
    }
    
    func testVoronoiCellularModifierDefaults() {
        let modifier = VoronoiCellularModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.membraneWidth, 0.1)
    }
    
    // MARK: - VoronoiHoneycombModifier Tests
    
    func testVoronoiHoneycombModifierCreation() {
        let modifier = VoronoiHoneycombModifier(
            time: 1.0,
            scale: 10.0,
            wallWidth: 0.1,
            wallColor: .yellow
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.scale, 10.0)
        XCTAssertEqual(modifier.wallWidth, 0.1)
    }
    
    func testVoronoiHoneycombModifierDefaults() {
        let modifier = VoronoiHoneycombModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.wallWidth, 0.08)
    }
    
    // MARK: - VoronoiDistortModifier Tests
    
    func testVoronoiDistortModifierCreation() {
        let modifier = VoronoiDistortModifier(
            time: 4.0,
            scale: 7.0,
            distortAmount: 0.8
        )
        
        XCTAssertEqual(modifier.time, 4.0)
        XCTAssertEqual(modifier.scale, 7.0)
        XCTAssertEqual(modifier.distortAmount, 0.8)
    }
    
    func testVoronoiDistortModifierDefaults() {
        let modifier = VoronoiDistortModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.distortAmount, 0.5)
    }
    
    // MARK: - VoronoiLiquidModifier Tests
    
    func testVoronoiLiquidModifierCreation() {
        let modifier = VoronoiLiquidModifier(
            time: 2.0,
            scale: 4.0,
            flowSpeed: 1.5,
            flowAmount: 0.4
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.scale, 4.0)
        XCTAssertEqual(modifier.flowSpeed, 1.5)
        XCTAssertEqual(modifier.flowAmount, 0.4)
    }
    
    func testVoronoiLiquidModifierDefaults() {
        let modifier = VoronoiLiquidModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 5.0)
        XCTAssertEqual(modifier.flowSpeed, 1.0)
        XCTAssertEqual(modifier.flowAmount, 0.3)
    }
    
    // MARK: - VoronoiLavaModifier Tests
    
    func testVoronoiLavaModifierCreation() {
        let modifier = VoronoiLavaModifier(
            time: 3.0,
            scale: 8.0,
            heatIntensity: 1.5
        )
        
        XCTAssertEqual(modifier.time, 3.0)
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.heatIntensity, 1.5)
    }
    
    func testVoronoiLavaModifierDefaults() {
        let modifier = VoronoiLavaModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.heatIntensity, 1.0)
    }
    
    // MARK: - VoronoiPlasmaModifier Tests
    
    func testVoronoiPlasmaModifierCreation() {
        let modifier = VoronoiPlasmaModifier(
            time: 1.0,
            scale: 6.0,
            pulseSpeed: 2.0,
            plasmaColor: .cyan
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.pulseSpeed, 2.0)
    }
    
    func testVoronoiPlasmaModifierDefaults() {
        let modifier = VoronoiPlasmaModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 5.0)
        XCTAssertEqual(modifier.pulseSpeed, 1.0)
    }
    
    // MARK: - VoronoiCausticsModifier Tests
    
    func testVoronoiCausticsModifierCreation() {
        let modifier = VoronoiCausticsModifier(
            time: 2.0,
            scale: 10.0,
            brightness: 0.7,
            sharpness: 3.0
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.scale, 10.0)
        XCTAssertEqual(modifier.brightness, 0.7)
        XCTAssertEqual(modifier.sharpness, 3.0)
    }
    
    func testVoronoiCausticsModifierDefaults() {
        let modifier = VoronoiCausticsModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.brightness, 0.5)
        XCTAssertEqual(modifier.sharpness, 2.0)
    }
    
    // MARK: - VoronoiStainedGlassModifier Tests
    
    func testVoronoiStainedGlassModifierCreation() {
        let modifier = VoronoiStainedGlassModifier(
            time: 0.0,
            scale: 6.0,
            leadWidth: 0.08,
            saturation: 0.8
        )
        
        XCTAssertEqual(modifier.time, 0.0)
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.leadWidth, 0.08)
        XCTAssertEqual(modifier.saturation, 0.8)
    }
    
    func testVoronoiStainedGlassModifierDefaults() {
        let modifier = VoronoiStainedGlassModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.leadWidth, 0.06)
        XCTAssertEqual(modifier.saturation, 1.0)
    }
    
    // MARK: - VoronoiFrostModifier Tests
    
    func testVoronoiFrostModifierCreation() {
        let modifier = VoronoiFrostModifier(
            time: 1.0,
            scale: 10.0,
            crackDepth: 1.5,
            frostiness: 0.7
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.scale, 10.0)
        XCTAssertEqual(modifier.crackDepth, 1.5)
        XCTAssertEqual(modifier.frostiness, 0.7)
    }
    
    func testVoronoiFrostModifierDefaults() {
        let modifier = VoronoiFrostModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 8.0)
        XCTAssertEqual(modifier.crackDepth, 1.0)
        XCTAssertEqual(modifier.frostiness, 0.5)
    }
}

// MARK: - Displacement Shader Tests

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class DisplacementShaderTests: XCTestCase {
    
    // MARK: - SineDisplacementModifier Tests
    
    func testSineDisplacementModifierCreation() {
        let modifier = SineDisplacementModifier(
            time: 1.0,
            amplitudeX: 0.03,
            amplitudeY: 0.02,
            frequencyX: 4.0,
            frequencyY: 3.0
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.amplitudeX, 0.03)
        XCTAssertEqual(modifier.amplitudeY, 0.02)
        XCTAssertEqual(modifier.frequencyX, 4.0)
        XCTAssertEqual(modifier.frequencyY, 3.0)
    }
    
    func testSineDisplacementModifierDefaults() {
        let modifier = SineDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amplitudeX, 0.02)
        XCTAssertEqual(modifier.amplitudeY, 0.01)
        XCTAssertEqual(modifier.frequencyX, 3.0)
        XCTAssertEqual(modifier.frequencyY, 2.0)
    }
    
    // MARK: - NoiseDisplacementModifier Tests
    
    func testNoiseDisplacementModifierCreation() {
        let modifier = NoiseDisplacementModifier(
            time: 2.0,
            scale: 6.0,
            amount: 0.08,
            speed: 0.5
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.scale, 6.0)
        XCTAssertEqual(modifier.amount, 0.08)
        XCTAssertEqual(modifier.speed, 0.5)
    }
    
    func testNoiseDisplacementModifierDefaults() {
        let modifier = NoiseDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 5.0)
        XCTAssertEqual(modifier.amount, 0.05)
        XCTAssertEqual(modifier.speed, 0.3)
    }
    
    // MARK: - FBMDisplacementModifier Tests
    
    func testFBMDisplacementModifierCreation() {
        let modifier = FBMDisplacementModifier(
            time: 1.5,
            scale: 4.0,
            amount: 0.06,
            octaves: 6
        )
        
        XCTAssertEqual(modifier.time, 1.5)
        XCTAssertEqual(modifier.scale, 4.0)
        XCTAssertEqual(modifier.amount, 0.06)
        XCTAssertEqual(modifier.octaves, 6)
    }
    
    func testFBMDisplacementModifierDefaults() {
        let modifier = FBMDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 3.0)
        XCTAssertEqual(modifier.amount, 0.05)
        XCTAssertEqual(modifier.octaves, 4)
    }
    
    // MARK: - RadialDisplacementModifier Tests
    
    func testRadialDisplacementModifierCreation() {
        let modifier = RadialDisplacementModifier(
            time: 2.0,
            amount: 0.05,
            frequency: 3.0,
            center: CGPoint(x: 0.3, y: 0.7)
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.amount, 0.05)
        XCTAssertEqual(modifier.frequency, 3.0)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.3, y: 0.7))
    }
    
    func testRadialDisplacementModifierDefaults() {
        let modifier = RadialDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amount, 0.03)
        XCTAssertEqual(modifier.frequency, 2.0)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - SpiralDisplacementModifier Tests
    
    func testSpiralDisplacementModifierCreation() {
        let modifier = SpiralDisplacementModifier(
            time: 3.0,
            amount: 0.7,
            tightness: 1.5,
            center: CGPoint(x: 0.4, y: 0.6)
        )
        
        XCTAssertEqual(modifier.time, 3.0)
        XCTAssertEqual(modifier.amount, 0.7)
        XCTAssertEqual(modifier.tightness, 1.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.4, y: 0.6))
    }
    
    func testSpiralDisplacementModifierDefaults() {
        let modifier = SpiralDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amount, 0.5)
        XCTAssertEqual(modifier.tightness, 1.0)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - HeatDistortionModifier Tests
    
    func testHeatDistortionModifierCreation() {
        let modifier = HeatDistortionModifier(
            time: 1.0,
            intensity: 1.5,
            riseFactor: 0.7,
            turbulence: 4.0
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.intensity, 1.5)
        XCTAssertEqual(modifier.riseFactor, 0.7)
        XCTAssertEqual(modifier.turbulence, 4.0)
    }
    
    func testHeatDistortionModifierDefaults() {
        let modifier = HeatDistortionModifier(time: 0.0)
        
        XCTAssertEqual(modifier.intensity, 1.0)
        XCTAssertEqual(modifier.riseFactor, 0.5)
        XCTAssertEqual(modifier.turbulence, 3.0)
    }
    
    // MARK: - UnderwaterDisplacementModifier Tests
    
    func testUnderwaterDisplacementModifierCreation() {
        let modifier = UnderwaterDisplacementModifier(
            time: 2.0,
            waveScale: 1.5,
            waveAmount: 1.2,
            depthFactor: 0.8
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.waveScale, 1.5)
        XCTAssertEqual(modifier.waveAmount, 1.2)
        XCTAssertEqual(modifier.depthFactor, 0.8)
    }
    
    func testUnderwaterDisplacementModifierDefaults() {
        let modifier = UnderwaterDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.waveScale, 1.0)
        XCTAssertEqual(modifier.waveAmount, 1.0)
        XCTAssertEqual(modifier.depthFactor, 1.0)
    }
    
    // MARK: - ShockwaveDisplacementModifier Tests
    
    func testShockwaveDisplacementModifierCreation() {
        let modifier = ShockwaveDisplacementModifier(
            time: 0.5,
            center: CGPoint(x: 0.3, y: 0.3),
            waveWidth: 0.15,
            amplitude: 0.08
        )
        
        XCTAssertEqual(modifier.time, 0.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.3, y: 0.3))
        XCTAssertEqual(modifier.waveWidth, 0.15)
        XCTAssertEqual(modifier.amplitude, 0.08)
    }
    
    func testShockwaveDisplacementModifierDefaults() {
        let modifier = ShockwaveDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
        XCTAssertEqual(modifier.waveWidth, 0.1)
        XCTAssertEqual(modifier.amplitude, 0.05)
    }
    
    // MARK: - LensDistortionModifier Tests
    
    func testLensDistortionModifierCreation() {
        let modifier = LensDistortionModifier(
            time: 1.0,
            k1: 0.5,
            k2: 0.1,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.k1, 0.5)
        XCTAssertEqual(modifier.k2, 0.1)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    func testLensDistortionModifierNegativeK1() {
        let modifier = LensDistortionModifier(
            time: 0.0,
            k1: -0.3,
            k2: 0.0,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        XCTAssertEqual(modifier.k1, -0.3) // Pincushion distortion
    }
    
    func testLensDistortionModifierDefaults() {
        let modifier = LensDistortionModifier(time: 0.0)
        
        XCTAssertEqual(modifier.k1, 0.3)
        XCTAssertEqual(modifier.k2, 0.0)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - FlagWaveModifier Tests
    
    func testFlagWaveModifierCreation() {
        let modifier = FlagWaveModifier(
            time: 2.0,
            amplitude: 0.7,
            frequency: 4.0,
            propagation: 6.0
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.amplitude, 0.7)
        XCTAssertEqual(modifier.frequency, 4.0)
        XCTAssertEqual(modifier.propagation, 6.0)
    }
    
    func testFlagWaveModifierDefaults() {
        let modifier = FlagWaveModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amplitude, 0.5)
        XCTAssertEqual(modifier.frequency, 3.0)
        XCTAssertEqual(modifier.propagation, 5.0)
    }
    
    // MARK: - SpherizeModifier Tests
    
    func testSpherizeModifierCreation() {
        let modifier = SpherizeModifier(
            time: 1.0,
            amount: 0.7,
            radius: 0.4,
            center: CGPoint(x: 0.6, y: 0.4)
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.amount, 0.7)
        XCTAssertEqual(modifier.radius, 0.4)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.6, y: 0.4))
    }
    
    func testSpherizeModifierDefaults() {
        let modifier = SpherizeModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amount, 0.5)
        XCTAssertEqual(modifier.radius, 0.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - TwirlModifier Tests
    
    func testTwirlModifierCreation() {
        let modifier = TwirlModifier(
            time: 2.0,
            angle: 3.14159,
            radius: 0.6,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.angle, 3.14159, accuracy: 0.0001)
        XCTAssertEqual(modifier.radius, 0.6)
    }
    
    func testTwirlModifierDefaults() {
        let modifier = TwirlModifier(time: 0.0)
        
        XCTAssertEqual(modifier.angle, 2.0)
        XCTAssertEqual(modifier.radius, 0.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - PinchModifier Tests
    
    func testPinchModifierCreation() {
        let modifier = PinchModifier(
            time: 1.5,
            amount: 0.6,
            radius: 0.3,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        XCTAssertEqual(modifier.time, 1.5)
        XCTAssertEqual(modifier.amount, 0.6)
        XCTAssertEqual(modifier.radius, 0.3)
    }
    
    func testPinchModifierDefaults() {
        let modifier = PinchModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amount, 0.5)
        XCTAssertEqual(modifier.radius, 0.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - ZigzagModifier Tests
    
    func testZigzagModifierCreation() {
        let modifier = ZigzagModifier(
            time: 1.0,
            amplitude: 0.4,
            frequency: 15.0,
            angle: 0.5
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.amplitude, 0.4)
        XCTAssertEqual(modifier.frequency, 15.0)
        XCTAssertEqual(modifier.angle, 0.5)
    }
    
    func testZigzagModifierDefaults() {
        let modifier = ZigzagModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amplitude, 0.3)
        XCTAssertEqual(modifier.frequency, 10.0)
        XCTAssertEqual(modifier.angle, 0.0)
    }
    
    // MARK: - BlobDisplacementModifier Tests
    
    func testBlobDisplacementModifierCreation() {
        let modifier = BlobDisplacementModifier(
            time: 2.0,
            scale: 4.0,
            amount: 0.4,
            smoothness: 0.9
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.scale, 4.0)
        XCTAssertEqual(modifier.amount, 0.4)
        XCTAssertEqual(modifier.smoothness, 0.9)
    }
    
    func testBlobDisplacementModifierDefaults() {
        let modifier = BlobDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.scale, 3.0)
        XCTAssertEqual(modifier.amount, 0.3)
        XCTAssertEqual(modifier.smoothness, 0.8)
    }
    
    // MARK: - BreathingDisplacementModifier Tests
    
    func testBreathingDisplacementModifierCreation() {
        let modifier = BreathingDisplacementModifier(
            time: 3.0,
            amount: 0.15,
            speed: 2.0,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        XCTAssertEqual(modifier.time, 3.0)
        XCTAssertEqual(modifier.amount, 0.15)
        XCTAssertEqual(modifier.speed, 2.0)
    }
    
    func testBreathingDisplacementModifierDefaults() {
        let modifier = BreathingDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.amount, 0.1)
        XCTAssertEqual(modifier.speed, 1.5)
        XCTAssertEqual(modifier.center, CGPoint(x: 0.5, y: 0.5))
    }
    
    // MARK: - BlockDisplacementModifier Tests
    
    func testBlockDisplacementModifierCreation() {
        let modifier = BlockDisplacementModifier(
            time: 1.0,
            blockSize: 0.08,
            amount: 0.6,
            probability: 0.4
        )
        
        XCTAssertEqual(modifier.time, 1.0)
        XCTAssertEqual(modifier.blockSize, 0.08)
        XCTAssertEqual(modifier.amount, 0.6)
        XCTAssertEqual(modifier.probability, 0.4)
    }
    
    func testBlockDisplacementModifierDefaults() {
        let modifier = BlockDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.blockSize, 0.05)
        XCTAssertEqual(modifier.amount, 0.5)
        XCTAssertEqual(modifier.probability, 0.3)
    }
    
    // MARK: - ScanlineJitterModifier Tests
    
    func testScanlineJitterModifierCreation() {
        let modifier = ScanlineJitterModifier(
            time: 2.0,
            lineHeight: 0.02,
            jitterAmount: 0.15,
            probability: 0.3
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.lineHeight, 0.02)
        XCTAssertEqual(modifier.jitterAmount, 0.15)
        XCTAssertEqual(modifier.probability, 0.3)
    }
    
    func testScanlineJitterModifierDefaults() {
        let modifier = ScanlineJitterModifier(time: 0.0)
        
        XCTAssertEqual(modifier.lineHeight, 0.01)
        XCTAssertEqual(modifier.jitterAmount, 0.1)
        XCTAssertEqual(modifier.probability, 0.2)
    }
    
    // MARK: - WindDisplacementModifier Tests
    
    func testWindDisplacementModifierCreation() {
        let modifier = WindDisplacementModifier(
            time: 4.0,
            strength: 0.7,
            gustiness: 1.5,
            direction: 1.57
        )
        
        XCTAssertEqual(modifier.time, 4.0)
        XCTAssertEqual(modifier.strength, 0.7)
        XCTAssertEqual(modifier.gustiness, 1.5)
        XCTAssertEqual(modifier.direction, 1.57, accuracy: 0.001)
    }
    
    func testWindDisplacementModifierDefaults() {
        let modifier = WindDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.strength, 0.5)
        XCTAssertEqual(modifier.gustiness, 1.0)
        XCTAssertEqual(modifier.direction, 0.0)
    }
    
    // MARK: - EarthquakeDisplacementModifier Tests
    
    func testEarthquakeDisplacementModifierCreation() {
        let modifier = EarthquakeDisplacementModifier(
            time: 0.5,
            magnitude: 1.5,
            frequency: 2.0,
            decay: 0.8
        )
        
        XCTAssertEqual(modifier.time, 0.5)
        XCTAssertEqual(modifier.magnitude, 1.5)
        XCTAssertEqual(modifier.frequency, 2.0)
        XCTAssertEqual(modifier.decay, 0.8)
    }
    
    func testEarthquakeDisplacementModifierDefaults() {
        let modifier = EarthquakeDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.magnitude, 1.0)
        XCTAssertEqual(modifier.frequency, 1.0)
        XCTAssertEqual(modifier.decay, 0.5)
    }
    
    // MARK: - MagneticDisplacementModifier Tests
    
    func testMagneticDisplacementModifierCreation() {
        let modifier = MagneticDisplacementModifier(
            time: 2.0,
            strength: 0.7,
            pole: CGPoint(x: 0.3, y: 0.7)
        )
        
        XCTAssertEqual(modifier.time, 2.0)
        XCTAssertEqual(modifier.strength, 0.7)
        XCTAssertEqual(modifier.pole, CGPoint(x: 0.3, y: 0.7))
    }
    
    func testMagneticDisplacementModifierDefaults() {
        let modifier = MagneticDisplacementModifier(time: 0.0)
        
        XCTAssertEqual(modifier.strength, 0.5)
        XCTAssertEqual(modifier.pole, CGPoint(x: 0.5, y: 0.5))
    }
}

// MARK: - View Extension Integration Tests

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class ViewExtensionTests: XCTestCase {
    
    // MARK: - Voronoi View Extensions
    
    func testVoronoiNoiseViewExtension() {
        let view = Rectangle()
            .voronoiNoise(time: 1.0, scale: 10.0)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiCellsViewExtension() {
        let view = Rectangle()
            .voronoiCells(time: 1.0, scale: 8.0, colorVariation: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiEdgeGlowViewExtension() {
        let view = Rectangle()
            .voronoiEdgeGlow(time: 1.0, scale: 6.0, glowWidth: 0.2, glowColor: .purple)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiCrystalViewExtension() {
        let view = Rectangle()
            .voronoiCrystal(time: 1.0, scale: 5.0)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiShatteredViewExtension() {
        let view = Rectangle()
            .voronoiShattered(time: 0.0, scale: 12.0, crackWidth: 0.02)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiCellularViewExtension() {
        let view = Rectangle()
            .voronoiCellular(time: 1.0, scale: 6.0, membraneWidth: 0.1)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiHoneycombViewExtension() {
        let view = Rectangle()
            .voronoiHoneycomb(time: 1.0, scale: 8.0, wallWidth: 0.08)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiDistortViewExtension() {
        let view = Rectangle()
            .voronoiDistort(time: 1.0, scale: 6.0, distortAmount: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiLiquidViewExtension() {
        let view = Rectangle()
            .voronoiLiquid(time: 1.0, scale: 5.0, flowSpeed: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiLavaViewExtension() {
        let view = Rectangle()
            .voronoiLava(time: 1.0, scale: 6.0, heatIntensity: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiPlasmaViewExtension() {
        let view = Rectangle()
            .voronoiPlasma(time: 1.0, scale: 5.0, pulseSpeed: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiCausticsViewExtension() {
        let view = Rectangle()
            .voronoiCaustics(time: 1.0, scale: 8.0, brightness: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiStainedGlassViewExtension() {
        let view = Rectangle()
            .voronoiStainedGlass(time: 0.0, scale: 8.0, leadWidth: 0.06)
        XCTAssertNotNil(view)
    }
    
    func testVoronoiFrostViewExtension() {
        let view = Rectangle()
            .voronoiFrost(time: 1.0, scale: 8.0, crackDepth: 1.0)
        XCTAssertNotNil(view)
    }
    
    // MARK: - Displacement View Extensions
    
    func testSineDisplacementViewExtension() {
        let view = Rectangle()
            .sineDisplacement(time: 1.0, amplitudeX: 0.02, amplitudeY: 0.01)
        XCTAssertNotNil(view)
    }
    
    func testNoiseDisplacementViewExtension() {
        let view = Rectangle()
            .noiseDisplacement(time: 1.0, scale: 5.0, amount: 0.05)
        XCTAssertNotNil(view)
    }
    
    func testFbmDisplacementViewExtension() {
        let view = Rectangle()
            .fbmDisplacement(time: 1.0, scale: 3.0, amount: 0.05, octaves: 4)
        XCTAssertNotNil(view)
    }
    
    func testRadialDisplacementViewExtension() {
        let view = Rectangle()
            .radialDisplacement(time: 1.0, amount: 0.03, frequency: 2.0)
        XCTAssertNotNil(view)
    }
    
    func testSpiralDisplacementViewExtension() {
        let view = Rectangle()
            .spiralDisplacement(time: 1.0, amount: 0.5, tightness: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testHeatDistortionViewExtension() {
        let view = Rectangle()
            .heatDistortion(time: 1.0, intensity: 1.0, riseFactor: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testUnderwaterDisplacementViewExtension() {
        let view = Rectangle()
            .underwaterDisplacement(time: 1.0, waveScale: 1.0, waveAmount: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testShockwaveDisplacementViewExtension() {
        let view = Rectangle()
            .shockwaveDisplacement(time: 1.0, center: CGPoint(x: 0.5, y: 0.5))
        XCTAssertNotNil(view)
    }
    
    func testLensDistortionViewExtension() {
        let view = Rectangle()
            .lensDistortion(time: 1.0, k1: 0.3, k2: 0.0)
        XCTAssertNotNil(view)
    }
    
    func testFlagWaveViewExtension() {
        let view = Rectangle()
            .flagWave(time: 1.0, amplitude: 0.5, frequency: 3.0)
        XCTAssertNotNil(view)
    }
    
    func testSpherizeViewExtension() {
        let view = Rectangle()
            .spherize(time: 1.0, amount: 0.5, radius: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testTwirlViewExtension() {
        let view = Rectangle()
            .twirl(time: 1.0, angle: 2.0, radius: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testPinchViewExtension() {
        let view = Rectangle()
            .pinch(time: 1.0, amount: 0.5, radius: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testZigzagViewExtension() {
        let view = Rectangle()
            .zigzag(time: 1.0, amplitude: 0.3, frequency: 10.0)
        XCTAssertNotNil(view)
    }
    
    func testBlobDisplacementViewExtension() {
        let view = Rectangle()
            .blobDisplacement(time: 1.0, scale: 3.0, amount: 0.3)
        XCTAssertNotNil(view)
    }
    
    func testBreathingDisplacementViewExtension() {
        let view = Rectangle()
            .breathingDisplacement(time: 1.0, amount: 0.1, speed: 1.5)
        XCTAssertNotNil(view)
    }
    
    func testBlockDisplacementViewExtension() {
        let view = Rectangle()
            .blockDisplacement(time: 1.0, blockSize: 0.05, amount: 0.5)
        XCTAssertNotNil(view)
    }
    
    func testScanlineJitterViewExtension() {
        let view = Rectangle()
            .scanlineJitter(time: 1.0, lineHeight: 0.01, jitterAmount: 0.1)
        XCTAssertNotNil(view)
    }
    
    func testWindDisplacementViewExtension() {
        let view = Rectangle()
            .windDisplacement(time: 1.0, strength: 0.5, gustiness: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testEarthquakeDisplacementViewExtension() {
        let view = Rectangle()
            .earthquakeDisplacement(time: 1.0, magnitude: 1.0, frequency: 1.0)
        XCTAssertNotNil(view)
    }
    
    func testMagneticDisplacementViewExtension() {
        let view = Rectangle()
            .magneticDisplacement(time: 1.0, strength: 0.5)
        XCTAssertNotNil(view)
    }
}

// MARK: - Edge Case Tests

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class EdgeCaseTests: XCTestCase {
    
    func testZeroTimeValues() {
        let voronoi = VoronoiNoiseModifier(time: 0.0)
        XCTAssertEqual(voronoi.time, 0.0)
        
        let displacement = SineDisplacementModifier(time: 0.0)
        XCTAssertEqual(displacement.time, 0.0)
    }
    
    func testNegativeTimeValues() {
        let voronoi = VoronoiNoiseModifier(time: -1.0)
        XCTAssertEqual(voronoi.time, -1.0)
        
        let displacement = SineDisplacementModifier(time: -5.0)
        XCTAssertEqual(displacement.time, -5.0)
    }
    
    func testLargeTimeValues() {
        let voronoi = VoronoiNoiseModifier(time: 10000.0)
        XCTAssertEqual(voronoi.time, 10000.0)
        
        let displacement = SineDisplacementModifier(time: 999999.0)
        XCTAssertEqual(displacement.time, 999999.0)
    }
    
    func testZeroScaleValues() {
        let voronoi = VoronoiNoiseModifier(time: 1.0, scale: 0.0)
        XCTAssertEqual(voronoi.scale, 0.0)
    }
    
    func testExtremeAmplitudes() {
        let sine = SineDisplacementModifier(
            time: 1.0,
            amplitudeX: 1.0,
            amplitudeY: 1.0
        )
        XCTAssertEqual(sine.amplitudeX, 1.0)
        XCTAssertEqual(sine.amplitudeY, 1.0)
    }
    
    func testCenterPointBoundaries() {
        let radial1 = RadialDisplacementModifier(
            time: 1.0,
            center: CGPoint(x: 0.0, y: 0.0)
        )
        XCTAssertEqual(radial1.center, CGPoint(x: 0.0, y: 0.0))
        
        let radial2 = RadialDisplacementModifier(
            time: 1.0,
            center: CGPoint(x: 1.0, y: 1.0)
        )
        XCTAssertEqual(radial2.center, CGPoint(x: 1.0, y: 1.0))
    }
    
    func testCenterPointOutOfBounds() {
        let radial = RadialDisplacementModifier(
            time: 1.0,
            center: CGPoint(x: -0.5, y: 1.5)
        )
        XCTAssertEqual(radial.center, CGPoint(x: -0.5, y: 1.5))
    }
    
    func testZeroRadius() {
        let spherize = SpherizeModifier(time: 1.0, radius: 0.0)
        XCTAssertEqual(spherize.radius, 0.0)
        
        let twirl = TwirlModifier(time: 1.0, radius: 0.0)
        XCTAssertEqual(twirl.radius, 0.0)
    }
    
    func testFullRadiusCoverage() {
        let spherize = SpherizeModifier(time: 1.0, radius: 1.0)
        XCTAssertEqual(spherize.radius, 1.0)
    }
    
    func testZeroProbability() {
        let block = BlockDisplacementModifier(time: 1.0, probability: 0.0)
        XCTAssertEqual(block.probability, 0.0)
        
        let scanline = ScanlineJitterModifier(time: 1.0, probability: 0.0)
        XCTAssertEqual(scanline.probability, 0.0)
    }
    
    func testFullProbability() {
        let block = BlockDisplacementModifier(time: 1.0, probability: 1.0)
        XCTAssertEqual(block.probability, 1.0)
        
        let scanline = ScanlineJitterModifier(time: 1.0, probability: 1.0)
        XCTAssertEqual(scanline.probability, 1.0)
    }
    
    func testAngleValues() {
        // Zero angle
        let zigzag0 = ZigzagModifier(time: 1.0, angle: 0.0)
        XCTAssertEqual(zigzag0.angle, 0.0)
        
        // Full rotation
        let zigzagFull = ZigzagModifier(time: 1.0, angle: 6.28318)
        XCTAssertEqual(zigzagFull.angle, 6.28318, accuracy: 0.0001)
        
        // Negative angle
        let zigzagNeg = ZigzagModifier(time: 1.0, angle: -1.57)
        XCTAssertEqual(zigzagNeg.angle, -1.57, accuracy: 0.001)
    }
    
    func testOctaveRange() {
        let fbmMin = FBMDisplacementModifier(time: 1.0, octaves: 1)
        XCTAssertEqual(fbmMin.octaves, 1)
        
        let fbmMax = FBMDisplacementModifier(time: 1.0, octaves: 8)
        XCTAssertEqual(fbmMax.octaves, 8)
    }
    
    func testDecayValues() {
        let quake0 = EarthquakeDisplacementModifier(time: 1.0, decay: 0.0)
        XCTAssertEqual(quake0.decay, 0.0)
        
        let quakeHigh = EarthquakeDisplacementModifier(time: 1.0, decay: 10.0)
        XCTAssertEqual(quakeHigh.decay, 10.0)
    }
}

// MARK: - Performance Characteristic Tests

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
final class PerformanceCharacteristicTests: XCTestCase {
    
    func testModifierMemoryFootprint() {
        let voronoi = VoronoiNoiseModifier(time: 1.0)
        let displacement = SineDisplacementModifier(time: 1.0)
        
        // Modifiers should have minimal memory footprint
        XCTAssertLessThan(MemoryLayout.size(ofValue: voronoi), 100)
        XCTAssertLessThan(MemoryLayout.size(ofValue: displacement), 100)
    }
    
    func testModifierInitializationSpeed() {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<1000 {
            _ = VoronoiNoiseModifier(time: 1.0)
            _ = SineDisplacementModifier(time: 1.0)
        }
        
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // 1000 initializations should take less than 100ms
        XCTAssertLessThan(elapsed, 0.1)
    }
    
    func testCGPointStorageEfficiency() {
        let modifier = RadialDisplacementModifier(
            time: 1.0,
            center: CGPoint(x: 0.5, y: 0.5)
        )
        
        // CGPoint should be stored efficiently
        XCTAssertEqual(MemoryLayout<CGPoint>.size, 16)
        XCTAssertNotNil(modifier.center)
    }
}

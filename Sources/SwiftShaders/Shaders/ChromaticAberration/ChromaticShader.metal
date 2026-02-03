#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Chromatic Aberration Shader
// Simulates lens chromatic aberration by separating RGB channels.
// Creates the characteristic color fringing seen in optical systems.

/// Basic chromatic aberration with radial separation.
/// Separates RGB channels based on distance from center.
///
/// - Parameters:
///   - position: Current pixel position.
///   - color: Original pixel color.
///   - bounds: View bounds.
///   - intensity: Separation strength.
///   - centerX: Center X (normalized).
///   - centerY: Center Y (normalized).
[[ stitchable ]]
half4 chromaticAberration(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float centerX,
    float centerY
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 direction = position - center;
    float dist = length(direction) / length(bounds.zw * 0.5);
    
    // Calculate offset based on distance from center
    float2 offset = normalize(direction + 0.0001) * intensity * dist * bounds.zw;
    
    // The color parameter represents the pixel at this position
    // For true chromatic aberration, we would need layerEffect
    // This version simulates the effect with color shifts
    
    half4 result = color;
    result.r = color.r * (1.0 + half(intensity * dist * 0.5));
    result.b = color.b * (1.0 - half(intensity * dist * 0.5));
    
    return result;
}

/// Directional chromatic aberration.
/// Separates channels along a specific angle.
[[ stitchable ]]
half4 directionalChromatic(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float angle
) {
    float2 direction = float2(cos(angle), sin(angle));
    
    // Simulate channel separation effect
    half offset = half(intensity * 0.1);
    
    half4 result;
    result.r = color.r * (1.0h + offset);
    result.g = color.g;
    result.b = color.b * (1.0h - offset);
    result.a = color.a;
    
    return result;
}

/// Animated chromatic aberration with pulsing effect.
[[ stitchable ]]
half4 pulsingChromatic(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float baseIntensity,
    float pulseSpeed,
    float pulseAmount
) {
    float2 center = bounds.zw * 0.5;
    float2 direction = position - center;
    float dist = length(direction) / length(center);
    
    // Pulsing intensity
    float pulse = sin(time * pulseSpeed) * 0.5 + 0.5;
    float intensity = baseIntensity + pulse * pulseAmount;
    
    half4 result = color;
    result.r = color.r * half(1.0 + intensity * dist);
    result.b = color.b * half(1.0 - intensity * dist);
    
    return result;
}

/// Lens-accurate chromatic aberration.
/// Simulates real lens dispersion characteristics.
[[ stitchable ]]
half4 lensChromatic(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float distortionK1,
    float distortionK2
) {
    float2 center = bounds.zw * 0.5;
    float2 uv = (position - center) / center;
    
    // Radial distance squared
    float r2 = dot(uv, uv);
    float r4 = r2 * r2;
    
    // Lens distortion factors for each channel
    float distortR = 1.0 + distortionK1 * r2 + distortionK2 * r4;
    float distortG = 1.0 + distortionK1 * r2 * 0.98 + distortionK2 * r4 * 0.98;
    float distortB = 1.0 + distortionK1 * r2 * 0.96 + distortionK2 * r4 * 0.96;
    
    // Apply chromatic shift based on distortion difference
    half chromaShift = half((distortR - distortB) * intensity * 10.0);
    
    half4 result = color;
    result.r = color.r * (1.0h + chromaShift);
    result.b = color.b * (1.0h - chromaShift);
    
    return result;
}

/// RGB split effect for glitch aesthetics.
[[ stitchable ]]
half4 rgbSplit(
    float2 position,
    half4 color,
    float4 bounds,
    float splitX,
    float splitY
) {
    float2 normalizedPos = position / bounds.zw;
    
    // Create color channel shifts based on position
    half redShift = half(normalizedPos.x * splitX);
    half blueShift = half(normalizedPos.y * splitY);
    
    half4 result;
    result.r = color.r * (1.0h + redShift * 0.2h);
    result.g = color.g;
    result.b = color.b * (1.0h + blueShift * 0.2h);
    result.a = color.a;
    
    return result;
}

/// Spectral dispersion effect.
/// Creates rainbow-like color spreading.
[[ stitchable ]]
half4 spectralDispersion(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float spread
) {
    float2 center = bounds.zw * 0.5;
    float2 direction = position - center;
    float dist = length(direction) / length(center);
    float angle = atan2(direction.y, direction.x);
    
    // Create spectral color shift
    half hueShift = half(intensity * dist * spread);
    
    // Simplified hue rotation effect
    half3 hsv;
    hsv.x = fract(half(angle / (2.0 * M_PI_F)) + hueShift);
    hsv.y = half(dist * intensity);
    hsv.z = 1.0h;
    
    // Blend with original color
    half4 result = color;
    result.r = mix(color.r, color.r * (1.0h + hueShift * 0.5h), half(intensity));
    result.g = color.g;
    result.b = mix(color.b, color.b * (1.0h - hueShift * 0.5h), half(intensity));
    
    return result;
}

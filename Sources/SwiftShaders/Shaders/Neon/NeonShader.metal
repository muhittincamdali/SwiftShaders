// Neon Glow Effect Shader
// Creates vibrant neon light effects with bloom and color bleeding
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Neon effect creates glowing light appearance by:
// 1. Edge detection to find bright areas
// 2. Multi-pass gaussian blur for bloom
// 3. HDR-style color intensification
// 4. Additive blending for light bleeding
// 5. Color saturation boost
// =============================================================================

// Luminance calculation
float luminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// HDR tone mapping
half3 toneMap(half3 color, float exposure) {
    return half3(1.0) - exp(-color * half(exposure));
}

// =============================================================================
// COLOR EFFECT: Neon Glow
// =============================================================================
// Parameters:
// - color: Input pixel color
// - glowColor: Neon glow color (R, G, B)
// - intensity: Glow strength (0.0-3.0, default: 1.5)
// - threshold: Brightness threshold for glow (0.0-1.0, default: 0.3)
// =============================================================================
[[stitchable]] half4 neonGlow(
    float2 position,
    half4 color,
    half3 glowColor,
    float intensity,
    float threshold
) {
    float lum = luminance(color.rgb);
    
    // Only glow bright areas
    float glowAmount = smoothstep(threshold, threshold + 0.3, lum);
    
    // Apply glow color
    half3 glow = glowColor * half(glowAmount * intensity);
    
    // Combine with original
    half3 result = color.rgb + glow;
    
    // HDR boost
    result = toneMap(result, 1.5);
    
    return half4(result, color.a);
}

// =============================================================================
// LAYER EFFECT: Neon Outline
// =============================================================================
[[stitchable]] half4 neonOutline(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    half3 glowColor,
    float glowWidth,
    float intensity
) {
    half4 center = layer.sample(position);
    float2 pixelSize = 1.0 / size;
    
    // Edge detection via alpha sampling
    float alphaSum = 0.0;
    int samples = 8;
    
    for (int i = 0; i < samples; i++) {
        float angle = float(i) * 6.28318 / float(samples);
        float2 offset = float2(cos(angle), sin(angle)) * glowWidth;
        half4 sample = layer.sample(position + offset);
        alphaSum += float(sample.a);
    }
    
    // Detect edges (where some samples are transparent)
    float edge = 1.0 - abs(alphaSum / float(samples) - center.a);
    
    // Only glow on edges
    if (center.a > 0.1 && edge > 0.1) {
        half3 glow = glowColor * half(edge * intensity);
        return half4(center.rgb + glow, center.a);
    }
    
    // Outer glow for transparent areas near content
    if (center.a < 0.1 && alphaSum > 0.0) {
        float outerGlow = alphaSum / float(samples);
        return half4(glowColor * half(outerGlow * intensity * 0.5), half(outerGlow * 0.5));
    }
    
    return center;
}

// =============================================================================
// COLOR EFFECT: Neon Color Shift
// =============================================================================
[[stitchable]] half4 neonColorShift(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float speed
) {
    float2 uv = position / size;
    
    // Animated hue shift
    float hueShift = sin(time * speed + uv.x * 3.0) * 0.5 + 0.5;
    
    // RGB to HSV-like shift
    half3 shifted;
    shifted.r = color.r * half(0.5 + 0.5 * sin(hueShift * 6.28));
    shifted.g = color.g * half(0.5 + 0.5 * sin(hueShift * 6.28 + 2.09));
    shifted.b = color.b * half(0.5 + 0.5 * sin(hueShift * 6.28 + 4.18));
    
    // Boost saturation
    float lum = luminance(shifted);
    shifted = mix(half3(lum), shifted, half(1.5));
    
    // Add glow
    shifted *= half(1.3);
    
    return half4(shifted, color.a);
}

// =============================================================================
// LAYER EFFECT: Multi-Glow Neon
// =============================================================================
[[stitchable]] half4 neonMultiGlow(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    half3 innerColor,
    half3 outerColor,
    float innerRadius,
    float outerRadius,
    float intensity
) {
    half4 center = layer.sample(position);
    
    // Inner glow (close blur)
    half3 innerGlow = half3(0.0);
    int innerSamples = 8;
    for (int i = 0; i < innerSamples; i++) {
        float angle = float(i) * 6.28318 / float(innerSamples);
        float2 offset = float2(cos(angle), sin(angle)) * innerRadius;
        half4 sample = layer.sample(position + offset);
        innerGlow += sample.rgb;
    }
    innerGlow /= half(innerSamples);
    innerGlow *= innerColor;
    
    // Outer glow (far blur)
    half3 outerGlow = half3(0.0);
    int outerSamples = 16;
    for (int i = 0; i < outerSamples; i++) {
        float angle = float(i) * 6.28318 / float(outerSamples);
        float2 offset = float2(cos(angle), sin(angle)) * outerRadius;
        half4 sample = layer.sample(position + offset);
        outerGlow += sample.rgb;
    }
    outerGlow /= half(outerSamples);
    outerGlow *= outerColor;
    
    // Combine
    half3 result = center.rgb + (innerGlow + outerGlow * 0.5) * half(intensity);
    result = clamp(result, half3(0.0), half3(1.0));
    
    return half4(result, center.a);
}

// =============================================================================
// COLOR EFFECT: Electric Neon
// =============================================================================
[[stitchable]] half4 neonElectric(
    float2 position,
    half4 color,
    float2 size,
    float time,
    half3 primaryColor,
    half3 secondaryColor,
    float flickerSpeed
) {
    float2 uv = position / size;
    
    // Flicker effect
    float flicker = 0.9 + 0.1 * sin(time * flickerSpeed * 10.0);
    flicker *= 0.95 + 0.05 * sin(time * flickerSpeed * 50.0 + uv.y * 10.0);
    
    // Noise-based variation
    float noise = fract(sin(dot(uv + time * 0.1, float2(12.9898, 78.233))) * 43758.5453);
    
    // Color mixing based on luminance
    float lum = luminance(color.rgb);
    half3 neonColor = mix(secondaryColor, primaryColor, half(lum));
    
    // Apply flicker and intensity
    half3 result = color.rgb * neonColor * half(flicker * 1.5);
    
    // Add slight noise for electric feel
    result += half3(noise * 0.05);
    
    return half4(result, color.a);
}

// =============================================================================
// SIMPLE: Basic Neon Tint
// =============================================================================
[[stitchable]] half4 neonTint(
    float2 position,
    half4 color,
    half3 tintColor,
    float intensity
) {
    float lum = luminance(color.rgb);
    
    // Tint based on brightness
    half3 tinted = mix(color.rgb, tintColor * half(lum * 2.0), half(intensity));
    
    // Boost bright areas
    if (lum > 0.5) {
        tinted += tintColor * half((lum - 0.5) * 0.5);
    }
    
    return half4(clamp(tinted, half3(0.0), half3(1.0)), color.a);
}

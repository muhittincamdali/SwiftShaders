// Invert & Negative Effect Shader
// Creates color inversion and negative film effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Invert effects reverse color values by:
// 1. Subtracting RGB values from 1.0 (white)
// 2. Optionally preserving luminance while inverting hue
// 3. Selective channel inversion for creative effects
// 4. Smooth transition for animated inversion
// =============================================================================

// Luminance calculation
float getLuminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// =============================================================================
// COLOR EFFECT: Basic Invert
// =============================================================================
// Parameters:
// - amount: Inversion amount (0.0 = original, 1.0 = fully inverted)
// =============================================================================
[[stitchable]] half4 invert(
    float2 position,
    half4 color,
    float amount
) {
    half3 inverted = half3(1.0) - color.rgb;
    half3 result = mix(color.rgb, inverted, half(amount));
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Smart Invert (preserve images)
// =============================================================================
[[stitchable]] half4 invertSmart(
    float2 position,
    half4 color,
    float threshold
) {
    // Calculate if this is likely an image (high color variation) or UI
    float lum = getLuminance(color.rgb);
    
    // Simple heuristic: very light or very dark colors get inverted
    // Mid-tones (likely images) are preserved more
    float shouldInvert = abs(lum - 0.5) * 2.0;
    shouldInvert = smoothstep(threshold, 1.0, shouldInvert);
    
    half3 inverted = half3(1.0) - color.rgb;
    half3 result = mix(color.rgb, inverted, half(shouldInvert));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Channel Invert (selective)
// =============================================================================
[[stitchable]] half4 invertChannels(
    float2 position,
    half4 color,
    float invertR,
    float invertG,
    float invertB
) {
    half3 result;
    result.r = mix(color.r, half(1.0) - color.r, half(invertR));
    result.g = mix(color.g, half(1.0) - color.g, half(invertG));
    result.b = mix(color.b, half(1.0) - color.b, half(invertB));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Luminance Invert (keep colors)
// =============================================================================
[[stitchable]] half4 invertLuminance(
    float2 position,
    half4 color,
    float amount
) {
    float lum = getLuminance(color.rgb);
    float invertedLum = 1.0 - lum;
    
    // Scale color to match inverted luminance while preserving hue
    float scale = (lum > 0.001) ? invertedLum / lum : 1.0;
    scale = mix(1.0, scale, amount);
    
    half3 result = color.rgb * half(scale);
    result = clamp(result, half3(0.0), half3(1.0));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Hue Invert (keep brightness)
// =============================================================================
[[stitchable]] half4 invertHue(
    float2 position,
    half4 color,
    float amount
) {
    // Convert to a simple hue representation
    float lum = getLuminance(color.rgb);
    
    // Rotate hue by 180 degrees (complementary color)
    half3 inverted = half3(1.0) - color.rgb;
    
    // Restore original luminance
    float invertedLum = getLuminance(inverted);
    if (invertedLum > 0.001) {
        inverted *= half(lum / invertedLum);
    }
    
    half3 result = mix(color.rgb, inverted, half(amount));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Negative Film
// =============================================================================
[[stitchable]] half4 negativeFilm(
    float2 position,
    half4 color,
    float2 size,
    float orangeMask
) {
    float2 uv = position / size;
    
    // Invert colors
    half3 negative = half3(1.0) - color.rgb;
    
    // Apply orange mask (film base color)
    half3 filmBase = half3(1.0, 0.65, 0.4);
    negative = negative * mix(half3(1.0), filmBase, half(orangeMask));
    
    // Slight vignette for film look
    float2 vigUV = uv * (1.0 - uv);
    float vig = pow(vigUV.x * vigUV.y * 15.0, 0.3);
    negative *= half(vig * 0.3 + 0.7);
    
    return half4(negative, color.a);
}

// =============================================================================
// COLOR EFFECT: X-Ray Effect
// =============================================================================
[[stitchable]] half4 xrayEffect(
    float2 position,
    half4 color,
    float intensity,
    float edgeEnhance
) {
    // Convert to grayscale
    float lum = getLuminance(color.rgb);
    
    // Invert
    float inverted = 1.0 - lum;
    
    // X-ray typically shows structure, so enhance contrast
    inverted = pow(inverted, 1.0 + edgeEnhance * 0.5);
    
    // Slight blue tint for medical X-ray look
    half3 result = half3(
        half(inverted * 0.9),
        half(inverted * 0.95),
        half(inverted * 1.0)
    );
    
    // Mix with original based on intensity
    result = mix(color.rgb, result, half(intensity));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Solarize Effect
// =============================================================================
[[stitchable]] half4 solarize(
    float2 position,
    half4 color,
    float threshold
) {
    // Solarization: invert pixels above threshold
    half3 result = color.rgb;
    
    // Invert bright areas only
    if (float(color.r) > threshold) result.r = half(1.0) - color.r;
    if (float(color.g) > threshold) result.g = half(1.0) - color.g;
    if (float(color.b) > threshold) result.b = half(1.0) - color.b;
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Animated Invert
// =============================================================================
[[stitchable]] half4 invertAnimated(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float speed,
    float waveScale
) {
    float2 uv = position / size;
    
    // Wave-based inversion
    float wave = sin(uv.x * waveScale + time * speed) * 0.5 + 0.5;
    wave *= sin(uv.y * waveScale * 0.7 + time * speed * 0.8) * 0.5 + 0.5;
    
    half3 inverted = half3(1.0) - color.rgb;
    half3 result = mix(color.rgb, inverted, half(wave));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Partial Invert (by region)
// =============================================================================
[[stitchable]] half4 invertRegion(
    float2 position,
    half4 color,
    float2 size,
    float2 regionCenter,
    float regionRadius,
    float feather
) {
    float2 uv = position / size;
    
    // Distance from region center
    float dist = length(uv - regionCenter);
    
    // Smooth transition
    float inRegion = 1.0 - smoothstep(regionRadius - feather, regionRadius + feather, dist);
    
    half3 inverted = half3(1.0) - color.rgb;
    half3 result = mix(color.rgb, inverted, half(inRegion));
    
    return half4(result, color.a);
}

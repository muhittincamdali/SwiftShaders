// Posterize Effect Shader
// Reduces color levels for poster/pop art effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Posterization reduces color depth by:
// 1. Quantizing each color channel to discrete levels
// 2. floor(color * levels) / levels
// 3. Can also apply per-channel different levels
// 4. Optional color palette mapping
// =============================================================================

// =============================================================================
// COLOR EFFECT: Basic Posterize
// =============================================================================
// Parameters:
// - levels: Number of color levels per channel (2-256, default: 4)
// =============================================================================
[[stitchable]] half4 posterize(
    float2 position,
    half4 color,
    float levels
) {
    // Quantize to discrete levels
    half3 posterized = floor(color.rgb * half(levels)) / half(levels - 1.0);
    return half4(posterized, color.a);
}

// =============================================================================
// COLOR EFFECT: Channel-Specific Posterize
// =============================================================================
[[stitchable]] half4 posterizeChannels(
    float2 position,
    half4 color,
    float levelsR,
    float levelsG,
    float levelsB
) {
    half3 result;
    result.r = floor(color.r * half(levelsR)) / half(levelsR - 1.0);
    result.g = floor(color.g * half(levelsG)) / half(levelsG - 1.0);
    result.b = floor(color.b * half(levelsB)) / half(levelsB - 1.0);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Smooth Posterize (with dithering)
// =============================================================================
[[stitchable]] half4 posterizeSmooth(
    float2 position,
    half4 color,
    float2 size,
    float levels,
    float ditherAmount
) {
    float2 uv = position / size;
    
    // Generate dither pattern
    float dither = fract(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
    dither = (dither - 0.5) * ditherAmount / levels;
    
    // Apply dithered posterization
    half3 posterized = floor((color.rgb + half(dither)) * half(levels)) / half(levels - 1.0);
    
    return half4(clamp(posterized, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Pop Art Posterize
// =============================================================================
[[stitchable]] half4 posterizePopArt(
    float2 position,
    half4 color,
    float2 size,
    float levels,
    float saturationBoost,
    float contrastBoost
) {
    // Boost saturation first
    float lum = dot(float3(color.rgb), float3(0.299, 0.587, 0.114));
    half3 saturated = mix(half3(lum), color.rgb, half(saturationBoost));
    
    // Boost contrast
    saturated = (saturated - half3(0.5)) * half(contrastBoost) + half3(0.5);
    saturated = clamp(saturated, half3(0.0), half3(1.0));
    
    // Posterize
    half3 posterized = floor(saturated * half(levels)) / half(levels - 1.0);
    
    return half4(posterized, color.a);
}

// =============================================================================
// COLOR EFFECT: HSL Posterize (posterize only lightness)
// =============================================================================
[[stitchable]] half4 posterizeLightness(
    float2 position,
    half4 color,
    float levels,
    float preserveColor
) {
    // Simple lightness approximation
    float lum = dot(float3(color.rgb), float3(0.299, 0.587, 0.114));
    
    // Posterize lightness
    float posterizedLum = floor(lum * levels) / (levels - 1.0);
    
    // Scale color to match new lightness
    float scale = (lum > 0.001) ? posterizedLum / lum : 1.0;
    
    // Mix between full posterize and lightness-only posterize
    half3 fullPosterize = floor(color.rgb * half(levels)) / half(levels - 1.0);
    half3 lumPosterize = color.rgb * half(scale);
    
    half3 result = mix(fullPosterize, lumPosterize, half(preserveColor));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Palette Map (posterize to specific colors)
// =============================================================================
[[stitchable]] half4 posterizePalette(
    float2 position,
    half4 color,
    half3 color1,
    half3 color2,
    half3 color3,
    half3 color4,
    float levels
) {
    // Get luminance
    float lum = dot(float3(color.rgb), float3(0.299, 0.587, 0.114));
    
    // Posterize luminance
    float posterizedLum = floor(lum * levels) / (levels - 1.0);
    
    // Map to palette
    half3 result;
    if (posterizedLum < 0.25) {
        result = mix(color1, color2, half(posterizedLum * 4.0));
    } else if (posterizedLum < 0.5) {
        result = mix(color2, color3, half((posterizedLum - 0.25) * 4.0));
    } else if (posterizedLum < 0.75) {
        result = mix(color3, color4, half((posterizedLum - 0.5) * 4.0));
    } else {
        result = color4;
    }
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Duotone Posterize
// =============================================================================
[[stitchable]] half4 posterizeDuotone(
    float2 position,
    half4 color,
    half3 darkColor,
    half3 lightColor,
    float levels
) {
    // Convert to grayscale
    float lum = dot(float3(color.rgb), float3(0.299, 0.587, 0.114));
    
    // Posterize
    float posterizedLum = floor(lum * levels) / (levels - 1.0);
    
    // Map to duotone
    half3 result = mix(darkColor, lightColor, half(posterizedLum));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Tritone Posterize
// =============================================================================
[[stitchable]] half4 posterizeTritone(
    float2 position,
    half4 color,
    half3 shadowColor,
    half3 midColor,
    half3 highlightColor,
    float levels
) {
    float lum = dot(float3(color.rgb), float3(0.299, 0.587, 0.114));
    float posterizedLum = floor(lum * levels) / (levels - 1.0);
    
    // Three-way blend
    half3 result;
    if (posterizedLum < 0.5) {
        result = mix(shadowColor, midColor, half(posterizedLum * 2.0));
    } else {
        result = mix(midColor, highlightColor, half((posterizedLum - 0.5) * 2.0));
    }
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Animated Posterize (changing levels)
// =============================================================================
[[stitchable]] half4 posterizeAnimated(
    float2 position,
    half4 color,
    float time,
    float minLevels,
    float maxLevels,
    float speed
) {
    // Animate between min and max levels
    float t = sin(time * speed) * 0.5 + 0.5;
    float levels = mix(minLevels, maxLevels, t);
    
    half3 posterized = floor(color.rgb * half(levels)) / half(levels - 1.0);
    
    return half4(posterized, color.a);
}

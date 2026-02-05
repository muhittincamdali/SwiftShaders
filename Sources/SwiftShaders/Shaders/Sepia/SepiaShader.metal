// Sepia & Vintage Color Effect Shader
// Creates classic sepia tone and vintage photography effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Sepia and vintage effects transform colors by:
// 1. Converting to grayscale using luminance
// 2. Applying sepia tone matrix transformation
// 3. Adjusting contrast and saturation
// 4. Adding optional grain and vignette
// =============================================================================

// Standard sepia matrix
constant float3x3 sepiaMatrix = float3x3(
    float3(0.393, 0.349, 0.272),
    float3(0.769, 0.686, 0.534),
    float3(0.189, 0.168, 0.131)
);

// Luminance weights
float getLuminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// Film grain generation
float filmGrain(float2 uv, float time, float intensity) {
    float noise = fract(sin(dot(uv + fract(time), float2(12.9898, 78.233))) * 43758.5453);
    return (noise - 0.5) * intensity;
}

// =============================================================================
// COLOR EFFECT: Classic Sepia
// =============================================================================
// Parameters:
// - intensity: Sepia strength (0.0-1.0, default: 1.0)
// =============================================================================
[[stitchable]] half4 sepia(
    float2 position,
    half4 color,
    float intensity
) {
    // Apply sepia matrix
    float3 sepiaColor;
    sepiaColor.r = dot(float3(color.rgb), sepiaMatrix[0]);
    sepiaColor.g = dot(float3(color.rgb), sepiaMatrix[1]);
    sepiaColor.b = dot(float3(color.rgb), sepiaMatrix[2]);
    
    // Mix with original based on intensity
    half3 result = mix(color.rgb, half3(sepiaColor), half(intensity));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Vintage Photo
// =============================================================================
[[stitchable]] half4 vintagePhoto(
    float2 position,
    half4 color,
    float2 size,
    float fadeAmount,
    float warmth,
    float contrast
) {
    float2 uv = position / size;
    
    // Apply sepia base
    float lum = getLuminance(color.rgb);
    half3 sepiaTone = half3(lum * 1.2, lum * 1.0, lum * 0.8);
    
    // Adjust warmth (more red/yellow)
    sepiaTone.r += half(warmth * 0.1);
    sepiaTone.g += half(warmth * 0.05);
    
    // Contrast adjustment
    sepiaTone = (sepiaTone - half3(0.5)) * half(contrast) + half3(0.5);
    
    // Fade effect (reduced contrast in shadows)
    sepiaTone = mix(sepiaTone, half3(lum * 0.5 + 0.25), half(fadeAmount * (1.0 - lum)));
    
    // Vignette
    float2 vigUV = uv * (1.0 - uv);
    float vig = vigUV.x * vigUV.y * 15.0;
    vig = clamp(pow(vig, 0.25), 0.0, 1.0);
    sepiaTone *= half(vig * 0.5 + 0.5);
    
    return half4(clamp(sepiaTone, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Aged Film
// =============================================================================
[[stitchable]] half4 agedFilm(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float grainIntensity,
    float scratchIntensity,
    float fadeAmount
) {
    float2 uv = position / size;
    
    // Base sepia
    float lum = getLuminance(color.rgb);
    half3 result = half3(lum * 1.1, lum * 0.95, lum * 0.75);
    
    // Film grain
    float grain = filmGrain(uv * 100.0, time, grainIntensity);
    result += half3(grain);
    
    // Random scratches
    float scratch = 0.0;
    float scratchX = fract(uv.x * 50.0 + time * 0.1);
    if (scratchX > 0.98 && fract(sin(floor(uv.x * 50.0)) * 43758.5453) > (1.0 - scratchIntensity)) {
        scratch = 0.3;
    }
    result += half3(scratch);
    
    // Dust specks
    float dust = step(0.997, fract(sin(dot(uv * 200.0 + time * 0.01, float2(12.9898, 78.233))) * 43758.5453));
    result = mix(result, half3(0.8), half(dust * 0.3));
    
    // Faded blacks
    result = max(result, half3(fadeAmount * 0.1));
    
    // Vignette (stronger for aged look)
    float2 vigUV = uv * (1.0 - uv);
    float vig = pow(vigUV.x * vigUV.y * 15.0, 0.5);
    result *= half(vig * 0.6 + 0.4);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Polaroid Style
// =============================================================================
[[stitchable]] half4 polaroid(
    float2 position,
    half4 color,
    float2 size,
    float exposure,
    float saturation
) {
    float2 uv = position / size;
    
    // Slight color cast (blue shadows, yellow highlights)
    float lum = getLuminance(color.rgb);
    
    half3 result = color.rgb;
    
    // Blue shadows
    if (lum < 0.5) {
        result.b += half((0.5 - lum) * 0.15);
    }
    
    // Yellow/warm highlights
    if (lum > 0.5) {
        result.r += half((lum - 0.5) * 0.1);
        result.g += half((lum - 0.5) * 0.05);
    }
    
    // Exposure adjustment
    result *= half(exposure);
    
    // Saturation adjustment
    result = mix(half3(lum), result, half(saturation));
    
    // Slight fade/lift blacks
    result = max(result, half3(0.03));
    
    // Reduced contrast in midtones
    result = pow(result, half3(0.95));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Cross Process
// =============================================================================
[[stitchable]] half4 crossProcess(
    float2 position,
    half4 color,
    float intensity
) {
    // Cross-processing shifts colors in opposite directions
    half3 result = color.rgb;
    
    // Boost greens in highlights
    result.g = pow(result.g, half(0.9));
    
    // Add cyan to shadows
    float lum = getLuminance(color.rgb);
    result.r -= half((1.0 - lum) * 0.1 * intensity);
    result.b += half((1.0 - lum) * 0.15 * intensity);
    
    // Add yellow to highlights
    result.r += half(lum * 0.1 * intensity);
    result.g += half(lum * 0.05 * intensity);
    
    // Boost contrast
    result = (result - half3(0.5)) * half(1.0 + intensity * 0.3) + half3(0.5);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// COLOR EFFECT: Faded Memory
// =============================================================================
[[stitchable]] half4 fadedMemory(
    float2 position,
    half4 color,
    float2 size,
    float fadeAmount,
    half3 tintColor
) {
    float2 uv = position / size;
    float lum = getLuminance(color.rgb);
    
    // Desaturate
    half3 result = mix(half3(lum), color.rgb, half(1.0 - fadeAmount * 0.5));
    
    // Apply color tint
    result = mix(result, tintColor * half(lum), half(fadeAmount * 0.3));
    
    // Lift blacks significantly
    result = max(result, half3(fadeAmount * 0.15));
    
    // Reduce highlights
    result = min(result, half3(1.0 - fadeAmount * 0.1));
    
    // Soft vignette
    float2 vigUV = uv * (1.0 - uv);
    float vig = pow(vigUV.x * vigUV.y * 15.0, 0.3);
    result *= half(vig * 0.4 + 0.6);
    
    return half4(result, color.a);
}

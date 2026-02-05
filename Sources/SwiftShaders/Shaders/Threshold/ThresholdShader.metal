// Threshold Effect Shader
// Creates binary and multi-level threshold effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Threshold effects convert images to binary/discrete levels:
// 1. Convert to luminance
// 2. Compare against threshold value
// 3. Output black or white (or other colors)
// 4. Optional dithering for smoother appearance
// =============================================================================

// Get luminance
float getLuminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// Bayer dithering matrix 4x4
constant float bayerMatrix[16] = {
    0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
   12.0/16.0,  4.0/16.0, 14.0/16.0,  6.0/16.0,
    3.0/16.0, 11.0/16.0,  1.0/16.0,  9.0/16.0,
   15.0/16.0,  7.0/16.0, 13.0/16.0,  5.0/16.0
};

// =============================================================================
// COLOR EFFECT: Basic Binary Threshold
// =============================================================================
// Parameters:
// - threshold: Cutoff point (0.0-1.0, default: 0.5)
// - lowColor: Color below threshold
// - highColor: Color above threshold
// =============================================================================
[[stitchable]] half4 threshold(
    float2 position,
    half4 color,
    float threshold,
    half3 lowColor,
    half3 highColor
) {
    float lum = getLuminance(color.rgb);
    half3 result = (lum > threshold) ? highColor : lowColor;
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Dithered Threshold (Bayer)
// =============================================================================
[[stitchable]] half4 thresholdDithered(
    float2 position,
    half4 color,
    float threshold,
    half3 lowColor,
    half3 highColor
) {
    float lum = getLuminance(color.rgb);
    
    // Get dither value from Bayer matrix
    int x = int(fmod(position.x, 4.0));
    int y = int(fmod(position.y, 4.0));
    float dither = bayerMatrix[y * 4 + x];
    
    // Apply dithered threshold
    float adjustedThreshold = threshold + (dither - 0.5) * 0.25;
    
    half3 result = (lum > adjustedThreshold) ? highColor : lowColor;
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Multi-Level Threshold
// =============================================================================
[[stitchable]] half4 thresholdMultiLevel(
    float2 position,
    half4 color,
    float levels,
    half3 tintColor
) {
    float lum = getLuminance(color.rgb);
    
    // Quantize to discrete levels
    float quantized = floor(lum * levels) / (levels - 1.0);
    
    // Apply tint
    half3 result = tintColor * half(quantized);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Color Threshold (per channel)
// =============================================================================
[[stitchable]] half4 thresholdColor(
    float2 position,
    half4 color,
    float thresholdR,
    float thresholdG,
    float thresholdB
) {
    half3 result;
    result.r = (color.r > half(thresholdR)) ? half(1.0) : half(0.0);
    result.g = (color.g > half(thresholdG)) ? half(1.0) : half(0.0);
    result.b = (color.b > half(thresholdB)) ? half(1.0) : half(0.0);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Smooth Threshold (with softness)
// =============================================================================
[[stitchable]] half4 thresholdSmooth(
    float2 position,
    half4 color,
    float threshold,
    float softness,
    half3 lowColor,
    half3 highColor
) {
    float lum = getLuminance(color.rgb);
    
    // Smooth transition
    float t = smoothstep(threshold - softness, threshold + softness, lum);
    
    half3 result = mix(lowColor, highColor, half(t));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Adaptive Threshold
// =============================================================================
[[stitchable]] half4 thresholdAdaptive(
    float2 position,
    half4 color,
    float2 size,
    float baseThreshold,
    float adaptAmount
) {
    float2 uv = position / size;
    
    // Spatially varying threshold
    float spatialVariation = sin(uv.x * 6.28318) * cos(uv.y * 6.28318);
    float adaptiveThreshold = baseThreshold + spatialVariation * adaptAmount;
    
    float lum = getLuminance(color.rgb);
    float result = (lum > adaptiveThreshold) ? 1.0 : 0.0;
    
    return half4(half3(result), color.a);
}

// =============================================================================
// COLOR EFFECT: Animated Threshold
// =============================================================================
[[stitchable]] half4 thresholdAnimated(
    float2 position,
    half4 color,
    float time,
    float speed,
    float amplitude,
    half3 lowColor,
    half3 highColor
) {
    float lum = getLuminance(color.rgb);
    
    // Animated threshold
    float animatedThreshold = 0.5 + sin(time * speed) * amplitude;
    
    half3 result = (lum > animatedThreshold) ? highColor : lowColor;
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Halftone (circular pattern threshold)
// =============================================================================
[[stitchable]] half4 thresholdHalftone(
    float2 position,
    half4 color,
    float2 size,
    float dotSize,
    float angle
) {
    float lum = getLuminance(color.rgb);
    
    // Rotate coordinates
    float c = cos(angle);
    float s = sin(angle);
    float2 rotated = float2(
        position.x * c - position.y * s,
        position.x * s + position.y * c
    );
    
    // Create dot pattern
    float2 cell = fmod(rotated, dotSize);
    float2 center = cell - dotSize * 0.5;
    float dist = length(center) / dotSize;
    
    // Dot size based on luminance
    float dotRadius = (1.0 - lum) * 0.5;
    float result = (dist < dotRadius) ? 0.0 : 1.0;
    
    return half4(half3(result), color.a);
}

// =============================================================================
// COLOR EFFECT: Edge Threshold
// =============================================================================
[[stitchable]] half4 thresholdEdge(
    float2 position,
    half4 color,
    float threshold,
    half3 edgeColor,
    half3 fillColor
) {
    // Use derivatives to detect edges
    float lum = getLuminance(color.rgb);
    float edge = fwidth(lum);
    
    // Threshold edges
    if (edge > threshold) {
        return half4(edgeColor, color.a);
    }
    
    return half4(fillColor, color.a);
}

// =============================================================================
// COLOR EFFECT: Noise Threshold
// =============================================================================
[[stitchable]] half4 thresholdNoise(
    float2 position,
    half4 color,
    float2 size,
    float threshold,
    float noiseAmount,
    half3 lowColor,
    half3 highColor
) {
    float2 uv = position / size;
    
    // Generate noise
    float noise = fract(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
    
    float lum = getLuminance(color.rgb);
    float noisyThreshold = threshold + (noise - 0.5) * noiseAmount;
    
    half3 result = (lum > noisyThreshold) ? highColor : lowColor;
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Triple Threshold
// =============================================================================
[[stitchable]] half4 thresholdTriple(
    float2 position,
    half4 color,
    float threshold1,
    float threshold2,
    half3 darkColor,
    half3 midColor,
    half3 lightColor
) {
    float lum = getLuminance(color.rgb);
    
    half3 result;
    if (lum < threshold1) {
        result = darkColor;
    } else if (lum < threshold2) {
        result = midColor;
    } else {
        result = lightColor;
    }
    
    return half4(result, color.a);
}

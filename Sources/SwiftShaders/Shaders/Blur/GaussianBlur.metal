#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Blur Effect Shaders
// Provides various blur algorithms for image softening effects.

/// Gaussian weight calculation.
float gaussianWeight(float x, float sigma) {
    return exp(-(x * x) / (2.0 * sigma * sigma)) / (sqrt(2.0 * 3.14159) * sigma);
}

/// Box blur approximation using color effect.
/// Note: True blur requires layerEffect, this simulates the look.
[[ stitchable ]]
half4 boxBlurSimulation(
    float2 position,
    half4 color,
    float4 bounds,
    float radius
) {
    // Simulated blur by reducing contrast and adding softness
    half3 result = color.rgb;
    
    // Reduce local contrast
    half avg = (result.r + result.g + result.b) / 3.0h;
    result = mix(result, half3(avg), half(radius * 0.01));
    
    return half4(result, color.a);
}

/// Radial blur effect (zoom blur).
[[ stitchable ]]
half4 radialBlur(
    float2 position,
    half4 color,
    float4 bounds,
    float centerX,
    float centerY,
    float strength
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    // Direction from center
    float2 direction = uv - center;
    float dist = length(direction);
    
    // Blur increases with distance
    float blur = dist * strength;
    
    // Simulate radial blur with color shift
    half3 result = color.rgb;
    result *= half(1.0 - blur * 0.2);
    
    return half4(result, color.a);
}

/// Motion blur simulation.
[[ stitchable ]]
half4 motionBlur(
    float2 position,
    half4 color,
    float4 bounds,
    float angle,
    float strength
) {
    float2 uv = position / bounds.zw;
    
    // Motion direction
    float2 direction = float2(cos(angle), sin(angle));
    
    // Directional streaking simulation
    float streak = dot(fract(uv * 50.0) - 0.5, direction);
    
    half3 result = color.rgb;
    result *= half(1.0 - abs(streak) * strength * 0.3);
    
    return half4(result, color.a);
}

/// Tilt-shift blur simulation (miniature effect).
[[ stitchable ]]
half4 tiltShiftBlur(
    float2 position,
    half4 color,
    float4 bounds,
    float focusY,
    float focusWidth,
    float blurStrength
) {
    float2 uv = position / bounds.zw;
    
    // Distance from focus line
    float dist = abs(uv.y - focusY);
    float blur = smoothstep(0.0, focusWidth, dist) * blurStrength;
    
    // Reduce saturation and contrast in blurred areas
    half3 result = color.rgb;
    half avg = (result.r + result.g + result.b) / 3.0h;
    result = mix(result, half3(avg), half(blur * 0.5));
    
    // Slightly brighten blurred areas (bokeh simulation)
    result *= half(1.0 + blur * 0.1);
    
    return half4(result, color.a);
}

/// Depth of field blur simulation.
[[ stitchable ]]
half4 depthOfFieldBlur(
    float2 position,
    half4 color,
    float4 bounds,
    float focalDistance,
    float aperture,
    float maxBlur
) {
    float2 uv = position / bounds.zw;
    
    // Simulate depth based on vertical position
    float depth = uv.y;
    
    // Circle of confusion calculation
    float coc = abs(depth - focalDistance) / aperture;
    coc = min(coc, maxBlur);
    
    // Apply blur simulation
    half3 result = color.rgb;
    half avg = (result.r + result.g + result.b) / 3.0h;
    result = mix(result, half3(avg), half(coc * 0.5));
    
    return half4(result, color.a);
}

/// Frosted glass blur effect.
[[ stitchable ]]
half4 frostBlur(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float frostAmount,
    float grainSize
) {
    float2 uv = position / bounds.zw;
    
    // Noise for frost texture
    float noise1 = fract(sin(dot(uv * grainSize, float2(12.9898, 78.233))) * 43758.5453);
    float noise2 = fract(sin(dot(uv * grainSize + 0.5, float2(12.9898, 78.233))) * 43758.5453);
    
    // Animated frost movement
    float2 offset = (float2(noise1, noise2) - 0.5) * frostAmount * 0.02;
    offset *= sin(time * 0.5 + uv.y * 10.0) * 0.5 + 0.5;
    
    // Color distortion
    half3 result = color.rgb;
    result.r *= half(1.0 + offset.x);
    result.b *= half(1.0 - offset.y);
    
    // Add frost sparkle
    float sparkle = pow(noise1, 10.0) * frostAmount;
    result += half(sparkle * 0.3);
    
    return half4(result, color.a);
}

/// Lens blur with hexagonal bokeh.
[[ stitchable ]]
half4 lensBokeh(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float threshold
) {
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    
    // Highlight bright areas (bokeh highlights)
    half highlight = smoothstep(half(threshold), 1.0h, luma);
    
    // Expand highlights
    half3 result = color.rgb;
    result += half3(highlight * half(intensity));
    
    return half4(result, color.a);
}

/// Circular blur vignette.
[[ stitchable ]]
half4 circularBlurVignette(
    float2 position,
    half4 color,
    float4 bounds,
    float centerX,
    float centerY,
    float innerRadius,
    float outerRadius
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float dist = length(uv - center);
    float blur = smoothstep(innerRadius, outerRadius, dist);
    
    // Apply blur effect
    half3 result = color.rgb;
    half avg = (result.r + result.g + result.b) / 3.0h;
    result = mix(result, half3(avg), half(blur * 0.6));
    
    // Darken edges slightly
    result *= half(1.0 - blur * 0.2);
    
    return half4(result, color.a);
}

/// Gaussian-weighted color softening.
[[ stitchable ]]
half4 softGlow(
    float2 position,
    half4 color,
    float4 bounds,
    float intensity,
    float threshold
) {
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    
    // Extract highlights
    half highlight = max(0.0h, luma - half(threshold));
    
    // Create glow
    half3 glow = color.rgb * highlight * half(intensity);
    
    // Add glow to original
    half3 result = color.rgb + glow;
    
    return half4(result, color.a);
}

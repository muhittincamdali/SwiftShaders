// Vignette Effect Shader
// Creates edge darkening and focus effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Vignette creates edge darkening by:
// 1. Calculating distance from center (or focus point)
// 2. Applying falloff curve (smoothstep/power)
// 3. Darkening or color-tinting outer areas
// 4. Optional oval/circular shape control
// =============================================================================

// =============================================================================
// COLOR EFFECT: Classic Circular Vignette
// =============================================================================
// Parameters:
// - size: View dimensions
// - radius: Inner radius of full brightness (0.0-1.0, default: 0.5)
// - softness: Falloff softness (0.0-1.0, default: 0.5)
// - intensity: Darkening amount (0.0-1.0, default: 0.5)
// =============================================================================
[[stitchable]] half4 vignette(
    float2 position,
    half4 color,
    float2 size,
    float radius,
    float softness,
    float intensity
) {
    // Normalize to center
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    // Calculate distance from center
    float dist = length(center);
    
    // Apply vignette falloff
    float vignette = smoothstep(radius, radius - softness, dist);
    
    // Mix between original and darkened
    half3 result = mix(color.rgb * half(1.0 - intensity), color.rgb, half(vignette));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Oval Vignette (aspect-ratio aware)
// =============================================================================
[[stitchable]] half4 vignetteOval(
    float2 position,
    half4 color,
    float2 size,
    float radiusX,
    float radiusY,
    float softness,
    float intensity
) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    // Scale by radii for oval shape
    float2 scaled = center / float2(radiusX, radiusY);
    float dist = length(scaled);
    
    float vignette = 1.0 - smoothstep(1.0 - softness, 1.0, dist);
    
    half3 result = color.rgb * half(mix(1.0 - intensity, 1.0, vignette));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Colored Vignette
// =============================================================================
[[stitchable]] half4 vignetteColored(
    float2 position,
    half4 color,
    float2 size,
    half3 vignetteColor,
    float radius,
    float softness,
    float intensity
) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    float dist = length(center);
    
    float vignette = smoothstep(radius, radius - softness, dist);
    
    // Blend with vignette color instead of just darkening
    half3 result = mix(vignetteColor, color.rgb, half(vignette * (1.0 - intensity) + intensity));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Radial Gradient Vignette
// =============================================================================
[[stitchable]] half4 vignetteGradient(
    float2 position,
    half4 color,
    float2 size,
    half3 innerColor,
    half3 outerColor,
    float radius,
    float softness
) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    float dist = length(center);
    
    // Gradient from inner to outer color
    float t = smoothstep(radius - softness, radius + softness, dist);
    half3 gradient = mix(innerColor, outerColor, half(t));
    
    // Multiply with original color
    half3 result = color.rgb * gradient;
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Focus Vignette (spotlight)
// =============================================================================
[[stitchable]] half4 vignetteFocus(
    float2 position,
    half4 color,
    float2 size,
    float2 focusPoint,
    float focusRadius,
    float falloff,
    float dimAmount
) {
    float2 uv = position / size;
    float2 toFocus = uv - focusPoint;
    float dist = length(toFocus);
    
    // Focus area is bright, surroundings are dimmed
    float focus = 1.0 - smoothstep(focusRadius, focusRadius + falloff, dist);
    
    // Dim outside focus
    half3 result = color.rgb * half(mix(1.0 - dimAmount, 1.0, focus));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Box Vignette (rectangular)
// =============================================================================
[[stitchable]] half4 vignetteBox(
    float2 position,
    half4 color,
    float2 size,
    float margin,
    float softness,
    float intensity
) {
    float2 uv = position / size;
    
    // Distance from edges
    float left = uv.x;
    float right = 1.0 - uv.x;
    float top = uv.y;
    float bottom = 1.0 - uv.y;
    
    // Minimum distance from any edge
    float edgeDist = min(min(left, right), min(top, bottom));
    
    // Vignette based on edge distance
    float vignette = smoothstep(0.0, margin * softness, edgeDist - margin * (1.0 - softness));
    
    half3 result = color.rgb * half(mix(1.0 - intensity, 1.0, vignette));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Animated Vignette (breathing)
// =============================================================================
[[stitchable]] half4 vignetteAnimated(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float baseRadius,
    float pulseAmount,
    float speed,
    float intensity
) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    float dist = length(center);
    
    // Animated radius
    float animatedRadius = baseRadius + sin(time * speed) * pulseAmount;
    
    float vignette = smoothstep(animatedRadius + 0.2, animatedRadius, dist);
    
    half3 result = color.rgb * half(mix(1.0 - intensity, 1.0, vignette));
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Film Border Vignette
// =============================================================================
[[stitchable]] half4 vignetteFilmBorder(
    float2 position,
    half4 color,
    float2 size,
    float borderWidth,
    float cornerRadius,
    float intensity
) {
    float2 uv = position / size;
    
    // Calculate distance from rounded rectangle
    float2 halfSize = float2(0.5 - borderWidth);
    float2 d = abs(uv - 0.5) - halfSize + cornerRadius;
    float dist = length(max(d, float2(0.0))) - cornerRadius;
    
    // Sharp border with slight softness
    float border = smoothstep(0.0, 0.02, -dist);
    
    half3 result = color.rgb * half(mix(1.0 - intensity, 1.0, border));
    
    return half4(result, color.a);
}

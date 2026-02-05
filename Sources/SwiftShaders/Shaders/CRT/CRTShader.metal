// CRT Monitor Effect Shader
// Simulates vintage CRT monitor with scanlines, curvature, and phosphor glow
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// This shader recreates the look of old CRT monitors by:
// 1. Applying barrel distortion for curved screen effect
// 2. Adding horizontal scanlines
// 3. Simulating RGB phosphor sub-pixels
// 4. Adding subtle vignette darkening at edges
// 5. Chromatic aberration for color fringing
// =============================================================================

// Barrel distortion function for curved screen effect
float2 barrelDistortion(float2 coord, float amount) {
    float2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * dist * amount;
}

// Generate scanline pattern
float scanline(float y, float resolution, float intensity) {
    return 1.0 - intensity * abs(sin(y * resolution * 3.14159));
}

// RGB phosphor pattern
half3 phosphorMask(float2 uv, float scale) {
    int px = int(uv.x * scale) % 3;
    if (px == 0) return half3(1.0, 0.2, 0.2);
    if (px == 1) return half3(0.2, 1.0, 0.2);
    return half3(0.2, 0.2, 1.0);
}

// =============================================================================
// COLOR EFFECT: CRT with scanlines and curvature
// =============================================================================
// Parameters:
// - size: View dimensions (width, height)
// - time: Animation time for flicker
// - curvature: Screen curve amount (0.0-0.5, default: 0.1)
// - scanlineIntensity: Scanline darkness (0.0-1.0, default: 0.3)
// - phosphorScale: Phosphor dot scale (default: 800.0)
// - vignetteIntensity: Edge darkening (0.0-1.0, default: 0.3)
// =============================================================================
[[stitchable]] half4 crtEffect(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float curvature,
    float scanlineIntensity,
    float phosphorScale,
    float vignetteIntensity
) {
    // Normalize coordinates
    float2 uv = position / size;
    
    // Apply barrel distortion for curved screen
    float2 distortedUV = barrelDistortion(uv, curvature);
    
    // Check if we're outside the screen after distortion
    if (distortedUV.x < 0.0 || distortedUV.x > 1.0 || 
        distortedUV.y < 0.0 || distortedUV.y > 1.0) {
        return half4(0.0, 0.0, 0.0, 1.0);
    }
    
    // Apply scanlines
    float scan = scanline(distortedUV.y, size.y * 0.5, scanlineIntensity);
    
    // Apply phosphor mask
    half3 phosphor = phosphorMask(distortedUV, phosphorScale);
    
    // Calculate vignette
    float2 vignetteUV = uv * (1.0 - uv.yx);
    float vignette = vignetteUV.x * vignetteUV.y * 15.0;
    vignette = pow(vignette, vignetteIntensity);
    
    // Add subtle flicker
    float flicker = 1.0 + 0.02 * sin(time * 10.0);
    
    // Combine effects
    half3 result = color.rgb;
    result *= half(scan);
    result *= phosphor;
    result *= half(vignette);
    result *= half(flicker);
    
    // Slight color bleeding
    result += color.rgb * 0.1;
    
    return half4(result, color.a);
}

// =============================================================================
// LAYER EFFECT: Full CRT with chromatic aberration
// =============================================================================
[[stitchable]] half4 crtLayerEffect(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float time,
    float curvature,
    float aberration
) {
    float2 uv = position / size;
    float2 distortedUV = barrelDistortion(uv, curvature);
    
    // Chromatic aberration offsets
    float2 rOffset = float2(aberration, 0.0) / size;
    float2 bOffset = float2(-aberration, 0.0) / size;
    
    // Sample with chromatic aberration
    half4 rSample = layer.sample(distortedUV * size + rOffset * size);
    half4 gSample = layer.sample(distortedUV * size);
    half4 bSample = layer.sample(distortedUV * size + bOffset * size);
    
    half3 result = half3(rSample.r, gSample.g, bSample.b);
    
    // Add scanlines
    float scan = scanline(distortedUV.y, size.y * 0.5, 0.25);
    result *= half(scan);
    
    return half4(result, gSample.a);
}

// =============================================================================
// SIMPLE CRT: Just scanlines and slight curve
// =============================================================================
[[stitchable]] half4 crtSimple(
    float2 position,
    half4 color,
    float2 size,
    float scanlineCount
) {
    float2 uv = position / size;
    
    // Simple scanline
    float scanline = sin(uv.y * scanlineCount * 3.14159) * 0.5 + 0.5;
    scanline = pow(scanline, 0.5);
    
    // Slight vignette
    float2 vig = uv * (1.0 - uv);
    float vignette = vig.x * vig.y * 20.0;
    vignette = clamp(vignette, 0.0, 1.0);
    
    half3 result = color.rgb * half(scanline * 0.3 + 0.7) * half(vignette);
    
    return half4(result, color.a);
}

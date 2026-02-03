#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Dissolve Transition Shader
// Creates various dissolve effects for view transitions.

/// Hash function for dissolve patterns.
float dissolveHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
}

/// Value noise for smooth dissolve.
float dissolveNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = dissolveHash(i);
    float b = dissolveHash(i + float2(1.0, 0.0));
    float c = dissolveHash(i + float2(0.0, 1.0));
    float d = dissolveHash(i + float2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

/// Basic noise dissolve effect.
/// Reveals/hides based on noise threshold.
[[ stitchable ]]
half4 dissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float scale,
    float edgeWidth
) {
    float2 uv = position / bounds.zw;
    
    // Generate noise pattern
    float noise = dissolveNoise(uv * scale);
    
    // Calculate dissolve threshold
    float threshold = progress;
    
    // Edge glow
    float edge = smoothstep(threshold - edgeWidth, threshold, noise) -
                 smoothstep(threshold, threshold + edgeWidth, noise);
    
    // Base visibility
    float visible = step(threshold, noise);
    
    if (visible < 0.5) {
        // Dissolved area
        return half4(0.0h, 0.0h, 0.0h, 0.0h);
    }
    
    // Add edge glow
    half3 edgeColor = half3(1.0h, 0.5h, 0.0h); // Orange glow
    return half4(mix(color.rgb, edgeColor, half(edge)), color.a);
}

/// Directional dissolve from edge.
[[ stitchable ]]
half4 directionalDissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float angle,
    float edgeWidth
) {
    float2 uv = position / bounds.zw;
    
    // Direction vector
    float2 dir = float2(cos(angle), sin(angle));
    
    // Project position onto direction
    float projected = dot(uv - 0.5, dir) + 0.5;
    
    // Add some noise for organic edge
    float noise = dissolveNoise(uv * 20.0) * 0.1;
    projected += noise;
    
    // Dissolve based on progress
    float threshold = progress;
    float edge = smoothstep(threshold - edgeWidth, threshold, projected) -
                 smoothstep(threshold, threshold + edgeWidth, projected);
    
    if (projected < threshold) {
        return half4(0.0h, 0.0h, 0.0h, 0.0h);
    }
    
    half3 edgeColor = half3(1.0h, 0.8h, 0.3h);
    return half4(mix(color.rgb, edgeColor, half(edge)), color.a);
}

/// Radial dissolve from center.
[[ stitchable ]]
half4 radialDissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float centerX,
    float centerY,
    float edgeWidth
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    // Distance from center
    float dist = length(uv - center) * 1.414; // Normalize to 0-1
    
    // Add noise for organic edge
    float noise = dissolveNoise(uv * 30.0) * 0.1;
    dist += noise;
    
    float threshold = progress;
    float edge = smoothstep(threshold - edgeWidth, threshold, dist) -
                 smoothstep(threshold, threshold + edgeWidth, dist);
    
    if (dist < threshold) {
        return half4(0.0h, 0.0h, 0.0h, 0.0h);
    }
    
    half3 edgeColor = half3(0.3h, 0.8h, 1.0h); // Blue glow
    return half4(mix(color.rgb, edgeColor, half(edge)), color.a);
}

/// Burn dissolve with fire-like edge.
[[ stitchable ]]
half4 burnDissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float scale,
    float burnWidth
) {
    float2 uv = position / bounds.zw;
    
    // Multi-octave noise for burn pattern
    float noise = 0.0;
    float amp = 0.5;
    float freq = scale;
    
    for (int i = 0; i < 4; i++) {
        noise += dissolveNoise(uv * freq) * amp;
        amp *= 0.5;
        freq *= 2.0;
    }
    
    float threshold = progress;
    
    // Multiple edge layers for fire effect
    float innerEdge = smoothstep(threshold - burnWidth * 0.3, threshold, noise);
    float midEdge = smoothstep(threshold - burnWidth * 0.6, threshold, noise);
    float outerEdge = smoothstep(threshold - burnWidth, threshold, noise);
    
    if (noise < threshold - burnWidth) {
        return half4(0.0h, 0.0h, 0.0h, 0.0h);
    }
    
    // Fire color gradient
    half3 innerColor = half3(1.0h, 1.0h, 0.3h); // Yellow
    half3 midColor = half3(1.0h, 0.5h, 0.0h);   // Orange
    half3 outerColor = half3(0.5h, 0.0h, 0.0h); // Red/dark
    
    half3 burnColor = mix(outerColor, midColor, half(outerEdge - midEdge));
    burnColor = mix(burnColor, innerColor, half(midEdge - innerEdge));
    
    float edgeStrength = 1.0 - innerEdge;
    return half4(mix(color.rgb, burnColor, half(edgeStrength * 2.0)), color.a);
}

/// Pixelated dissolve.
[[ stitchable ]]
half4 pixelDissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float pixelSize
) {
    float2 uv = position / bounds.zw;
    
    // Pixelate coordinates
    float2 pixelUV = floor(uv / pixelSize) * pixelSize;
    
    // Noise per pixel block
    float noise = dissolveHash(pixelUV * 100.0);
    
    if (noise < progress) {
        return half4(0.0h, 0.0h, 0.0h, 0.0h);
    }
    
    return color;
}

/// Particle scatter dissolve.
[[ stitchable ]]
half4 scatterDissolve(
    float2 position,
    half4 color,
    float4 bounds,
    float progress,
    float time,
    float particleSize
) {
    float2 uv = position / bounds.zw;
    
    // Grid for particles
    float2 grid = floor(uv / particleSize);
    float2 localUV = fract(uv / particleSize);
    
    // Random values per particle
    float randomPhase = dissolveHash(grid);
    float randomAngle = dissolveHash(grid + 100.0) * 6.28318;
    
    // Dissolve timing per particle
    float particleProgress = smoothstep(randomPhase - 0.1, randomPhase + 0.1, progress);
    
    if (particleProgress > 0.5) {
        // Particle is dissolving - animate scatter
        float scatter = particleProgress * 2.0;
        float2 velocity = float2(cos(randomAngle), sin(randomAngle)) * scatter * time;
        
        // Fade out
        half alpha = half(1.0 - scatter);
        return half4(color.rgb, color.a * alpha);
    }
    
    return color;
}

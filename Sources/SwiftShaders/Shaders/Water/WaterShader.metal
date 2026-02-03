#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Water Effect Shader
// Simulates water surfaces, reflections, and caustics.

/// Noise for water simulation.
float waterNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float n = i.x + i.y * 57.0;
    float a = fract(sin(n) * 43758.5453);
    float b = fract(sin(n + 1.0) * 43758.5453);
    float c = fract(sin(n + 57.0) * 43758.5453);
    float d = fract(sin(n + 58.0) * 43758.5453);
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

/// Water surface ripple distortion.
[[ stitchable ]]
float2 waterSurface(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float speed
) {
    float2 uv = position / bounds.zw;
    
    // Multiple overlapping waves
    float wave1 = sin(uv.x * frequency * 10.0 + time * speed) * 
                  cos(uv.y * frequency * 8.0 + time * speed * 0.8);
    float wave2 = sin(uv.x * frequency * 15.0 - time * speed * 1.2) * 
                  cos(uv.y * frequency * 12.0 - time * speed);
    float wave3 = waterNoise(uv * frequency * 5.0 + time * speed * 0.5);
    
    float combined = (wave1 + wave2 * 0.5 + wave3 * 0.3) * amplitude;
    
    float2 offset = float2(combined, combined) * bounds.zw * 0.02;
    
    return position + offset;
}

/// Water reflection effect.
[[ stitchable ]]
half4 waterReflection(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float reflectivity,
    float distortion
) {
    float2 uv = position / bounds.zw;
    
    // Reflection tint (sky blue)
    half3 reflectionColor = half3(0.4h, 0.6h, 0.9h);
    
    // Fresnel-like effect (more reflection at grazing angles)
    float fresnel = pow(1.0 - uv.y, 2.0) * reflectivity;
    
    // Ripple distortion for reflection
    float ripple = sin(uv.x * 30.0 + time * 3.0) * sin(uv.y * 25.0 + time * 2.5);
    ripple *= distortion * 0.1;
    
    // Blend reflection
    half3 result = mix(color.rgb, reflectionColor, half(fresnel + ripple));
    
    // Specular highlights
    float spec = pow(max(0.0, ripple + 0.5), 20.0);
    result += half3(spec * 0.5);
    
    return half4(result, color.a);
}

/// Underwater caustics effect.
[[ stitchable ]]
half4 caustics(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float intensity
) {
    float2 uv = position / bounds.zw;
    
    // Animated caustic pattern
    float2 p = uv * scale;
    
    // Multiple overlapping caustic layers
    float c1 = sin(p.x * 10.0 + time * 2.0) * sin(p.y * 10.0 + time * 1.8);
    float c2 = sin(p.x * 15.0 - time * 1.5) * sin(p.y * 12.0 + time * 2.2);
    float c3 = sin((p.x + p.y) * 8.0 + time * 1.2) * sin((p.x - p.y) * 9.0 - time * 1.7);
    
    float caustic = (c1 + c2 + c3) / 3.0;
    caustic = pow(abs(caustic), 0.5) * intensity;
    
    // Apply caustic light
    half3 causticColor = half3(0.6h, 0.8h, 1.0h);
    half3 result = color.rgb + causticColor * half(caustic);
    
    return half4(result, color.a);
}

/// Pool/calm water surface.
[[ stitchable ]]
half4 poolWater(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float clarity,
    float tileScale
) {
    float2 uv = position / bounds.zw;
    
    // Gentle waves
    float wave = sin(uv.x * 20.0 + time * 2.0) * sin(uv.y * 18.0 + time * 1.8) * 0.02;
    
    // Pool tile pattern (optional grid)
    float2 tile = fract(uv * tileScale);
    float grid = smoothstep(0.02, 0.0, tile.x) + smoothstep(0.98, 1.0, tile.x);
    grid += smoothstep(0.02, 0.0, tile.y) + smoothstep(0.98, 1.0, tile.y);
    grid = min(grid, 1.0);
    
    // Water tint
    half3 waterTint = half3(0.3h, 0.6h, 0.8h);
    half3 result = mix(color.rgb, waterTint, half(1.0 - clarity));
    
    // Add grid lines
    result = mix(result, half3(0.4h, 0.7h, 0.9h), half(grid * 0.3));
    
    // Surface shimmer
    result += half(wave);
    
    return half4(result, color.a);
}

/// Ocean wave effect.
[[ stitchable ]]
half4 oceanWaves(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float waveHeight,
    float waveLength,
    float foamThreshold
) {
    float2 uv = position / bounds.zw;
    
    // Gerstner-like wave approximation
    float wave1 = sin(uv.x * waveLength * 5.0 - time * 3.0);
    float wave2 = sin(uv.x * waveLength * 7.0 + uv.y * 2.0 - time * 2.5) * 0.5;
    float wave3 = sin(uv.x * waveLength * 3.0 - uv.y * 1.5 - time * 2.0) * 0.3;
    
    float totalWave = (wave1 + wave2 + wave3) * waveHeight;
    
    // Wave-based coloring
    half3 deepColor = half3(0.1h, 0.3h, 0.5h);
    half3 shallowColor = half3(0.2h, 0.5h, 0.7h);
    half3 waveColor = mix(deepColor, shallowColor, half(totalWave * 0.5 + 0.5));
    
    // Foam on wave crests
    float foam = smoothstep(foamThreshold, foamThreshold + 0.1, totalWave);
    foam *= waterNoise(uv * 50.0 + time * 2.0);
    waveColor = mix(waveColor, half3(1.0h), half(foam));
    
    half3 result = mix(color.rgb, waveColor, half(0.7));
    return half4(result, color.a);
}

/// Rain drops on surface.
[[ stitchable ]]
half4 rainDrops(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float dropDensity,
    float dropSize,
    float rippleSpeed
) {
    float2 uv = position / bounds.zw;
    
    half3 result = color.rgb;
    
    // Multiple drop layers
    for (int layer = 0; layer < 3; layer++) {
        float phase = float(layer) * 1.33;
        
        // Grid for drops
        float2 grid = floor(uv * dropDensity + phase);
        float2 localUV = fract(uv * dropDensity + phase);
        
        // Random drop timing
        float dropTime = fract(time * 0.5 + 
                              fract(sin(dot(grid, float2(12.9898, 78.233))) * 43758.5453));
        
        // Ripple animation
        float rippleRadius = dropTime * rippleSpeed;
        float dist = length(localUV - 0.5);
        
        // Expanding ring
        float ring = smoothstep(rippleRadius - 0.05, rippleRadius, dist) *
                     smoothstep(rippleRadius + 0.05, rippleRadius, dist);
        ring *= 1.0 - dropTime; // Fade out
        
        result += half3(ring * 0.2);
    }
    
    return half4(result, color.a);
}

/// Underwater view effect.
[[ stitchable ]]
half4 underwater(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float depth,
    float murkiness
) {
    float2 uv = position / bounds.zw;
    
    // Depth-based color absorption
    half3 waterAbsorption = half3(0.8h, 0.9h, 1.0h); // Red absorbed first
    half3 depthColor = pow(waterAbsorption, half(depth * 2.0));
    
    // Apply absorption
    half3 result = color.rgb * depthColor;
    
    // Add underwater tint
    half3 underwaterTint = half3(0.2h, 0.4h, 0.6h);
    result = mix(result, underwaterTint, half(murkiness * depth));
    
    // Light rays
    float rays = sin(uv.x * 20.0 + time) * sin(uv.y * 15.0 + time * 0.8);
    rays = pow(max(0.0, rays), 3.0) * (1.0 - uv.y);
    result += half3(0.1h, 0.2h, 0.3h) * half(rays);
    
    // Floating particles
    float particles = waterNoise(uv * 100.0 + time * 0.5);
    particles = step(0.97, particles);
    result += half(particles * 0.3);
    
    return half4(result, color.a);
}

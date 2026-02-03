#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Noise Generation Shader
// Provides various noise algorithms for procedural effects.

/// Hash function for pseudo-random generation.
float noiseHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
}

/// Hash function for 3D input.
float noiseHash3(float3 p) {
    return fract(sin(dot(p, float3(127.1, 311.7, 74.7))) * 43758.5453123);
}

/// 2D value noise.
float valueNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    
    // Smooth interpolation
    float2 u = f * f * (3.0 - 2.0 * f);
    
    // Four corners
    float a = noiseHash(i);
    float b = noiseHash(i + float2(1.0, 0.0));
    float c = noiseHash(i + float2(0.0, 1.0));
    float d = noiseHash(i + float2(1.0, 1.0));
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

/// 2D gradient noise (Perlin-like).
float2 gradientNoise2D(float2 p) {
    float2 i = floor(p);
    float angle = noiseHash(i) * 6.28318;
    return float2(cos(angle), sin(angle));
}

float perlinNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    
    float2 u = f * f * (3.0 - 2.0 * f);
    
    float2 ga = gradientNoise2D(i);
    float2 gb = gradientNoise2D(i + float2(1.0, 0.0));
    float2 gc = gradientNoise2D(i + float2(0.0, 1.0));
    float2 gd = gradientNoise2D(i + float2(1.0, 1.0));
    
    float va = dot(ga, f);
    float vb = dot(gb, f - float2(1.0, 0.0));
    float vc = dot(gc, f - float2(0.0, 1.0));
    float vd = dot(gd, f - float2(1.0, 1.0));
    
    return mix(mix(va, vb, u.x), mix(vc, vd, u.x), u.y) * 0.5 + 0.5;
}

/// Fractal Brownian Motion noise.
float fbm(float2 p, int octaves, float lacunarity, float gain) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        value += amplitude * valueNoise(p * frequency);
        amplitude *= gain;
        frequency *= lacunarity;
    }
    
    return value;
}

/// Basic noise overlay effect.
[[ stitchable ]]
half4 noise(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float scale
) {
    float2 uv = position / bounds.zw;
    
    // Animated noise
    float n = valueNoise(uv * scale * 100.0 + time * 10.0);
    
    // Mix with original color
    half noiseValue = half((n - 0.5) * intensity);
    return half4(color.rgb + noiseValue, color.a);
}

/// Film grain effect.
[[ stitchable ]]
half4 filmGrain(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float size
) {
    float2 uv = position / bounds.zw;
    
    // Animated grain
    float grain = noiseHash(uv * size + fract(time * 100.0));
    grain = (grain - 0.5) * intensity;
    
    // Luminance-based grain (more visible in midtones)
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half grainStrength = half(1.0 - abs(float(luma) - 0.5) * 2.0);
    
    half4 result = color;
    result.rgb += half(grain) * grainStrength;
    
    return result;
}

/// Perlin noise distortion.
[[ stitchable ]]
float2 perlinDistort(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float scale
) {
    float2 uv = position / bounds.zw;
    
    float noiseX = perlinNoise(uv * scale + float2(time * 0.5, 0.0));
    float noiseY = perlinNoise(uv * scale + float2(0.0, time * 0.5));
    
    float2 offset = (float2(noiseX, noiseY) - 0.5) * intensity * bounds.zw * 0.1;
    
    return position + offset;
}

/// FBM noise pattern.
[[ stitchable ]]
half4 fbmNoise(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float octaves,
    float lacunarity,
    float gain
) {
    float2 uv = position / bounds.zw;
    
    float n = fbm(uv * scale + time * 0.1, int(octaves), lacunarity, gain);
    
    // Apply as brightness modulation
    half4 result = color;
    result.rgb *= half(0.5 + n);
    
    return result;
}

/// Simplex-like noise color effect.
[[ stitchable ]]
half4 simplexColor(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float colorMix
) {
    float2 uv = position / bounds.zw;
    
    // Three-channel noise for RGB variation
    float r = perlinNoise((uv + float2(time * 0.1, 0.0)) * scale);
    float g = perlinNoise((uv + float2(0.0, time * 0.1)) * scale + 100.0);
    float b = perlinNoise((uv + float2(time * 0.05, time * 0.05)) * scale + 200.0);
    
    half3 noiseColor = half3(r, g, b);
    
    half4 result;
    result.rgb = mix(color.rgb, noiseColor, half(colorMix));
    result.a = color.a;
    
    return result;
}

/// Voronoi/cellular noise.
[[ stitchable ]]
half4 voronoiNoise(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float intensity
) {
    float2 uv = position / bounds.zw * scale;
    
    float2 cellUV = fract(uv);
    float2 cellID = floor(uv);
    
    float minDist = 1.0;
    
    // Check neighboring cells
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(x, y);
            float2 point = noiseHash(cellID + neighbor + time * 0.1) * 0.5 + 0.25;
            float dist = length(cellUV - neighbor - point);
            minDist = min(minDist, dist);
        }
    }
    
    half4 result = color;
    result.rgb *= half(1.0 - minDist * intensity);
    
    return result;
}

/// Turbulence noise distortion.
[[ stitchable ]]
float2 turbulence(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float scale,
    float octaves
) {
    float2 uv = position / bounds.zw;
    
    float2 offset = float2(0.0);
    float amp = 1.0;
    float freq = scale;
    
    for (int i = 0; i < int(octaves); i++) {
        float nx = valueNoise(uv * freq + float2(time, 0.0));
        float ny = valueNoise(uv * freq + float2(0.0, time) + 100.0);
        offset += (float2(nx, ny) - 0.5) * amp;
        amp *= 0.5;
        freq *= 2.0;
    }
    
    return position + offset * intensity * bounds.zw * 0.1;
}

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Glitch Effect Shader
// Creates digital glitch artifacts including scan lines, color shifts,
// block displacement, and signal noise.

/// Pseudo-random hash function.
float glitchHash(float n) {
    return fract(sin(n) * 43758.5453123);
}

/// 2D noise function for glitch patterns.
float glitchNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float n = i.x + i.y * 57.0;
    return mix(
        mix(glitchHash(n), glitchHash(n + 1.0), f.x),
        mix(glitchHash(n + 57.0), glitchHash(n + 58.0), f.x),
        f.y
    );
}

/// Basic glitch distortion effect.
/// Creates horizontal line displacement and color aberration.
[[ stitchable ]]
float2 glitch(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float blockSize
) {
    float2 uv = position / bounds.zw;
    
    // Block-based displacement
    float block = floor(uv.y / blockSize);
    float noise = glitchHash(block + floor(time * 10.0));
    
    // Only glitch some blocks randomly
    if (noise > intensity) {
        return position;
    }
    
    // Calculate displacement
    float displacement = (glitchHash(block * time) - 0.5) * intensity * bounds.z * 0.2;
    
    return float2(position.x + displacement, position.y);
}

/// Color glitch effect with RGB channel separation.
[[ stitchable ]]
half4 glitchColor(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity
) {
    float2 uv = position / bounds.zw;
    
    // Time-based noise
    float noise = glitchNoise(float2(uv.y * 50.0, time * 5.0));
    
    // Randomly shift color channels
    if (noise > 1.0 - intensity * 0.5) {
        // Color channel swap/shift
        return half4(color.b, color.r, color.g, color.a);
    }
    
    // Add scan line effect
    float scanline = sin(uv.y * bounds.w * 2.0 + time * 10.0) * 0.5 + 0.5;
    if (noise > 1.0 - intensity && scanline > 0.8) {
        return half4(1.0h - color.rgb, color.a);
    }
    
    return color;
}

/// VHS-style glitch effect.
[[ stitchable ]]
half4 vhsGlitch(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float noiseAmount
) {
    float2 uv = position / bounds.zw;
    
    // Horizontal jitter
    float jitter = (glitchNoise(float2(time * 100.0, uv.y * 100.0)) - 0.5) * intensity * 0.1;
    
    // VHS tracking lines
    float tracking = step(0.99, glitchNoise(float2(uv.y * 10.0, floor(time * 5.0))));
    
    // Color bleeding
    half4 result = color;
    result.r = color.r * half(1.0 + jitter);
    result.b = color.b * half(1.0 - jitter);
    
    // Add noise
    float noise = glitchNoise(uv * 500.0 + time * 100.0);
    result.rgb += half3(noise * noiseAmount);
    
    // Tracking line effect
    if (tracking > 0.5) {
        result.rgb = mix(result.rgb, half3(1.0), half(0.5 * intensity));
    }
    
    return result;
}

/// Digital corruption glitch.
[[ stitchable ]]
half4 digitalCorruption(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float blockWidth,
    float blockHeight
) {
    float2 uv = position / bounds.zw;
    
    // Grid-based corruption
    float2 block = floor(uv * float2(1.0/blockWidth, 1.0/blockHeight));
    float blockNoise = glitchHash(dot(block, float2(12.9898, 78.233)) + floor(time * 8.0));
    
    half4 result = color;
    
    // Random block effects
    if (blockNoise < intensity * 0.2) {
        // Invert block
        result.rgb = 1.0h - result.rgb;
    } else if (blockNoise < intensity * 0.4) {
        // Shift hue
        result.rgb = result.gbr;
    } else if (blockNoise < intensity * 0.6) {
        // Increase contrast
        result.rgb = (result.rgb - 0.5h) * 2.0h + 0.5h;
    } else if (blockNoise < intensity * 0.8) {
        // Desaturate
        half luma = dot(result.rgb, half3(0.299h, 0.587h, 0.114h));
        result.rgb = half3(luma);
    }
    
    return result;
}

/// Scan line glitch with distortion.
[[ stitchable ]]
float2 scanlineGlitch(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float lineHeight
) {
    float2 uv = position / bounds.zw;
    
    // Animated scan lines
    float scanY = floor(uv.y / lineHeight);
    float scanPhase = glitchHash(scanY + floor(time * 15.0));
    
    if (scanPhase > 1.0 - intensity * 0.3) {
        // Horizontal shift
        float shift = (glitchHash(scanY * time) - 0.5) * intensity * bounds.z * 0.15;
        return float2(position.x + shift, position.y);
    }
    
    return position;
}

/// Signal interference effect.
[[ stitchable ]]
half4 signalInterference(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float frequency
) {
    float2 uv = position / bounds.zw;
    
    // Wave interference pattern
    float wave1 = sin(uv.y * frequency * 100.0 + time * 10.0);
    float wave2 = sin(uv.y * frequency * 150.0 - time * 8.0);
    float interference = (wave1 + wave2) * 0.5;
    
    // Apply as color modulation
    half4 result = color;
    result.rgb += half3(interference * intensity * 0.2);
    
    // Rolling bar effect
    float bar = smoothstep(0.0, 0.1, fract(uv.y - time * 0.2));
    bar *= smoothstep(1.0, 0.9, fract(uv.y - time * 0.2));
    result.rgb *= half(1.0 - bar * intensity * 0.3);
    
    return result;
}

/// Pixelated glitch blocks.
[[ stitchable ]]
half4 pixelGlitch(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float pixelSize
) {
    float2 uv = position / bounds.zw;
    float2 pixelUV = floor(uv / pixelSize) * pixelSize;
    
    float noise = glitchHash(dot(pixelUV, float2(12.9898, 78.233)) + floor(time * 20.0));
    
    half4 result = color;
    
    if (noise < intensity * 0.3) {
        // Solid color block
        result.rgb = half3(glitchHash(noise), glitchHash(noise * 2.0), glitchHash(noise * 3.0));
    } else if (noise < intensity * 0.5) {
        // Brightness shift
        result.rgb *= half(1.5 + noise);
    }
    
    return result;
}

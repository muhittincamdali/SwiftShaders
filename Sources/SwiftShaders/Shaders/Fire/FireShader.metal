#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Fire Effect Shader
// Procedural fire generation using noise and color mapping.

/// Noise function for fire turbulence.
float fireNoise(float2 p) {
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

/// Fractal noise for realistic flames.
float fireFBM(float2 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        value += fireNoise(p * frequency) * amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value;
}

/// Basic fire effect overlay.
[[ stitchable ]]
half4 fire(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float scale,
    float speed
) {
    float2 uv = position / bounds.zw;
    
    // Upward motion
    float2 q = uv * scale;
    q.y -= time * speed;
    
    // Turbulence
    float noise = fireFBM(q, 6);
    
    // Shape fire (narrower at top)
    float shape = 1.0 - uv.y;
    shape = pow(shape, 0.5);
    
    // Horizontal falloff
    float horizontal = 1.0 - abs(uv.x - 0.5) * 2.0;
    horizontal = pow(horizontal, 0.5);
    
    // Combine
    float fireIntensity = noise * shape * horizontal * intensity;
    fireIntensity = clamp(fireIntensity, 0.0, 1.0);
    
    // Fire color gradient
    half3 fireColor;
    if (fireIntensity > 0.8) {
        fireColor = half3(1.0h, 1.0h, 0.8h); // White/yellow core
    } else if (fireIntensity > 0.5) {
        fireColor = half3(1.0h, 0.7h, 0.0h); // Orange
    } else if (fireIntensity > 0.2) {
        fireColor = half3(1.0h, 0.3h, 0.0h); // Red-orange
    } else {
        fireColor = half3(0.5h, 0.0h, 0.0h); // Dark red
    }
    
    // Blend with original
    half3 result = mix(color.rgb, fireColor, half(fireIntensity));
    
    return half4(result, color.a);
}

/// Campfire/torch flame effect.
[[ stitchable ]]
half4 torchFlame(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float flameHeight,
    float flameWidth,
    float flickerSpeed
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(0.5, 1.0); // Flame base at bottom center
    
    // Distance from flame base
    float2 delta = uv - center;
    delta.x /= flameWidth;
    delta.y /= flameHeight;
    
    // Animated distortion
    float noise1 = fireNoise(float2(uv.x * 8.0, time * flickerSpeed));
    float noise2 = fireNoise(float2(uv.x * 12.0 + 100.0, time * flickerSpeed * 1.3));
    
    delta.x += (noise1 - 0.5) * 0.3 * (1.0 - uv.y);
    
    // Flame shape
    float dist = length(delta);
    float flame = 1.0 - smoothstep(0.0, 0.5, dist);
    
    // Vertical gradient
    flame *= 1.0 - uv.y;
    
    // Flicker
    flame *= 0.8 + noise2 * 0.4;
    
    // Color based on intensity
    half3 flameColor = mix(
        half3(1.0h, 0.2h, 0.0h),
        half3(1.0h, 0.9h, 0.3h),
        half(flame)
    );
    
    half3 result = mix(color.rgb, flameColor, half(flame));
    return half4(result, color.a);
}

/// Explosion fireball effect.
[[ stitchable ]]
half4 fireball(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float centerX,
    float centerY,
    float radius,
    float turbulence
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float dist = length(delta);
    float angle = atan2(delta.y, delta.x);
    
    // Radial noise
    float noise = fireFBM(float2(angle * 3.0, time * 2.0 + dist * 5.0), 4);
    
    // Expanding radius with noise
    float noisyRadius = radius * (1.0 + (noise - 0.5) * turbulence);
    
    if (dist > noisyRadius) {
        return color;
    }
    
    float intensity = 1.0 - dist / noisyRadius;
    intensity = pow(intensity, 1.5);
    
    // Fireball color
    half3 fireColor;
    if (intensity > 0.7) {
        fireColor = half3(1.0h, 1.0h, 0.6h);
    } else if (intensity > 0.4) {
        fireColor = half3(1.0h, 0.5h, 0.0h);
    } else {
        fireColor = half3(0.8h, 0.2h, 0.0h);
    }
    
    half3 result = mix(color.rgb, fireColor, half(intensity));
    return half4(result, color.a);
}

/// Ember particles effect.
[[ stitchable ]]
half4 embers(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float density,
    float speed,
    float size
) {
    float2 uv = position / bounds.zw;
    
    half3 result = color.rgb;
    
    // Multiple ember layers
    for (int i = 0; i < 5; i++) {
        float phase = float(i) * 1.618; // Golden ratio for variety
        
        // Grid for embers
        float2 grid = floor(uv * density + float2(phase, 0.0));
        float2 localUV = fract(uv * density + float2(phase, 0.0));
        
        // Random position within cell
        float rx = fract(sin(grid.x * 127.1 + grid.y * 311.7) * 43758.5453);
        float ry = fract(sin(grid.x * 269.5 + grid.y * 183.3) * 43758.5453);
        
        // Animated Y position (rising)
        float animY = fract(ry - time * speed * (0.5 + rx * 0.5));
        
        // Ember position
        float2 emberPos = float2(rx, animY);
        float dist = length(localUV - emberPos);
        
        // Ember glow
        if (dist < size) {
            float glow = 1.0 - dist / size;
            glow *= glow;
            
            // Flickering
            float flicker = 0.5 + 0.5 * sin(time * 10.0 + phase * 100.0);
            glow *= flicker;
            
            half3 emberColor = half3(1.0h, 0.5h * half(ry), 0.0h);
            result += emberColor * half(glow * 0.5);
        }
    }
    
    return half4(result, color.a);
}

/// Lava/magma flow effect.
[[ stitchable ]]
half4 lava(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float flowSpeed,
    float coolAmount
) {
    float2 uv = position / bounds.zw;
    
    // Flowing coordinates
    float2 q = uv * scale;
    q.x += time * flowSpeed * 0.5;
    q.y += sin(q.x * 2.0 + time) * 0.1;
    
    // Lava pattern
    float noise1 = fireFBM(q, 6);
    float noise2 = fireFBM(q * 2.0 + 100.0, 4);
    
    float lavaPattern = noise1 * 0.7 + noise2 * 0.3;
    
    // Cool cracks
    float cracks = smoothstep(0.4, 0.5, lavaPattern);
    
    // Hot lava color
    half3 hotColor = mix(
        half3(1.0h, 0.3h, 0.0h),
        half3(1.0h, 0.8h, 0.0h),
        half(lavaPattern)
    );
    
    // Cooled rock color
    half3 coolColor = half3(0.15h, 0.1h, 0.1h);
    
    half3 lavaColor = mix(hotColor, coolColor, half(cracks * coolAmount));
    
    half3 result = mix(color.rgb, lavaColor, half(0.8));
    return half4(result, color.a);
}

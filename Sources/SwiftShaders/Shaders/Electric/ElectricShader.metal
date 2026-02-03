#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Electric Effect Shader
// Creates lightning, plasma, and electrical discharge effects.

/// Hash function for electric noise.
float electricHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

/// Noise for electric patterns.
float electricNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = electricHash(i);
    float b = electricHash(i + float2(1.0, 0.0));
    float c = electricHash(i + float2(0.0, 1.0));
    float d = electricHash(i + float2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

/// Lightning bolt effect.
[[ stitchable ]]
half4 lightning(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float intensity,
    float branchiness,
    float glowRadius
) {
    float2 uv = position / bounds.zw;
    
    half3 result = color.rgb;
    half3 lightningColor = half3(0.7h, 0.8h, 1.0h);
    
    // Main bolt path
    float boltX = 0.5;
    float accumulator = 0.0;
    
    // Zigzag down the screen
    for (float y = 0.0; y < 1.0; y += 0.02) {
        // Random displacement at each step
        float noise = electricHash(float2(y * 100.0, floor(time * 10.0)));
        boltX += (noise - 0.5) * branchiness * 0.1;
        boltX = clamp(boltX, 0.1, 0.9);
        
        // Distance to bolt at this Y level
        if (abs(uv.y - y) < 0.02) {
            float dist = abs(uv.x - boltX);
            float bolt = exp(-dist * 50.0 / glowRadius);
            accumulator += bolt;
        }
    }
    
    // Apply lightning
    accumulator *= intensity;
    result += lightningColor * half(accumulator);
    
    // Occasional flash
    float flash = step(0.98, electricHash(float2(floor(time * 3.0), 0.0)));
    result += half3(flash * intensity * 0.3);
    
    return half4(result, color.a);
}

/// Plasma ball effect.
[[ stitchable ]]
half4 plasma(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float colorSpeed
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(0.5);
    
    // Multiple plasma wave functions
    float v1 = sin(uv.x * scale * 10.0 + time);
    float v2 = sin(uv.y * scale * 10.0 + time);
    float v3 = sin((uv.x + uv.y) * scale * 10.0 + time);
    float v4 = sin(length(uv - center) * scale * 20.0 - time * 2.0);
    
    float plasma = (v1 + v2 + v3 + v4) / 4.0;
    
    // Color mapping
    half3 plasmaColor;
    plasmaColor.r = half(sin(plasma * 3.14159 + time * colorSpeed) * 0.5 + 0.5);
    plasmaColor.g = half(sin(plasma * 3.14159 + time * colorSpeed + 2.094) * 0.5 + 0.5);
    plasmaColor.b = half(sin(plasma * 3.14159 + time * colorSpeed + 4.188) * 0.5 + 0.5);
    
    // Intensity based on original luminance
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 result = mix(color.rgb, plasmaColor, luma);
    
    return half4(result, color.a);
}

/// Electric arc between two points.
[[ stitchable ]]
half4 electricArc(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float startX,
    float startY,
    float endX,
    float endY,
    float thickness
) {
    float2 uv = position / bounds.zw;
    float2 start = float2(startX, startY);
    float2 end = float2(endX, endY);
    
    // Line from start to end
    float2 line = end - start;
    float lineLength = length(line);
    float2 lineDir = line / lineLength;
    
    // Project point onto line
    float2 toPoint = uv - start;
    float t = clamp(dot(toPoint, lineDir) / lineLength, 0.0, 1.0);
    
    // Point on line
    float2 closestPoint = start + lineDir * t * lineLength;
    
    // Add jagged displacement
    float noise = electricNoise(float2(t * 20.0 + time * 10.0, floor(time * 15.0)));
    float2 displacement = float2(lineDir.y, -lineDir.x) * (noise - 0.5) * 0.1;
    closestPoint += displacement;
    
    // Distance to arc
    float dist = length(uv - closestPoint);
    float arc = exp(-dist / thickness * 10.0);
    
    // Arc color
    half3 arcColor = half3(0.6h, 0.8h, 1.0h);
    half3 coreColor = half3(1.0h, 1.0h, 1.0h);
    
    half3 result = color.rgb;
    result = mix(result, arcColor, half(arc * 0.8));
    result = mix(result, coreColor, half(pow(arc, 4.0)));
    
    return half4(result, color.a);
}

/// Static electricity/spark effect.
[[ stitchable ]]
half4 staticElectricity(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float density,
    float sparkSize
) {
    float2 uv = position / bounds.zw;
    
    half3 result = color.rgb;
    
    // Multiple spark layers
    for (int i = 0; i < 3; i++) {
        float phase = float(i) * 1.33;
        
        // Grid for sparks
        float2 grid = floor(uv * density + phase);
        float2 localUV = fract(uv * density + phase);
        
        // Random spark position
        float rx = electricHash(grid);
        float ry = electricHash(grid + 100.0);
        float sparkTime = electricHash(grid + 200.0);
        
        // Spark timing
        float spark = step(0.95, sin(time * 10.0 + sparkTime * 100.0));
        
        if (spark > 0.5) {
            float2 sparkPos = float2(rx, ry);
            float dist = length(localUV - sparkPos);
            float glow = exp(-dist / sparkSize * 10.0);
            
            half3 sparkColor = half3(0.8h, 0.9h, 1.0h);
            result += sparkColor * half(glow * 0.5);
        }
    }
    
    return half4(result, color.a);
}

/// Electric field/force lines.
[[ stitchable ]]
half4 electricField(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float lineCount,
    float flowSpeed
) {
    float2 uv = position / bounds.zw;
    
    // Field lines
    float field = 0.0;
    
    // Multiple charge points
    for (int i = 0; i < 3; i++) {
        float phase = float(i) / 3.0;
        float2 charge = float2(
            0.3 + 0.4 * sin(time * 0.5 + phase * 6.28),
            0.3 + 0.4 * cos(time * 0.7 + phase * 6.28)
        );
        
        float2 delta = uv - charge;
        float angle = atan2(delta.y, delta.x);
        float dist = length(delta);
        
        // Radial lines
        float lines = sin(angle * lineCount + time * flowSpeed);
        lines *= exp(-dist * 3.0);
        
        field += lines;
    }
    
    field = abs(field);
    
    half3 fieldColor = half3(0.3h, 0.5h, 1.0h);
    half3 result = mix(color.rgb, fieldColor, half(field * 0.5));
    
    return half4(result, color.a);
}

/// Neon glow electric effect.
[[ stitchable ]]
half4 neonElectric(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float glowIntensity,
    float flickerSpeed
) {
    float2 uv = position / bounds.zw;
    
    // Edge detection approximation
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    
    // Neon glow on edges
    half edge = fwidth(luma) * 10.0;
    
    // Flicker
    float flicker = 0.7 + 0.3 * sin(time * flickerSpeed * 10.0);
    flicker *= 0.8 + 0.2 * electricHash(float2(floor(time * 20.0), 0.0));
    
    // Neon color
    half3 neonColor = half3(0.2h, 0.6h, 1.0h);
    
    half3 result = color.rgb;
    result += neonColor * edge * half(glowIntensity * flicker);
    
    return half4(result, color.a);
}

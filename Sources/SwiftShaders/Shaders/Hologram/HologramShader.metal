#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Hologram Effect Shader
// Creates futuristic holographic display effects.

/// Hash function for hologram noise.
float holoHash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
}

/// Basic hologram effect with scan lines and color shift.
[[ stitchable ]]
half4 hologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scanlineIntensity,
    float flickerSpeed,
    float colorShift
) {
    float2 uv = position / bounds.zw;
    
    // Base color conversion to holographic blue/cyan
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 holoColor = half3(0.2h, 0.8h, 1.0h) * luma;
    
    // Scan lines
    float scanline = sin(uv.y * bounds.w * 2.0 + time * 5.0) * 0.5 + 0.5;
    scanline = pow(scanline, 4.0) * scanlineIntensity;
    
    // Horizontal interference lines
    float interference = sin(uv.y * bounds.w * 0.5 - time * 20.0);
    interference = step(0.98, interference) * 0.5;
    
    // Flicker effect
    float flicker = sin(time * flickerSpeed * 10.0) * 0.5 + 0.5;
    flicker = 0.8 + flicker * 0.2;
    
    // Color shift/aberration
    half3 shifted = half3(
        holoColor.r * half(1.0 + sin(time * 3.0) * colorShift),
        holoColor.g,
        holoColor.b * half(1.0 - sin(time * 3.0) * colorShift)
    );
    
    // Combine effects
    half3 result = shifted * half(flicker);
    result += half(scanline + interference);
    
    // Edge glow based on original alpha
    half edgeGlow = color.a * 0.3h;
    result += half3(0.0h, edgeGlow, edgeGlow * 1.5h);
    
    return half4(result, color.a * half(flicker));
}

/// Glitchy hologram with artifacts.
[[ stitchable ]]
half4 glitchyHologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float glitchIntensity,
    float noiseAmount
) {
    float2 uv = position / bounds.zw;
    
    // Base holographic color
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 holoColor = half3(0.1h, 0.7h, 1.0h) * luma;
    
    // Random glitch blocks
    float blockY = floor(uv.y * 20.0);
    float glitchNoise = holoHash(float2(blockY, floor(time * 10.0)));
    
    if (glitchNoise < glitchIntensity * 0.3) {
        // Horizontal offset glitch
        float offset = (holoHash(float2(blockY, time)) - 0.5) * 0.1;
        uv.x += offset;
    }
    
    // Noise overlay
    float noise = holoHash(uv * 500.0 + time * 100.0);
    
    // Scan lines
    float scan = sin(uv.y * bounds.w * 1.5) * 0.5 + 0.5;
    scan = pow(scan, 3.0);
    
    // Color corruption
    if (glitchNoise < glitchIntensity * 0.1) {
        holoColor = holoColor.gbr; // Channel swap
    }
    
    half3 result = holoColor;
    result += half(scan * 0.3);
    result += half(noise * noiseAmount);
    
    // Random brightness drops
    float dropout = step(0.95, holoHash(float2(uv.y * 10.0, floor(time * 8.0))));
    result *= half(1.0 - dropout * 0.5);
    
    return half4(result, color.a);
}

/// Wireframe hologram effect.
[[ stitchable ]]
half4 wireframeHologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float gridSize,
    float lineWidth
) {
    float2 uv = position / bounds.zw;
    
    // Grid pattern
    float2 grid = fract(uv * gridSize);
    float hLine = smoothstep(lineWidth, lineWidth * 0.5, grid.y) +
                  smoothstep(1.0 - lineWidth, 1.0 - lineWidth * 0.5, grid.y);
    float vLine = smoothstep(lineWidth, lineWidth * 0.5, grid.x) +
                  smoothstep(1.0 - lineWidth, 1.0 - lineWidth * 0.5, grid.x);
    
    float gridLine = max(hLine, vLine);
    
    // Holographic color
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 wireColor = half3(0.0h, 1.0h, 0.8h);
    
    // Pulsing glow
    float pulse = sin(time * 3.0) * 0.3 + 0.7;
    
    // Combine
    half3 result = wireColor * half(gridLine * pulse) * luma;
    
    // Add slight fill
    result += half3(0.0h, 0.1h, 0.1h) * luma;
    
    return half4(result, color.a * half(max(gridLine * 0.8, 0.3)));
}

/// Projection hologram with depth lines.
[[ stitchable ]]
half4 projectionHologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float lineSpacing,
    float perspectiveAmount
) {
    float2 uv = position / bounds.zw;
    
    // Perspective distortion (lines converge toward top)
    float perspective = 1.0 + (1.0 - uv.y) * perspectiveAmount;
    float2 perspUV = float2(uv.x * perspective, uv.y);
    
    // Horizontal scan lines
    float scanY = fract(perspUV.y * (1.0 / lineSpacing) + time * 0.5);
    float scanLine = smoothstep(0.0, 0.1, scanY) * smoothstep(1.0, 0.9, scanY);
    
    // Base color
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 holoColor = mix(
        half3(0.0h, 0.5h, 1.0h),
        half3(0.0h, 1.0h, 0.8h),
        half(uv.y)
    ) * luma;
    
    // Apply scan lines
    half3 result = holoColor * half(0.5 + scanLine * 0.5);
    
    // Edge highlight
    float edge = abs(fract(perspUV.y * (1.0 / lineSpacing)) - 0.5) * 2.0;
    edge = 1.0 - pow(edge, 4.0);
    result += half3(0.2h, 0.5h, 0.8h) * half(edge * 0.3);
    
    return half4(result, color.a);
}

/// Data stream hologram.
[[ stitchable ]]
half4 dataStreamHologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float streamSpeed,
    float density
) {
    float2 uv = position / bounds.zw;
    
    // Multiple data streams
    float stream = 0.0;
    for (int i = 0; i < 5; i++) {
        float offset = float(i) * 0.2;
        float streamX = fract(uv.x * density + offset);
        float streamY = fract(uv.y - time * streamSpeed * (1.0 + float(i) * 0.3));
        
        // Vertical line with traveling dots
        float line = smoothstep(0.02, 0.0, abs(streamX - 0.5));
        float dot = smoothstep(0.1, 0.0, streamY) * line;
        
        stream += dot * (0.5 + float(i) * 0.1);
    }
    
    // Base holographic tint
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 holoColor = half3(0.1h, 0.6h, 0.9h) * luma;
    
    // Add data streams
    half3 result = holoColor + half3(0.0h, half(stream), half(stream * 0.8));
    
    return half4(result, color.a);
}

/// Retro hologram with chromatic bands.
[[ stitchable ]]
half4 retroHologram(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float bandCount,
    float speed
) {
    float2 uv = position / bounds.zw;
    
    // Horizontal color bands
    float band = sin(uv.y * bandCount * 3.14159 - time * speed) * 0.5 + 0.5;
    
    // Rainbow-ish color cycling
    half3 bandColor;
    bandColor.r = half(sin(band * 6.28 + 0.0) * 0.5 + 0.5);
    bandColor.g = half(sin(band * 6.28 + 2.09) * 0.5 + 0.5);
    bandColor.b = half(sin(band * 6.28 + 4.18) * 0.5 + 0.5);
    
    // Modulate with original luminance
    half luma = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 result = bandColor * luma;
    
    // Add scan line overlay
    float scan = sin(uv.y * bounds.w * 2.0) * 0.5 + 0.5;
    result *= half(0.8 + scan * 0.2);
    
    return half4(result, color.a);
}

// Sketch & Drawing Effect Shader
// Creates pencil, pen, and artistic drawing effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Sketch effects simulate hand-drawn appearance by:
// 1. Edge detection (Sobel/Canny-like)
// 2. Cross-hatching patterns based on luminance
// 3. Paper texture overlay
// 4. Line wobble for hand-drawn feel
// =============================================================================

// Hash functions for noise
float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Get luminance
float luminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// =============================================================================
// LAYER EFFECT: Pencil Sketch
// =============================================================================
// Parameters:
// - size: View dimensions
// - lineIntensity: Edge line darkness (0.0-2.0, default: 1.0)
// - paperColor: Background paper color
// - pencilColor: Pencil stroke color
// =============================================================================
[[stitchable]] half4 sketchPencil(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float lineIntensity,
    half3 paperColor,
    half3 pencilColor
) {
    float2 pixelSize = 1.0 / size;
    
    // Sample neighborhood for edge detection
    half3 samples[9];
    int idx = 0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            samples[idx++] = layer.sample(position + offset).rgb;
        }
    }
    
    // Convert to luminance
    float lum[9];
    for (int i = 0; i < 9; i++) {
        lum[i] = luminance(samples[i]);
    }
    
    // Sobel edge detection
    float gx = lum[2] - lum[0] + 2.0 * (lum[5] - lum[3]) + lum[8] - lum[6];
    float gy = lum[6] - lum[0] + 2.0 * (lum[7] - lum[1]) + lum[8] - lum[2];
    float edge = sqrt(gx * gx + gy * gy);
    
    // Paper texture
    float paperNoise = noise(position * 0.5) * 0.1;
    
    // Combine
    float stroke = edge * lineIntensity;
    stroke = clamp(stroke, 0.0, 1.0);
    
    half3 result = mix(paperColor + half(paperNoise), pencilColor, half(stroke));
    
    return half4(result, 1.0);
}

// =============================================================================
// LAYER EFFECT: Cross-Hatch Sketch
// =============================================================================
[[stitchable]] half4 sketchCrossHatch(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float lineSpacing,
    float lineWidth,
    half3 paperColor,
    half3 inkColor
) {
    float2 pixelSize = 1.0 / size;
    half4 original = layer.sample(position);
    
    float lum = luminance(original.rgb);
    float darkness = 1.0 - lum;
    
    // Hatching lines (diagonal)
    float hatch1 = fmod(position.x + position.y, lineSpacing);
    float hatch2 = fmod(position.x - position.y + lineSpacing * 0.5, lineSpacing);
    
    // Draw lines based on darkness
    float line1 = step(hatch1, lineWidth) * step(0.25, darkness);
    float line2 = step(hatch2, lineWidth) * step(0.5, darkness);
    float line3 = step(fmod(position.x, lineSpacing * 0.5), lineWidth * 0.5) * step(0.75, darkness);
    
    float ink = max(max(line1, line2), line3);
    
    // Edge detection for outlines
    half3 samples[4];
    samples[0] = layer.sample(position + float2(-1.0, 0.0) * pixelSize * size).rgb;
    samples[1] = layer.sample(position + float2(1.0, 0.0) * pixelSize * size).rgb;
    samples[2] = layer.sample(position + float2(0.0, -1.0) * pixelSize * size).rgb;
    samples[3] = layer.sample(position + float2(0.0, 1.0) * pixelSize * size).rgb;
    
    float edge = abs(luminance(samples[1]) - luminance(samples[0])) + 
                 abs(luminance(samples[3]) - luminance(samples[2]));
    edge = step(0.1, edge);
    
    ink = max(ink, edge);
    
    half3 result = mix(paperColor, inkColor, half(ink));
    
    return half4(result, 1.0);
}

// =============================================================================
// LAYER EFFECT: Ink Drawing
// =============================================================================
[[stitchable]] half4 sketchInk(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float threshold,
    float lineWidth,
    half3 paperColor,
    half3 inkColor
) {
    float2 pixelSize = 1.0 / size;
    
    // Multi-sample edge detection for smoother lines
    float edge = 0.0;
    
    for (int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398; // 45 degree increments
        float2 offset = float2(cos(angle), sin(angle)) * lineWidth;
        
        half4 s1 = layer.sample(position + offset * pixelSize * size);
        half4 s2 = layer.sample(position - offset * pixelSize * size);
        
        edge += abs(luminance(s1.rgb) - luminance(s2.rgb));
    }
    edge /= 8.0;
    
    // Threshold for clean lines
    float ink = step(threshold, edge);
    
    half3 result = mix(paperColor, inkColor, half(ink));
    
    return half4(result, 1.0);
}

// =============================================================================
// LAYER EFFECT: Charcoal Sketch
// =============================================================================
[[stitchable]] half4 sketchCharcoal(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float smudgeAmount,
    half3 paperColor,
    half3 charcoalColor
) {
    float2 pixelSize = 1.0 / size;
    half4 original = layer.sample(position);
    
    float lum = luminance(original.rgb);
    
    // Smudged sampling
    float2 smudgeOffset = float2(
        noise(position * 0.1) - 0.5,
        noise(position * 0.1 + 100.0) - 0.5
    ) * smudgeAmount;
    
    half4 smudged = layer.sample(position + smudgeOffset);
    float smudgedLum = luminance(smudged.rgb);
    lum = mix(lum, smudgedLum, 0.3);
    
    // Grainy texture
    float grain = noise(position * 2.0) * 0.3;
    
    // Charcoal darkness
    float darkness = (1.0 - lum) + grain * (1.0 - lum);
    darkness = clamp(darkness, 0.0, 1.0);
    
    half3 result = mix(paperColor, charcoalColor, half(darkness));
    
    return half4(result, 1.0);
}

// =============================================================================
// COLOR EFFECT: Simple Outline
// =============================================================================
[[stitchable]] half4 sketchOutline(
    float2 position,
    half4 color,
    float2 size,
    float threshold
) {
    // Simple edge based on color
    float lum = luminance(color.rgb);
    float edge = fwidth(lum) * size.x;
    
    float outline = step(threshold, edge);
    
    half3 result = mix(half3(1.0), half3(0.0), half(outline));
    
    return half4(result, color.a);
}

// =============================================================================
// LAYER EFFECT: Watercolor Sketch
// =============================================================================
[[stitchable]] half4 sketchWatercolor(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float bleedAmount,
    float edgeDarkening
) {
    float2 pixelSize = 1.0 / size;
    
    // Irregular sampling for watercolor bleed
    half3 color = half3(0.0);
    float total = 0.0;
    
    for (int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398 + noise(position * 0.01) * 0.5;
        float dist = (noise(position * 0.1 + float(i) * 10.0) + 0.5) * bleedAmount;
        
        float2 offset = float2(cos(angle), sin(angle)) * dist;
        half4 sample = layer.sample(position + offset);
        
        float weight = 1.0 / (1.0 + dist);
        color += sample.rgb * half(weight);
        total += weight;
    }
    color /= half(total);
    
    // Edge darkening
    half4 original = layer.sample(position);
    float edge = 0.0;
    for (int i = 0; i < 4; i++) {
        float2 offset = float2(float(i % 2) * 2.0 - 1.0, float(i / 2) * 2.0 - 1.0) * pixelSize * size * 2.0;
        half4 neighbor = layer.sample(position + offset);
        edge += abs(luminance(original.rgb) - luminance(neighbor.rgb));
    }
    edge = clamp(edge * edgeDarkening, 0.0, 0.3);
    
    color -= half3(edge);
    
    return half4(clamp(color, half3(0.0), half3(1.0)), original.a);
}

// Emboss & Relief Effect Shader
// Creates 3D embossed/debossed appearance with lighting simulation
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Emboss effect simulates raised or sunken surfaces by:
// 1. Computing gradient/edge detection using Sobel operator
// 2. Applying directional lighting based on surface normal
// 3. Converting to grayscale for relief effect
// 4. Optionally preserving color while adding depth
// =============================================================================

// Sobel kernels for edge detection
constant float3x3 sobelX = float3x3(
    float3(-1.0,  0.0,  1.0),
    float3(-2.0,  0.0,  2.0),
    float3(-1.0,  0.0,  1.0)
);

constant float3x3 sobelY = float3x3(
    float3(-1.0, -2.0, -1.0),
    float3( 0.0,  0.0,  0.0),
    float3( 1.0,  2.0,  1.0)
);

// Convert to grayscale
float luminance(half3 color) {
    return dot(float3(color), float3(0.299, 0.587, 0.114));
}

// =============================================================================
// LAYER EFFECT: Classic Emboss
// =============================================================================
// Parameters:
// - size: View dimensions
// - strength: Emboss intensity (0.0-3.0, default: 1.0)
// - lightAngle: Light direction in radians (default: 0.785 = 45°)
// - elevation: Simulated surface height (0.5-2.0)
// =============================================================================
[[stitchable]] half4 emboss(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float strength,
    float lightAngle
) {
    float2 pixelSize = 1.0 / size;
    
    // Sample 3x3 neighborhood
    float samples[9];
    int idx = 0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            half4 sample = layer.sample(position + offset);
            samples[idx++] = luminance(sample.rgb);
        }
    }
    
    // Apply Sobel operators
    float gx = 0.0, gy = 0.0;
    idx = 0;
    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            gx += samples[idx] * sobelX[y][x];
            gy += samples[idx] * sobelY[y][x];
            idx++;
        }
    }
    
    // Compute lighting direction
    float2 lightDir = float2(cos(lightAngle), sin(lightAngle));
    float2 gradient = float2(gx, gy);
    
    // Dot product for lighting
    float lighting = dot(normalize(gradient + 0.001), lightDir) * strength;
    
    // Base gray + lighting
    float result = 0.5 + lighting * 0.5;
    result = clamp(result, 0.0, 1.0);
    
    half4 original = layer.sample(position);
    return half4(half3(result), original.a);
}

// =============================================================================
// LAYER EFFECT: Color Emboss (preserves color)
// =============================================================================
[[stitchable]] half4 embossColor(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float strength,
    float lightAngle,
    float colorMix
) {
    float2 pixelSize = 1.0 / size;
    half4 center = layer.sample(position);
    
    // Sample for gradient
    half4 left = layer.sample(position + float2(-pixelSize.x * size.x, 0.0));
    half4 right = layer.sample(position + float2(pixelSize.x * size.x, 0.0));
    half4 top = layer.sample(position + float2(0.0, -pixelSize.y * size.y));
    half4 bottom = layer.sample(position + float2(0.0, pixelSize.y * size.y));
    
    // Compute gradients
    float gx = luminance(right.rgb) - luminance(left.rgb);
    float gy = luminance(bottom.rgb) - luminance(top.rgb);
    
    // Light direction
    float2 lightDir = float2(cos(lightAngle), sin(lightAngle));
    float lighting = (gx * lightDir.x + gy * lightDir.y) * strength;
    
    // Apply to color
    half3 embossed = center.rgb + half3(lighting);
    
    // Mix original color
    half3 result = mix(half3(0.5 + lighting), embossed, half(colorMix));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), center.a);
}

// =============================================================================
// COLOR EFFECT: Bump Map Effect
// =============================================================================
[[stitchable]] half4 bumpMap(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float depth
) {
    float2 uv = position / size;
    
    // Animated light position
    float2 lightPos = float2(
        0.5 + 0.3 * cos(time),
        0.5 + 0.3 * sin(time)
    );
    
    // Distance-based shading
    float2 toLight = lightPos - uv;
    float dist = length(toLight);
    float lighting = 1.0 - dist * depth;
    lighting = clamp(lighting, 0.3, 1.0);
    
    // Apply luminance variation for depth
    float lum = luminance(color.rgb);
    float heightFactor = lum * depth;
    
    half3 result = color.rgb * half(lighting + heightFactor * 0.2);
    
    return half4(result, color.a);
}

// =============================================================================
// LAYER EFFECT: Deboss (sunken effect)
// =============================================================================
[[stitchable]] half4 deboss(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float strength
) {
    // Deboss is just emboss with inverted light angle
    float lightAngle = 3.14159 + 0.785; // Opposite of 45°
    float2 pixelSize = 1.0 / size;
    
    half4 center = layer.sample(position);
    half4 topLeft = layer.sample(position + float2(-pixelSize.x, -pixelSize.y) * size);
    half4 bottomRight = layer.sample(position + float2(pixelSize.x, pixelSize.y) * size);
    
    float diff = luminance(topLeft.rgb) - luminance(bottomRight.rgb);
    float result = 0.5 - diff * strength * 0.5;
    
    return half4(half3(result), center.a);
}

// =============================================================================
// LAYER EFFECT: Metallic Emboss
// =============================================================================
[[stitchable]] half4 embossMetallic(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float strength,
    float lightAngle,
    half3 metalColor
) {
    float2 pixelSize = 1.0 / size;
    
    // Sample neighborhood
    half4 center = layer.sample(position);
    half4 nw = layer.sample(position + float2(-1.0, -1.0) * pixelSize * size);
    half4 se = layer.sample(position + float2(1.0, 1.0) * pixelSize * size);
    
    // Compute emboss
    float diff = luminance(nw.rgb) - luminance(se.rgb);
    float highlight = 0.5 + diff * strength;
    
    // Apply metallic color
    half3 result = metalColor * half(highlight);
    
    // Add specular
    if (highlight > 0.7) {
        result += half3(0.3) * half(highlight - 0.7) * 3.0;
    }
    
    return half4(result, center.a);
}

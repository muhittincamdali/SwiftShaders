// Sharpen Effect Shader
// Enhances edges and details through convolution
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Sharpening enhances edges by:
// 1. Detecting edges using high-pass filter
// 2. Adding edge information back to original
// 3. Laplacian sharpening: center - neighbors
// 4. Unsharp mask: original + (original - blur)
// =============================================================================

// Standard sharpen kernel (3x3)
constant float sharpenKernel[9] = {
     0.0, -1.0,  0.0,
    -1.0,  5.0, -1.0,
     0.0, -1.0,  0.0
};

// Strong sharpen kernel
constant float strongKernel[9] = {
    -1.0, -1.0, -1.0,
    -1.0,  9.0, -1.0,
    -1.0, -1.0, -1.0
};

// =============================================================================
// LAYER EFFECT: Basic Sharpen
// =============================================================================
// Parameters:
// - size: View dimensions
// - amount: Sharpen intensity (0.0-3.0, default: 1.0)
// =============================================================================
[[stitchable]] half4 sharpen(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float amount
) {
    float2 pixelSize = 1.0 / size;
    
    // Sample 3x3 neighborhood
    half3 samples[9];
    int idx = 0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            samples[idx++] = layer.sample(position + offset).rgb;
        }
    }
    
    // Apply sharpen kernel
    half3 sharpened = half3(0.0);
    for (int i = 0; i < 9; i++) {
        sharpened += samples[i] * half(sharpenKernel[i]);
    }
    
    // Blend with original
    half4 original = layer.sample(position);
    half3 result = mix(original.rgb, sharpened, half(amount));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), original.a);
}

// =============================================================================
// LAYER EFFECT: Unsharp Mask
// =============================================================================
[[stitchable]] half4 unsharpMask(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float radius,
    float amount,
    float threshold
) {
    float2 pixelSize = 1.0 / size;
    
    // Simple box blur for unsharp mask
    half3 blurred = half3(0.0);
    float total = 0.0;
    
    int r = int(radius);
    for (int y = -r; y <= r; y++) {
        for (int x = -r; x <= r; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            blurred += layer.sample(position + offset).rgb;
            total += 1.0;
        }
    }
    blurred /= half(total);
    
    // Original - blur = high pass
    half4 original = layer.sample(position);
    half3 highPass = original.rgb - blurred;
    
    // Apply threshold
    float strength = length(float3(highPass));
    if (strength < threshold) {
        return original;
    }
    
    // Add high pass back
    half3 result = original.rgb + highPass * half(amount);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), original.a);
}

// =============================================================================
// LAYER EFFECT: High Pass Sharpen
// =============================================================================
[[stitchable]] half4 sharpenHighPass(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float radius,
    float strength
) {
    float2 pixelSize = 1.0 / size;
    
    // Blur
    half3 blurred = half3(0.0);
    float total = 0.0;
    
    int r = int(radius);
    for (int y = -r; y <= r; y++) {
        for (int x = -r; x <= r; x++) {
            float weight = 1.0 / (1.0 + float(x*x + y*y) * 0.5);
            float2 offset = float2(x, y) * pixelSize * size;
            blurred += layer.sample(position + offset).rgb * half(weight);
            total += weight;
        }
    }
    blurred /= half(total);
    
    // High pass = original - blur + 0.5
    half4 original = layer.sample(position);
    half3 highPass = original.rgb - blurred + half3(0.5);
    
    // Overlay blend for sharpening
    half3 result = original.rgb;
    for (int i = 0; i < 3; i++) {
        if (highPass[i] < 0.5) {
            result[i] = 2.0 * original.rgb[i] * highPass[i];
        } else {
            result[i] = 1.0 - 2.0 * (1.0 - original.rgb[i]) * (1.0 - highPass[i]);
        }
    }
    
    // Mix based on strength
    result = mix(original.rgb, result, half(strength));
    
    return half4(clamp(result, half3(0.0), half3(1.0)), original.a);
}

// =============================================================================
// LAYER EFFECT: Edge Enhance
// =============================================================================
[[stitchable]] half4 sharpenEdges(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float amount
) {
    float2 pixelSize = 1.0 / size;
    
    // Sobel edge detection
    half3 samples[9];
    int idx = 0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            samples[idx++] = layer.sample(position + offset).rgb;
        }
    }
    
    // Sobel X
    half3 gx = samples[2] - samples[0] + 2.0 * samples[5] - 2.0 * samples[3] + samples[8] - samples[6];
    
    // Sobel Y
    half3 gy = samples[6] - samples[0] + 2.0 * samples[7] - 2.0 * samples[1] + samples[8] - samples[2];
    
    // Edge magnitude
    half3 edge = sqrt(gx * gx + gy * gy);
    
    // Add edges to original
    half4 original = layer.sample(position);
    half3 result = original.rgb + edge * half(amount);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), original.a);
}

// =============================================================================
// LAYER EFFECT: Clarity (midtone contrast)
// =============================================================================
[[stitchable]] half4 sharpenClarity(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float radius,
    float amount
) {
    float2 pixelSize = 1.0 / size;
    
    // Blur
    half3 blurred = half3(0.0);
    float total = 0.0;
    
    int r = int(radius);
    for (int y = -r; y <= r; y++) {
        for (int x = -r; x <= r; x++) {
            float2 offset = float2(x, y) * pixelSize * size;
            blurred += layer.sample(position + offset).rgb;
            total += 1.0;
        }
    }
    blurred /= half(total);
    
    // Clarity affects midtones more
    half4 original = layer.sample(position);
    half3 diff = original.rgb - blurred;
    
    // Midtone weight (affects middle luminance more)
    float lum = dot(float3(original.rgb), float3(0.299, 0.587, 0.114));
    float midtoneWeight = 1.0 - abs(lum - 0.5) * 2.0;
    midtoneWeight = pow(midtoneWeight, 2.0);
    
    half3 result = original.rgb + diff * half(amount * midtoneWeight);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), original.a);
}

// =============================================================================
// COLOR EFFECT: Simple Sharpen (no layer sampling)
// =============================================================================
[[stitchable]] half4 sharpenSimple(
    float2 position,
    half4 color,
    float amount
) {
    // Enhance color differences from mid-gray
    half3 midGray = half3(0.5);
    half3 diff = color.rgb - midGray;
    half3 result = color.rgb + diff * half(amount);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

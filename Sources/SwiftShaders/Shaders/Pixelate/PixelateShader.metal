#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Pixelate Shader
// Creates various pixelation and mosaic effects for retro aesthetics.

/// Basic square pixelation effect.
/// Reduces resolution by grouping pixels into blocks.
///
/// - Parameters:
///   - position: Current pixel position.
///   - bounds: View bounds.
///   - pixelSize: Size of each pixel block.
[[ stitchable ]]
float2 pixelate(
    float2 position,
    float4 bounds,
    float pixelSize
) {
    if (pixelSize <= 1.0) {
        return position;
    }
    
    // Snap to pixel grid
    float2 pixelated = floor(position / pixelSize) * pixelSize + pixelSize * 0.5;
    
    return pixelated;
}

/// Animated pixelation transition.
/// Smoothly transitions between original and pixelated.
[[ stitchable ]]
float2 pixelateTransition(
    float2 position,
    float4 bounds,
    float progress,
    float maxPixelSize
) {
    // Calculate pixel size based on progress
    float pixelSize = mix(1.0, maxPixelSize, progress);
    
    if (pixelSize <= 1.0) {
        return position;
    }
    
    float2 pixelated = floor(position / pixelSize) * pixelSize + pixelSize * 0.5;
    return pixelated;
}

/// Hexagonal pixelation.
/// Uses hexagonal grid for more organic appearance.
[[ stitchable ]]
float2 hexPixelate(
    float2 position,
    float4 bounds,
    float hexSize
) {
    float2 uv = position / bounds.zw;
    
    // Hexagonal grid calculations
    float2 hexUV = uv * float2(1.0, 1.0 / 0.866);
    
    float2 a = fmod(hexUV, 1.0);
    float2 b = fmod(hexUV + 0.5, 1.0);
    
    float2 gv;
    if (length(a - 0.5) < length(b - 0.5)) {
        gv = a;
    } else {
        gv = b;
    }
    
    // Snap to hex centers
    float2 hexCenter = (floor(hexUV / hexSize) + 0.5) * hexSize;
    float2 result = hexCenter * float2(1.0, 0.866) * bounds.zw;
    
    return result;
}

/// Diamond/rhombus pixelation.
[[ stitchable ]]
float2 diamondPixelate(
    float2 position,
    float4 bounds,
    float diamondSize
) {
    float2 uv = position / bounds.zw;
    
    // Rotate coordinates 45 degrees
    float angle = 0.785398; // pi/4
    float cosA = cos(angle);
    float sinA = sin(angle);
    
    float2 rotated = float2(
        uv.x * cosA - uv.y * sinA,
        uv.x * sinA + uv.y * cosA
    );
    
    // Pixelate in rotated space
    float2 pixelated = floor(rotated / diamondSize) * diamondSize + diamondSize * 0.5;
    
    // Rotate back
    float2 result = float2(
        pixelated.x * cosA + pixelated.y * sinA,
        -pixelated.x * sinA + pixelated.y * cosA
    );
    
    return result * bounds.zw;
}

/// Circular dot matrix effect.
[[ stitchable ]]
half4 dotMatrix(
    float2 position,
    half4 color,
    float4 bounds,
    float dotSize,
    float dotSpacing
) {
    float2 uv = position / bounds.zw;
    
    // Grid position
    float2 grid = fmod(uv, dotSpacing) / dotSpacing;
    
    // Distance from grid center
    float dist = length(grid - 0.5) * 2.0;
    
    // Create dot based on brightness
    half brightness = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    float threshold = 1.0 - float(brightness);
    
    if (dist < threshold * dotSize) {
        return color;
    } else {
        return half4(0.0h, 0.0h, 0.0h, color.a);
    }
}

/// LED matrix display effect.
[[ stitchable ]]
half4 ledMatrix(
    float2 position,
    half4 color,
    float4 bounds,
    float ledSize,
    float ledGap,
    float brightness
) {
    float2 uv = position / bounds.zw;
    float cellSize = ledSize + ledGap;
    
    // Grid cell position
    float2 cell = fmod(uv * bounds.zw, cellSize);
    
    // LED shape (rounded square)
    float2 ledUV = cell / ledSize;
    float dist = max(abs(ledUV.x - 0.5), abs(ledUV.y - 0.5));
    
    // Inside LED
    if (cell.x < ledSize && cell.y < ledSize && dist < 0.45) {
        half4 result = color * half(brightness);
        // Add LED glow at center
        float glow = 1.0 - dist * 2.0;
        result.rgb *= half(1.0 + glow * 0.3);
        return result;
    }
    
    // Gap between LEDs
    return half4(0.05h, 0.05h, 0.05h, color.a);
}

/// Triangular mosaic pixelation.
[[ stitchable ]]
float2 trianglePixelate(
    float2 position,
    float4 bounds,
    float triangleSize
) {
    float2 uv = position / bounds.zw;
    
    // Triangle grid
    float2 scaled = uv / triangleSize;
    float2 gridPos = floor(scaled);
    float2 localPos = fract(scaled);
    
    // Determine which triangle we're in
    bool upperTriangle = localPos.x + localPos.y < 1.0;
    
    float2 center;
    if (upperTriangle) {
        center = gridPos + float2(0.333, 0.333);
    } else {
        center = gridPos + float2(0.666, 0.666);
    }
    
    return center * triangleSize * bounds.zw;
}

// Kaleidoscope Effect Shader
// Creates symmetrical mirror patterns like a kaleidoscope
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Kaleidoscope creates symmetric patterns by:
// 1. Converting coordinates to polar (angle/radius)
// 2. Dividing angle into segments
// 3. Mirroring alternating segments
// 4. Converting back to Cartesian for sampling
// =============================================================================

// Convert Cartesian to polar coordinates
float2 cartesianToPolar(float2 cartesian) {
    float r = length(cartesian);
    float theta = atan2(cartesian.y, cartesian.x);
    return float2(r, theta);
}

// Convert polar to Cartesian coordinates
float2 polarToCartesian(float2 polar) {
    return float2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// =============================================================================
// LAYER EFFECT: Classic Kaleidoscope
// =============================================================================
// Parameters:
// - size: View dimensions
// - center: Center point (normalized 0-1)
// - segments: Number of mirror segments (2-16, default: 6)
// - rotation: Rotation angle in radians
// =============================================================================
[[stitchable]] half4 kaleidoscope(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float segments,
    float rotation
) {
    // Normalize and center coordinates
    float2 uv = position / size;
    float2 centered = uv - center;
    
    // Convert to polar
    float2 polar = cartesianToPolar(centered);
    
    // Add rotation
    polar.y += rotation;
    
    // Calculate segment size
    float segmentAngle = 6.28318 / segments;
    
    // Fold angle into first segment
    float angle = polar.y;
    angle = fmod(angle + 3.14159, segmentAngle);
    
    // Mirror every other segment
    if (fmod(floor((polar.y + 3.14159) / segmentAngle), 2.0) >= 1.0) {
        angle = segmentAngle - angle;
    }
    
    // Convert back to Cartesian
    float2 newPolar = float2(polar.x, angle - 3.14159 / segments);
    float2 newUV = polarToCartesian(newPolar) + center;
    
    // Sample from transformed coordinates
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Animated Kaleidoscope
// =============================================================================
[[stitchable]] half4 kaleidoscopeAnimated(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float segments,
    float time,
    float rotationSpeed,
    float zoomSpeed
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    // Animated zoom
    float zoom = 1.0 + sin(time * zoomSpeed) * 0.2;
    centered *= zoom;
    
    // Convert to polar with animated rotation
    float2 polar = cartesianToPolar(centered);
    polar.y += time * rotationSpeed;
    
    float segmentAngle = 6.28318 / segments;
    float angle = fmod(polar.y + 3.14159, segmentAngle);
    
    if (fmod(floor((polar.y + 3.14159) / segmentAngle), 2.0) >= 1.0) {
        angle = segmentAngle - angle;
    }
    
    float2 newPolar = float2(polar.x, angle - 3.14159 / segments);
    float2 newUV = polarToCartesian(newPolar) + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Triangle Kaleidoscope
// =============================================================================
[[stitchable]] half4 kaleidoscopeTriangle(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float scale,
    float rotation
) {
    float2 uv = position / size;
    float2 p = (uv - center) * scale;
    
    // Rotate
    float c = cos(rotation);
    float s = sin(rotation);
    p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Triangle tessellation
    float sqrt3 = 1.732050808;
    
    // Transform to triangle grid
    float2 a = float2(1.0, 0.0);
    float2 b = float2(0.5, sqrt3 * 0.5);
    
    float2 grid = float2(dot(p, a), dot(p, b));
    
    // Fold into fundamental domain
    grid = fract(grid);
    
    if (grid.x + grid.y > 1.0) {
        grid = float2(1.0) - grid;
    }
    
    // Transform back
    float2 newP = grid.x * a + grid.y * b;
    float2 newUV = newP / scale + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Square Kaleidoscope (4-fold symmetry)
// =============================================================================
[[stitchable]] half4 kaleidoscopeSquare(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float scale,
    float rotation
) {
    float2 uv = position / size;
    float2 p = (uv - center) * scale;
    
    // Rotate
    float c = cos(rotation);
    float s = sin(rotation);
    p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Fold into first quadrant
    p = abs(p);
    
    // Mirror along diagonal
    if (p.x > p.y) {
        p = p.yx;
    }
    
    // Tile
    p = fract(p);
    
    float2 newUV = p / scale + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Radial Kaleidoscope
// =============================================================================
[[stitchable]] half4 kaleidoscopeRadial(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float segments,
    float spiralAmount,
    float time
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float2 polar = cartesianToPolar(centered);
    
    // Add spiral distortion
    polar.y += polar.x * spiralAmount + time * 0.5;
    
    float segmentAngle = 6.28318 / segments;
    float angle = fmod(polar.y + 3.14159, segmentAngle);
    
    if (fmod(floor((polar.y + 3.14159) / segmentAngle), 2.0) >= 1.0) {
        angle = segmentAngle - angle;
    }
    
    float2 newPolar = float2(polar.x, angle);
    float2 newUV = polarToCartesian(newPolar) + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// COLOR EFFECT: Kaleidoscope Tint
// =============================================================================
[[stitchable]] half4 kaleidoscopeTint(
    float2 position,
    half4 color,
    float2 size,
    float segments,
    float time
) {
    float2 uv = position / size;
    float2 centered = uv - 0.5;
    
    float2 polar = cartesianToPolar(centered);
    
    // Segment-based color variation
    float segment = floor((polar.y + 3.14159) / (6.28318 / segments));
    float hue = fract(segment / segments + time * 0.1);
    
    // Simple HSV to RGB
    float3 rgb = clamp(abs(fmod(hue * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    
    // Tint original color
    half3 result = color.rgb * half3(rgb * 0.5 + 0.5);
    
    return half4(result, color.a);
}

// =============================================================================
// LAYER EFFECT: Hexagonal Kaleidoscope
// =============================================================================
[[stitchable]] half4 kaleidoscopeHex(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float scale,
    float rotation
) {
    float2 uv = position / size;
    float2 p = (uv - center) * scale;
    
    // Rotate
    float c = cos(rotation);
    float s = sin(rotation);
    p = float2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Hexagonal coordinates
    float sqrt3 = 1.732050808;
    float2 r = float2(1.0, 1.0 / sqrt3);
    float2 h = r * 0.5;
    
    float2 a = fmod(p, r) - h;
    float2 b = fmod(p - h, r) - h;
    
    float2 gv = dot(a, a) < dot(b, b) ? a : b;
    
    // Mirror
    gv = abs(gv);
    
    float2 newUV = gv / scale + center;
    
    return layer.sample(newUV * size);
}

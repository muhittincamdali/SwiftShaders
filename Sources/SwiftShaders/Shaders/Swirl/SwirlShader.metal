// Swirl & Twist Effect Shader
// Creates spiral and vortex distortion effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Swirl effects create spiral distortions by:
// 1. Converting to polar coordinates around center
// 2. Rotating angle based on distance
// 3. Applying various falloff curves
// 4. Converting back for texture sampling
// =============================================================================

// =============================================================================
// LAYER EFFECT: Basic Swirl
// =============================================================================
// Parameters:
// - size: View dimensions
// - center: Swirl center point (normalized 0-1)
// - angle: Maximum twist angle in radians
// - radius: Effect radius (normalized)
// =============================================================================
[[stitchable]] half4 swirl(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float angle,
    float radius
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    // Distance from center
    float dist = length(centered);
    
    // Calculate twist amount (falloff towards edge)
    float twist = 0.0;
    if (dist < radius) {
        float t = 1.0 - dist / radius;
        twist = angle * t * t; // Quadratic falloff
    }
    
    // Rotate around center
    float c = cos(twist);
    float s = sin(twist);
    float2 rotated = float2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    
    // Convert back to texture coordinates
    float2 newUV = rotated + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Animated Swirl
// =============================================================================
[[stitchable]] half4 swirlAnimated(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float time,
    float speed,
    float radius
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    // Animated angle
    float angle = time * speed;
    
    float twist = 0.0;
    if (dist < radius) {
        float t = 1.0 - dist / radius;
        twist = angle * t * t;
    }
    
    float c = cos(twist);
    float s = sin(twist);
    float2 rotated = float2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    
    float2 newUV = rotated + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Multi-Swirl (multiple vortices)
// =============================================================================
[[stitchable]] half4 swirlMulti(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center1,
    float2 center2,
    float angle1,
    float angle2,
    float radius
) {
    float2 uv = position / size;
    
    // First swirl
    float2 centered1 = uv - center1;
    float dist1 = length(centered1);
    float twist1 = 0.0;
    if (dist1 < radius) {
        float t = 1.0 - dist1 / radius;
        twist1 = angle1 * t * t;
    }
    
    // Second swirl
    float2 centered2 = uv - center2;
    float dist2 = length(centered2);
    float twist2 = 0.0;
    if (dist2 < radius) {
        float t = 1.0 - dist2 / radius;
        twist2 = angle2 * t * t;
    }
    
    // Combine twists
    float totalTwist = twist1 + twist2;
    
    // Apply to position (relative to first center)
    float2 centered = uv - 0.5;
    float c = cos(totalTwist);
    float s = sin(totalTwist);
    float2 rotated = float2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    
    float2 newUV = rotated + 0.5;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Pinch (opposite of swirl)
// =============================================================================
[[stitchable]] half4 pinch(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float strength,
    float radius
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    if (dist < radius && dist > 0.001) {
        float t = dist / radius;
        float pinchFactor = pow(t, strength);
        centered = centered * (pinchFactor / t);
    }
    
    float2 newUV = centered + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Bulge
// =============================================================================
[[stitchable]] half4 bulge(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float strength,
    float radius
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    if (dist < radius && dist > 0.001) {
        float t = dist / radius;
        float bulgeFactor = pow(t, 1.0 / max(strength, 0.1));
        centered = centered * (bulgeFactor / t);
    }
    
    float2 newUV = centered + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Vortex (sucking in)
// =============================================================================
[[stitchable]] half4 vortex(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float angle,
    float pullStrength,
    float radius
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    if (dist < radius) {
        float t = 1.0 - dist / radius;
        
        // Swirl
        float twist = angle * t * t;
        float c = cos(twist);
        float s = sin(twist);
        centered = float2(
            centered.x * c - centered.y * s,
            centered.x * s + centered.y * c
        );
        
        // Pull towards center
        float pull = pow(t, pullStrength);
        centered *= (1.0 - pull * 0.5);
    }
    
    float2 newUV = centered + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Twirl (angular distortion)
// =============================================================================
[[stitchable]] half4 twirl(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float angle,
    float falloff
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    // Smooth falloff without hard radius
    float twist = angle * exp(-dist * dist * falloff);
    
    float c = cos(twist);
    float s = sin(twist);
    float2 rotated = float2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    
    float2 newUV = rotated + center;
    
    return layer.sample(newUV * size);
}

// =============================================================================
// LAYER EFFECT: Spiral Zoom
// =============================================================================
[[stitchable]] half4 spiralZoom(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float time,
    float rotationSpeed,
    float zoomSpeed
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    float dist = length(centered);
    
    // Spiral rotation increases with distance
    float rotation = dist * rotationSpeed + time;
    
    // Zoom pulsation
    float zoom = 1.0 + sin(time * zoomSpeed) * 0.1;
    centered *= zoom;
    
    float c = cos(rotation);
    float s = sin(rotation);
    float2 rotated = float2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    
    float2 newUV = rotated + center;
    
    return layer.sample(newUV * size);
}

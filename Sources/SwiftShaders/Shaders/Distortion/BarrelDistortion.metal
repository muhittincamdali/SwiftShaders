#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Distortion Shaders
// Various geometric distortion effects for lens and warping effects.

/// Barrel distortion (fisheye-like bulge).
[[ stitchable ]]
float2 barrelDistortion(
    float2 position,
    float4 bounds,
    float strength,
    float zoom
) {
    float2 center = bounds.zw * 0.5;
    float2 uv = (position - center) / center;
    
    float r2 = dot(uv, uv);
    float distortion = 1.0 + r2 * strength;
    
    float2 distorted = uv * distortion * zoom;
    
    return distorted * center + center;
}

/// Pincushion distortion (inverse barrel).
[[ stitchable ]]
float2 pincushionDistortion(
    float2 position,
    float4 bounds,
    float strength,
    float zoom
) {
    float2 center = bounds.zw * 0.5;
    float2 uv = (position - center) / center;
    
    float r2 = dot(uv, uv);
    float distortion = 1.0 - r2 * strength;
    
    float2 distorted = uv * distortion * zoom;
    
    return distorted * center + center;
}

/// Spherical bulge distortion.
[[ stitchable ]]
float2 sphereBulge(
    float2 position,
    float4 bounds,
    float centerX,
    float centerY,
    float radius,
    float strength
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = position - center;
    float dist = length(delta);
    
    if (dist < radius) {
        float factor = dist / radius;
        float bulge = sin(factor * 1.5707963) * strength;
        float2 direction = normalize(delta + 0.0001);
        return position + direction * bulge * (radius - dist);
    }
    
    return position;
}

/// Pinch/squeeze distortion.
[[ stitchable ]]
float2 pinchDistortion(
    float2 position,
    float4 bounds,
    float centerX,
    float centerY,
    float radius,
    float strength
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = position - center;
    float dist = length(delta);
    
    if (dist < radius) {
        float factor = pow(dist / radius, strength);
        float2 direction = normalize(delta + 0.0001);
        return center + direction * factor * radius;
    }
    
    return position;
}

/// Swirl/twirl distortion.
[[ stitchable ]]
float2 swirlDistortion(
    float2 position,
    float4 bounds,
    float centerX,
    float centerY,
    float radius,
    float angle
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = position - center;
    float dist = length(delta);
    
    if (dist < radius) {
        float factor = 1.0 - dist / radius;
        float twist = angle * factor * factor;
        
        float cosA = cos(twist);
        float sinA = sin(twist);
        
        float2 rotated = float2(
            delta.x * cosA - delta.y * sinA,
            delta.x * sinA + delta.y * cosA
        );
        
        return center + rotated;
    }
    
    return position;
}

/// Wave distortion pattern.
[[ stitchable ]]
float2 waveDistortion(
    float2 position,
    float4 bounds,
    float time,
    float amplitudeX,
    float amplitudeY,
    float frequencyX,
    float frequencyY
) {
    float2 uv = position / bounds.zw;
    
    float2 offset;
    offset.x = sin(uv.y * frequencyY * 10.0 + time * 3.0) * amplitudeX * bounds.z;
    offset.y = sin(uv.x * frequencyX * 10.0 + time * 3.0) * amplitudeY * bounds.w;
    
    return position + offset;
}

/// Kaleidoscope reflection.
[[ stitchable ]]
float2 kaleidoscope(
    float2 position,
    float4 bounds,
    float segments,
    float rotation
) {
    float2 center = bounds.zw * 0.5;
    float2 delta = position - center;
    
    float angle = atan2(delta.y, delta.x) + rotation;
    float dist = length(delta);
    
    // Segment angle
    float segmentAngle = 6.28318 / segments;
    float segment = floor(angle / segmentAngle);
    float localAngle = fmod(angle, segmentAngle);
    
    // Mirror alternate segments
    if (fmod(segment, 2.0) > 0.5) {
        localAngle = segmentAngle - localAngle;
    }
    
    float2 result = float2(cos(localAngle), sin(localAngle)) * dist;
    return result + center;
}

/// Magnifying glass effect.
[[ stitchable ]]
float2 magnify(
    float2 position,
    float4 bounds,
    float centerX,
    float centerY,
    float radius,
    float magnification
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = position - center;
    float dist = length(delta);
    
    if (dist < radius) {
        // Inside magnification area
        float2 scaled = delta / magnification;
        return center + scaled;
    }
    
    return position;
}

/// Tunnel/zoom distortion.
[[ stitchable ]]
float2 tunnelDistortion(
    float2 position,
    float4 bounds,
    float time,
    float zoomSpeed,
    float rotationSpeed
) {
    float2 center = bounds.zw * 0.5;
    float2 delta = position - center;
    
    float angle = atan2(delta.y, delta.x);
    float dist = length(delta) / length(center);
    
    // Zoom and rotation based on distance
    float zoom = fract(log(dist + 0.01) + time * zoomSpeed);
    float rotation = time * rotationSpeed * (1.0 - dist);
    
    float2 result = float2(
        cos(angle + rotation),
        sin(angle + rotation)
    ) * zoom * length(center);
    
    return result + center;
}

/// Displacement map simulation.
[[ stitchable ]]
float2 displacementMap(
    float2 position,
    float4 bounds,
    float time,
    float strength,
    float scale
) {
    float2 uv = position / bounds.zw;
    
    // Simple procedural displacement
    float noise1 = sin(uv.x * scale * 10.0 + time) * cos(uv.y * scale * 8.0 + time * 0.7);
    float noise2 = cos(uv.x * scale * 12.0 - time * 0.5) * sin(uv.y * scale * 10.0 + time * 0.8);
    
    float2 offset = float2(noise1, noise2) * strength * bounds.zw * 0.05;
    
    return position + offset;
}

/// Lens warp effect.
[[ stitchable ]]
float2 lensWarp(
    float2 position,
    float4 bounds,
    float k1,
    float k2,
    float centerX,
    float centerY
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = (position - center) / bounds.zw;
    
    float r2 = dot(delta, delta);
    float r4 = r2 * r2;
    
    float distortion = 1.0 + k1 * r2 + k2 * r4;
    
    float2 distorted = delta * distortion;
    
    return distorted * bounds.zw + center;
}

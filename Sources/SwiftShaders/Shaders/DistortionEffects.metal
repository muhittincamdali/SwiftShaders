// Distortion effects: each pixel shows the view's color from another position.
// Used with SwiftUI's distortionEffect(_:maxSampleOffset:isEnabled:). The returned value is the
// position to read from.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderCommon.h"
using namespace metal;

/// Shifts rows sideways along a sine wave that travels down the view `speed` times per second.
[[ stitchable ]] float2 ssWave(float2 position, float2 size, float time, float amplitude, float wavelength, float speed) {
    float phase = 2.0 * ss::pi * (position.y / wavelength - time * speed);
    return float2(position.x + amplitude * sin(phase), position.y);
}

/// Twists the area within `radius` points of `center` by up to `angle` radians at the center,
/// easing to no twist at the edge of the circle.
[[ stitchable ]] float2 ssSwirl(float2 position, float2 size, float2 center, float radius, float angle) {
    float2 offset = position - center;
    float distance = length(offset);
    if (distance >= radius) {
        return position;
    }
    float falloff = 1.0 - distance / radius;
    return center + ss::rotate(offset, angle * falloff * falloff);
}

/// Magnifies (positive `strength`) or pinches (negative) the area within `radius` points of
/// `center`. `strength` 1 magnifies the center the most; 0 changes nothing.
[[ stitchable ]] float2 ssBulge(float2 position, float2 size, float2 center, float radius, float strength) {
    float2 offset = position - center;
    float distance = length(offset);
    if (distance >= radius) {
        return position;
    }
    float falloff = 1.0 - distance / radius;
    return center + offset * (1.0 - strength * falloff * falloff);
}

/// Moves pixels along overlapping sine waves, like the surface of a pool. `scale` is the size of
/// the larger waves in points; the result is never more than `amplitude` points from `position`.
[[ stitchable ]] float2 ssWater(float2 position, float2 size, float time, float amplitude, float scale, float speed) {
    float2 point = position / scale * 2.0 * ss::pi;
    float t = time * speed;
    float x = sin(point.y + t * 1.3) * 0.6 + sin(point.x * 0.7 + point.y * 1.6 + t * 1.9) * 0.4;
    float y = sin(point.x + t * 1.1) * 0.6 + sin(point.y * 0.8 - point.x * 1.4 + t * 1.7) * 0.4;
    return position + amplitude * float2(x, y) * 0.70710678;
}

/// Shows the area around `center` enlarged by `magnification` inside a circle of `radius`
/// points, like a magnifying glass held over the view.
[[ stitchable ]] float2 ssLoupe(float2 position, float2 size, float2 center, float radius, float magnification) {
    float2 offset = position - center;
    if (length(offset) >= radius) {
        return position;
    }
    return center + offset / magnification;
}

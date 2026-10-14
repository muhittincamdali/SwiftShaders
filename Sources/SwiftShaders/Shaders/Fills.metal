// Fills: shaders used as a ShapeStyle, e.g. Rectangle().fill(.checkerboard()).
// They receive only the position, plus the arguments passed from Swift.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderCommon.h"
using namespace metal;

/// Alternating `first` and `second` squares of `cell` points, `first` in the top-left corner.
[[ stitchable ]] half4 ssCheckerboard(float2 position, float cell, half4 first, half4 second) {
    float2 index = floor(position / cell);
    return fmod(index.x + index.y, 2.0) == 0.0 ? first : second;
}

/// Alternating stripes `width` points wide, rotated by `angle` radians.
[[ stitchable ]] half4 ssStripes(float2 position, float width, float angle, half4 first, half4 second) {
    float across = ss::rotate(position, -angle).x;
    return fmod(floor(across / width), 2.0) == 0.0 ? first : second;
}

/// A moving plasma pattern blending three colors. `bounds` is the filled shape's rectangle.
[[ stitchable ]] half4 ssPlasma(float2 position, float4 bounds, float time, float scale, half4 first, half4 second, half4 third) {
    float2 point = (position - bounds.xy) / max(min(bounds.z, bounds.w), 1.0) * scale;
    float value = sin(point.x * 3.0 + time)
        + sin(point.y * 4.0 - time * 1.3)
        + sin((point.x + point.y) * 2.5 + time * 0.7)
        + sin(length(point - scale * 0.5) * 5.0 - time * 1.7);
    float t = value * 0.125 + 0.5;
    half4 low = mix(first, second, half(smoothstep(0.0, 0.5, t)));
    return mix(low, third, half(smoothstep(0.5, 1.0, t)));
}

// Shaders used only by the transitions. The pixelate and swirl transitions reuse the effects.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderCommon.h"
using namespace metal;

/// Hides grains of `grain` points in random order: none at `progress` 0, all at 1.
[[ stitchable ]] half4 ssDissolve(float2 position, half4 color, float2 size, float progress, float grain, float seed) {
    float order = ss::hash(floor(position / grain) + seed * float2(7.0, 13.0));
    return order >= progress ? color : half4(0.0h);
}

/// Hides everything outside a circle around `center` that shrinks from the farthest corner at
/// `progress` 0 to nothing at 1. The edge is antialiased over one point.
[[ stitchable ]] half4 ssCircleReveal(float2 position, half4 color, float2 size, float2 center, float progress) {
    float2 far = max(abs(center), abs(size - center));
    float radius = length(far) * (1.0 - progress);
    float inside = 1.0 - smoothstep(radius - 0.5, radius + 0.5, distance(position, center));
    return color * half(inside);
}

/// Hides a growing sector around `center`, like the hand of a clock that starts at `start`
/// radians (0 points right, angles grow clockwise) and has swept `progress` of a full turn.
[[ stitchable ]] half4 ssRadialWipe(float2 position, half4 color, float2 size, float2 center, float progress, float start) {
    float2 offset = position - center;
    float turn = fract((atan2(offset.y, offset.x) - start) / (2.0 * ss::pi));
    // The distance to the hand in points along the arc, for a one-point antialiased edge.
    float arc = (turn - progress) * 2.0 * ss::pi * length(offset);
    float visible = progress <= 0.0 ? 1.0 : (progress >= 1.0 ? 0.0 : smoothstep(-0.5, 0.5, arc));
    return color * half(visible);
}

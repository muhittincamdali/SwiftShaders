// Helpers shared by the SwiftShaders Metal files.
//
// SwiftUI hands shaders premultiplied colors: rgb is already multiplied by alpha. Effects that
// change hue or brightness work on the straight (unpremultiplied) color and multiply again at the
// end, so that antialiased edges and translucent views keep their alpha.

#pragma once

#include <metal_stdlib>
using namespace metal;

namespace ss {

constant float pi = 3.14159265358979;

/// Rec. 709 luma of a straight color.
inline half luminance(half3 rgb) {
    return dot(rgb, half3(0.2126h, 0.7152h, 0.0722h));
}

/// The straight color of a premultiplied one; black where the pixel is fully transparent.
inline half3 straight(half4 color) {
    return color.a > 0.0h ? color.rgb / color.a : half3(0.0h);
}

/// A premultiplied color from a straight one.
inline half4 premultiplied(half3 rgb, half alpha) {
    return half4(clamp(rgb, 0.0h, 1.0h) * alpha, alpha);
}

/// A pseudo-random value in [0, 1) for a 2D point, without sin() so that results do not depend
/// on the GPU's precision. Adapted from "Hash without Sine" by Dave Hoskins (MIT license).
inline float hash(float2 point) {
    float3 p = fract(float3(point.xyx) * 0.1031);
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
}

/// `point` rotated around the origin by `angle` radians.
inline float2 rotate(float2 point, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return float2(point.x * c - point.y * s, point.x * s + point.y * c);
}

/// `point` moved inside a view of `size`, half a pixel from the edge. Layer effects sample
/// through this so they never read outside the view: the pixels there are transparent, which
/// would draw a dark or bright border, and reading them would need a larger offscreen layer.
inline float2 clampInto(float2 point, float2 size) {
    return clamp(point, float2(0.5), max(size - 0.5, float2(0.5)));
}

/// `point` folded back into a view of `size` by mirroring it at the edges, so a pattern that
/// reaches past the view repeats the view instead of showing transparent gaps.
inline float2 mirrorInto(float2 point, float2 size) {
    float2 period = 2.0 * max(size, float2(1.0));
    float2 folded = point - period * floor(point / period);
    return clampInto(min(folded, period - folded), size);
}

} // namespace ss

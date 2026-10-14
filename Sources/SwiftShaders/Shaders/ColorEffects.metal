// Color effects: each pixel's new color depends only on its own color and position.
// Used with SwiftUI's colorEffect(_:isEnabled:).

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderCommon.h"
using namespace metal;

/// Warm brown tones, blended with the original by `amount` (0...1).
[[ stitchable ]] half4 ssSepia(float2 position, half4 color, float2 size, float amount) {
    half3 rgb = ss::straight(color);
    half3 sepia = half3(
        dot(rgb, half3(0.393h, 0.769h, 0.189h)),
        dot(rgb, half3(0.349h, 0.686h, 0.168h)),
        dot(rgb, half3(0.272h, 0.534h, 0.131h))
    );
    return ss::premultiplied(mix(rgb, min(sepia, 1.0h), half(amount)), color.a);
}

/// Maps luminance onto a gradient from `shadows` (black) to `highlights` (white).
[[ stitchable ]] half4 ssDuotone(float2 position, half4 color, float2 size, half4 shadows, half4 highlights, float amount) {
    half3 rgb = ss::straight(color);
    half3 tone = mix(ss::straight(shadows), ss::straight(highlights), ss::luminance(rgb));
    return ss::premultiplied(mix(rgb, tone, half(amount)), color.a);
}

/// Rounds every channel to one of `levels` evenly spaced values, 0 and 1 included.
[[ stitchable ]] half4 ssPosterize(float2 position, half4 color, float2 size, float levels) {
    half steps = half(levels) - 1.0h;
    half3 rgb = floor(ss::straight(color) * steps + 0.5h) / steps;
    return ss::premultiplied(rgb, color.a);
}

/// `dark` where luminance is below `cutoff`, `light` elsewhere.
[[ stitchable ]] half4 ssThreshold(float2 position, half4 color, float2 size, float cutoff, half4 dark, half4 light) {
    half4 tone = ss::luminance(ss::straight(color)) < half(cutoff) ? dark : light;
    return tone * color.a;
}

/// Darkens toward the edges. Distance is 0 at the center, 1 at the middle of each edge and about
/// 1.41 in the corners; darkening starts at `radius` and reaches `intensity` at radius + softness.
[[ stitchable ]] half4 ssVignette(float2 position, half4 color, float2 size, float intensity, float radius, float softness) {
    float2 offset = (position / size - 0.5) * 2.0;
    float falloff = smoothstep(radius, radius + softness, length(offset));
    half factor = 1.0h - half(intensity * falloff);
    return half4(color.rgb * factor, color.a);
}

/// Darkens the lower half of every band of `spacing` points by `intensity`.
[[ stitchable ]] half4 ssScanlines(float2 position, half4 color, float2 size, float spacing, float intensity) {
    bool dark = fract(position.y / spacing) >= 0.5;
    half factor = dark ? 1.0h - half(intensity) : 1.0h;
    return half4(color.rgb * factor, color.a);
}

/// Monochrome noise that changes 24 times a second, like film grain.
[[ stitchable ]] half4 ssFilmGrain(float2 position, half4 color, float2 size, float time, float intensity) {
    float frame = floor(time * 24.0);
    float noise = ss::hash(floor(position) + frame * float2(17.0, 59.0)) - 0.5;
    half3 rgb = ss::straight(color) + half(noise * intensity);
    return ss::premultiplied(rgb, color.a);
}

/// Ordered dithering with a 4 x 4 Bayer matrix: each channel is reduced to `levels` values,
/// and the pattern keeps the average brightness of an area.
[[ stitchable ]] half4 ssDither(float2 position, half4 color, float2 size, float levels) {
    const float bayer[16] = { 0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5 };
    // Bitwise AND on signed integers gives 0...3 for negative positions too, where converting a
    // negative float to an unsigned integer would be undefined.
    int2 cell = int2(floor(position)) & 3;
    half threshold = half((bayer[cell.y * 4 + cell.x] + 0.5) / 16.0);
    half steps = half(levels) - 1.0h;
    half3 rgb = floor(ss::straight(color) * steps + threshold) / steps;
    return ss::premultiplied(rgb, color.a);
}

/// Maps luminance onto a gradient through `count` colors (at least 2): black takes the first
/// color, white the last. Blended with the original by `amount` (0...1).
[[ stitchable ]] half4 ssGradientMap(float2 position, half4 color, float2 size, device const half4 *colors, int count, float amount) {
    // The Swift API always passes at least two colors; a direct call might not, and reading
    // colors[index + 1] would then read past the end of the array.
    if (count < 2) {
        return count == 1 ? ss::premultiplied(mix(ss::straight(color), ss::straight(colors[0]), half(amount)), color.a) : color;
    }
    half3 rgb = ss::straight(color);
    float scaled = float(ss::luminance(rgb)) * float(count - 1);
    int index = clamp(int(floor(scaled)), 0, count - 2);
    half4 tone = mix(colors[index], colors[index + 1], half(scaled - float(index)));
    return ss::premultiplied(mix(rgb, ss::straight(tone), half(amount)), color.a);
}

/// A band of `highlight` that sweeps across the view in the direction of `angle` once every
/// `duration` seconds. `width` is the band's half width as a fraction of the sweep's length.
/// At time 0 the band is just outside the view, so a stopped shimmer shows nothing.
[[ stitchable ]] half4 ssShimmer(float2 position, half4 color, float2 size, float time, half4 highlight, float intensity, float width, float angle, float duration) {
    float2 direction = float2(cos(angle), sin(angle));
    float2 along = float2(size.x * direction.x, size.y * direction.y);
    // The projections of the view's corners onto the direction span [low, high].
    float low = min(0.0, along.x) + min(0.0, along.y);
    float high = max(0.0, along.x) + max(0.0, along.y);
    float band = max(width * (high - low), 1.0);
    float phase = fract(time / duration);
    float center = mix(low - band, high + band, phase);
    float glow = 1.0 - smoothstep(0.0, band, abs(dot(position, direction) - center));
    half3 rgb = mix(ss::straight(color), ss::straight(highlight), half(glow * intensity) * highlight.a);
    return ss::premultiplied(rgb, color.a);
}

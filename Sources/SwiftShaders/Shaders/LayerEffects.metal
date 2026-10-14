// Layer effects: each pixel may read other pixels of the view.
// Used with SwiftUI's layerEffect(_:maxSampleOffset:isEnabled:).

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#include "ShaderCommon.h"
using namespace metal;

/// Fills every `cell` x `cell` square with the color at its center. Centers of the partial
/// squares along the right and bottom edges are moved inside the view.
[[ stitchable ]] half4 ssPixelate(float2 position, SwiftUI::Layer layer, float2 size, float cell) {
    float2 center = (floor(position / cell) + 0.5) * cell;
    return layer.sample(ss::clampInto(center, size));
}

/// Moves the red channel by `offset` and the blue channel by `-offset`.
[[ stitchable ]] half4 ssChromaticAberration(float2 position, SwiftUI::Layer layer, float2 size, float2 offset) {
    half4 red = layer.sample(position - offset);
    half4 green = layer.sample(position);
    half4 blue = layer.sample(position + offset);
    return half4(red.r, green.g, blue.b, max(max(red.a, green.a), blue.a));
}

/// Luminance of the straight color at `point`, read from inside a view of `size`.
static half lumaAt(SwiftUI::Layer layer, float2 point, float2 size) {
    return ss::luminance(ss::straight(layer.sample(ss::clampInto(point, size))));
}

/// Pencil-like outlines: a Sobel filter on luminance, drawn in `line` on `paper`.
[[ stitchable ]] half4 ssSketch(float2 position, SwiftUI::Layer layer, float2 size, float strength, float width, half4 line, half4 paper) {
    float2 dx = float2(width, 0.0);
    float2 dy = float2(0.0, width);
    half topLeft = lumaAt(layer, position - dx - dy, size);
    half top = lumaAt(layer, position - dy, size);
    half topRight = lumaAt(layer, position + dx - dy, size);
    half left = lumaAt(layer, position - dx, size);
    half right = lumaAt(layer, position + dx, size);
    half bottomLeft = lumaAt(layer, position - dx + dy, size);
    half bottom = lumaAt(layer, position + dy, size);
    half bottomRight = lumaAt(layer, position + dx + dy, size);
    half gx = (topRight + 2.0h * right + bottomRight) - (topLeft + 2.0h * left + bottomLeft);
    half gy = (bottomLeft + 2.0h * bottom + bottomRight) - (topLeft + 2.0h * top + topRight);
    half ink = clamp(length(half2(gx, gy)) * half(strength), 0.0h, 1.0h);
    return mix(paper, line, ink) * layer.sample(position).a;
}

/// Raised relief: adds the luminance difference across `offset` to the color, so flat areas keep
/// their color and edges facing the light get brighter.
[[ stitchable ]] half4 ssEmboss(float2 position, SwiftUI::Layer layer, float2 size, float strength, float2 offset) {
    half4 color = layer.sample(position);
    half relief = lumaAt(layer, position - offset, size) - lumaAt(layer, position + offset, size);
    return ss::premultiplied(ss::straight(color) + relief * half(strength), color.a);
}

/// Unsharp mask with the four neighbors `radius` points away.
[[ stitchable ]] half4 ssSharpen(float2 position, SwiftUI::Layer layer, float2 size, float amount, float radius) {
    half4 center = layer.sample(position);
    half4 neighbors = layer.sample(ss::clampInto(position + float2(radius, 0.0), size))
        + layer.sample(ss::clampInto(position - float2(radius, 0.0), size))
        + layer.sample(ss::clampInto(position + float2(0.0, radius), size))
        + layer.sample(ss::clampInto(position - float2(0.0, radius), size));
    half4 sharpened = center * (1.0h + 4.0h * half(amount)) - neighbors * half(amount);
    half alpha = clamp(sharpened.a, 0.0h, 1.0h);
    return half4(clamp(sharpened.rgb, 0.0h, alpha), alpha);
}

/// Black-and-white halftone: a grid of `cell`-sized dots rotated by `angle`, each dot's area
/// proportional to how dark the view is at the dot's center.
[[ stitchable ]] half4 ssHalftone(float2 position, SwiftUI::Layer layer, float2 size, float cell, float angle, half4 ink, half4 paper) {
    float2 rotated = ss::rotate(position, -angle);
    float2 center = (floor(rotated / cell) + 0.5) * cell;
    half4 source = layer.sample(ss::clampInto(ss::rotate(center, angle), size));
    float coverage = 1.0 - float(ss::luminance(ss::straight(source)));
    float radius = cell * sqrt(coverage / ss::pi);
    float inside = 1.0 - smoothstep(radius - 0.5, radius + 0.5, distance(rotated, center));
    return mix(paper, ink, half(inside)) * source.a;
}

/// Mirrors one wedge of the view around `center` into `segments` wedges. Points of the wedge that
/// lie outside the view are mirrored back into it, so the pattern has no transparent gaps.
[[ stitchable ]] half4 ssKaleidoscope(float2 position, SwiftUI::Layer layer, float2 size, float2 center, float segments, float rotation) {
    float2 offset = position - center;
    float wedge = 2.0 * ss::pi / segments;
    float angle = atan2(offset.y, offset.x) - rotation;
    angle = angle - wedge * floor(angle / wedge);
    angle = min(angle, wedge - angle);
    float radius = length(offset);
    return layer.sample(ss::mirrorInto(center + radius * float2(cos(angle + rotation), sin(angle + rotation)), size));
}

/// Horizontal bands that jump sideways with split color channels. The pattern changes 12 times a
/// second; `intensity` (0...1) sets how many bands move and how far.
[[ stitchable ]] half4 ssGlitch(float2 position, SwiftUI::Layer layer, float2 size, float time, float intensity) {
    float frame = floor(time * 12.0);
    float bandHeight = mix(6.0, 28.0, ss::hash(float2(frame, 3.7)));
    float band = floor(position.y / bandHeight);
    float chance = ss::hash(float2(band, frame));
    float shift = 0.0;
    if (chance < intensity * 0.5) {
        shift = (ss::hash(float2(frame, band + 11.0)) - 0.5) * intensity * size.x * 0.2;
    }
    float split = intensity * 4.0;
    half4 red = layer.sample(position - float2(shift + split, 0.0));
    half4 green = layer.sample(position - float2(shift, 0.0));
    half4 blue = layer.sample(position - float2(shift - split, 0.0));
    return half4(red.r, green.g, blue.b, max(max(red.a, green.a), blue.a));
}

/// A ring that spreads from `origin` and fades: the view is displaced along the ring and the
/// crest is brightened. `elapsed` is the time since the ring started, in seconds.
[[ stitchable ]] half4 ssRipple(float2 position, SwiftUI::Layer layer, float2 size, float2 origin, float elapsed, float amplitude, float frequency, float decay, float speed) {
    float2 offset = position - origin;
    float distance = length(offset);
    float local = max(0.0, elapsed - distance / speed);
    float wave = sin(frequency * local) * exp(-decay * local);
    float2 direction = distance > 0.0 ? offset / distance : float2(0.0);
    half4 color = layer.sample(position - direction * amplitude * wave);
    color.rgb += half(0.25 * wave) * color.a;
    return half4(clamp(color.rgb, 0.0h, color.a), color.a);
}

/// One pass of a blur whose radius grows from 0 at `start` to `radius` at `end` (points along
/// the line between them). `step` is (1, 0) for the horizontal pass and (0, 1) for the vertical
/// one; together they make a Gaussian blur. The number of samples is fixed, so the cost per pixel
/// does not depend on the radius.
[[ stitchable ]] half4 ssProgressiveBlur(float2 position, SwiftUI::Layer layer, float2 size, float2 start, float2 end, float radius, float2 step) {
    float2 axis = end - start;
    float progress = clamp(dot(position - start, axis) / max(dot(axis, axis), 1e-4), 0.0, 1.0);
    float local = radius * progress;
    if (local < 0.25) {
        return layer.sample(ss::clampInto(position, size));
    }
    // 2 * taps + 1 samples spread over -local...local; sigma is half the radius.
    const int taps = 24;
    // Accumulated in 32-bit floats: 49 half-precision additions would lose the last bit, and an
    // opaque view would come out with an alpha just below 1.
    float4 sum = float4(0.0);
    float total = 0.0;
    for (int i = -taps; i <= taps; i++) {
        float offset = float(i) / float(taps);
        float2 point = position + step * offset * local;
        // Samples outside the view are left out rather than clamped, so the edge pixels are not
        // repeated and the blur near an edge averages only what is in the view. The center
        // sample is always inside, so `total` is never 0.
        if (any(point < float2(0.0)) || any(point > size)) {
            continue;
        }
        float weight = exp(-2.0 * offset * offset);
        sum += float4(layer.sample(ss::clampInto(point, size))) * weight;
        total += weight;
    }
    return half4(sum / total);
}

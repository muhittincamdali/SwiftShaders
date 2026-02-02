#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// Chromatic aberration color effect.
///
/// Splits the red, green, and blue channels by offsetting their
/// sample positions along a given angle. Simulates lens fringing
/// seen in real camera optics.
///
/// Parameters:
///   position  - current pixel position
///   layer     - the source layer to sample
///   intensity - offset distance in pixels for R and B channels
///   angle     - direction of the channel split in radians

[[ stitchable ]]
half4 chromatic_aberration(
    float2 position,
    SwiftUI::Layer layer,
    float intensity,
    float angle
) {
    float2 direction = float2(cos(angle), sin(angle));
    float2 offset = direction * intensity;
    
    // Sample each channel at a different offset
    half4 redSample = layer.sample(position + offset);
    half4 greenSample = layer.sample(position);
    half4 blueSample = layer.sample(position - offset);
    
    return half4(
        redSample.r,
        greenSample.g,
        blueSample.b,
        greenSample.a
    );
}

/// Radial chromatic aberration — offset increases with distance from center.
[[ stitchable ]]
half4 chromatic_aberration_radial(
    float2 position,
    SwiftUI::Layer layer,
    float2 center,
    float intensity
) {
    float2 delta = position - center;
    float dist = length(delta);
    float2 direction = normalize(delta);
    
    float offset = dist * intensity * 0.01;
    
    half4 r = layer.sample(position + direction * offset);
    half4 g = layer.sample(position);
    half4 b = layer.sample(position - direction * offset);
    
    return half4(r.r, g.g, b.b, g.a);
}

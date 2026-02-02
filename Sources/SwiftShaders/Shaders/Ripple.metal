#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// Ripple distortion effect.
///
/// Creates concentric circular waves emanating from a given origin point.
/// Each pixel is displaced radially based on a sine wave that decays
/// with distance from the origin.
///
/// Parameters:
///   position  - current pixel position
///   origin    - center of the ripple in pixel coordinates
///   time      - elapsed time for animation
///   frequency - number of wave cycles per unit distance
///   amplitude - maximum displacement in pixels
///   decay     - rate at which amplitude diminishes with distance

[[ stitchable ]]
float2 ripple(
    float2 position,
    float2 origin,
    float time,
    float frequency,
    float amplitude,
    float decay
) {
    float2 delta = position - origin;
    float dist = length(delta);
    
    // Avoid division by zero at the exact origin
    if (dist < 0.001) {
        return position;
    }
    
    float2 direction = delta / dist;
    
    // Sine wave that propagates outward over time
    float wave = sin(dist * frequency - time * 10.0);
    
    // Exponential decay so the ripple fades at distance
    float falloff = exp(-dist * decay * 0.01);
    
    // Scale the displacement
    float displacement = wave * amplitude * falloff;
    
    // Push the pixel along the radial direction
    float2 offset = direction * displacement;
    
    return position + offset;
}

/// A secondary ripple variant that uses cosine for a phase-shifted look.
[[ stitchable ]]
float2 ripple_soft(
    float2 position,
    float2 origin,
    float time,
    float frequency,
    float amplitude,
    float decay
) {
    float2 delta = position - origin;
    float dist = length(delta);
    
    if (dist < 0.001) {
        return position;
    }
    
    float2 direction = delta / dist;
    float wave = cos(dist * frequency - time * 8.0);
    float falloff = 1.0 / (1.0 + dist * decay * 0.02);
    float displacement = wave * amplitude * falloff;
    
    return position + direction * displacement;
}

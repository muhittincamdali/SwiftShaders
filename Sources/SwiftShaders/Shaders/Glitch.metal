#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// Pseudo-random hash for glitch block generation.
float glitch_hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

/// Digital glitch distortion effect.
///
/// Randomly offsets horizontal blocks of pixels to simulate
/// digital signal corruption. The pattern changes with time
/// for an animated jittering look.
///
/// Parameters:
///   position  - current pixel position
///   layer     - source layer
///   time      - elapsed time in seconds
///   intensity - how far blocks can shift (0 to 1)
///   speed     - animation speed multiplier
///   blockSize - height of each glitch block in pixels

[[ stitchable ]]
half4 glitch(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float intensity,
    float speed,
    float blockSize
) {
    // Quantize the y position into blocks
    float blockY = floor(position.y / blockSize);
    
    // Time-varying seed per block
    float seed = blockY + floor(time * speed) * 100.0;
    float random = glitch_hash(seed);
    
    // Only glitch some blocks (threshold based on intensity)
    float threshold = 1.0 - intensity;
    float2 samplePos = position;
    
    if (random > threshold) {
        // Offset the x position by a random amount
        float offsetAmount = (glitch_hash(seed + 1.0) - 0.5) * 2.0;
        samplePos.x += offsetAmount * intensity * 50.0;
    }
    
    // Occasionally shift color channels too
    float channelSeed = glitch_hash(seed + 2.0);
    if (channelSeed > (1.0 - intensity * 0.3)) {
        half4 r = layer.sample(samplePos + float2(intensity * 3.0, 0));
        half4 g = layer.sample(samplePos);
        half4 b = layer.sample(samplePos - float2(intensity * 3.0, 0));
        return half4(r.r, g.g, b.b, g.a);
    }
    
    return layer.sample(samplePos);
}

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Wave Distortion Shader
// Creates various wave-based distortion effects for fluid animations.

/// Basic sine wave distortion.
/// Creates smooth, periodic wave patterns.
///
/// - Parameters:
///   - position: Current pixel position.
///   - bounds: View bounds.
///   - time: Animation time.
///   - amplitude: Wave height.
///   - frequency: Number of waves.
///   - direction: 0 = horizontal, 1 = vertical.
[[ stitchable ]]
float2 wave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float direction
) {
    float2 uv = position / bounds.zw;
    float2 offset = float2(0.0);
    
    if (direction < 0.5) {
        // Horizontal wave (affects Y based on X)
        offset.y = sin(uv.x * frequency * 10.0 + time * 5.0) * amplitude * bounds.w;
    } else {
        // Vertical wave (affects X based on Y)
        offset.x = sin(uv.y * frequency * 10.0 + time * 5.0) * amplitude * bounds.z;
    }
    
    return position + offset;
}

/// Multi-directional wave effect.
/// Combines horizontal and vertical waves.
[[ stitchable ]]
float2 multiWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitudeX,
    float amplitudeY,
    float frequencyX,
    float frequencyY,
    float speed
) {
    float2 uv = position / bounds.zw;
    
    float waveX = sin(uv.y * frequencyY * 10.0 + time * speed) * amplitudeX * bounds.z;
    float waveY = sin(uv.x * frequencyX * 10.0 + time * speed * 1.3) * amplitudeY * bounds.w;
    
    return position + float2(waveX, waveY);
}

/// Radial wave distortion.
/// Creates circular waves emanating from center.
[[ stitchable ]]
float2 radialWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float centerX,
    float centerY
) {
    float2 center = float2(centerX, centerY) * bounds.zw;
    float2 delta = position - center;
    float dist = length(delta);
    float2 direction = normalize(delta + 0.0001);
    
    float wave = sin(dist * frequency * 0.1 - time * 5.0) * amplitude;
    
    return position + direction * wave * min(bounds.z, bounds.w) * 0.1;
}

/// Flag wave effect.
/// Simulates cloth/flag waving in wind.
[[ stitchable ]]
float2 flagWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float windSpeed
) {
    float2 uv = position / bounds.zw;
    
    // Wave increases toward the right (flag pole on left)
    float distFromPole = uv.x;
    
    // Multiple wave frequencies for realistic cloth
    float wave1 = sin(uv.x * frequency * 5.0 - time * windSpeed) * amplitude;
    float wave2 = sin(uv.x * frequency * 8.0 - time * windSpeed * 1.3) * amplitude * 0.5;
    float wave3 = sin(uv.y * frequency * 3.0 - time * windSpeed * 0.8) * amplitude * 0.3;
    
    float totalWave = (wave1 + wave2 + wave3) * distFromPole;
    
    return position + float2(0.0, totalWave * bounds.w);
}

/// Liquid wave surface effect.
/// Simulates water surface distortion.
[[ stitchable ]]
float2 liquidWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float turbulence,
    float viscosity
) {
    float2 uv = position / bounds.zw;
    
    // Multiple overlapping waves
    float wave1 = sin(uv.x * 10.0 + time * 3.0) * sin(uv.y * 8.0 + time * 2.5);
    float wave2 = sin(uv.x * 15.0 - time * 2.0) * sin(uv.y * 12.0 - time * 3.0);
    float wave3 = sin(uv.x * 20.0 + uv.y * 20.0 + time * 4.0);
    
    float combined = (wave1 + wave2 * 0.5 + wave3 * 0.25) * amplitude / (1.0 + viscosity);
    
    // Add turbulence noise
    float noise = fract(sin(dot(uv + time * 0.1, float2(12.9898, 78.233))) * 43758.5453);
    combined += noise * turbulence * 0.1;
    
    float2 offset = float2(combined, combined) * bounds.zw * 0.05;
    
    return position + offset;
}

/// Jelly/gelatin wobble effect.
[[ stitchable ]]
float2 jellyWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float stiffness,
    float damping
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(0.5);
    float2 delta = uv - center;
    float dist = length(delta);
    
    // Damped oscillation
    float dampedTime = time * (1.0 - damping * 0.5);
    float wobble = sin(dampedTime * stiffness * 5.0) * exp(-time * damping);
    
    // Apply wobble based on distance from center
    float2 offset = delta * wobble * amplitude;
    
    // Add secondary ripples
    float ripple = sin(dist * 20.0 - time * 8.0) * amplitude * 0.2 * exp(-dist * 3.0);
    offset += normalize(delta + 0.0001) * ripple;
    
    return position + offset * bounds.zw;
}

/// Spiral wave effect.
[[ stitchable ]]
float2 spiralWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float rotationSpeed
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(0.5);
    float2 delta = uv - center;
    
    float dist = length(delta);
    float angle = atan2(delta.y, delta.x);
    
    // Spiral modulation
    float spiral = sin(angle * frequency + dist * 20.0 - time * rotationSpeed) * amplitude;
    
    // Apply as radial displacement
    float2 offset = normalize(delta + 0.0001) * spiral * bounds.zw * 0.05;
    
    return position + offset;
}

/// Earthquake/shake wave effect.
[[ stitchable ]]
float2 shakeWave(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float frequency
) {
    // Random shake using hash
    float noise1 = fract(sin(time * frequency * 10.0) * 43758.5453);
    float noise2 = fract(sin(time * frequency * 10.0 + 1.0) * 43758.5453);
    
    float2 shake = (float2(noise1, noise2) - 0.5) * 2.0 * intensity;
    
    // Decay shake over distance from center
    float2 uv = position / bounds.zw;
    float dist = length(uv - 0.5);
    shake *= (1.0 - dist);
    
    return position + shake * bounds.zw * 0.1;
}

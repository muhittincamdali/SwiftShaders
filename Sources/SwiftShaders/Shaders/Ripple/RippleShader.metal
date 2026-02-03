#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Ripple Effect Shader
// Creates water-like ripple distortion effects with customizable parameters.
// Supports multiple ripple origins, variable amplitude, and decay.

/// Calculates the distance from a point to the ripple origin.
/// - Parameters:
///   - position: Current pixel position (normalized).
///   - origin: Center of the ripple (normalized).
/// - Returns: Euclidean distance from origin.
float rippleDistance(float2 position, float2 origin) {
    float2 delta = position - origin;
    return length(delta);
}

/// Calculates ripple displacement at a given distance and time.
/// - Parameters:
///   - distance: Distance from ripple origin.
///   - time: Animation time.
///   - amplitude: Wave amplitude.
///   - frequency: Wave frequency.
///   - decay: Decay rate.
///   - speed: Wave propagation speed.
/// - Returns: Displacement value.
float rippleWave(float distance, float time, float amplitude, float frequency, float decay, float speed) {
    float wave = sin(distance * frequency - time * speed);
    float envelope = exp(-distance * decay);
    return wave * amplitude * envelope;
}

/// Single ripple distortion effect.
/// Creates a circular ripple emanating from a center point.
///
/// - Parameters:
///   - position: Sampling position.
///   - bounds: View bounds.
///   - time: Animation time.
///   - originX: Ripple center X (normalized 0-1).
///   - originY: Ripple center Y (normalized 0-1).
///   - amplitude: Distortion strength.
///   - frequency: Wave count.
///   - decay: Falloff rate.
[[ stitchable ]]
float2 ripple(
    float2 position,
    float4 bounds,
    float time,
    float originX,
    float originY,
    float amplitude,
    float frequency,
    float decay
) {
    // Normalize position to 0-1 range
    float2 normalizedPos = position / bounds.zw;
    float2 origin = float2(originX, originY);
    
    // Calculate distance and direction
    float dist = rippleDistance(normalizedPos, origin);
    float2 direction = normalize(normalizedPos - origin + 0.0001);
    
    // Calculate wave displacement
    float wave = rippleWave(dist, time, amplitude, frequency, decay, 10.0);
    
    // Apply displacement
    float2 displacement = direction * wave * bounds.zw;
    
    return position + displacement;
}

/// Multi-ripple distortion effect.
/// Creates multiple overlapping ripples for complex patterns.
[[ stitchable ]]
float2 multiRipple(
    float2 position,
    float4 bounds,
    float time,
    float rippleCount,
    float amplitude,
    float frequency,
    float decay
) {
    float2 normalizedPos = position / bounds.zw;
    float2 totalDisplacement = float2(0.0);
    
    // Generate multiple ripples at pseudo-random positions
    for (int i = 0; i < int(rippleCount); i++) {
        float phase = float(i) / rippleCount;
        float2 origin = float2(
            fract(sin(float(i) * 12.9898) * 43758.5453),
            fract(sin(float(i) * 78.233) * 43758.5453)
        );
        
        float dist = rippleDistance(normalizedPos, origin);
        float2 direction = normalize(normalizedPos - origin + 0.0001);
        float wave = rippleWave(dist, time + phase * 2.0, amplitude / rippleCount, frequency, decay, 8.0);
        
        totalDisplacement += direction * wave;
    }
    
    return position + totalDisplacement * bounds.zw;
}

/// Interactive ripple with touch response.
/// Responds to touch location with expanding ripple.
[[ stitchable ]]
float2 touchRipple(
    float2 position,
    float4 bounds,
    float time,
    float touchX,
    float touchY,
    float touchTime,
    float amplitude,
    float frequency
) {
    float2 normalizedPos = position / bounds.zw;
    float2 touchPoint = float2(touchX, touchY);
    
    // Time since touch
    float elapsed = time - touchTime;
    if (elapsed < 0.0) {
        return position;
    }
    
    // Expanding wave front
    float waveRadius = elapsed * 0.5;
    float dist = rippleDistance(normalizedPos, touchPoint);
    
    // Only affect area within wave front
    if (dist > waveRadius) {
        return position;
    }
    
    float2 direction = normalize(normalizedPos - touchPoint + 0.0001);
    
    // Wave with expanding envelope
    float wave = sin((dist - waveRadius) * frequency * 20.0);
    float envelope = exp(-elapsed * 2.0) * exp(-abs(dist - waveRadius) * 50.0);
    float displacement = wave * amplitude * envelope;
    
    return position + direction * displacement * bounds.zw;
}

/// Concentric rings ripple effect.
/// Creates sharp concentric ring patterns.
[[ stitchable ]]
float2 concentricRipple(
    float2 position,
    float4 bounds,
    float time,
    float originX,
    float originY,
    float ringWidth,
    float amplitude,
    float speed
) {
    float2 normalizedPos = position / bounds.zw;
    float2 origin = float2(originX, originY);
    
    float dist = rippleDistance(normalizedPos, origin);
    float2 direction = normalize(normalizedPos - origin + 0.0001);
    
    // Create sharp rings
    float ring = fract(dist * (1.0 / ringWidth) - time * speed);
    float sharpRing = smoothstep(0.0, 0.1, ring) * smoothstep(1.0, 0.9, ring);
    
    // Apply as displacement
    float displacement = (sharpRing - 0.5) * amplitude;
    
    return position + direction * displacement * bounds.zw;
}

/// Damped harmonic ripple.
/// Physically accurate damped oscillation.
[[ stitchable ]]
float2 dampedRipple(
    float2 position,
    float4 bounds,
    float time,
    float originX,
    float originY,
    float amplitude,
    float frequency,
    float damping
) {
    float2 normalizedPos = position / bounds.zw;
    float2 origin = float2(originX, originY);
    
    float dist = rippleDistance(normalizedPos, origin);
    float2 direction = normalize(normalizedPos - origin + 0.0001);
    
    // Damped harmonic motion
    float omega = frequency * 2.0 * M_PI_F;
    float dampedFreq = omega * sqrt(1.0 - damping * damping);
    float envelope = exp(-damping * omega * dist);
    float wave = envelope * cos(dampedFreq * dist - time * omega);
    
    return position + direction * wave * amplitude * bounds.zw;
}

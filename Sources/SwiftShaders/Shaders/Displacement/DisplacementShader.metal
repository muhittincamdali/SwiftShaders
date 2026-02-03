#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Displacement Map Shader
// Provides various displacement and distortion effects that warp
// pixel positions based on mathematical functions and patterns.

// MARK: - Utility Functions

/// Pseudo-random hash function.
float dispHash(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

/// 2D noise function for smooth displacement.
float dispNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float a = dispHash(i);
    float b = dispHash(i + float2(1.0, 0.0));
    float c = dispHash(i + float2(0.0, 1.0));
    float d = dispHash(i + float2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

/// Fractal Brownian Motion noise.
float dispFBM(float2 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        value += amplitude * dispNoise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    return value;
}

/// Gradient noise for smooth displacement vectors.
float2 dispGradNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    
    float2 u = f * f * (3.0 - 2.0 * f);
    
    float n00 = dispHash(i);
    float n10 = dispHash(i + float2(1.0, 0.0));
    float n01 = dispHash(i + float2(0.0, 1.0));
    float n11 = dispHash(i + float2(1.0, 1.0));
    
    float dx = mix(n10 - n00, n11 - n01, u.y);
    float dy = mix(n01 - n00, n11 - n10, u.x);
    
    return float2(dx, dy);
}

// MARK: - Basic Displacement Effects

/// Sine wave displacement.
[[ stitchable ]]
float2 sineDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float amplitudeX,
    float amplitudeY,
    float frequencyX,
    float frequencyY
) {
    float2 uv = position / bounds.zw;
    
    float offsetX = sin(uv.y * frequencyY * 6.28318 + time) * amplitudeX * bounds.z;
    float offsetY = sin(uv.x * frequencyX * 6.28318 + time * 0.8) * amplitudeY * bounds.w;
    
    return position + float2(offsetX, offsetY);
}

/// Noise-based displacement.
[[ stitchable ]]
float2 noiseDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float scale,
    float amount,
    float speed
) {
    float2 uv = position / bounds.zw;
    
    // Animated noise
    float2 noiseCoord = uv * scale + time * speed;
    float2 offset = float2(
        dispNoise(noiseCoord) - 0.5,
        dispNoise(noiseCoord + 100.0) - 0.5
    ) * amount * bounds.zw;
    
    return position + offset;
}

/// FBM (Fractal Brownian Motion) displacement.
[[ stitchable ]]
float2 fbmDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float scale,
    float amount,
    float octaves
) {
    float2 uv = position / bounds.zw;
    
    int numOctaves = clamp(int(octaves), 1, 8);
    
    float2 noiseCoord = uv * scale;
    float2 offset = float2(
        dispFBM(noiseCoord + time * 0.5, numOctaves) - 0.5,
        dispFBM(noiseCoord + float2(50.0, 0.0) + time * 0.3, numOctaves) - 0.5
    ) * amount * bounds.zw;
    
    return position + offset;
}

/// Radial displacement from center.
[[ stitchable ]]
float2 radialDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float frequency,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 dir = uv - center;
    float dist = length(dir);
    float2 normDir = normalize(dir);
    
    // Radial wave
    float wave = sin(dist * frequency * 10.0 - time * 3.0);
    float2 offset = normDir * wave * amount * bounds.z * dist;
    
    return position + offset;
}

/// Spiral displacement.
[[ stitchable ]]
float2 spiralDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float tightness,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 dir = uv - center;
    float dist = length(dir);
    float angle = atan2(dir.y, dir.x);
    
    // Spiral offset
    float spiralAngle = angle + dist * tightness * 10.0 + time;
    float spiralAmount = amount * (1.0 - dist);
    
    float2 offset = float2(
        cos(spiralAngle) * spiralAmount,
        sin(spiralAngle) * spiralAmount
    ) * bounds.zw * 0.1;
    
    return position + offset;
}

// MARK: - Advanced Displacement Effects

/// Heat distortion effect.
[[ stitchable ]]
float2 heatDistortion(
    float2 position,
    float4 bounds,
    float time,
    float intensity,
    float riseFactor,
    float turbulence
) {
    float2 uv = position / bounds.zw;
    
    // Rising heat waves
    float2 noiseCoord = float2(uv.x * turbulence, uv.y + time * riseFactor);
    float noise = dispNoise(noiseCoord * 10.0);
    
    // Horizontal shimmer
    float shimmer = sin(uv.y * 50.0 + time * 5.0 + noise * 10.0);
    
    // More distortion at bottom (where heat rises from)
    float heightFactor = 1.0 - uv.y;
    heightFactor = pow(heightFactor, 0.5);
    
    float offsetX = shimmer * intensity * heightFactor * bounds.z * 0.02;
    
    return float2(position.x + offsetX, position.y);
}

/// Underwater caustic displacement.
[[ stitchable ]]
float2 underwaterDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float waveScale,
    float waveAmount,
    float depthFactor
) {
    float2 uv = position / bounds.zw;
    
    // Multiple wave layers
    float wave1 = sin(uv.x * waveScale * 5.0 + time * 2.0) * cos(uv.y * waveScale * 3.0 + time * 1.5);
    float wave2 = sin(uv.x * waveScale * 7.0 - time * 1.7) * cos(uv.y * waveScale * 5.0 + time);
    
    // Depth attenuation
    float depth = uv.y * depthFactor;
    
    float2 offset = float2(
        (wave1 + wave2 * 0.5) * waveAmount * depth,
        wave1 * 0.3 * waveAmount * depth
    ) * bounds.zw * 0.03;
    
    return position + offset;
}

/// Shockwave displacement.
[[ stitchable ]]
float2 shockwaveDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float centerX,
    float centerY,
    float waveWidth,
    float amplitude
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float dist = distance(uv, center);
    
    // Expanding ring
    float ringPos = fract(time * 0.5);
    float ringDist = abs(dist - ringPos);
    
    // Wave shape
    float wave = smoothstep(waveWidth, 0.0, ringDist);
    wave *= sin(ringDist / waveWidth * 3.14159);
    
    // Fade out as ring expands
    wave *= 1.0 - ringPos;
    
    // Direction from center
    float2 dir = normalize(uv - center);
    float2 offset = dir * wave * amplitude * bounds.z;
    
    return position + offset;
}

/// Lens barrel/pincushion distortion.
[[ stitchable ]]
float2 lensDistortion(
    float2 position,
    float4 bounds,
    float time,
    float k1,
    float k2,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float r2 = dot(delta, delta);
    float r4 = r2 * r2;
    
    // Radial distortion
    float distortion = 1.0 + k1 * r2 + k2 * r4;
    
    // Animate subtle pulsing
    distortion *= 1.0 + sin(time * 2.0) * 0.02;
    
    float2 newUV = center + delta * distortion;
    
    return newUV * bounds.zw;
}

/// Flag waving effect.
[[ stitchable ]]
float2 flagWave(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float propagation
) {
    float2 uv = position / bounds.zw;
    
    // Wave propagates from left to right
    float phase = uv.x * propagation + time * 3.0;
    
    // Primary wave
    float wave = sin(phase * frequency) * amplitude;
    
    // Secondary ripple
    float ripple = sin(phase * frequency * 2.0 + time) * amplitude * 0.3;
    
    // Amplitude increases towards the right (free end)
    float xFactor = pow(uv.x, 1.5);
    
    float offsetY = (wave + ripple) * xFactor * bounds.w * 0.1;
    
    // Slight horizontal compression at wave peaks
    float offsetX = cos(phase * frequency) * amplitude * 0.2 * xFactor * bounds.z * 0.05;
    
    return position + float2(offsetX, offsetY);
}

// MARK: - Geometric Displacement

/// Spherize/bulge effect.
[[ stitchable ]]
float2 spherize(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float radius,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float dist = length(delta);
    
    if (dist < radius) {
        // Spherical bulge
        float normalizedDist = dist / radius;
        float bulgeFactor = sqrt(1.0 - normalizedDist * normalizedDist);
        
        // Animate
        bulgeFactor *= 1.0 + sin(time * 2.0) * 0.1 * amount;
        
        float2 newDelta = delta * (1.0 - amount * bulgeFactor * (1.0 - normalizedDist));
        return (center + newDelta) * bounds.zw;
    }
    
    return position;
}

/// Twirl/twist effect.
[[ stitchable ]]
float2 twirl(
    float2 position,
    float4 bounds,
    float time,
    float angle,
    float radius,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float dist = length(delta);
    
    if (dist < radius) {
        // Twist amount decreases with distance from center
        float normalizedDist = dist / radius;
        float twirlAmount = (1.0 - normalizedDist) * angle;
        twirlAmount += sin(time) * 0.5; // Animate
        
        float cosAngle = cos(twirlAmount);
        float sinAngle = sin(twirlAmount);
        
        float2 newDelta = float2(
            delta.x * cosAngle - delta.y * sinAngle,
            delta.x * sinAngle + delta.y * cosAngle
        );
        
        return (center + newDelta) * bounds.zw;
    }
    
    return position;
}

/// Pinch effect.
[[ stitchable ]]
float2 pinch(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float radius,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float dist = length(delta);
    
    if (dist < radius && dist > 0.001) {
        float normalizedDist = dist / radius;
        
        // Pinch factor
        float pinchFactor = pow(normalizedDist, amount);
        pinchFactor *= 1.0 + sin(time * 3.0) * 0.1; // Animate
        
        float2 newDelta = normalize(delta) * radius * pinchFactor;
        return (center + newDelta) * bounds.zw;
    }
    
    return position;
}

/// Zigzag displacement.
[[ stitchable ]]
float2 zigzag(
    float2 position,
    float4 bounds,
    float time,
    float amplitude,
    float frequency,
    float angle
) {
    float2 uv = position / bounds.zw;
    
    // Rotate coordinates
    float cosA = cos(angle);
    float sinA = sin(angle);
    float2 rotUV = float2(
        uv.x * cosA - uv.y * sinA,
        uv.x * sinA + uv.y * cosA
    );
    
    // Triangle wave (zigzag)
    float t = rotUV.y * frequency + time;
    float zigzagWave = abs(fract(t) - 0.5) * 4.0 - 1.0;
    
    float2 offset = float2(
        cosA * zigzagWave * amplitude,
        sinA * zigzagWave * amplitude
    ) * bounds.zw * 0.1;
    
    return position + offset;
}

// MARK: - Organic Displacement

/// Blob/organic morphing displacement.
[[ stitchable ]]
float2 blobDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float scale,
    float amount,
    float smoothness
) {
    float2 uv = position / bounds.zw;
    
    // Multiple noise layers for organic feel
    float2 n1 = dispGradNoise(uv * scale + time * 0.3);
    float2 n2 = dispGradNoise(uv * scale * 2.0 - time * 0.2);
    float2 n3 = dispGradNoise(uv * scale * 0.5 + time * 0.1);
    
    // Combine with different weights
    float2 combined = n1 * 0.5 + n2 * 0.3 + n3 * 0.2;
    
    // Smooth the displacement
    combined = mix(float2(0.0), combined, smoothness);
    
    float2 offset = combined * amount * bounds.zw * 0.2;
    
    return position + offset;
}

/// Muscle/tension displacement.
[[ stitchable ]]
float2 tensionDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float strength,
    float frequency,
    float direction
) {
    float2 uv = position / bounds.zw;
    
    // Direction vector
    float2 dir = float2(cos(direction), sin(direction));
    
    // Project position onto direction
    float proj = dot(uv - 0.5, dir);
    
    // Tension wave
    float tension = sin(proj * frequency * 10.0 + time * 4.0);
    tension = tension * tension * sign(tension); // Sharper peaks
    
    // Perpendicular displacement
    float2 perpDir = float2(-dir.y, dir.x);
    float2 offset = perpDir * tension * strength * bounds.zw * 0.05;
    
    return position + offset;
}

/// Breathing/pulsing displacement.
[[ stitchable ]]
float2 breathingDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float speed,
    float centerX,
    float centerY
) {
    float2 uv = position / bounds.zw;
    float2 center = float2(centerX, centerY);
    
    float2 delta = uv - center;
    float dist = length(delta);
    
    // Breathing cycle
    float breath = sin(time * speed) * 0.5 + 0.5;
    breath = pow(breath, 0.7); // Ease curve
    
    // Expansion from center
    float expansion = 1.0 + breath * amount * (1.0 - dist);
    
    float2 newDelta = delta * expansion;
    
    return (center + newDelta) * bounds.zw;
}

// MARK: - Glitch Displacement

/// Digital block displacement.
[[ stitchable ]]
float2 blockDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float blockSize,
    float amount,
    float probability
) {
    float2 uv = position / bounds.zw;
    
    // Grid of blocks
    float2 blockCoord = floor(uv / blockSize);
    float blockRand = dispHash(blockCoord + floor(time * 8.0));
    
    if (blockRand < probability) {
        // Random offset for this block
        float2 offset = float2(
            (dispHash(blockCoord * 2.0 + time) - 0.5) * 2.0,
            (dispHash(blockCoord * 3.0 + time) - 0.5) * 2.0
        ) * amount * bounds.zw * 0.1;
        
        return position + offset;
    }
    
    return position;
}

/// Scanline jitter displacement.
[[ stitchable ]]
float2 scanlineJitter(
    float2 position,
    float4 bounds,
    float time,
    float lineHeight,
    float jitterAmount,
    float probability
) {
    float2 uv = position / bounds.zw;
    
    // Scan line index
    float lineIndex = floor(uv.y / lineHeight);
    float lineRand = dispHash(float2(lineIndex, floor(time * 20.0)));
    
    if (lineRand < probability) {
        // Horizontal jitter
        float jitter = (dispHash(float2(lineIndex * 7.0, time)) - 0.5) * jitterAmount;
        return float2(position.x + jitter * bounds.z, position.y);
    }
    
    return position;
}

/// Chromatic split displacement (for RGB channels).
[[ stitchable ]]
float2 chromaticSplit(
    float2 position,
    float4 bounds,
    float time,
    float amount,
    float angle,
    float channel
) {
    float2 direction = float2(cos(angle + time * 0.5), sin(angle + time * 0.5));
    
    // Different offset per channel
    float channelOffset = (channel - 1.0) * amount;
    float2 offset = direction * channelOffset * bounds.z * 0.02;
    
    return position + offset;
}

// MARK: - Natural Displacement

/// Wind effect displacement.
[[ stitchable ]]
float2 windDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float strength,
    float gustiness,
    float direction
) {
    float2 uv = position / bounds.zw;
    
    // Wind direction
    float2 windDir = float2(cos(direction), sin(direction));
    
    // Base wind
    float wind = sin(time * 2.0 + uv.x * 5.0 + uv.y * 3.0);
    
    // Gusts (irregular stronger bursts)
    float gust = dispNoise(float2(time * gustiness, 0.0)) * 2.0 - 0.5;
    gust = max(0.0, gust);
    
    // Combined
    float totalWind = (wind + gust * 2.0) * strength;
    
    // More effect at top (like grass)
    float heightFactor = uv.y;
    
    float2 offset = windDir * totalWind * heightFactor * bounds.z * 0.05;
    
    return position + offset;
}

/// Gravity drip displacement.
[[ stitchable ]]
float2 gravityDrip(
    float2 position,
    float4 bounds,
    float time,
    float dripSpeed,
    float dripAmount,
    float viscosity
) {
    float2 uv = position / bounds.zw;
    
    // Multiple drip streams
    float streamX = floor(uv.x * 10.0) / 10.0;
    float streamPhase = dispHash(float2(streamX, 0.0)) * 6.28;
    
    // Drip timing
    float dripTime = fract(time * dripSpeed + streamPhase);
    
    // Drip shape (bulge that travels down)
    float dripY = dripTime;
    float distFromDrip = abs(uv.y - dripY);
    float dripInfluence = smoothstep(0.15 * viscosity, 0.0, distFromDrip);
    
    // Horizontal squish near drip
    float squish = (uv.x - streamX - 0.05) * dripInfluence * dripAmount;
    
    // Vertical stretch
    float stretch = dripInfluence * dripAmount * 0.5;
    
    return position + float2(squish, stretch) * bounds.zw * 0.1;
}

/// Earthquake/shake displacement.
[[ stitchable ]]
float2 earthquakeDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float magnitude,
    float frequency,
    float decay
) {
    // High-frequency shake
    float shakeX = sin(time * frequency * 50.0) * cos(time * frequency * 37.0);
    float shakeY = sin(time * frequency * 43.0) * cos(time * frequency * 51.0);
    
    // Decay over time
    float envelope = exp(-time * decay);
    envelope = max(0.0, envelope);
    
    float2 shake = float2(shakeX, shakeY) * magnitude * envelope * bounds.z * 0.02;
    
    return position + shake;
}

/// Magnetic field displacement.
[[ stitchable ]]
float2 magneticDisplacement(
    float2 position,
    float4 bounds,
    float time,
    float strength,
    float poleX,
    float poleY
) {
    float2 uv = position / bounds.zw;
    float2 pole = float2(poleX, poleY);
    
    float2 delta = uv - pole;
    float dist = length(delta);
    
    // Magnetic field lines (perpendicular to radial)
    float2 fieldDir = float2(-delta.y, delta.x);
    if (dist > 0.001) {
        fieldDir = normalize(fieldDir);
    }
    
    // Field strength falls off with distance
    float fieldStrength = 1.0 / (dist * dist + 0.1);
    fieldStrength = min(fieldStrength, 5.0);
    
    // Oscillating field
    float oscillation = sin(time * 3.0 + dist * 10.0);
    
    float2 offset = fieldDir * fieldStrength * oscillation * strength * bounds.z * 0.01;
    
    return position + offset;
}

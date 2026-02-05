// Scanlines Effect Shader
// Creates retro scanline and TV line effects
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Scanlines simulate old CRT/TV displays by:
// 1. Creating horizontal lines at regular intervals
// 2. Modulating brightness based on line position
// 3. Optionally adding flicker and RGB separation
// 4. Supporting both additive and multiplicative modes
// =============================================================================

// =============================================================================
// COLOR EFFECT: Basic Scanlines
// =============================================================================
// Parameters:
// - size: View dimensions
// - lineCount: Number of scanlines (default: 240)
// - intensity: Line darkness (0.0-1.0, default: 0.3)
// - brightness: Overall brightness (0.5-1.5, default: 1.0)
// =============================================================================
[[stitchable]] half4 scanlines(
    float2 position,
    half4 color,
    float2 size,
    float lineCount,
    float intensity,
    float brightness
) {
    float y = position.y / size.y;
    
    // Create scanline pattern
    float scanline = sin(y * lineCount * 3.14159) * 0.5 + 0.5;
    scanline = pow(scanline, 0.5); // Soften the transition
    
    // Apply intensity
    float multiplier = 1.0 - intensity * (1.0 - scanline);
    
    // Apply brightness
    half3 result = color.rgb * half(multiplier * brightness);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Interlaced Scanlines
// =============================================================================
[[stitchable]] half4 scanlinesInterlaced(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float lineCount,
    float intensity
) {
    float y = position.y / size.y;
    
    // Alternate which lines are visible (interlace simulation)
    float frame = floor(fmod(time * 30.0, 2.0));
    float linePhase = fmod(floor(y * lineCount), 2.0);
    
    // Only show every other line, alternating each frame
    float visible = 1.0;
    if (linePhase == frame) {
        visible = 1.0 - intensity;
    }
    
    half3 result = color.rgb * half(visible);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: VHS Scanlines
// =============================================================================
[[stitchable]] half4 scanlinesVHS(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float intensity,
    float noiseAmount
) {
    float2 uv = position / size;
    
    // Basic scanline
    float scanline = sin(uv.y * 480.0 * 3.14159) * 0.5 + 0.5;
    
    // VHS noise
    float noise = fract(sin(dot(uv + fract(time * 10.0), float2(12.9898, 78.233))) * 43758.5453);
    
    // Horizontal jitter
    float jitter = (noise - 0.5) * noiseAmount * 0.01;
    
    // Color bleeding
    half3 result = color.rgb;
    result.r = color.r + half(jitter);
    
    // Apply scanline
    result *= half(1.0 - intensity * (1.0 - scanline));
    
    // Add noise
    result += half3(noise * noiseAmount * 0.1);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: LCD Pixel Grid
// =============================================================================
[[stitchable]] half4 scanlinesLCD(
    float2 position,
    half4 color,
    float2 size,
    float pixelSize,
    float gapSize,
    float intensity
) {
    // Create pixel grid
    float2 pixel = fmod(position, float2(pixelSize));
    
    // Gap between pixels
    float gapX = step(pixelSize - gapSize, pixel.x);
    float gapY = step(pixelSize - gapSize, pixel.y);
    float gap = max(gapX, gapY);
    
    // Darken gaps
    float multiplier = 1.0 - gap * intensity;
    
    // Sub-pixel simulation (RGB stripes)
    float subpixel = fmod(position.x, pixelSize * 3.0);
    half3 result = color.rgb;
    
    if (subpixel < pixelSize) {
        result *= half3(1.2, 0.9, 0.9); // R emphasis
    } else if (subpixel < pixelSize * 2.0) {
        result *= half3(0.9, 1.2, 0.9); // G emphasis
    } else {
        result *= half3(0.9, 0.9, 1.2); // B emphasis
    }
    
    result *= half(multiplier);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Rolling Scanline
// =============================================================================
[[stitchable]] half4 scanlinesRolling(
    float2 position,
    half4 color,
    float2 size,
    float time,
    float speed,
    float width,
    float intensity
) {
    float y = position.y / size.y;
    
    // Animated position of the bright band
    float bandPos = fmod(time * speed, 1.0);
    
    // Distance from band
    float dist = abs(y - bandPos);
    if (dist > 0.5) dist = 1.0 - dist; // Wrap around
    
    // Bright band
    float band = smoothstep(width, 0.0, dist);
    
    // Regular scanlines
    float scanline = sin(y * 480.0 * 3.14159) * 0.5 + 0.5;
    
    // Combine
    float multiplier = (1.0 - intensity * (1.0 - scanline)) * (1.0 + band * 0.3);
    
    half3 result = color.rgb * half(multiplier);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Diagonal Lines
// =============================================================================
[[stitchable]] half4 scanlinesDiagonal(
    float2 position,
    half4 color,
    float2 size,
    float angle,
    float spacing,
    float intensity
) {
    // Rotate coordinates
    float cosA = cos(angle);
    float sinA = sin(angle);
    float2 rotated = float2(
        position.x * cosA - position.y * sinA,
        position.x * sinA + position.y * cosA
    );
    
    // Create diagonal lines
    float line = sin(rotated.y / spacing * 3.14159) * 0.5 + 0.5;
    
    float multiplier = 1.0 - intensity * (1.0 - line);
    
    half3 result = color.rgb * half(multiplier);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Gradient Scanlines
// =============================================================================
[[stitchable]] half4 scanlinesGradient(
    float2 position,
    half4 color,
    float2 size,
    float lineCount,
    float topIntensity,
    float bottomIntensity
) {
    float2 uv = position / size;
    
    // Scanline pattern
    float scanline = sin(uv.y * lineCount * 3.14159) * 0.5 + 0.5;
    
    // Intensity varies from top to bottom
    float intensity = mix(topIntensity, bottomIntensity, uv.y);
    
    float multiplier = 1.0 - intensity * (1.0 - scanline);
    
    half3 result = color.rgb * half(multiplier);
    
    return half4(result, color.a);
}

// =============================================================================
// COLOR EFFECT: Double Scanlines (horizontal + vertical)
// =============================================================================
[[stitchable]] half4 scanlinesDouble(
    float2 position,
    half4 color,
    float2 size,
    float horizontalCount,
    float verticalCount,
    float intensity
) {
    float2 uv = position / size;
    
    // Horizontal scanlines
    float hLine = sin(uv.y * horizontalCount * 3.14159) * 0.5 + 0.5;
    
    // Vertical scanlines
    float vLine = sin(uv.x * verticalCount * 3.14159) * 0.5 + 0.5;
    
    // Combine both
    float combined = hLine * vLine;
    
    float multiplier = 1.0 - intensity * (1.0 - combined);
    
    half3 result = color.rgb * half(multiplier);
    
    return half4(result, color.a);
}

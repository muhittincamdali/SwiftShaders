// ShaderTemplate.metal
// SwiftShaders
//
// Template for creating new Metal shaders

#include <metal_stdlib>
using namespace metal;

// MARK: - Basic Shader Template

/// A template shader that demonstrates the basic structure.
///
/// Parameters:
/// - position: The pixel position in the texture
/// - color: The current pixel color (RGBA)
/// - intensity: Effect intensity (0.0 to 1.0)
[[stitchable]] half4 templateShader(
    float2 position,
    half4 color,
    float intensity
) {
    // Clamp intensity to valid range
    float safeIntensity = clamp(intensity, 0.0, 1.0);
    
    // Example: Simple brightness adjustment
    half4 result = color;
    result.rgb *= (1.0 + safeIntensity * 0.5);
    
    return result;
}

// MARK: - Shader with Time Animation

/// A shader template with time-based animation.
///
/// Parameters:
/// - position: The pixel position
/// - color: The current pixel color
/// - time: Animation time in seconds
/// - speed: Animation speed multiplier
[[stitchable]] half4 animatedShader(
    float2 position,
    half4 color,
    float time,
    float speed
) {
    // Calculate animated value using sine wave
    float animValue = sin(time * speed) * 0.5 + 0.5;
    
    // Apply animation to color
    half4 result = color;
    result.rgb *= (0.8 + animValue * 0.4);
    
    return result;
}

// MARK: - Shader with UV Coordinates

/// A shader template using normalized UV coordinates.
///
/// Parameters:
/// - position: The pixel position
/// - color: The current pixel color
/// - size: The texture size (width, height)
[[stitchable]] half4 uvShader(
    float2 position,
    half4 color,
    float2 size
) {
    // Calculate normalized UV coordinates (0 to 1)
    float2 uv = position / size;
    
    // Example: Create gradient based on position
    half4 result = color;
    result.r *= uv.x;
    result.b *= uv.y;
    
    return result;
}

// MARK: - Color Manipulation Shader

/// A shader template for color manipulation.
///
/// Parameters:
/// - position: The pixel position
/// - color: The current pixel color
/// - hueShift: Hue rotation in radians
/// - saturation: Saturation multiplier
/// - brightness: Brightness adjustment
[[stitchable]] half4 colorManipulationShader(
    float2 position,
    half4 color,
    float hueShift,
    float saturation,
    float brightness
) {
    // Convert RGB to HSV
    half3 rgb = color.rgb;
    half minVal = min(min(rgb.r, rgb.g), rgb.b);
    half maxVal = max(max(rgb.r, rgb.g), rgb.b);
    half delta = maxVal - minVal;
    
    half h = 0.0;
    half s = 0.0;
    half v = maxVal;
    
    if (delta != 0.0) {
        s = delta / maxVal;
        
        if (rgb.r == maxVal) {
            h = (rgb.g - rgb.b) / delta;
        } else if (rgb.g == maxVal) {
            h = 2.0 + (rgb.b - rgb.r) / delta;
        } else {
            h = 4.0 + (rgb.r - rgb.g) / delta;
        }
        
        h /= 6.0;
        if (h < 0.0) h += 1.0;
    }
    
    // Apply adjustments
    h = fract(h + hueShift / (2.0 * M_PI_F));
    s = clamp(s * saturation, 0.0h, 1.0h);
    v = clamp(v + brightness, 0.0h, 1.0h);
    
    // Convert HSV back to RGB
    half c = v * s;
    half x = c * (1.0 - abs(fmod(h * 6.0, 2.0) - 1.0));
    half m = v - c;
    
    half3 result;
    if (h < 1.0/6.0) {
        result = half3(c, x, 0);
    } else if (h < 2.0/6.0) {
        result = half3(x, c, 0);
    } else if (h < 3.0/6.0) {
        result = half3(0, c, x);
    } else if (h < 4.0/6.0) {
        result = half3(0, x, c);
    } else if (h < 5.0/6.0) {
        result = half3(x, 0, c);
    } else {
        result = half3(c, 0, x);
    }
    
    return half4(result + m, color.a);
}

// MARK: - Blur Shader Template

/// A simple box blur shader template.
///
/// Note: For production, use the actual blur shaders with proper sampling.
[[stitchable]] half4 simpleBlurShader(
    float2 position,
    SwiftUI::Layer layer,
    float radius
) {
    // Sample surrounding pixels (simplified 3x3 blur)
    half4 sum = half4(0);
    float samples = 0.0;
    
    for (float x = -radius; x <= radius; x += 1.0) {
        for (float y = -radius; y <= radius; y += 1.0) {
            sum += layer.sample(position + float2(x, y));
            samples += 1.0;
        }
    }
    
    return sum / samples;
}

// MARK: - Distortion Shader Template

/// A template for distortion effects.
///
/// Parameters:
/// - position: The pixel position
/// - layer: The source layer for sampling
/// - center: Distortion center point
/// - amount: Distortion strength
[[stitchable]] half4 distortionShader(
    float2 position,
    SwiftUI::Layer layer,
    float2 center,
    float amount
) {
    // Calculate vector from center
    float2 delta = position - center;
    float distance = length(delta);
    
    // Apply distortion based on distance
    float factor = 1.0 + amount * exp(-distance * 0.01);
    float2 newPos = center + delta * factor;
    
    return layer.sample(newPos);
}

// MARK: - Utility Functions

/// Converts linear color to sRGB.
inline half3 linearToSRGB(half3 linear) {
    half3 cutoff = step(linear, half3(0.0031308));
    half3 higher = pow(linear, half3(1.0/2.4)) * 1.055 - 0.055;
    half3 lower = linear * 12.92;
    return mix(higher, lower, cutoff);
}

/// Converts sRGB color to linear.
inline half3 sRGBToLinear(half3 srgb) {
    half3 cutoff = step(srgb, half3(0.04045));
    half3 higher = pow((srgb + 0.055) / 1.055, half3(2.4));
    half3 lower = srgb / 12.92;
    return mix(higher, lower, cutoff);
}

/// Calculates luminance of a color.
inline half luminance(half3 color) {
    return dot(color, half3(0.2126, 0.7152, 0.0722));
}

/// Creates smooth step transition.
inline float smootherstep(float edge0, float edge1, float x) {
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

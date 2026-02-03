#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Color Grading Shader
// Professional color manipulation for image processing.

/// RGB to HSL conversion.
float3 rgbToHsl(float3 rgb) {
    float maxC = max(max(rgb.r, rgb.g), rgb.b);
    float minC = min(min(rgb.r, rgb.g), rgb.b);
    float delta = maxC - minC;
    
    float3 hsl;
    hsl.z = (maxC + minC) * 0.5; // Lightness
    
    if (delta < 0.00001) {
        hsl.x = 0.0; // Hue
        hsl.y = 0.0; // Saturation
    } else {
        hsl.y = hsl.z < 0.5 ? delta / (maxC + minC) : delta / (2.0 - maxC - minC);
        
        if (rgb.r >= maxC) {
            hsl.x = (rgb.g - rgb.b) / delta;
        } else if (rgb.g >= maxC) {
            hsl.x = 2.0 + (rgb.b - rgb.r) / delta;
        } else {
            hsl.x = 4.0 + (rgb.r - rgb.g) / delta;
        }
        hsl.x /= 6.0;
        if (hsl.x < 0.0) hsl.x += 1.0;
    }
    
    return hsl;
}

/// HSL to RGB conversion.
float hueToRgb(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0/2.0) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

float3 hslToRgb(float3 hsl) {
    if (hsl.y < 0.00001) {
        return float3(hsl.z);
    }
    
    float q = hsl.z < 0.5 ? hsl.z * (1.0 + hsl.y) : hsl.z + hsl.y - hsl.z * hsl.y;
    float p = 2.0 * hsl.z - q;
    
    return float3(
        hueToRgb(p, q, hsl.x + 1.0/3.0),
        hueToRgb(p, q, hsl.x),
        hueToRgb(p, q, hsl.x - 1.0/3.0)
    );
}

/// Complete color grading control.
[[ stitchable ]]
half4 colorGrading(
    float2 position,
    half4 color,
    float4 bounds,
    float brightness,
    float contrast,
    float saturation,
    float hueShift,
    float temperature,
    float tint
) {
    float3 rgb = float3(color.rgb);
    
    // Brightness
    rgb += brightness;
    
    // Contrast
    rgb = (rgb - 0.5) * contrast + 0.5;
    
    // Convert to HSL for saturation and hue
    float3 hsl = rgbToHsl(rgb);
    
    // Saturation
    hsl.y *= saturation;
    
    // Hue shift
    hsl.x = fract(hsl.x + hueShift);
    
    // Convert back to RGB
    rgb = hslToRgb(hsl);
    
    // Temperature (warm/cool)
    rgb.r += temperature * 0.1;
    rgb.b -= temperature * 0.1;
    
    // Tint (green/magenta)
    rgb.g += tint * 0.1;
    
    // Clamp
    rgb = clamp(rgb, 0.0, 1.0);
    
    return half4(half3(rgb), color.a);
}

/// Levels adjustment (shadows, midtones, highlights).
[[ stitchable ]]
half4 levels(
    float2 position,
    half4 color,
    float4 bounds,
    float inputBlack,
    float inputWhite,
    float gamma,
    float outputBlack,
    float outputWhite
) {
    float3 rgb = float3(color.rgb);
    
    // Input levels
    rgb = (rgb - inputBlack) / (inputWhite - inputBlack);
    rgb = clamp(rgb, 0.0, 1.0);
    
    // Gamma correction
    rgb = pow(rgb, float3(1.0 / gamma));
    
    // Output levels
    rgb = rgb * (outputWhite - outputBlack) + outputBlack;
    
    return half4(half3(rgb), color.a);
}

/// Curves adjustment with control points.
[[ stitchable ]]
half4 curves(
    float2 position,
    half4 color,
    float4 bounds,
    float shadowLift,
    float midtoneContrast,
    float highlightCompress
) {
    float3 rgb = float3(color.rgb);
    
    // S-curve approximation
    float3 shadows = rgb * rgb * (3.0 - 2.0 * rgb);
    float3 highlights = 1.0 - (1.0 - rgb) * (1.0 - rgb);
    
    // Lift shadows
    rgb = mix(rgb, shadows, -shadowLift);
    
    // Midtone contrast (S-curve)
    float3 sCurve = rgb * rgb * (3.0 - 2.0 * rgb);
    rgb = mix(rgb, sCurve, midtoneContrast);
    
    // Compress highlights
    rgb = mix(rgb, highlights, highlightCompress);
    
    return half4(half3(clamp(rgb, 0.0, 1.0)), color.a);
}

/// Split toning (shadows and highlights coloring).
[[ stitchable ]]
half4 splitToning(
    float2 position,
    half4 color,
    float4 bounds,
    float shadowHue,
    float shadowSaturation,
    float highlightHue,
    float highlightSaturation,
    float balance
) {
    float3 rgb = float3(color.rgb);
    float luma = dot(rgb, float3(0.299, 0.587, 0.114));
    
    // Shadow color
    float3 shadowColor = hslToRgb(float3(shadowHue, shadowSaturation, 0.5));
    
    // Highlight color
    float3 highlightColor = hslToRgb(float3(highlightHue, highlightSaturation, 0.5));
    
    // Blend based on luminance
    float shadowMask = 1.0 - smoothstep(0.0, 0.5 + balance * 0.5, luma);
    float highlightMask = smoothstep(0.5 - balance * 0.5, 1.0, luma);
    
    rgb = mix(rgb, shadowColor * luma * 2.0, shadowMask * shadowSaturation);
    rgb = mix(rgb, highlightColor * luma * 2.0, highlightMask * highlightSaturation);
    
    return half4(half3(rgb), color.a);
}

/// Color balance adjustment.
[[ stitchable ]]
half4 colorBalance(
    float2 position,
    half4 color,
    float4 bounds,
    float cyanRed,
    float magentaGreen,
    float yellowBlue
) {
    float3 rgb = float3(color.rgb);
    
    // Apply color balance
    rgb.r += cyanRed * 0.2;
    rgb.g += magentaGreen * 0.2;
    rgb.b += yellowBlue * 0.2;
    
    // Counter-adjust complementary channels
    rgb.g -= cyanRed * 0.1;
    rgb.b -= cyanRed * 0.1;
    
    rgb.r -= magentaGreen * 0.1;
    rgb.b -= magentaGreen * 0.1;
    
    rgb.r -= yellowBlue * 0.1;
    rgb.g -= yellowBlue * 0.1;
    
    return half4(half3(clamp(rgb, 0.0, 1.0)), color.a);
}

/// Vibrance adjustment (smart saturation).
[[ stitchable ]]
half4 vibrance(
    float2 position,
    half4 color,
    float4 bounds,
    float amount
) {
    float3 rgb = float3(color.rgb);
    
    float maxChannel = max(max(rgb.r, rgb.g), rgb.b);
    float minChannel = min(min(rgb.r, rgb.g), rgb.b);
    float saturation = maxChannel - minChannel;
    
    // Apply more saturation boost to less saturated colors
    float boost = amount * (1.0 - saturation);
    
    float3 hsl = rgbToHsl(rgb);
    hsl.y = clamp(hsl.y + boost, 0.0, 1.0);
    rgb = hslToRgb(hsl);
    
    return half4(half3(rgb), color.a);
}

/// LUT-style color mapping.
[[ stitchable ]]
half4 colorMap(
    float2 position,
    half4 color,
    float4 bounds,
    float redShift,
    float greenShift,
    float blueShift,
    float mixAmount
) {
    float3 rgb = float3(color.rgb);
    
    // Simple color channel remapping
    float3 mapped;
    mapped.r = mix(rgb.r, rgb.r + redShift, rgb.r);
    mapped.g = mix(rgb.g, rgb.g + greenShift, rgb.g);
    mapped.b = mix(rgb.b, rgb.b + blueShift, rgb.b);
    
    rgb = mix(rgb, mapped, mixAmount);
    
    return half4(half3(clamp(rgb, 0.0, 1.0)), color.a);
}

/// Film emulation with color curves.
[[ stitchable ]]
half4 filmEmulation(
    float2 position,
    half4 color,
    float4 bounds,
    float filmType,
    float intensity
) {
    float3 rgb = float3(color.rgb);
    
    // Different film looks based on type
    float3 filmColor;
    
    if (filmType < 0.33) {
        // Kodak Portra style (warm, low contrast)
        filmColor.r = rgb.r * 1.05 + 0.02;
        filmColor.g = rgb.g * 1.0;
        filmColor.b = rgb.b * 0.95 - 0.02;
    } else if (filmType < 0.66) {
        // Fuji Velvia style (saturated, high contrast)
        float3 hsl = rgbToHsl(rgb);
        hsl.y *= 1.3;
        rgb = hslToRgb(hsl);
        filmColor = (rgb - 0.5) * 1.2 + 0.5;
    } else {
        // Cinestill style (halation, blue shadows)
        filmColor = rgb;
        filmColor.b += (1.0 - rgb.b) * 0.1;
        if (rgb.r > 0.8) {
            filmColor.r += (rgb.r - 0.8) * 0.5;
            filmColor.g += (rgb.r - 0.8) * 0.2;
        }
    }
    
    rgb = mix(rgb, filmColor, intensity);
    
    return half4(half3(clamp(rgb, 0.0, 1.0)), color.a);
}

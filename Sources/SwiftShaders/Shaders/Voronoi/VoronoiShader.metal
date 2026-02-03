#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Voronoi Noise Shader
// Generates procedural Voronoi (Worley) noise patterns for cellular,
// organic, and crystalline visual effects.

// MARK: - Hash Functions

/// High-quality 2D hash function for point generation.
float2 voronoiHash2(float2 p) {
    p = float2(
        dot(p, float2(127.1, 311.7)),
        dot(p, float2(269.5, 183.3))
    );
    return fract(sin(p) * 43758.5453123);
}

/// 3D hash for animated voronoi cells.
float2 voronoiHash2Animated(float2 p, float time) {
    p = float2(
        dot(p, float2(127.1, 311.7)),
        dot(p, float2(269.5, 183.3))
    );
    float2 hash = fract(sin(p) * 43758.5453123);
    return sin(hash * 6.2831853 + time) * 0.5 + 0.5;
}

/// Simple hash for randomization.
float voronoiHash1(float2 p) {
    return fract(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453);
}

// MARK: - Core Voronoi Functions

/// Computes first-order Voronoi distance (distance to nearest cell center).
float voronoiF1(float2 uv, float scale, float time, float jitter) {
    float2 p = uv * scale;
    float2 ip = floor(p);
    float2 fp = fract(p);
    
    float minDist = 10.0;
    
    // Search 3x3 neighborhood
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 cellCenter = voronoiHash2Animated(ip + neighbor, time) * jitter;
            float2 diff = neighbor + cellCenter - fp;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    
    return minDist;
}

/// Computes second-order Voronoi distance (distance to second nearest).
float2 voronoiF1F2(float2 uv, float scale, float time, float jitter) {
    float2 p = uv * scale;
    float2 ip = floor(p);
    float2 fp = fract(p);
    
    float minDist1 = 10.0;
    float minDist2 = 10.0;
    
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 cellCenter = voronoiHash2Animated(ip + neighbor, time) * jitter;
            float2 diff = neighbor + cellCenter - fp;
            float dist = length(diff);
            
            if (dist < minDist1) {
                minDist2 = minDist1;
                minDist1 = dist;
            } else if (dist < minDist2) {
                minDist2 = dist;
            }
        }
    }
    
    return float2(minDist1, minDist2);
}

/// Voronoi with cell ID for coloring.
float3 voronoiWithID(float2 uv, float scale, float time, float jitter) {
    float2 p = uv * scale;
    float2 ip = floor(p);
    float2 fp = fract(p);
    
    float minDist = 10.0;
    float2 minCell = float2(0.0);
    
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 cellPos = ip + neighbor;
            float2 cellCenter = voronoiHash2Animated(cellPos, time) * jitter;
            float2 diff = neighbor + cellCenter - fp;
            float dist = length(diff);
            
            if (dist < minDist) {
                minDist = dist;
                minCell = cellPos;
            }
        }
    }
    
    return float3(minDist, minCell);
}

// MARK: - Basic Voronoi Color Effect

/// Standard Voronoi noise pattern.
[[ stitchable ]]
half4 voronoiNoise(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float jitter,
    float edgeWidth
) {
    float2 uv = position / bounds.zw;
    
    float2 distances = voronoiF1F2(uv, scale, time * 0.5, jitter);
    float f1 = distances.x;
    float f2 = distances.y;
    
    // Cell interior based on F1
    float cell = smoothstep(0.0, 0.5, f1);
    
    // Edge detection using F2 - F1
    float edge = smoothstep(edgeWidth * 0.5, edgeWidth, f2 - f1);
    
    // Mix with original color
    half4 result = color;
    result.rgb *= half(cell * 0.5 + 0.5);
    result.rgb *= half(edge * 0.8 + 0.2);
    
    return result;
}

/// Voronoi cells with unique colors per cell.
[[ stitchable ]]
half4 voronoiCells(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float jitter,
    float colorVariation
) {
    float2 uv = position / bounds.zw;
    
    float3 voronoi = voronoiWithID(uv, scale, time * 0.3, jitter);
    float dist = voronoi.x;
    float2 cellID = voronoi.yz;
    
    // Generate cell color from ID
    float3 cellColor = float3(
        voronoiHash1(cellID),
        voronoiHash1(cellID + 127.0),
        voronoiHash1(cellID + 311.0)
    );
    
    // Apply color variation
    cellColor = mix(float3(0.5), cellColor, colorVariation);
    
    // Modulate by distance for depth
    float shade = 1.0 - smoothstep(0.0, 0.6, dist);
    
    half4 result = color;
    result.rgb *= half3(cellColor * shade * 1.2);
    
    return result;
}

/// Voronoi edge glow effect.
[[ stitchable ]]
half4 voronoiEdgeGlow(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float jitter,
    float glowWidth,
    float3 glowColor
) {
    float2 uv = position / bounds.zw;
    
    float2 distances = voronoiF1F2(uv, scale, time * 0.4, jitter);
    float edgeDist = distances.y - distances.x;
    
    // Create glow around edges
    float glow = 1.0 - smoothstep(0.0, glowWidth, edgeDist);
    glow = pow(glow, 2.0);
    
    // Pulse animation
    float pulse = sin(time * 3.0) * 0.3 + 0.7;
    glow *= pulse;
    
    half4 result = color;
    result.rgb += half3(glowColor * glow);
    
    return result;
}

// MARK: - Crystalline Effects

/// Creates a crystalline/gemstone pattern.
[[ stitchable ]]
half4 voronoiCrystal(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float facetSharpness,
    float refractAmount
) {
    float2 uv = position / bounds.zw;
    
    // Multi-layer voronoi for complex crystal structure
    float2 d1 = voronoiF1F2(uv, scale, time * 0.2, 1.0);
    float2 d2 = voronoiF1F2(uv * 1.5 + 0.5, scale * 0.7, time * 0.15, 0.8);
    
    // Facet angle simulation
    float facet1 = pow(d1.x, facetSharpness);
    float facet2 = pow(d2.x, facetSharpness);
    float facets = facet1 * 0.6 + facet2 * 0.4;
    
    // Refraction color shift
    float2 offset = float2(
        (d1.y - d1.x) * refractAmount,
        (d2.y - d2.x) * refractAmount
    );
    
    // Create prismatic color effect
    half4 result;
    result.r = color.r * half(1.0 + offset.x * 2.0);
    result.g = color.g * half(1.0 + (offset.x + offset.y) * 0.5);
    result.b = color.b * half(1.0 + offset.y * 2.0);
    result.a = color.a;
    
    // Apply facet shading
    result.rgb *= half(facets * 0.5 + 0.5);
    
    // Edge highlight
    float edgeHighlight = 1.0 - smoothstep(0.02, 0.08, d1.y - d1.x);
    result.rgb += half3(edgeHighlight * 0.5);
    
    return result;
}

/// Shattered glass effect.
[[ stitchable ]]
half4 voronoiShattered(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float crackWidth,
    float3 crackColor
) {
    float2 uv = position / bounds.zw;
    
    // Static voronoi for consistent cracks
    float2 distances = voronoiF1F2(uv, scale, 0.0, 1.0);
    float edgeDist = distances.y - distances.x;
    
    // Sharp crack lines
    float crack = 1.0 - smoothstep(0.0, crackWidth, edgeDist);
    crack = pow(crack, 0.5);
    
    // Fragment shading based on cell
    float3 voronoi = voronoiWithID(uv, scale, 0.0, 1.0);
    float shade = voronoiHash1(voronoi.yz);
    shade = shade * 0.3 + 0.7;
    
    // Apply subtle offset per shard (displacement feel)
    float3 shardTint = float3(
        voronoiHash1(voronoi.yz + 0.0),
        voronoiHash1(voronoi.yz + 1.0),
        voronoiHash1(voronoi.yz + 2.0)
    ) * 0.2 + 0.9;
    
    half4 result = color;
    result.rgb *= half3(shardTint * shade);
    
    // Add crack overlay
    result.rgb = mix(result.rgb, half3(crackColor), half(crack));
    
    return result;
}

// MARK: - Organic Patterns

/// Cell membrane / biological pattern.
[[ stitchable ]]
half4 voronoiCellular(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float membraneWidth,
    float3 membraneColor
) {
    float2 uv = position / bounds.zw;
    
    // Animated cells for organic feel
    float2 distances = voronoiF1F2(uv, scale, time * 0.5, 0.9);
    float f1 = distances.x;
    float f2 = distances.y;
    
    // Cell membrane
    float membrane = smoothstep(membraneWidth, membraneWidth * 0.3, f2 - f1);
    
    // Nucleus effect (center of cell)
    float nucleus = smoothstep(0.15, 0.0, f1);
    
    // Cell interior gradient
    float interior = smoothstep(0.0, 0.4, f1);
    
    half4 result = color;
    
    // Apply interior shading
    result.rgb *= half(0.8 + interior * 0.4);
    
    // Add nucleus highlight
    result.rgb += half3(nucleus * 0.3);
    
    // Apply membrane
    result.rgb = mix(result.rgb, half3(membraneColor), half(membrane));
    
    return result;
}

/// Honeycomb pattern.
[[ stitchable ]]
half4 voronoiHoneycomb(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float wallWidth,
    float3 wallColor
) {
    float2 uv = position / bounds.zw;
    
    // Fixed jitter of 0 creates more regular cells
    float2 distances = voronoiF1F2(uv, scale, time * 0.2, 0.0);
    float edgeDist = distances.y - distances.x;
    
    // Hexagonal-ish walls
    float wall = smoothstep(wallWidth, wallWidth * 0.5, edgeDist);
    
    // Depth gradient
    float depth = smoothstep(0.0, 0.5, distances.x);
    
    half4 result = color;
    result.rgb *= half(0.7 + depth * 0.5);
    result.rgb = mix(result.rgb, half3(wallColor), half(wall));
    
    return result;
}

// MARK: - Distortion Effects

/// Voronoi-based position distortion.
[[ stitchable ]]
float2 voronoiDistort(
    float2 position,
    float4 bounds,
    float time,
    float scale,
    float distortAmount
) {
    float2 uv = position / bounds.zw;
    
    float2 distances = voronoiF1F2(uv, scale, time * 0.3, 1.0);
    
    // Direction towards cell center
    float angle = voronoiHash1(floor(uv * scale)) * 6.28318;
    float2 dir = float2(cos(angle), sin(angle));
    
    // Distort based on edge proximity
    float edgeFactor = 1.0 - (distances.y - distances.x);
    float2 offset = dir * edgeFactor * distortAmount;
    
    return position + offset * bounds.zw * 0.1;
}

/// Liquid/fluid voronoi movement.
[[ stitchable ]]
float2 voronoiLiquid(
    float2 position,
    float4 bounds,
    float time,
    float scale,
    float flowSpeed,
    float flowAmount
) {
    float2 uv = position / bounds.zw;
    
    // Layered voronoi for complex flow
    float2 d1 = voronoiF1F2(uv, scale, time * flowSpeed, 1.0);
    float2 d2 = voronoiF1F2(uv + 0.5, scale * 0.5, time * flowSpeed * 0.7, 0.8);
    
    // Flow direction from gradient
    float flow1 = d1.y - d1.x;
    float flow2 = d2.y - d2.x;
    
    float2 offset = float2(
        sin(flow1 * 6.28318 + time) * flow2,
        cos(flow2 * 6.28318 + time * 0.8) * flow1
    ) * flowAmount;
    
    return position + offset * bounds.zw * 0.05;
}

// MARK: - Special Effects

/// Lava/magma cracks effect.
[[ stitchable ]]
half4 voronoiLava(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float heatIntensity,
    float3 coolColor,
    float3 hotColor
) {
    float2 uv = position / bounds.zw;
    
    float2 distances = voronoiF1F2(uv, scale, time * 0.3, 1.0);
    float crackDist = distances.y - distances.x;
    
    // Hot cracks with glow falloff
    float heat = 1.0 - smoothstep(0.0, 0.15 * heatIntensity, crackDist);
    heat = pow(heat, 1.5);
    
    // Pulsating heat
    float pulse = sin(time * 2.0 + uv.x * 5.0) * 0.2 + 0.8;
    heat *= pulse;
    
    // Surface cooling pattern
    float cooling = smoothstep(0.0, 0.4, distances.x);
    
    // Blend between cool surface and hot cracks
    float3 lavaColor = mix(hotColor, coolColor, cooling * (1.0 - heat));
    lavaColor = mix(lavaColor, hotColor * 2.0, heat);
    
    half4 result;
    result.rgb = half3(lavaColor) * color.rgb;
    result.a = color.a;
    
    return result;
}

/// Electric/plasma web effect.
[[ stitchable ]]
half4 voronoiPlasma(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float pulseSpeed,
    float3 plasmaColor
) {
    float2 uv = position / bounds.zw;
    
    // Multi-scale voronoi
    float2 d1 = voronoiF1F2(uv, scale, time * pulseSpeed, 1.0);
    float2 d2 = voronoiF1F2(uv * 2.0, scale * 1.5, time * pulseSpeed * 1.3, 0.7);
    
    // Plasma tendrils along edges
    float tendril1 = 1.0 - smoothstep(0.0, 0.05, d1.y - d1.x);
    float tendril2 = 1.0 - smoothstep(0.0, 0.03, d2.y - d2.x);
    
    // Combine with interference pattern
    float plasma = tendril1 * 0.7 + tendril2 * 0.3;
    plasma *= sin(time * 10.0 + uv.y * 30.0) * 0.3 + 0.7;
    
    // Glow falloff
    float glow1 = 1.0 - smoothstep(0.0, 0.2, d1.y - d1.x);
    float glow = pow(glow1, 3.0) * 0.5;
    
    half4 result = color;
    result.rgb += half3(plasmaColor) * half(plasma + glow);
    
    return result;
}

/// Water caustics pattern.
[[ stitchable ]]
half4 voronoiCaustics(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float brightness,
    float sharpness
) {
    float2 uv = position / bounds.zw;
    
    // Two offset voronoi layers for caustic interference
    float f1a = voronoiF1(uv, scale, time * 0.5, 1.0);
    float f1b = voronoiF1(uv + 0.3, scale * 1.2, time * 0.4, 0.9);
    
    // Interference pattern
    float caustic = f1a * f1b;
    caustic = pow(caustic, sharpness);
    caustic *= brightness;
    
    // Add subtle color variation
    float colorShift = sin(f1a * 10.0 + time) * 0.1;
    
    half4 result = color;
    result.r += half(caustic * (1.0 + colorShift));
    result.g += half(caustic);
    result.b += half(caustic * (1.0 - colorShift * 0.5));
    
    return result;
}

/// Stained glass window effect.
[[ stitchable ]]
half4 voronoiStainedGlass(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float leadWidth,
    float saturation
) {
    float2 uv = position / bounds.zw;
    
    // Static cells for consistent glass panes
    float3 voronoi = voronoiWithID(uv, scale, 0.0, 1.0);
    float dist = voronoi.x;
    float2 cellID = voronoi.yz;
    float2 distances = voronoiF1F2(uv, scale, 0.0, 1.0);
    
    // Lead lines (dark borders)
    float lead = smoothstep(leadWidth, leadWidth * 0.3, distances.y - distances.x);
    
    // Unique color per glass pane
    float hue = voronoiHash1(cellID) * 6.28318;
    float3 paneColor = float3(
        sin(hue) * 0.5 + 0.5,
        sin(hue + 2.094) * 0.5 + 0.5,
        sin(hue + 4.189) * 0.5 + 0.5
    );
    
    // Apply saturation
    float luma = dot(paneColor, float3(0.299, 0.587, 0.114));
    paneColor = mix(float3(luma), paneColor, saturation);
    
    // Light variation within pane
    float lightVar = 1.0 - smoothstep(0.0, 0.3, dist);
    paneColor *= (0.8 + lightVar * 0.4);
    
    half4 result;
    result.rgb = mix(half3(paneColor) * color.rgb, half3(0.1), half(lead));
    result.a = color.a;
    
    return result;
}

/// Frosted/cracked ice pattern.
[[ stitchable ]]
half4 voronoiFrost(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float scale,
    float crackDepth,
    float frostiness
) {
    float2 uv = position / bounds.zw;
    
    // Static cracks
    float2 distances = voronoiF1F2(uv, scale, 0.0, 1.0);
    float crackDist = distances.y - distances.x;
    
    // Deep crack lines
    float crack = smoothstep(0.02 * crackDepth, 0.0, crackDist);
    
    // Secondary micro-cracks
    float2 microDist = voronoiF1F2(uv, scale * 3.0, 0.0, 0.7);
    float microCrack = smoothstep(0.015, 0.0, microDist.y - microDist.x) * 0.3;
    
    // Frost accumulation (inverse of distance)
    float frost = 1.0 - smoothstep(0.0, 0.4, distances.x);
    frost = pow(frost, 0.5) * frostiness;
    
    // Slight blue tint for ice
    half4 result = color;
    result.rgb = mix(result.rgb, half3(0.9, 0.95, 1.0), half(frost * 0.5));
    
    // Add crack darkness
    result.rgb *= half(1.0 - crack * 0.5 - microCrack);
    
    // Subtle sparkle
    float sparkle = voronoiHash1(floor(uv * scale * 10.0) + floor(time * 5.0));
    sparkle = step(0.995, sparkle);
    result.rgb += half3(sparkle * 0.8);
    
    return result;
}

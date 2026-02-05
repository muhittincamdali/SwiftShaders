// Mosaic & Tile Effect Shader
// Creates mosaic, stained glass, and tile patterns
// Author: Muhittin Camdali
// License: MIT

#include <metal_stdlib>
using namespace metal;

// =============================================================================
// ALGORITHM EXPLANATION
// =============================================================================
// Mosaic effects divide the image into regions by:
// 1. Voronoi cells for organic shapes
// 2. Regular grid for square tiles
// 3. Hexagonal grid for honeycomb
// 4. Sampling center of each cell
// 5. Optional edge/grout rendering
// =============================================================================

// Hash function for random values
float2 hash2(float2 p) {
    return fract(sin(float2(dot(p, float2(127.1, 311.7)), 
                            dot(p, float2(269.5, 183.3)))) * 43758.5453);
}

float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

// =============================================================================
// LAYER EFFECT: Square Mosaic
// =============================================================================
// Parameters:
// - size: View dimensions
// - tileSize: Size of each tile in pixels
// - groutWidth: Width of grout lines (0 = no grout)
// - groutColor: Color of grout (R, G, B)
// =============================================================================
[[stitchable]] half4 mosaicSquare(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float tileSize,
    float groutWidth,
    half3 groutColor
) {
    // Calculate tile coordinates
    float2 tileCoord = floor(position / tileSize);
    float2 tileCenter = (tileCoord + 0.5) * tileSize;
    
    // Sample from tile center
    half4 color = layer.sample(tileCenter);
    
    // Add grout
    if (groutWidth > 0.0) {
        float2 withinTile = fmod(position, tileSize);
        float edgeX = min(withinTile.x, tileSize - withinTile.x);
        float edgeY = min(withinTile.y, tileSize - withinTile.y);
        float edge = min(edgeX, edgeY);
        
        if (edge < groutWidth) {
            color.rgb = groutColor;
        }
    }
    
    return color;
}

// =============================================================================
// LAYER EFFECT: Hexagonal Mosaic
// =============================================================================
[[stitchable]] half4 mosaicHexagon(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float hexSize,
    float groutWidth,
    half3 groutColor
) {
    float sqrt3 = 1.732050808;
    
    // Hex grid calculation
    float2 r = float2(1.0, sqrt3);
    float2 h = r * 0.5;
    
    float2 a = fmod(position / hexSize, r) - h;
    float2 b = fmod(position / hexSize - h, r) - h;
    
    float2 gv = dot(a, a) < dot(b, b) ? a : b;
    
    // Find hex center
    float2 hexCenter = position - gv * hexSize;
    
    // Sample from hex center
    half4 color = layer.sample(hexCenter);
    
    // Grout (hex edges)
    if (groutWidth > 0.0) {
        float dist = length(gv);
        float edge = 0.5 - dist;
        
        if (edge * hexSize < groutWidth) {
            color.rgb = groutColor;
        }
    }
    
    return color;
}

// =============================================================================
// LAYER EFFECT: Voronoi Mosaic (Stained Glass)
// =============================================================================
[[stitchable]] half4 mosaicVoronoi(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float cellSize,
    float groutWidth,
    half3 groutColor,
    float randomness
) {
    float2 uv = position / cellSize;
    float2 cell = floor(uv);
    float2 frac = fract(uv);
    
    float minDist = 1.0;
    float secondDist = 1.0;
    float2 minPoint = float2(0.0);
    
    // Find closest cell center
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(x, y);
            float2 point = hash2(cell + neighbor) * randomness + (1.0 - randomness) * 0.5;
            float2 diff = neighbor + point - frac;
            float dist = length(diff);
            
            if (dist < minDist) {
                secondDist = minDist;
                minDist = dist;
                minPoint = cell + neighbor + point;
            } else if (dist < secondDist) {
                secondDist = dist;
            }
        }
    }
    
    // Sample from cell center
    float2 samplePos = minPoint * cellSize;
    half4 color = layer.sample(samplePos);
    
    // Edge detection for grout
    if (groutWidth > 0.0) {
        float edge = secondDist - minDist;
        if (edge < groutWidth / cellSize) {
            color.rgb = groutColor;
        }
    }
    
    return color;
}

// =============================================================================
// LAYER EFFECT: Brick Mosaic
// =============================================================================
[[stitchable]] half4 mosaicBrick(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float brickWidth,
    float brickHeight,
    float groutWidth,
    half3 groutColor
) {
    // Offset every other row
    float row = floor(position.y / brickHeight);
    float xOffset = fmod(row, 2.0) * brickWidth * 0.5;
    
    float2 adjustedPos = float2(position.x - xOffset, position.y);
    float2 brickCoord = floor(adjustedPos / float2(brickWidth, brickHeight));
    float2 brickCenter = (brickCoord + 0.5) * float2(brickWidth, brickHeight);
    brickCenter.x += xOffset;
    
    // Sample from brick center
    half4 color = layer.sample(brickCenter);
    
    // Grout
    if (groutWidth > 0.0) {
        float2 withinBrick = fmod(adjustedPos, float2(brickWidth, brickHeight));
        float edgeX = min(withinBrick.x, brickWidth - withinBrick.x);
        float edgeY = min(withinBrick.y, brickHeight - withinBrick.y);
        float edge = min(edgeX, edgeY);
        
        if (edge < groutWidth) {
            color.rgb = groutColor;
        }
    }
    
    return color;
}

// =============================================================================
// LAYER EFFECT: Diamond Mosaic
// =============================================================================
[[stitchable]] half4 mosaicDiamond(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float diamondSize,
    float groutWidth,
    half3 groutColor
) {
    // Rotate 45 degrees
    float c = 0.707107; // cos(45°)
    float2 rotated = float2(
        position.x * c - position.y * c,
        position.x * c + position.y * c
    );
    
    // Square grid in rotated space
    float2 tileCoord = floor(rotated / diamondSize);
    float2 tileCenter = (tileCoord + 0.5) * diamondSize;
    
    // Rotate back
    float2 samplePos = float2(
        tileCenter.x * c + tileCenter.y * c,
        -tileCenter.x * c + tileCenter.y * c
    );
    
    // Sample
    half4 color = layer.sample(samplePos);
    
    // Grout
    if (groutWidth > 0.0) {
        float2 withinTile = fmod(rotated, diamondSize);
        float edgeX = min(withinTile.x, diamondSize - withinTile.x);
        float edgeY = min(withinTile.y, diamondSize - withinTile.y);
        float edge = min(edgeX, edgeY);
        
        if (edge < groutWidth) {
            color.rgb = groutColor;
        }
    }
    
    return color;
}

// =============================================================================
// COLOR EFFECT: Simple Mosaic (no layer sampling needed)
// =============================================================================
[[stitchable]] half4 mosaicSimple(
    float2 position,
    half4 color,
    float2 size,
    float tileSize
) {
    // Just quantize the color based on tile
    float2 tileCoord = floor(position / tileSize);
    
    // Add slight variation per tile
    float variation = hash(tileCoord) * 0.1;
    
    half3 result = color.rgb + half3(variation - 0.05);
    
    return half4(clamp(result, half3(0.0), half3(1.0)), color.a);
}

// =============================================================================
// LAYER EFFECT: Circular Mosaic
// =============================================================================
[[stitchable]] half4 mosaicCircular(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float2 center,
    float ringWidth,
    float segmentAngle
) {
    float2 uv = position / size;
    float2 centered = uv - center;
    
    // Polar coordinates
    float r = length(centered) * size.x;
    float theta = atan2(centered.y, centered.x);
    
    // Quantize radius and angle
    float ringIndex = floor(r / ringWidth);
    float angleIndex = floor((theta + 3.14159) / segmentAngle);
    
    // Calculate cell center in polar
    float centerR = (ringIndex + 0.5) * ringWidth;
    float centerTheta = (angleIndex + 0.5) * segmentAngle - 3.14159;
    
    // Convert back to Cartesian
    float2 samplePos = float2(
        cos(centerTheta) * centerR / size.x + center.x,
        sin(centerTheta) * centerR / size.x + center.y
    ) * size;
    
    return layer.sample(samplePos);
}

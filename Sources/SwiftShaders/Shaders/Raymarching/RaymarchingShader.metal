#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Raymarching Utility Functions

/// Hash function for pseudo-random values.
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

/// 3D hash function.
float hash3D(float3 p) {
    return fract(sin(dot(p, float3(127.1, 311.7, 74.7))) * 43758.5453);
}

/// Value noise function.
float valueNoise(float3 p) {
    float3 i = floor(p);
    float3 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    
    float n = i.x + i.y * 57.0 + i.z * 113.0;
    
    float a = hash(n);
    float b = hash(n + 1.0);
    float c = hash(n + 57.0);
    float d = hash(n + 58.0);
    float e = hash(n + 113.0);
    float f1 = hash(n + 114.0);
    float g = hash(n + 170.0);
    float h = hash(n + 171.0);
    
    return mix(
        mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
        mix(mix(e, f1, f.x), mix(g, h, f.x), f.y),
        f.z
    );
}

/// Fractal Brownian Motion for volumetric effects.
float fbm3D(float3 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        value += valueNoise(p * frequency) * amplitude;
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value;
}

// MARK: - SDF Primitives

/// Sphere signed distance function.
float sdSphere(float3 p, float r) {
    return length(p) - r;
}

/// Box signed distance function.
float sdBox(float3 p, float3 b) {
    float3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

/// Torus signed distance function.
float sdTorus(float3 p, float2 t) {
    float2 q = float2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

/// Cylinder signed distance function.
float sdCylinder(float3 p, float h, float r) {
    float2 d = abs(float2(length(p.xz), p.y)) - float2(r, h);
    return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

/// Octahedron signed distance function.
float sdOctahedron(float3 p, float s) {
    p = abs(p);
    float m = p.x + p.y + p.z - s;
    
    float3 q;
    if (3.0 * p.x < m) {
        q = p;
    } else if (3.0 * p.y < m) {
        q = p.yzx;
    } else if (3.0 * p.z < m) {
        q = p.zxy;
    } else {
        return m * 0.57735027;
    }
    
    float k = clamp(0.5 * (q.z - q.y + s), 0.0, s);
    return length(float3(q.x, q.y - s + k, q.z - k));
}

// MARK: - SDF Operations

/// Smooth minimum for blending shapes.
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

/// Smooth subtraction.
float smax(float a, float b, float k) {
    return -smin(-a, -b, k);
}

/// Union operation.
float opUnion(float d1, float d2) {
    return min(d1, d2);
}

/// Subtraction operation.
float opSubtraction(float d1, float d2) {
    return max(-d1, d2);
}

/// Intersection operation.
float opIntersection(float d1, float d2) {
    return max(d1, d2);
}

// MARK: - Rotation Matrices

/// Rotation matrix around X axis.
float3x3 rotateX(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return float3x3(
        1.0, 0.0, 0.0,
        0.0, c, -s,
        0.0, s, c
    );
}

/// Rotation matrix around Y axis.
float3x3 rotateY(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return float3x3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

/// Rotation matrix around Z axis.
float3x3 rotateZ(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return float3x3(
        c, -s, 0.0,
        s, c, 0.0,
        0.0, 0.0, 1.0
    );
}

// MARK: - Scene Distance Functions

/// Basic scene with multiple primitives.
float sceneBasic(float3 p, float time) {
    float3 rp = rotateY(time * 0.5) * p;
    
    float sphere = sdSphere(rp, 0.5);
    float box = sdBox(rp - float3(0.8, 0.0, 0.0), float3(0.3));
    float torus = sdTorus(rp + float3(0.8, 0.0, 0.0), float2(0.3, 0.1));
    
    return smin(smin(sphere, box, 0.3), torus, 0.3);
}

/// Calculate normal using gradient.
float3 calcNormal(float3 p, float time) {
    float2 e = float2(0.001, 0.0);
    return normalize(float3(
        sceneBasic(p + e.xyy, time) - sceneBasic(p - e.xyy, time),
        sceneBasic(p + e.yxy, time) - sceneBasic(p - e.yxy, time),
        sceneBasic(p + e.yyx, time) - sceneBasic(p - e.yyx, time)
    ));
}

/// Soft shadow calculation.
float softShadow(float3 ro, float3 rd, float mint, float maxt, float k) {
    float res = 1.0;
    float t = mint;
    
    for (int i = 0; i < 32; i++) {
        float h = sceneBasic(ro + rd * t, 0.0);
        res = min(res, k * h / t);
        t += clamp(h, 0.02, 0.1);
        if (h < 0.001 || t > maxt) break;
    }
    
    return clamp(res, 0.0, 1.0);
}

/// Ambient occlusion calculation.
float ambientOcclusion(float3 p, float3 n, float time) {
    float occ = 0.0;
    float sca = 1.0;
    
    for (int i = 0; i < 5; i++) {
        float h = 0.01 + 0.12 * float(i) / 4.0;
        float d = sceneBasic(p + h * n, time);
        occ += (h - d) * sca;
        sca *= 0.95;
    }
    
    return clamp(1.0 - 3.0 * occ, 0.0, 1.0);
}

// MARK: - Basic Raymarching Shader

[[ stitchable ]]
half4 raymarching(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float cameraDistance,
    float rotationSpeed,
    float aoStrength,
    float shadowSoftness
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Camera setup
    float3 ro = float3(0.0, 0.0, cameraDistance);
    ro = rotateY(time * rotationSpeed) * ro;
    
    float3 target = float3(0.0);
    float3 forward = normalize(target - ro);
    float3 right = normalize(cross(float3(0.0, 1.0, 0.0), forward));
    float3 up = cross(forward, right);
    
    float3 rd = normalize(forward + uv.x * right + uv.y * up);
    
    // Raymarching loop
    float t = 0.0;
    float3 p;
    
    for (int i = 0; i < 100; i++) {
        p = ro + rd * t;
        float d = sceneBasic(p, time);
        
        if (d < 0.001) break;
        if (t > 20.0) break;
        
        t += d;
    }
    
    if (t > 20.0) {
        // Background gradient
        half3 bg = mix(half3(0.1h, 0.1h, 0.2h), half3(0.0h), half(uv.y + 0.5));
        return half4(bg, 1.0h);
    }
    
    // Shading
    float3 n = calcNormal(p, time);
    float3 lightDir = normalize(float3(1.0, 1.0, 1.0));
    
    float diff = max(dot(n, lightDir), 0.0);
    float ao = ambientOcclusion(p, n, time);
    ao = mix(1.0, ao, aoStrength);
    
    float shadow = softShadow(p + n * 0.01, lightDir, 0.01, 5.0, shadowSoftness);
    
    // Specular
    float3 h = normalize(lightDir - rd);
    float spec = pow(max(dot(n, h), 0.0), 32.0);
    
    // Material color
    half3 matColor = half3(0.8h, 0.4h, 0.2h);
    
    // Final color
    half3 col = matColor * half(diff * shadow * ao) + half3(0.3h) * half(spec * shadow);
    col += half3(0.05h, 0.08h, 0.1h) * half(ao);
    
    return half4(col, 1.0h);
}

// MARK: - Metaballs Shader

/// Metaballs scene distance function.
float sceneMetaballs(float3 p, float time, float blobCount, float smoothness, float scale, float moveSpeed) {
    float d = 10000.0;
    
    for (int i = 0; i < int(blobCount); i++) {
        float phase = float(i) * 1.618 * 3.14159;
        
        float3 offset = float3(
            sin(time * moveSpeed + phase) * 0.5,
            cos(time * moveSpeed * 1.3 + phase * 0.7) * 0.3,
            sin(time * moveSpeed * 0.8 + phase * 1.2) * 0.5
        ) * scale;
        
        float radius = 0.2 + 0.1 * sin(time + phase);
        float sphere = sdSphere(p - offset, radius);
        
        d = smin(d, sphere, smoothness);
    }
    
    return d;
}

[[ stitchable ]]
half4 metaballs(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float blobCount,
    float smoothness,
    float scale,
    float moveSpeed,
    float hue
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Camera
    float3 ro = float3(0.0, 0.0, 2.5);
    float3 rd = normalize(float3(uv, -1.0));
    
    // Raymarch
    float t = 0.0;
    float3 p;
    
    for (int i = 0; i < 80; i++) {
        p = ro + rd * t;
        float d = sceneMetaballs(p, time, blobCount, smoothness, scale, moveSpeed);
        
        if (d < 0.001) break;
        if (t > 10.0) break;
        
        t += d;
    }
    
    if (t > 10.0) {
        return half4(0.0h, 0.0h, 0.0h, 1.0h);
    }
    
    // Normal calculation
    float2 e = float2(0.001, 0.0);
    float3 n = normalize(float3(
        sceneMetaballs(p + e.xyy, time, blobCount, smoothness, scale, moveSpeed) -
        sceneMetaballs(p - e.xyy, time, blobCount, smoothness, scale, moveSpeed),
        sceneMetaballs(p + e.yxy, time, blobCount, smoothness, scale, moveSpeed) -
        sceneMetaballs(p - e.yxy, time, blobCount, smoothness, scale, moveSpeed),
        sceneMetaballs(p + e.yyx, time, blobCount, smoothness, scale, moveSpeed) -
        sceneMetaballs(p - e.yyx, time, blobCount, smoothness, scale, moveSpeed)
    ));
    
    // Lighting
    float3 lightDir = normalize(float3(1.0, 1.0, 0.5));
    float diff = max(dot(n, lightDir), 0.0);
    float rim = pow(1.0 - max(dot(n, -rd), 0.0), 3.0);
    
    // Iridescent color based on normal
    float angle = atan2(n.y, n.x) / 6.28318 + 0.5;
    half3 baseColor = half3(
        half(0.5 + 0.5 * sin(6.28318 * (hue + angle))),
        half(0.5 + 0.5 * sin(6.28318 * (hue + angle + 0.33))),
        half(0.5 + 0.5 * sin(6.28318 * (hue + angle + 0.67)))
    );
    
    half3 col = baseColor * half(diff) + half3(0.8h) * half(rim);
    
    return half4(col, 1.0h);
}

// MARK: - SDF Shapes Shader

/// SDF shapes scene with boolean operations.
float sceneSdfShapes(float3 p, float time, float operation, float smoothFactor, float shapeScale) {
    float3 rp = rotateY(time * 0.5) * rotateX(time * 0.3) * p;
    
    float box = sdBox(rp, float3(shapeScale * 0.8));
    float sphere = sdSphere(rp, shapeScale * 1.0);
    float torus = sdTorus(rp, float2(shapeScale * 0.7, shapeScale * 0.2));
    
    int op = int(operation);
    
    if (op == 0) {
        return min(min(box, sphere), torus);
    } else if (op == 1) {
        return opSubtraction(sphere, box);
    } else if (op == 2) {
        return opIntersection(box, sphere);
    } else {
        float d = smin(box, sphere, smoothFactor);
        return smin(d, torus, smoothFactor);
    }
}

[[ stitchable ]]
half4 sdfShapes(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float operation,
    float rotationSpeed,
    float smoothFactor,
    float shapeScale
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    float3 ro = float3(0.0, 0.0, 3.0);
    ro = rotateY(time * rotationSpeed) * ro;
    
    float3 target = float3(0.0);
    float3 forward = normalize(target - ro);
    float3 right = normalize(cross(float3(0.0, 1.0, 0.0), forward));
    float3 up = cross(forward, right);
    
    float3 rd = normalize(forward + uv.x * right + uv.y * up);
    
    float t = 0.0;
    float3 p;
    
    for (int i = 0; i < 80; i++) {
        p = ro + rd * t;
        float d = sceneSdfShapes(p, time, operation, smoothFactor, shapeScale);
        
        if (d < 0.001) break;
        if (t > 15.0) break;
        
        t += d;
    }
    
    if (t > 15.0) {
        half3 bg = half3(0.02h, 0.02h, 0.05h);
        return half4(bg, 1.0h);
    }
    
    float2 e = float2(0.001, 0.0);
    float3 n = normalize(float3(
        sceneSdfShapes(p + e.xyy, time, operation, smoothFactor, shapeScale) -
        sceneSdfShapes(p - e.xyy, time, operation, smoothFactor, shapeScale),
        sceneSdfShapes(p + e.yxy, time, operation, smoothFactor, shapeScale) -
        sceneSdfShapes(p - e.yxy, time, operation, smoothFactor, shapeScale),
        sceneSdfShapes(p + e.yyx, time, operation, smoothFactor, shapeScale) -
        sceneSdfShapes(p - e.yyx, time, operation, smoothFactor, shapeScale)
    ));
    
    float3 lightDir = normalize(float3(1.0, 2.0, 1.0));
    float diff = max(dot(n, lightDir), 0.0);
    float spec = pow(max(dot(reflect(-lightDir, n), -rd), 0.0), 64.0);
    
    half3 matColor = half3(0.9h, 0.3h, 0.1h);
    half3 col = matColor * half(diff * 0.8 + 0.2) + half3(1.0h) * half(spec * 0.5);
    
    return half4(col, 1.0h);
}

// MARK: - Infinite Grid Shader

[[ stitchable ]]
half4 infiniteGrid(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float gridSize,
    float moveSpeed,
    float lineWidth,
    float fogDistance,
    float hue
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Camera looking down at grid
    float3 ro = float3(0.0, 1.0, time * moveSpeed);
    float3 rd = normalize(float3(uv.x, -0.5, 1.0));
    
    // Ray-plane intersection
    float t = -ro.y / rd.y;
    
    if (t < 0.0 || rd.y >= 0.0) {
        half3 sky = half3(0.0h, 0.0h, 0.02h);
        return half4(sky, 1.0h);
    }
    
    float3 p = ro + rd * t;
    
    // Grid lines
    float2 grid = abs(fract(p.xz / gridSize - 0.5) - 0.5) / fwidth(p.xz / gridSize);
    float line = min(grid.x, grid.y);
    
    float gridIntensity = 1.0 - smoothstep(0.0, lineWidth * 50.0, line);
    
    // Distance fog
    float fog = exp(-t / fogDistance);
    
    // Grid color
    half3 gridColor = half3(
        half(0.5 + 0.5 * sin(6.28318 * hue)),
        half(0.5 + 0.5 * sin(6.28318 * (hue + 0.33))),
        half(0.5 + 0.5 * sin(6.28318 * (hue + 0.67)))
    );
    
    half3 col = gridColor * half(gridIntensity * fog);
    
    // Horizon glow
    col += half3(0.1h, 0.0h, 0.2h) * half((1.0 - fog) * 0.5);
    
    return half4(col, 1.0h);
}

// MARK: - Tunnel Shader

/// Tunnel cross-section distance.
float tunnelCrossSection(float2 p, float shape, float radius) {
    int s = int(shape);
    
    if (s == 0) {
        // Circular
        return length(p) - radius;
    } else if (s == 1) {
        // Square
        float2 d = abs(p) - float2(radius);
        return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
    } else if (s == 2) {
        // Hexagonal
        float2 q = abs(p);
        return max(q.x * 0.866025 + q.y * 0.5, q.y) - radius;
    } else {
        // Star
        float angle = atan2(p.y, p.x);
        float r = length(p);
        float star = radius * (0.5 + 0.5 * sin(angle * 5.0));
        return r - star;
    }
}

[[ stitchable ]]
half4 tunnel(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float shape,
    float speed,
    float radius,
    float patternFrequency,
    float twist
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Tunnel raymarching
    float3 ro = float3(0.0, 0.0, time * speed);
    float3 rd = normalize(float3(uv, 1.0));
    
    half3 col = half3(0.0h);
    float t = 0.0;
    
    for (int i = 0; i < 64; i++) {
        float3 p = ro + rd * t;
        
        // Twist the tunnel
        float twistAngle = p.z * twist;
        float2 twisted = float2(
            p.x * cos(twistAngle) - p.y * sin(twistAngle),
            p.x * sin(twistAngle) + p.y * cos(twistAngle)
        );
        
        float d = -tunnelCrossSection(twisted, shape, radius);
        
        if (d < 0.001) {
            // Wall pattern
            float pattern = sin(p.z * patternFrequency) * sin(atan2(twisted.y, twisted.x) * 8.0);
            pattern = smoothstep(-0.1, 0.1, pattern);
            
            float fog = exp(-t * 0.1);
            
            half3 wallColor = mix(
                half3(0.1h, 0.0h, 0.3h),
                half3(0.0h, 0.5h, 1.0h),
                half(pattern)
            );
            
            col = wallColor * half(fog);
            break;
        }
        
        t += abs(d);
        if (t > 50.0) break;
    }
    
    return half4(col, 1.0h);
}

// MARK: - Volumetric Clouds Shader

[[ stitchable ]]
half4 cloudsVolumetric(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float density,
    float coverage,
    float windSpeed,
    float lightAngle,
    float detail
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Sky gradient
    half3 skyColor = mix(
        half3(0.4h, 0.6h, 0.9h),
        half3(0.2h, 0.4h, 0.8h),
        half(uv.y + 0.5)
    );
    
    // Ray setup
    float3 ro = float3(0.0, 0.5, 0.0);
    float3 rd = normalize(float3(uv.x, uv.y + 0.2, 1.0));
    
    // Light direction
    float3 lightDir = normalize(float3(cos(lightAngle), 0.5, sin(lightAngle)));
    
    // Cloud layer bounds
    float cloudBase = 1.0;
    float cloudTop = 3.0;
    
    // Ray-slab intersection
    float t0 = (cloudBase - ro.y) / rd.y;
    float t1 = (cloudTop - ro.y) / rd.y;
    
    if (t0 > t1) {
        float temp = t0;
        t0 = t1;
        t1 = temp;
    }
    
    if (t1 < 0.0) {
        return half4(skyColor, 1.0h);
    }
    
    t0 = max(t0, 0.0);
    
    // Volume raymarch
    half3 col = half3(0.0h);
    float transmittance = 1.0;
    
    float stepSize = (t1 - t0) / 32.0;
    float t = t0;
    
    for (int i = 0; i < 32; i++) {
        float3 p = ro + rd * t;
        
        // Wind animation
        p.xz += time * windSpeed;
        
        // Cloud density using FBM
        float cloudNoise = fbm3D(p * 0.5, int(detail));
        float cloudDensity = smoothstep(1.0 - coverage, 1.0, cloudNoise) * density;
        
        if (cloudDensity > 0.01) {
            // Light sampling
            float lightDensity = 0.0;
            float3 lightPos = p;
            
            for (int j = 0; j < 4; j++) {
                lightPos += lightDir * 0.2;
                float ln = fbm3D(lightPos * 0.5, int(detail));
                lightDensity += smoothstep(1.0 - coverage, 1.0, ln);
            }
            
            float lightTransmittance = exp(-lightDensity * 0.5);
            
            // Cloud color with light scattering
            half3 cloudColor = mix(
                half3(0.3h, 0.3h, 0.4h),
                half3(1.0h, 1.0h, 1.0h),
                half(lightTransmittance)
            );
            
            col += cloudColor * half(cloudDensity * transmittance * stepSize * 2.0);
            transmittance *= exp(-cloudDensity * stepSize * 2.0);
            
            if (transmittance < 0.01) break;
        }
        
        t += stepSize;
    }
    
    // Blend with sky
    col = mix(skyColor, col + skyColor * half(transmittance), half(1.0 - transmittance));
    
    return half4(col, 1.0h);
}

// MARK: - Fractal Terrain Shader

/// Terrain height function.
float terrainHeight(float2 p, int octaves) {
    float h = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    
    for (int i = 0; i < octaves; i++) {
        float2 pp = p * freq;
        float n = valueNoise(float3(pp.x, 0.0, pp.y));
        h += n * amp;
        amp *= 0.5;
        freq *= 2.0;
    }
    
    return h;
}

[[ stitchable ]]
half4 fractalTerrain(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float height,
    float octaves,
    float cameraHeight,
    float moveSpeed,
    float snowLine
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    // Camera
    float3 ro = float3(0.0, cameraHeight + 0.5, time * moveSpeed);
    float3 rd = normalize(float3(uv.x, uv.y - 0.2, 1.0));
    
    // Terrain raymarching
    float t = 0.0;
    float3 p;
    bool hit = false;
    
    for (int i = 0; i < 100; i++) {
        p = ro + rd * t;
        float h = terrainHeight(p.xz, int(octaves)) * height;
        
        if (p.y < h) {
            hit = true;
            break;
        }
        
        t += max(0.01, (p.y - h) * 0.5);
        if (t > 30.0) break;
    }
    
    if (!hit) {
        // Sky
        half3 sky = mix(
            half3(0.5h, 0.7h, 1.0h),
            half3(0.2h, 0.4h, 0.8h),
            half(max(0.0, uv.y + 0.5))
        );
        return half4(sky, 1.0h);
    }
    
    // Normal calculation
    float eps = 0.01;
    float h = terrainHeight(p.xz, int(octaves)) * height;
    float hx = terrainHeight(p.xz + float2(eps, 0.0), int(octaves)) * height;
    float hz = terrainHeight(p.xz + float2(0.0, eps), int(octaves)) * height;
    
    float3 n = normalize(float3(h - hx, eps, h - hz));
    
    // Lighting
    float3 lightDir = normalize(float3(0.5, 0.8, 0.3));
    float diff = max(dot(n, lightDir), 0.0);
    
    // Terrain color based on height and slope
    float normalizedHeight = h / height;
    float slope = 1.0 - n.y;
    
    half3 terrainColor;
    if (normalizedHeight > snowLine) {
        terrainColor = half3(0.95h, 0.95h, 1.0h); // Snow
    } else if (slope > 0.5) {
        terrainColor = half3(0.4h, 0.35h, 0.3h); // Rock
    } else if (normalizedHeight > snowLine * 0.5) {
        terrainColor = half3(0.3h, 0.4h, 0.2h); // Grass
    } else {
        terrainColor = half3(0.2h, 0.35h, 0.15h); // Low grass
    }
    
    half3 col = terrainColor * half(diff * 0.7 + 0.3);
    
    // Distance fog
    float fog = exp(-t * 0.05);
    half3 fogColor = half3(0.6h, 0.7h, 0.8h);
    col = mix(fogColor, col, half(fog));
    
    return half4(col, 1.0h);
}

// MARK: - Black Hole Shader

[[ stitchable ]]
half4 blackHole(
    float2 position,
    half4 color,
    float4 bounds,
    float time,
    float mass,
    float diskBrightness,
    float diskSpeed,
    float starDensity
) {
    float2 uv = (position - bounds.zw * 0.5) / min(bounds.z, bounds.w);
    
    float dist = length(uv);
    float angle = atan2(uv.y, uv.x);
    
    // Schwarzschild radius
    float rs = 0.1 * mass;
    
    // Event horizon (pure black)
    if (dist < rs) {
        return half4(0.0h, 0.0h, 0.0h, 1.0h);
    }
    
    // Gravitational lensing
    float bendStrength = rs * rs / (dist * dist);
    float2 bentUV = uv * (1.0 + bendStrength);
    
    // Star field
    half3 stars = half3(0.0h);
    float2 starUV = bentUV * starDensity;
    float2 starCell = floor(starUV);
    float2 starLocal = fract(starUV);
    
    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            float2 cell = starCell + float2(i, j);
            float2 starPos = float2(
                hash(cell.x + cell.y * 57.0),
                hash(cell.x * 57.0 + cell.y)
            );
            
            float2 toStar = starLocal - starPos - float2(i, j);
            float starDist = length(toStar);
            float brightness = hash(cell.x * 113.0 + cell.y * 31.0);
            
            if (starDist < 0.05 * brightness) {
                float glow = exp(-starDist * 40.0) * brightness;
                stars += half3(half(glow));
            }
        }
    }
    
    // Accretion disk
    half3 disk = half3(0.0h);
    float diskInner = rs * 1.5;
    float diskOuter = rs * 6.0;
    
    if (dist > diskInner && dist < diskOuter) {
        // Disk rotation
        float diskAngle = angle + time * diskSpeed / dist;
        
        // Disk intensity
        float diskFalloff = smoothstep(diskOuter, diskInner, dist);
        diskFalloff *= smoothstep(diskInner, diskInner * 1.2, dist);
        
        // Disk pattern
        float pattern = sin(diskAngle * 8.0 - time * 2.0) * 0.5 + 0.5;
        pattern += valueNoise(float3(diskAngle * 10.0, dist * 20.0, time)) * 0.3;
        
        // Doppler effect (blue shift on approaching side, red shift on receding)
        float dopplerShift = sin(diskAngle - time * diskSpeed);
        
        half3 diskColor;
        if (dopplerShift > 0.0) {
            diskColor = mix(half3(1.0h, 0.7h, 0.3h), half3(0.5h, 0.7h, 1.0h), half(dopplerShift));
        } else {
            diskColor = mix(half3(1.0h, 0.7h, 0.3h), half3(1.0h, 0.3h, 0.1h), half(-dopplerShift));
        }
        
        disk = diskColor * half(diskFalloff * pattern * diskBrightness);
    }
    
    // Photon sphere glow
    float photonSphere = rs * 1.5;
    float photonGlow = exp(-abs(dist - photonSphere) * 10.0) * 0.5;
    
    // Combine
    half3 col = stars + disk + half3(1.0h, 0.8h, 0.5h) * half(photonGlow);
    
    return half4(col, 1.0h);
}

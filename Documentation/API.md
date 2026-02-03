# SwiftShaders API Documentation

## Overview

SwiftShaders provides 30+ custom Metal shaders as SwiftUI view modifiers.

## Blur Effects

### gaussianBlur

```swift
view.gaussianBlur(radius: CGFloat)
```

Applies Gaussian blur with configurable radius.

### motionBlur

```swift
view.motionBlur(angle: Angle, intensity: Double)
```

Directional motion blur effect.

### zoomBlur

```swift
view.zoomBlur(center: UnitPoint, amount: Double)
```

Radial zoom blur from center point.

## Color Effects

### colorGrading

```swift
view.colorGrading(
    shadows: Color,
    midtones: Color,
    highlights: Color
)
```

Professional three-way color correction.

### grayscale

```swift
view.grayscale(algorithm: GrayscaleAlgorithm)
```

Algorithms: `.luminosity`, `.average`, `.lightness`

### sepia

```swift
view.sepia(intensity: Double)
```

Vintage sepia tone effect.

## Distortion Effects

### wave

```swift
view.wave(
    amplitude: Double,
    frequency: Double,
    speed: Double
)
```

Animated wave distortion.

### pixelate

```swift
view.pixelate(scale: Int)
```

Retro pixelation effect.

### ripple

```swift
view.ripple(
    center: UnitPoint,
    amplitude: Double,
    frequency: Double
)
```

Water ripple distortion.

## Stylization

### bloom

```swift
view.bloom(
    intensity: Double,
    threshold: Double
)
```

Light bleed glow effect.

### vignette

```swift
view.vignette(
    radius: Double,
    softness: Double
)
```

Edge darkening effect.

### halftone

```swift
view.halftone(
    dotSize: Double,
    angle: Angle
)
```

Comic book dot pattern.

## Full Shader List

| Shader | Category | Parameters |
|--------|----------|------------|
| gaussianBlur | Blur | radius |
| motionBlur | Blur | angle, intensity |
| zoomBlur | Blur | center, amount |
| boxBlur | Blur | radius |
| colorGrading | Color | shadows, midtones, highlights |
| grayscale | Color | algorithm |
| sepia | Color | intensity |
| hueRotation | Color | angle |
| saturation | Color | amount |
| contrast | Color | amount |
| brightness | Color | amount |
| invert | Color | - |
| posterize | Color | levels |
| wave | Distortion | amplitude, frequency, speed |
| pixelate | Distortion | scale |
| ripple | Distortion | center, amplitude, frequency |
| swirl | Distortion | center, amount, radius |
| spherize | Distortion | center, amount |
| bloom | Style | intensity, threshold |
| vignette | Style | radius, softness |
| halftone | Style | dotSize, angle |
| crosshatch | Style | density, width |
| noise | Style | intensity |
| filmGrain | Style | intensity |
| chromaticAberration | Style | offset |
| glow | Style | color, radius, intensity |
| outline | Style | color, width |
| emboss | Style | amount |
| sharpen | Style | amount |
| liquidGlass | iOS26 | - |

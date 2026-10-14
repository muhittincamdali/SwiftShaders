# ``SwiftShaders``

Metal shader effects for SwiftUI views, applied with one view modifier each.

## Overview

SwiftShaders is a set of GPU effects built on SwiftUI's own shader support
(`colorEffect`, `distortionEffect` and `layerEffect`, available from iOS 17 and macOS 14). Each
effect is a view modifier, so you add it like any other:

```swift
import SwiftShaders
import SwiftUI

struct Poster: View {
    var body: some View {
        Image(systemName: "mountain.2.fill")
            .font(.system(size: 96))
            .foregroundStyle(.blue)
            .halftone(dotSize: 6)
    }
}
```

The package has color effects that recolor each pixel, layer effects that read neighboring
pixels, distortions that move pixels, shape fills, view transitions and a ripple that follows
taps. Every argument is checked before it reaches the GPU, animated effects stop when Reduce
Motion is on, and the shaders' output is tested pixel by pixel on macOS and on an iOS simulator.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:AnimatingEffects>
- <doc:HowEffectsAreDrawn>

### Color effects

- ``SwiftUICore/View/sepia(_:)``
- ``SwiftUICore/View/duotone(shadows:highlights:amount:)``
- ``SwiftUICore/View/gradientMap(_:amount:)``
- ``SwiftUICore/View/posterize(levels:)``
- ``SwiftUICore/View/threshold(_:dark:light:)``
- ``SwiftUICore/View/dither(levels:)``
- ``SwiftUICore/View/vignette(intensity:radius:softness:)``
- ``SwiftUICore/View/scanlines(spacing:intensity:)``
- ``SwiftUICore/View/filmGrain(intensity:time:)``
- ``SwiftUICore/View/shimmer(color:intensity:width:angle:duration:time:)``

### Layer effects

- ``SwiftUICore/View/pixelate(cellSize:)``
- ``SwiftUICore/View/halftone(dotSize:angle:ink:paper:)``
- ``SwiftUICore/View/sketch(strength:lineWidth:lineColor:paperColor:)``
- ``SwiftUICore/View/emboss(strength:distance:angle:)``
- ``SwiftUICore/View/sharpen(_:radius:)``
- ``SwiftUICore/View/progressiveBlur(radius:from:to:)``
- ``SwiftUICore/View/chromaticAberration(offset:angle:)``
- ``SwiftUICore/View/kaleidoscope(segments:center:rotation:)``
- ``SwiftUICore/View/glitch(intensity:time:)``

### Distortions

- ``SwiftUICore/View/wave(amplitude:wavelength:speed:time:)``
- ``SwiftUICore/View/water(amplitude:scale:speed:time:)``
- ``SwiftUICore/View/swirl(angle:radius:center:)``
- ``SwiftUICore/View/bulge(strength:radius:center:)``

### Ripples

- ``SwiftUICore/View/rippleOnTap(style:duration:)``
- ``SwiftUICore/View/ripple(origin:elapsedTime:style:)``
- ``RippleStyle``

### Fills

- ``SwiftUICore/ShapeStyle/checkerboard(cellSize:_:_:)``
- ``SwiftUICore/ShapeStyle/stripes(width:angle:_:_:)``
- ``SwiftUICore/ShapeStyle/plasma(time:scale:colors:)``

### Transitions

- ``SwiftUICore/AnyTransition/dissolve``
- ``SwiftUICore/AnyTransition/dissolve(grainSize:seed:)``
- ``SwiftUICore/AnyTransition/pixelate``
- ``SwiftUICore/AnyTransition/pixelate(maxCellSize:)``
- ``SwiftUICore/AnyTransition/swirl``
- ``SwiftUICore/AnyTransition/swirl(angle:)``
- ``SwiftUICore/AnyTransition/circleReveal(center:)``
- ``SwiftUICore/AnyTransition/radialWipe(center:startAngle:)``

### Time

- ``ShaderTime``

### The shader library

- ``SwiftUICore/ShaderLibrary/swiftShaders``
- ``SwiftShaders/SwiftShaders``

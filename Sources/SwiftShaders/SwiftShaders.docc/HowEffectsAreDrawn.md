# How effects are drawn

The three kinds of effect, what they cost, how arguments are checked, and how to call the shaders
yourself.

## Overview

SwiftUI runs a shader for every pixel of a view. What the shader may read and return decides
which of SwiftUI's three effect modifiers it uses, and SwiftShaders groups its effects the same
way.

### Color effects

A color effect gets one pixel's position and color and returns a new color. It cannot see other
pixels, which makes it the cheapest kind: sepia, duotone, gradient map, posterize, threshold,
dither, vignette, scanlines, film grain and shimmer, and the dissolve, circle-reveal and
radial-wipe transitions. SwiftUI hands shaders premultiplied colors; these effects work on the
straight color and multiply the alpha back in, so text, symbols and translucent views keep their
antialiased edges.

### Distortions

A distortion effect returns the position whose color the pixel should show. The wave, water,
swirl, bulge and loupe effects are distortions. They tell SwiftUI how far they move content through
`maxSampleOffset`, so SwiftUI can draw the view into a larger offscreen layer and content moved
past an edge is not cut off. SwiftShaders limits that offset to the view's diagonal: an offset
grows the offscreen layer on every side, and an unbounded one could allocate gigabytes for a
radius typed as 10 instead of 1.

### Layer effects

A layer effect can read any pixel of the view. Pixelate, halftone, sketch, emboss, sharpen,
progressive blur, chromatic aberration, kaleidoscope, glitch and the ripple are layer effects.

- SwiftShaders draws the view into a compositing group first. Without one, SwiftUI applies the
  effect to each part of the view on its own, a background and the text on it, for example, and
  the shader would find edges between the parts that are not in the picture.
- Effects that compare neighboring pixels clamp the positions they read to the view. Pixels
  outside the view are transparent, and reading them drew a dark or bright border around a
  sharpened or sketched view. Because they read nothing outside, these effects need no
  offscreen margin at all.
- The kaleidoscope mirrors points outside the view back into it, so its pattern has no gaps.
- The progressive blur takes 49 samples in each of two passes whatever the radius, so its cost
  per pixel is fixed. Near an edge it averages only the samples inside the view.

### Arguments

A shader has no error handling: a NaN position, a zero divisor or a value too large for a
32-bit float draws nothing or garbage. Every public argument is therefore checked in Swift first:

| Input | What happens |
| --- | --- |
| NaN strength, amount or amplitude | 0, which switches the effect off |
| Value outside its documented range | clamped to the range |
| NaN or infinite angle used as a direction | 0; other angles are wrapped to one turn |
| NaN position or unit point | the view's center, or the origin for a point |
| Position too far away for a 32-bit float | limited to 1,000,000 points |
| Time too large for a 32-bit float | wrapped to the hour, like animated time |
| Count such as `levels` or `segments` | clamped, with no integer conversion that could trap |
| Gradient map colors | an empty list switches the effect off; at most 256 colors are used |

### Calling a shader yourself

``SwiftUICore/ShaderLibrary/swiftShaders`` is the compiled library. You can use its functions
with SwiftUI's own `colorEffect`, `distortionEffect` and `layerEffect`, or as a fill:

```swift
RoundedRectangle(cornerRadius: 16)
    .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
    .frame(width: 200, height: 120)
```

Pass the arguments that follow the ones SwiftUI supplies (the position, then the color or the
layer), in order. A call whose arguments do not match draws nothing, and calling a shader
directly skips the argument checks described above. Most functions take the view's size as a
`float2` first; get it from `visualEffect`'s geometry proxy.

| Function | Kind | Arguments after the ones SwiftUI supplies |
| --- | --- | --- |
| `ssSepia` | color | size, amount |
| `ssDuotone` | color | size, shadows color, highlights color, amount |
| `ssGradientMap` | color | size, color array, amount |
| `ssPosterize` | color | size, levels |
| `ssThreshold` | color | size, cutoff, dark color, light color |
| `ssDither` | color | size, levels |
| `ssVignette` | color | size, intensity, radius, softness |
| `ssScanlines` | color | size, spacing, intensity |
| `ssFilmGrain` | color | size, time, intensity |
| `ssShimmer` | color | size, time, color, intensity, width, angle in radians, duration |
| `ssDissolve` | color | size, progress, grain size, seed |
| `ssCircleReveal` | color | size, center, progress |
| `ssRadialWipe` | color | size, center, progress, start angle in radians |
| `ssWave` | distortion | size, time, amplitude, wavelength, speed |
| `ssWater` | distortion | size, time, amplitude, scale, speed |
| `ssSwirl` | distortion | size, center, radius in points, angle in radians |
| `ssBulge` | distortion | size, center, radius in points, strength |
| `ssLoupe` | distortion | size, center, radius in points, magnification |
| `ssPixelate` | layer | size, cell size |
| `ssHalftone` | layer | size, cell size, angle in radians, ink color, paper color |
| `ssSketch` | layer | size, strength, line width, line color, paper color |
| `ssEmboss` | layer | size, strength, offset as `float2` |
| `ssSharpen` | layer | size, amount, radius |
| `ssProgressiveBlur` | layer | size, start point, end point, radius, pass direction `(1, 0)` or `(0, 1)` |
| `ssChromaticAberration` | layer | size, offset as `float2` |
| `ssKaleidoscope` | layer | size, center, segments, rotation in radians |
| `ssGlitch` | layer | size, time, intensity |
| `ssRipple` | layer | size, origin, elapsed time, amplitude, frequency, decay, speed |
| `ssCheckerboard` | fill | cell size, first color, second color |
| `ssStripes` | fill | width, angle in radians, first color, second color |
| `ssPlasma` | fill | `.boundingRect`, time, scale, three colors |

## See Also

- <doc:GettingStarted>
- <doc:AnimatingEffects>

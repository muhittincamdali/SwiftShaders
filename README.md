# SwiftShaders

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20tvOS%2017%2B%20%7C%20visionOS%201%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

A comprehensive Metal shader library for SwiftUI with 30+ visual effects as easy-to-use view modifiers.

## Features

- 🎨 **30+ Shader Effects** - Ripple, Glitch, Chromatic Aberration, Hologram, Fire, Water, Electric, and more
- 🔧 **SwiftUI Native** - All effects as view modifiers that work with any SwiftUI view
- ⚡ **GPU Accelerated** - Metal shaders for maximum performance
- 🎬 **Animation Ready** - Built-in animation support with customizable timing
- 📱 **Cross-Platform** - iOS 17+, macOS 14+, tvOS 17+, visionOS 1+
- 📚 **Fully Documented** - DocC documentation for all public APIs

## Installation

### Swift Package Manager

Add SwiftShaders to your project via Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/muhittinpalamutcu/SwiftShaders.git`
3. Select your desired version

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittinpalamutcu/SwiftShaders.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftUI
import SwiftShaders

struct ContentView: View {
    @State private var time: Double = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            Image("photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rippleEffect(time: time)
        }
    }
}
```

## Available Shaders

### Distortion Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Ripple** | Water ripple distortion | `.rippleEffect(time:origin:amplitude:)` |
| **Wave** | Sine wave distortion | `.waveEffect(time:amplitude:frequency:)` |
| **Swirl** | Spiral twirl effect | `.swirlDistortion(center:radius:angle:)` |
| **Barrel** | Fisheye lens distortion | `.barrelDistortion(strength:zoom:)` |
| **Kaleidoscope** | Mirror pattern effect | `.kaleidoscope(segments:rotation:)` |

### Color Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Chromatic Aberration** | RGB channel separation | `.chromaticAberration(intensity:angle:)` |
| **Color Grading** | Professional color controls | `.colorGrading(brightness:contrast:saturation:)` |
| **Vibrance** | Smart saturation boost | `.vibrance(_:)` |
| **Split Toning** | Shadow/highlight coloring | `.splitToning(shadowHue:highlightHue:)` |
| **Film Emulation** | Analog film looks | `.filmEmulation(_:intensity:)` |

### Transition Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Dissolve** | Noise-based dissolve | `.dissolveEffect(progress:scale:)` |
| **Burn Dissolve** | Fire-edge dissolve | `.burnDissolve(progress:)` |
| **Pixelate** | Retro pixel transition | `.pixelateEffect(pixelSize:)` |
| **Directional Dissolve** | Sweep dissolve | `.directionalDissolve(progress:angle:)` |

### Stylization Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Hologram** | Sci-fi hologram look | `.hologramEffect(time:)` |
| **Glitch** | Digital glitch artifacts | `.glitchEffect(time:intensity:)` |
| **VHS** | Retro VHS tape effect | `.vhsGlitch(time:)` |
| **Neon** | Neon glow edges | `.neonElectric(time:)` |

### Environmental Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Fire** | Procedural flames | `.fireEffect(time:intensity:)` |
| **Lava** | Molten lava flow | `.lavaEffect(time:)` |
| **Water** | Water surface ripples | `.waterSurface(time:)` |
| **Caustics** | Underwater light patterns | `.caustics(time:)` |
| **Lightning** | Electric bolts | `.lightning(time:)` |
| **Plasma** | Plasma ball effect | `.plasma(time:)` |

### Blur Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Radial Blur** | Zoom blur effect | `.radialBlur(center:strength:)` |
| **Motion Blur** | Directional blur | `.motionBlur(angle:strength:)` |
| **Tilt-Shift** | Miniature effect | `.tiltShift(focusY:)` |
| **Frost** | Frosted glass | `.frostEffect(time:)` |

### Noise Effects

| Effect | Description | Example |
|--------|-------------|---------|
| **Film Grain** | Cinematic grain | `.filmGrain(time:intensity:)` |
| **Perlin Distort** | Organic distortion | `.perlinDistort(time:)` |
| **Voronoi** | Cellular patterns | `.voronoiNoise(time:)` |
| **Turbulence** | Turbulent flow | `.turbulence(time:)` |

## Advanced Usage

### Animation Support

Use the built-in animation helpers:

```swift
// Self-animating shader
AnimatedShaderView(speed: 1.0) { time in
    Image("photo")
        .rippleEffect(time: time)
}

// Pulsing effect
PulsingShaderView(pulseDuration: 2.0) { progress in
    Image("photo")
        .chromaticAberration(intensity: progress * 0.05)
}

// Triggered animation
@State private var trigger = false

TriggeredShaderView(trigger: $trigger, duration: 0.5) { progress in
    Image("photo")
        .dissolveEffect(progress: progress)
}
```

### Custom Shader Configuration

```swift
let config = ShaderConfiguration(
    quality: .high,
    samplingMode: .bilinear,
    blendMode: .normal,
    opacity: 0.8
)
```

### Chaining Multiple Effects

```swift
Image("photo")
    .rippleEffect(time: time)
    .chromaticAberration(intensity: 0.02)
    .filmGrain(time: time, intensity: 0.1)
```

### Interactive Effects

```swift
InteractiveShaderView { location, isPressed in
    Image("photo")
        .sphereBulge(
            center: location,
            radius: isPressed ? 100 : 0,
            strength: 0.5
        )
}
```

### Shader Preview (Debug)

```swift
ShaderPreview {
    Image("photo")
        .resizable()
        .aspectRatio(contentMode: .fit)
}
```

## Shader Library

Access shader information programmatically:

```swift
// Get all shaders
let shaders = ShaderLibrary.shared.availableShaders

// Filter by category
let distortionShaders = ShaderLibrary.shared.distortionShaders
let colorShaders = ShaderLibrary.shared.colorShaders

// Find specific shader
if let ripple = ShaderLibrary.shared.shader(named: "ripple") {
    print(ripple.description)
}
```

## Performance Tips

1. **Use appropriate quality settings** - Lower quality for real-time effects
2. **Limit shader stacking** - Each shader adds GPU overhead
3. **Prefer color effects over distortion** - Distortion effects sample multiple pixels
4. **Use conditional rendering** - Apply effects only when visible

```swift
.shaderIf(isVisible) { view in
    view.rippleEffect(time: time)
}
```

## Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / visionOS 1.0+
- Swift 5.9+
- Xcode 15.0+

## Documentation

Full API documentation is available via DocC. In Xcode:
1. Build Documentation (Product → Build Documentation)
2. Browse the SwiftShaders documentation

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

SwiftShaders is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Acknowledgments

- Built with SwiftUI and Metal
- Inspired by various shader tutorials and the shader art community

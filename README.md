# SwiftShaders 🎨

Real-time Metal shaders exposed as SwiftUI view modifiers. Ripple, chromatic aberration, glitch, pixelate, wave distortion, noise, dissolve, and hologram — all GPU-accelerated and ready to drop into any SwiftUI view.

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)](https://developer.apple.com/ios/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager/)

---

## Why SwiftShaders?

Apple gave us `ShaderLibrary` in iOS 17 but left the developer experience pretty raw — you're on your own writing `.metal` files, bridging uniforms, and wiring up animation timers. SwiftShaders wraps all of that into clean, chainable SwiftUI view modifiers so you can add cinematic effects in one line.

---

## Included Shaders

| Shader | Effect | Key Parameters |
|--------|--------|---------------|
| **Ripple** | Concentric water ripple from a touch point | `origin`, `frequency`, `amplitude`, `decay` |
| **ChromaticAberration** | RGB channel split | `intensity`, `angle` |
| **Glitch** | Digital glitch distortion | `intensity`, `speed`, `blockSize` |
| **Pixelate** | Mosaic pixel grid | `pixelSize` |
| **Wave** | Sine wave distortion | `amplitude`, `frequency`, `speed` |
| **Noise** | Perlin / simplex noise overlay | `scale`, `speed`, `opacity` |
| **Dissolve** | Burn-away dissolve transition | `progress`, `edgeColor`, `edgeWidth` |
| **Hologram** | Rainbow holographic foil | `speed`, `intensity`, `angle` |

---

## Quick Start

### Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftShaders.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the URL.

### Basic Usage

```swift
import SwiftShaders

struct ContentView: View {
    @State private var rippleOrigin: CGPoint = .zero
    
    var body: some View {
        Image("hero")
            .resizable()
            .scaledToFill()
            .rippleEffect(origin: rippleOrigin)
            .onTapGesture { location in
                rippleOrigin = location
            }
    }
}
```

### Chaining Effects

```swift
Text("GLITCH")
    .font(.system(size: 64, weight: .black))
    .glitchEffect(intensity: 0.6)
    .chromaticAberration(intensity: 3.0)
```

### Animated Dissolve

```swift
struct DissolveDemo: View {
    @State private var progress: Double = 0
    
    var body: some View {
        Image("poster")
            .dissolveEffect(
                progress: progress,
                edgeColor: .orange,
                edgeWidth: 0.04
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.5)) {
                    progress = progress < 1 ? 1 : 0
                }
            }
    }
}
```

---

## Shader Catalog

### Ripple

Generates concentric circular waves emanating from a point. Useful for touch feedback or water surface effects.

```swift
myView.rippleEffect(
    origin: CGPoint(x: 0.5, y: 0.5),
    frequency: 15,
    amplitude: 0.02,
    decay: 4.0,
    speed: 1.0
)
```

### Chromatic Aberration

Splits the RGB channels by an offset, simulating lens imperfections. Pairs well with glitch.

```swift
myView.chromaticAberration(
    intensity: 5.0,
    angle: .degrees(0)
)
```

### Glitch

Randomly offsets horizontal blocks, mimicking digital signal corruption. The effect is time-based and non-deterministic for realism.

```swift
myView.glitchEffect(
    intensity: 0.5,
    speed: 2.0,
    blockSize: 8.0
)
```

### Pixelate

Reduces the render to a grid of solid-color blocks. Great for transitions or retro aesthetics.

```swift
myView.pixelateEffect(pixelSize: 12)
```

### Wave

Applies a sine-wave displacement to the texture. Can simulate heat haze, underwater distortion, or flag waving.

```swift
myView.waveEffect(
    amplitude: 10,
    frequency: 3,
    speed: 1.5
)
```

### Noise

Overlays animated Perlin noise. Use for film grain, fog, or procedural textures.

```swift
myView.noiseEffect(
    scale: 4.0,
    speed: 0.5,
    opacity: 0.3
)
```

### Dissolve

Burns away the view from noise-generated edges. Perfect for scene transitions.

```swift
myView.dissolveEffect(
    progress: 0.5,
    edgeColor: .cyan,
    edgeWidth: 0.03
)
```

### Hologram

Creates a rainbow-shifting foil overlay that reacts to time or device motion.

```swift
myView.hologramEffect(
    speed: 1.0,
    intensity: 0.6,
    angle: .degrees(45)
)
```

---

## Architecture

```
Sources/SwiftShaders/
├── Core/
│   ├── ShaderLibrary.swift       # shader loading & caching
│   └── ShaderModifier.swift      # base ViewModifier protocol
├── Shaders/
│   ├── Ripple.metal + RippleShader.swift
│   ├── ChromaticAberration.metal + ChromaticShader.swift
│   ├── Glitch.metal + GlitchShader.swift
│   ├── Pixelate.metal + PixelateShader.swift
│   ├── Wave.metal + WaveShader.swift
│   ├── Noise.metal + NoiseShader.swift
│   ├── Dissolve.metal + DissolveShader.swift
│   └── Hologram.metal + HologramShader.swift
└── SwiftUI/
    ├── ShaderView.swift          # generic shader container
    └── AnimatedShader.swift      # auto-animating wrapper
```

---

## Requirements

- iOS 17+ / macOS 14+ / tvOS 17+ / visionOS 1+
- Swift 5.9+
- Xcode 15+
- Metal-capable device (no simulator for some effects)

---

## Performance

- All shaders run on the GPU — zero CPU overhead for the effect itself
- `ShaderLibrary` caches compiled shaders after first use
- `AnimatedShader` uses `CADisplayLink` pacing to avoid unnecessary frames
- Each shader function is `[[ stitchable ]]` for integration with SwiftUI's `layerEffect` / `colorEffect` / `distortionEffect`

---

## How It Works

SwiftShaders leverages the `ShaderLibrary` API introduced in iOS 17. Each `.metal` file contains a `[[ stitchable ]]` function that SwiftUI can call per-pixel. The Swift-side wrapper:

1. Loads the shader function by name via `ShaderLibrary`
2. Binds uniform values (intensity, speed, etc.) as shader arguments
3. Applies the shader as a `.layerEffect`, `.colorEffect`, or `.distortionEffect` modifier
4. Optionally drives a `TimelineView` for animation

---

## Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/new-shader`)
3. Write the `.metal` shader + Swift modifier
4. Add usage examples to the README
5. Open a Pull Request

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

## Author

**Muhittin Camdali**
- GitHub: [@muhittincamdali](https://github.com/muhittincamdali)

---

> Pixels deserve better. 🌈

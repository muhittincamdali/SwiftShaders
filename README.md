<p align="center">
  <img src="Assets/logo.png" alt="SwiftShaders" width="200"/>
</p>

<h1 align="center">SwiftShaders</h1>

<p align="center">
  <strong>🎨 34 Production-Ready Metal Shaders as SwiftUI View Modifiers</strong>
</p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0-F05138.svg?style=flat&logo=swift" alt="Swift 6.0"/></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-17.0+-007AFF.svg?style=flat&logo=apple" alt="iOS 17.0+"/></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-14.0+-007AFF.svg?style=flat&logo=apple" alt="macOS 14.0+"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"/></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#all-34-shaders">All Shaders</a> •
  <a href="#usage">Usage</a> •
  <a href="#performance">Performance</a>
</p>

---

## ✨ Why SwiftShaders?

Metal shaders are incredibly powerful for creating stunning visual effects, but they require deep GPU programming knowledge. **SwiftShaders** packages **34 production-ready effects** as simple SwiftUI view modifiers.

```swift
import SwiftShaders

Image("photo")
    .hologram()
    .glitch(intensity: 0.3)
    .neonGlow(color: .cyan)
```

## 📦 Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftShaders.git", from: "1.0.0")
]
```

## 🎨 All 34 Shaders

### 🌈 Visual Effects (8)

| Shader | Description | Parameters |
|--------|-------------|------------|
| **Hologram** | Holographic rainbow scanning effect | `intensity`, `speed`, `colorShift` |
| **Glitch** | Digital glitch with RGB split | `intensity`, `speed`, `blockSize` |
| **CRT** | Retro CRT monitor with scanlines | `curvature`, `scanlineIntensity`, `phosphorScale` |
| **Scanlines** | TV scanline overlay | `count`, `intensity`, `style` |
| **Pixelate** | Retro pixel art effect | `pixelSize`, `style` |
| **Electric** | Lightning/electric discharge | `intensity`, `branches`, `speed` |
| **Dissolve** | Particle dissolve transition | `progress`, `edgeColor`, `edgeWidth` |
| **Noise** | Perlin/Simplex noise generation | `scale`, `octaves`, `persistence` |

### 🎭 Color Effects (7)

| Shader | Description | Parameters |
|--------|-------------|------------|
| **Chromatic Aberration** | RGB channel split | `offset`, `angle`, `falloff` |
| **Color Grading** | Professional color correction | `lift`, `gamma`, `gain`, `saturation` |
| **Posterize** | Reduce color levels | `levels`, `style` |
| **Sepia** | Vintage sepia tone | `intensity`, `style` |
| **Invert** | Color/luminance inversion | `amount`, `style` |
| **Threshold** | Binary/multi-level threshold | `threshold`, `dithering` |
| **Neon** | Neon glow effect | `color`, `intensity`, `style` |

### 🌊 Distortion Effects (8)

| Shader | Description | Parameters |
|--------|-------------|------------|
| **Ripple** | Water ripple distortion | `center`, `amplitude`, `frequency` |
| **Wave** | Sine wave distortion | `amplitude`, `frequency`, `speed` |
| **Swirl** | Spiral/vortex distortion | `angle`, `radius`, `center` |
| **Barrel** | Barrel/pincushion distortion | `amount`, `style` |
| **Displacement** | Texture-based displacement | `strength`, `direction` |
| **Kaleidoscope** | Mirror symmetry patterns | `segments`, `rotation` |
| **Frost** | Frosted glass effect | `amount`, `crystalScale` |
| **Water** | Realistic water surface | `depth`, `caustics`, `foam` |

### 🔥 Generative Effects (5)

| Shader | Description | Parameters |
|--------|-------------|------------|
| **Fire** | Procedural fire/flames | `intensity`, `speed`, `color` |
| **Voronoi** | Voronoi cell patterns | `scale`, `style`, `animate` |
| **Raymarching** | 3D raymarched shapes | `shape`, `lighting`, `material` |
| **Particles** | Procedural particles | `type`, `density`, `speed` |
| **Mosaic** | Tile/mosaic patterns | `tileSize`, `groutWidth`, `pattern` |

### 🖼️ Image Processing (5)

| Shader | Description | Parameters |
|--------|-------------|------------|
| **Blur** | Gaussian/motion/radial blur | `radius`, `style`, `direction` |
| **Sharpen** | Edge enhancement | `amount`, `radius`, `threshold` |
| **Emboss** | 3D relief/emboss effect | `strength`, `lightAngle`, `style` |
| **Vignette** | Edge darkening | `radius`, `softness`, `color` |
| **Sketch** | Pencil/ink drawing effect | `style`, `lineWidth`, `threshold` |

## 🚀 Usage

### Basic Usage

```swift
import SwiftShaders

struct ContentView: View {
    var body: some View {
        Image("photo")
            .resizable()
            .scaledToFit()
            .hologram()
    }
}
```

### With Parameters

```swift
Image("photo")
    .glitch(intensity: 0.5, speed: 2.0)
    .neonGlow(color: .cyan, intensity: 2.0)
    .vignette(radius: 0.5, softness: 0.3)
```

### Animated Shaders

```swift
struct AnimatedView: View {
    @State private var startTime = Date.now
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = startTime.distance(to: timeline.date)
            
            Image("photo")
                .ripple(time: time, amplitude: 20)
                .fire(time: time, intensity: 1.0)
        }
    }
}
```

### Combining Multiple Shaders

```swift
Image("photo")
    .sepia(intensity: 0.3)           // Vintage color
    .vignette(radius: 0.4)           // Edge darkening
    .scanlines(count: 240)           // Retro scanlines
    .crtEffect()                     // CRT curvature
```

### Interactive Effects

```swift
struct InteractiveView: View {
    @State private var touchPoint: CGPoint = .zero
    
    var body: some View {
        Image("photo")
            .ripple(center: touchPoint, amplitude: 30)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        touchPoint = value.location
                    }
            )
    }
}
```

## ⚡ Performance

All shaders are:

- **GPU-Accelerated**: Runs entirely on Metal GPU
- **60/120 FPS**: ProMotion display support
- **Battery Efficient**: Minimal CPU overhead
- **Memory Optimized**: No texture copies
- **Auto-Scaling**: Quality adapts to device capability

### Benchmarks

| Device | Shader Count | Frame Rate |
|--------|--------------|------------|
| iPhone 15 Pro | 5 combined | 120 fps |
| iPhone 13 | 5 combined | 60 fps |
| iPad Pro M2 | 10 combined | 120 fps |

## 📚 Documentation

Each shader includes:
- Detailed parameter documentation
- Algorithm explanation in Metal code
- Performance characteristics
- Usage examples

```swift
/// Applies holographic rainbow scanning effect
/// - Parameters:
///   - intensity: Effect strength (0.0-1.0)
///   - speed: Animation speed multiplier
///   - colorShift: Rainbow color rotation
func hologram(
    intensity: Float = 1.0,
    speed: Float = 1.0,
    colorShift: Float = 0.0
) -> some View
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

1. Fork the repository
2. Create your feature branch
3. Add shader with Metal code + SwiftUI wrapper
4. Include tests and documentation
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built with ❤️ for the SwiftUI community</sub>
</p>

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/SwiftShaders&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftShaders&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftShaders&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftShaders&type=Date" />
 </picture>
</a>

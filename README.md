<p align="center">
  <img src="Assets/logo.png" alt="SwiftShaders" width="200"/>
</p>

<h1 align="center">SwiftShaders</h1>

<p align="center">
  <strong>🎨 30+ custom Metal shaders as SwiftUI view modifiers</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift"/>
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS"/>
</p>

---

## Why SwiftShaders?

Metal shaders are powerful but require low-level knowledge. **SwiftShaders** packages beautiful effects as simple SwiftUI modifiers.

```swift
Image("photo")
    .shader(.hologram)
    .shader(.glitch(intensity: 0.3))
    .shader(.chromaticAberration(offset: 5))
```

## Available Shaders

### Visual Effects

| Shader | Description |
|--------|-------------|
| `.hologram` | Holographic rainbow effect |
| `.glitch` | Digital glitch distortion |
| `.pixelate` | Retro pixel effect |
| `.vhs` | VHS tape distortion |
| `.crt` | CRT monitor effect |
| `.ascii` | ASCII art conversion |

### Color Effects

| Shader | Description |
|--------|-------------|
| `.chromaticAberration` | RGB split |
| `.duotone` | Two-color filter |
| `.hueRotate` | Color shift |
| `.posterize` | Reduce colors |
| `.invert` | Negative effect |

### Blur & Distortion

| Shader | Description |
|--------|-------------|
| `.motionBlur` | Directional blur |
| `.zoomBlur` | Radial zoom blur |
| `.ripple` | Water ripple |
| `.wave` | Wave distortion |
| `.barrel` | Barrel distortion |

### Lighting

| Shader | Description |
|--------|-------------|
| `.glow` | Soft glow |
| `.neon` | Neon light effect |
| `.emboss` | 3D emboss |
| `.spotlight` | Focused light |

## Usage

```swift
import SwiftShaders

struct ContentView: View {
    @State var glitchIntensity = 0.0
    
    var body: some View {
        Image("hero")
            .shader(.hologram)
            .shader(.glitch(intensity: glitchIntensity))
            .animation(.default, value: glitchIntensity)
    }
}
```

## Customization

```swift
// Glitch with custom parameters
.shader(.glitch(
    intensity: 0.5,
    speed: 2.0,
    blockSize: 10
))

// Ripple from touch point
.shader(.ripple(
    center: touchPoint,
    amplitude: 20,
    frequency: 10
))
```

## Animation

```swift
// Animate shader parameters
TimelineView(.animation) { timeline in
    Image("photo")
        .shader(.wave(
            time: timeline.date.timeIntervalSinceReferenceDate,
            amplitude: 10
        ))
}
```

## Performance

- GPU-accelerated
- 60fps guaranteed
- Minimal battery impact
- Automatic quality scaling

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License

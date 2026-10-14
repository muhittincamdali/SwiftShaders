<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-light.svg" alt="SwiftShaders: Metal shader effects for SwiftUI views: color, blur, distortion, ripples and transitions."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Latest version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

A Swift package of GPU effects for SwiftUI on iOS 17+ and macOS 14+: color effects such as
sepia, duotone and halftone, a progressive blur, distortions such as wave, swirl and loupe,
ripples that follow taps, shader fills and view transitions. Each effect is one view modifier
on top of SwiftUI's own `colorEffect`, `distortionEffect` and `layerEffect`, so it works on any
view: an image, text, a shape or a whole screen. It is for app developers who want these
effects without writing Metal code, and for those who do, it documents every shader function so
they can be called directly. The package has no dependencies.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Three copies of a landscape drawn in code: on the left the rows sway on a wave, in the middle a ripple spreads from the center, on the right a band of light sweeps across"></p>

## Highlights

- **26 view modifiers, 3 fills and 5 transitions** — counted from the sources and listed in the
  table below, each with documented parameters and their ranges.
- **Arguments that cannot break a shader** — values are clamped to their ranges, a NaN switches
  an effect off, angles, positions and times are kept to values a 32-bit float can hold, and no
  argument can make SwiftUI allocate an offscreen layer larger than the view plus its diagonal.
- **Clean edges** — effects that compare neighboring pixels read only inside the view, so a
  sharpened, embossed or sketched view gets no dark or bright border, and color effects keep the
  antialiased alpha of text and symbols.
- **Reduce Motion** — animated effects stop on their first frame and ripples ignore taps when
  the setting is on.
- **Tested pixels** — 76 Swift Testing tests render the effects with `ImageRenderer` and
  compare pixels with values computed in Swift, on macOS and on an iPhone simulator. Another
  test loads the compiled Metal library and checks that it holds exactly the functions the Swift
  code calls.
- **Samples that compile** — every sample below comes from the
  [example app](Examples/ShaderGallery), which CI builds for iOS and macOS, and the tests render
  each one.

### What's included

| Kind | Effects |
| --- | --- |
| Color (10) | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer` |
| Layer (9) | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Distortion (5) | `wave`, `water`, `swirl`, `bulge`, `loupe` |
| Ripples (2) | `rippleOnTap`, `ripple(origin:elapsedTime:style:)` |
| Fills (3) | `.checkerboard`, `.stripes`, `.plasma` for any `ShapeStyle` |
| Transitions (5) | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe` |

Animated effects take a `ShaderTime`: `.animated`, `.animated(speed:)` or `.fixed(_:)` for a
single frame.

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Paste it into the search field at the top right of the window. Leave **Dependency Rule** at
**Up to Next Major Version** from `2.0.0`, then click **Add Package**. In the next window,
choose your app target next to **SwiftShaders** and click **Add Package** again.

**2. Import the module**

```swift
import SwiftShaders
```

Put this line at the top of the Swift file where you use an effect, below `import SwiftUI`.

**3. Use it**

In a new Xcode app (**File › New › Project… › App**), replace everything in `ContentView.swift`
with:

```swift
import SwiftShaders
import SwiftUI

struct ContentView: View {
    var body: some View {
        Image(systemName: "mountain.2.fill")
            .font(.system(size: 96))
            .foregroundStyle(.blue)
            .padding(40)
            .background(.blue.opacity(0.15), in: .rect(cornerRadius: 24))
            .halftone(dotSize: 6, ink: .blue, paper: .white)
    }
}
```

Press **Run** (⌘R). The mountains appear as a halftone print: blue dots on white paper, large
where the symbol is and small around it. Change `dotSize` to 10 and run again to see coarser
dots.

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftShaders.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftShaders", package: "SwiftShaders")
    ])
]
```

The effects are `.metal` files that are compiled into the package's bundle. Xcode always
compiles them, and so does `swift build` from Swift 6.4 on, where SwiftPM's Swift Build engine
is the default. With an older `swift build` the files are copied without being compiled and
views with an effect are not drawn; `SwiftShaders.isMetalLibraryAvailable` tells you which case
you are in.

Version 2.0.0 (October 2026) is a new package with a new API. The earlier release, 1.0.0
(February 2026), did not build with the current Metal compiler and looked for its shaders in the
app's bundle instead of the package's, so its effects never appeared. In June 2026 its code was
replaced with placeholders, and in October 2026 the package was written again from scratch.
[CHANGELOG.md](CHANGELOG.md) lists what changed.

## Usage

The samples below are copied from
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift).
The example app and the test suite both compile that file.

### Combine effects

Effects run in order, from the view outward:

```swift
struct RetroScreenSample: View {
    var body: some View {
        Text("GAME OVER")
            .font(.system(size: 44, weight: .black, design: .monospaced))
            .foregroundStyle(.cyan)
            .padding(32)
            .background(Color(red: 0.02, green: 0.07, blue: 0.2))
            .chromaticAberration(offset: 2)
            .scanlines(spacing: 3, intensity: 0.4)
            .vignette(intensity: 0.7)
    }
}
```

### Show that content is loading

`shimmer` brightens only what is drawn, so placeholder shapes shimmer and the space around them
stays empty. With Reduce Motion on, the band is not shown.

```swift
struct LoadingRowSample: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 8) {
                Capsule().frame(width: 160, height: 12)
                Capsule().frame(width: 100, height: 12)
            }
        }
        .foregroundStyle(.gray.opacity(0.3))
        .shimmer()
    }
}
```

### Animate over time

Animated effects run by themselves. Pass `time: .fixed(seconds)` to show one frame, for example
in previews and snapshot tests, or to drive the time from your own animation.

```swift
struct WavingFlagSample: View {
    var body: some View {
        Rectangle()
            .fill(.stripes(width: 18, angle: .zero, .blue, .white))
            .frame(width: 240, height: 150)
            .wave(amplitude: 5, wavelength: 120, speed: 0.8)
    }
}
```

### Ripple where the user taps

The tap is recognized alongside the view's own gestures, so buttons inside keep working.

```swift
struct RippleCardSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.blue.gradient)
            .overlay {
                Text("Tap me")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            .frame(width: 280, height: 180)
            .rippleOnTap()
    }
}
```

### Transition between views

```swift
struct DissolveTransitionSample: View {
    @State private var isShown = true

    var body: some View {
        VStack(spacing: 24) {
            if isShown {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .transition(.dissolve)
            }
            Button(isShown ? "Hide" : "Show") {
                withAnimation(.easeInOut(duration: 1)) { isShown.toggle() }
            }
        }
        .frame(height: 160)
    }
}
```

### Call a shader yourself

`ShaderLibrary.swiftShaders` is the compiled library, for SwiftUI's own effect modifiers or for
fills. The [argument list of every function](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
is in the documentation; calls made this way skip the package's argument checks.

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## Demo

Every effect applied to a landscape drawn in code, rendered by
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) from
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift):

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="The landscape with each color effect: original, sepia, duotone, gradient map, posterize, threshold, dither, vignette, scanlines, film grain and shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="The landscape with each layer effect: pixelate, halftone, sketch, emboss, sharpen, progressive blur, chromatic aberration, kaleidoscope and glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="The landscape with each distortion: wave, water, swirl, bulge and loupe"></picture>

The transitions at 0, 25, 50 and 75 percent of the way:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Frames of the dissolve, pixelate, swirl, circle reveal and radial wipe transitions"></picture>

The halftone in the example app on an iPhone simulator, captured by
[`scripts/capture-gallery.sh`](scripts/capture-gallery.sh):

| Light | Dark |
| --- | --- |
| ![The example app's Halftone screen with a dot size slider, light](docs/images/gallery-light.png) | ![The example app's Halftone screen with a dot size slider, dark](docs/images/gallery-dark.png) |

To try the effects yourself, open `ShaderGallery.xcodeproj` in
[`Examples/ShaderGallery`](Examples/ShaderGallery) with Xcode, choose an iPhone simulator or
**My Mac**, and press **Run**. Each effect has a slider for its main parameter;
[Examples/README.md](Examples/README.md) has the details.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC, published to GitHub Pages from `main`)
- Build it locally in Xcode with **Product › Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — add the package, apply and combine effects, check the build tool, Reduce Motion
  ([source](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — animated, fixed and self-driven time, ripples, and why time wraps every hour
  ([source](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — color, distortion and layer effects, how arguments are checked, and the argument list of
  every shader function ([source](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Requirements

| Platform  | Minimum version       |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

`swift build` and `swift test` from the command line need Swift 6.4 to compile the shaders (see
[Installation](#installation)); Xcode 26 and later compile them in any case. CI builds with the
default Xcode of GitHub's `macos-26` runner image. The package is developed with Xcode 27.

## Architecture

- `Sources/SwiftShaders/Shaders/` holds the Metal code, one file per kind of effect, with
  helpers in `ShaderCommon.h`. Every function is `[[ stitchable ]]` and starts with `ss`, so
  it cannot collide with shaders in an app.
- `Sources/SwiftShaders/Effects/`, `Fills/` and `Transitions/` hold the Swift API: one view
  modifier, fill or transition per shader, each a few lines that check the arguments and call
  the shader.
- `Core/ShaderEffect.swift` applies a shader: it measures the view with `visualEffect`, runs a
  `TimelineView` for animated effects (stopped with Reduce Motion) and puts layer effects on a
  compositing group. `Core/ShaderInput.swift` holds every argument check, and
  `Core/ShaderTime.swift` the animated and fixed time, wrapped every hour.
- Tests render views with `ImageRenderer` over black and over white, which gives the color and
  the alpha of every pixel, and compare them with values computed in Swift.
  `InputSafetyTests` passes NaN, infinite and huge values to every kind of effect, and
  `LibraryTests` compares the compiled library's function names with the names the Swift code
  calls.
- CI runs the tests on macOS and on an iPhone simulator through `xcodebuild`, builds the example
  app for iOS and macOS, and publishes the DocC documentation.

Run the tests locally:

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roadmap

- Add the package to the Swift Package Index; `.spi.yml` is already in the repository.
- Test and enable tvOS and visionOS, where SwiftUI has the same shader API.
- A masked variant of the progressive blur that follows any shape.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).

# Getting started

Add the package, apply a first effect and check that the shaders were compiled.

## Overview

SwiftShaders needs iOS 17 or macOS 14 and Swift 6.2 or later. It has no dependencies.

### Add the package

In Xcode, choose **File › Add Package Dependencies**, enter
`https://github.com/muhittincamdali/SwiftShaders` and add the **SwiftShaders** library to your
app target. In a `Package.swift`, add the package and the product:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftShaders.git", from: "2.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: ["SwiftShaders"])
]
```

### Apply an effect

Import the module and add a modifier to any view: an image, text, a shape or a whole screen.

```swift
import SwiftShaders
import SwiftUI

struct HarborView: View {
    var body: some View {
        Image(systemName: "sailboat.fill")
            .font(.system(size: 120))
            .foregroundStyle(.blue)
            .pixelate(cellSize: 8)
    }
}
```

Effects combine like other modifiers and run in order, from the view outward:

```swift
Text("GAME OVER")
    .font(.system(size: 44, weight: .black, design: .monospaced))
    .foregroundStyle(.cyan)
    .padding(32)
    .background(.black)
    .chromaticAberration(offset: 2)
    .scanlines(spacing: 3, intensity: 0.4)
    .vignette(intensity: 0.7)
```

Every argument has a range, given in the modifier's documentation. Values outside it are clamped,
and a NaN switches the effect off, so a slider or a computed value can never make a shader draw
garbage.

### Check the build tool

The effects live in `.metal` files that must be compiled into a Metal library inside the
package's resource bundle. Xcode compiles them, and so does `swift build` from Swift 6.4 on.
Older versions of `swift build` copy the files without compiling them; SwiftUI then finds no
shader functions and does not draw views that have an effect.

``SwiftShaders/SwiftShaders/isMetalLibraryAvailable`` tells you which case you are in, for
example in a test:

```swift
import SwiftShaders
import Testing

@Test func shadersAreCompiled() {
    #expect(SwiftShaders.isMetalLibraryAvailable)
}
```

### Accessibility

Animated effects (``ShaderTime/animated``) stop and show their first frame when Reduce Motion is
on; the shimmer then shows nothing, because its band starts outside the view.
``SwiftUICore/View/rippleOnTap(style:duration:)`` ignores taps with Reduce Motion on. Effects do
not change a view's accessibility label, so VoiceOver reads a pixelated text as the text.

## See Also

- <doc:AnimatingEffects>
- <doc:HowEffectsAreDrawn>

# Examples

## ShaderGallery

An iOS and macOS app that shows every effect in the package on a landscape drawn in code, with a
slider for the effect's main parameter and a switch that stops time. It also has a screen for
each README sample, the fills and the transitions. It uses the package from this checkout (a
local package reference to `../..`), so it always shows the current code.

Run it:

1. Open `Examples/ShaderGallery/ShaderGallery.xcodeproj` in Xcode 26 or later.
2. Choose the **ShaderGallery** scheme and an iPhone simulator or **My Mac** as the run
   destination.
3. Press **Run** (⌘R).

From the command line:

```sh
cd Examples/ShaderGallery
xcodebuild build -scheme ShaderGallery -destination 'generic/platform=iOS Simulator'
xcodebuild build -scheme ShaderGallery -destination 'platform=macOS'
```

Pass `-page <name>` as a launch argument to open one screen directly, for example
`-page Halftone` or `-page Transitions`; `scripts/capture-gallery.sh` uses it for the README
screenshots.

| File | What it holds |
| --- | --- |
| [`ReadmeSamples.swift`](ShaderGallery/ShaderGallery/ReadmeSamples.swift) | The README's code samples. The package's tests compile and render this file through the symlink `Tests/SwiftShadersTests/ReadmeSamples.swift`. |
| [`EffectCatalog.swift`](ShaderGallery/ShaderGallery/EffectCatalog.swift) | Every effect with one adjustable parameter. The README images are rendered from it. |
| [`SampleScene.swift`](ShaderGallery/ShaderGallery/SampleScene.swift) | The landscape the effects are applied to, drawn with `Canvas`. |
| [`GalleryView.swift`](ShaderGallery/ShaderGallery/GalleryView.swift) | The app's screens. |

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](ShaderGallery/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-15

A new package with a new API, written from scratch on SwiftUI's shader modifiers. The 1.0.0
code did not build with the current Metal compiler (several `.metal` files used
`SwiftUI::Layer` without including `SwiftUI_Metal.h`), its Swift wrappers passed arguments that
did not match the Metal signatures, and it loaded shaders from the app's main bundle instead of
the package's, so no effect appeared in an app that added the package. In June 2026 that code
was replaced with placeholders: a modifier that only lowered the opacity, and circuit-breaker,
retry and event-bus types unrelated to shaders. Because every public name changes, this release
is a new major version.

### Added

- Color effects: `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`,
  `vignette`, `scanlines`, `filmGrain` and `shimmer`.
- Layer effects: `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`,
  `chromaticAberration`, `kaleidoscope` and `glitch`.
- Distortions: `wave`, `water`, `swirl`, `bulge` and `loupe`.
- `rippleOnTap(style:duration:)` and `ripple(origin:elapsedTime:style:)` with `RippleStyle`.
- Fills for any `ShapeStyle`: `.checkerboard`, `.stripes` and `.plasma`.
- Transitions: `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal` and `.radialWipe`.
- `ShaderTime` (`.animated`, `.animated(speed:)`, `.fixed(_:)`) for animated effects, which
  stop on their first frame when Reduce Motion is on.
- `ShaderLibrary.swiftShaders` to call the shader functions directly, and
  `SwiftShaders.isMetalLibraryAvailable` to check that the build tool compiled them.
- Argument checks for every public parameter: ranges are clamped, NaN switches an effect off,
  angles, positions and times are kept to values a 32-bit float can hold, sample offsets are
  limited to the view's diagonal, and gradient maps use at most 256 colors.
- 76 Swift Testing tests that render the effects and check their pixels on macOS and on an iOS
  simulator, including tests for NaN, infinite and huge arguments and a test that compares the
  compiled Metal library with the functions the Swift code calls.
- DocC catalog with three articles (Getting Started, Animating Effects, How Effects Are
  Drawn), built and deployed to GitHub Pages by `docs.yml`.
- `Examples/ShaderGallery`: an iOS and macOS app with every effect, the README samples, the
  fills and the transitions. The README samples are compiled and rendered by the tests.
- README images rendered from code by `scripts/generate-screenshots.sh`, and app screenshots
  captured by `scripts/capture-gallery.sh`.
- `.spi.yml` for the Swift Package Index.

### Changed

- Requires Swift tools 6.2 and builds in the Swift 6 language mode.
- Supports iOS 17 and macOS 14. tvOS and visionOS, listed before but never built, are not
  declared until they are tested.
- CI uses the shared workflows of `muhittincamdali/.github`, pinned to a commit, and runs the
  tests on macOS and on an iPhone simulator.

### Removed

- Every 1.0.0 type and modifier, and the placeholder code added in June 2026.
- `SwiftShaders.podspec`: the package was never published to CocoaPods trunk, and the podspec
  did not list the Metal sources.
- `Templates/`, `Documentation/` and the old example, written for the 1.0.0 API.
- The repository's own code of conduct, security policy and issue forms, which were copied from
  another project; the defaults in `muhittincamdali/.github` apply instead.

## [1.0.0] - 2026-02-03

First tagged release.

[Unreleased]: https://github.com/muhittincamdali/SwiftShaders/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/SwiftShaders/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/SwiftShaders/releases/tag/v1.0.0

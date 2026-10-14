# Contributing

Thanks for taking the time to improve SwiftShaders.

## Reporting bugs

Open an issue with:

- the modifier and the arguments you used,
- what you expected and what happened (a screenshot helps for visual bugs),
- the kind of view the effect is on (image, text, shape, a stack of views),
- platform and OS version (iOS simulator/device or macOS) and Xcode version.

If an effect draws nothing at all, check `SwiftShaders.isMetalLibraryAvailable` first: it is
`false` when the build tool did not compile the shaders.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one change.
3. Run the tests on both platforms:

    ```sh
    swift test                                    # needs Swift 6.4 to compile the shaders
    xcodebuild test -scheme SwiftShaders -destination 'platform=macOS'
    xcodebuild test -scheme SwiftShaders \
      -destination 'platform=iOS Simulator,name=iPhone 17'
    ```

4. If you change a README code sample, change the copy in
   `Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift` as well. That file is what gets
   compiled: by the example app, and by `swift test` through the symlink
   `Tests/SwiftShadersTests/ReadmeSamples.swift`. Build the app with:

    ```sh
    cd Examples/ShaderGallery
    xcodebuild build -scheme ShaderGallery -destination 'generic/platform=iOS Simulator'
    ```

5. If an effect looks different after your change, regenerate the README images with
   `scripts/generate-screenshots.sh`, and the app screenshots with
   `scripts/capture-gallery.sh` if the gallery changed. The landscape in the images is drawn
   with gradients, which SwiftUI dithers slightly differently each time, so commit only the
   images whose content changed.
6. `README.md` has translations (`README.<language>.md`). Each one records the version of
   `README.md` it follows, and CI fails while a translation is behind. If you change `README.md`
   and cannot update the translations, say so in the pull request and they will be updated
   before it is merged.

## Adding an effect

1. Write the Metal function in the file in `Sources/SwiftShaders/Shaders/` for its kind
   (color, distortion, layer, fill or transition). Mark it `[[ stitchable ]]`, start its name
   with `ss`, and take the view's size as the first argument after the ones SwiftUI supplies.
   Layer effects that compare neighbors read through `ss::clampInto`, so they never sample
   outside the view. Loops must have a fixed number of steps.
2. Add the modifier in `Sources/SwiftShaders/Effects/` (or `Fills/`, `Transitions/`). Pass
   every argument through `ShaderInput` first, document each parameter's range, and give a
   distortion or a layer effect that moves content a `maxSampleOffset` built with
   `ShaderInput.sampleOffset(_:in:)`.
3. Add the function name to `LibraryTests.expectedFunctions`, a test that renders the effect
   and checks the pixels, and a case in `InputSafetyTests` for NaN and huge arguments.
4. Add the effect to `EffectCatalog.swift` in the example app, list it in the DocC landing page
   (`SwiftShaders.docc/SwiftShaders.md`) and in the argument table of
   `HowEffectsAreDrawn.md`.

Test sources must be drawn without gradients (see `grayRamp()` and `colorField()` in
`Tests/SwiftShadersTests/Support/Rendering.swift`): SwiftUI dithers gradients, so two
renderings of one gradient can differ.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode; new code should not add warnings.
- Document public API with DocC comments (`///`).
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).

## License

By contributing you agree that your contributions are licensed under the MIT License.

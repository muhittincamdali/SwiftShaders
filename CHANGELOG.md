# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New bloom shader effect
- Chromatic aberration improvements

## [1.2.0] - 2026-02-06

### Added
- `GaussianBlur` shader with configurable radius
- `MotionBlur` directional blur effect
- `Pixelate` retro pixel art effect
- `Vignette` cinematic edge darkening
- `ColorGrading` professional color correction
- `Distortion` wave and ripple effects
- `Glow` neon-style glow shader
- `Noise` film grain and static effects
- iOS 26 Liquid Glass integration

### Changed
- Improved Metal shader compilation
- Optimized GPU memory usage
- Enhanced color accuracy

### Fixed
- Memory leak in shader pipeline
- Edge artifacts on certain effects

## [1.1.0] - 2026-01-15

### Added
- `Bloom` shader for light bleed effect
- `ChromaticAberration` color fringing
- `Halftone` comic book dots effect
- `Grayscale` with multiple algorithms
- `Sepia` vintage tone effect
- Shader preview gallery

### Changed
- Refactored shader architecture
- Improved performance on older devices

## [1.0.0] - 2026-01-01

### Added
- Initial release with 15 Metal shaders
- SwiftUI view modifier integration
- Example application
- Full documentation

[Unreleased]: https://github.com/muhittincamdali/SwiftShaders/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/muhittincamdali/SwiftShaders/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/muhittincamdali/SwiftShaders/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/muhittincamdali/SwiftShaders/releases/tag/v1.0.0

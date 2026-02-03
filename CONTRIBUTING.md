# Contributing to SwiftShaders

Thank you for your interest in contributing to SwiftShaders! 🎨

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/SwiftShaders.git`
3. Create a branch: `git checkout -b feature/your-feature`
4. Make your changes
5. Test thoroughly
6. Submit a pull request

## Development Setup

```bash
git clone https://github.com/muhittincamdali/SwiftShaders.git
cd SwiftShaders
open Package.swift
```

### Requirements

- Xcode 15.0+
- Swift 5.9+
- iOS 15.0+ / macOS 12.0+

## Creating New Shaders

### 1. Create the Metal Shader

```metal
// Shaders/YourShader.metal
#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 yourShader(
    float2 position,
    half4 color,
    float intensity
) {
    // Your shader implementation
    return color;
}
```

### 2. Create the SwiftUI Modifier

```swift
// Sources/SwiftShaders/Modifiers/YourShaderModifier.swift
import SwiftUI

extension View {
    public func yourShader(intensity: Double = 1.0) -> some View {
        self.colorEffect(
            ShaderLibrary.yourShader(.float(intensity))
        )
    }
}
```

### 3. Add Tests

```swift
// Tests/SwiftShadersTests/YourShaderTests.swift
import XCTest
@testable import SwiftShaders

final class YourShaderTests: XCTestCase {
    func testShaderExists() {
        XCTAssertNotNil(ShaderLibrary.yourShader)
    }
}
```

### 4. Add Documentation

Document your shader in `Documentation/Shaders/YourShader.md`:

- Description of the effect
- Parameters and their ranges
- Usage examples
- Performance considerations

## Code Style

- Follow Swift API Design Guidelines
- Use meaningful variable names
- Comment complex Metal code
- Add `#Preview` for visual testing

## Pull Request Checklist

- [ ] Shader compiles without errors
- [ ] Tests pass
- [ ] Documentation added
- [ ] Example added to gallery
- [ ] No performance regressions
- [ ] CHANGELOG updated

## Questions?

Open an issue with the `question` label.

Thank you for contributing! 🙏

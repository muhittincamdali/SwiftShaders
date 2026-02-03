# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.2.x   | :white_check_mark: |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |

## Reporting a Vulnerability

Please report security vulnerabilities via email to: security@muhittincamdali.com

**Do NOT open public issues for security vulnerabilities.**

### Response Timeline

- Initial Response: 48 hours
- Status Update: 5 business days
- Resolution: Based on severity

## Security Considerations

SwiftShaders runs Metal shaders on the GPU. While Metal provides sandboxed execution, users should:

1. Only use shaders from trusted sources
2. Avoid loading external shader code at runtime
3. Be aware of GPU memory usage with complex effects

## Best Practices

```swift
// ✅ Safe: Using built-in shaders
view.gaussianBlur(radius: 10)

// ⚠️ Caution: Custom shader compilation
// Only compile trusted shader sources
```

Thank you for helping keep SwiftShaders secure! 🛡️

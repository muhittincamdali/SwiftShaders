<div align="center">

# 🎨 SwiftShaders

**30+ custom Metal shaders as SwiftUI view modifiers**

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

## ✨ Features

- 🎨 **30+ Shaders** — Blur, glow, ripple, distortion
- 📱 **SwiftUI Native** — View modifiers
- ⚡ **GPU Powered** — 60fps performance
- 🎛️ **Customizable** — All parameters exposed
- 🌈 **Color Effects** — Hue, saturation, contrast

---

## 🚀 Quick Start

```swift
import SwiftShaders

struct ContentView: View {
    var body: some View {
        Image("photo")
            .glowEffect(color: .blue, radius: 10)
            .rippleEffect(origin: .center, time: time)
            .pixelateEffect(scale: 8)
    }
}
```

---

## 📄 License

MIT • [@muhittincamdali](https://github.com/muhittincamdali)

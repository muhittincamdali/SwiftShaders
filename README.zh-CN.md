<!-- i18n-source: README.md@cd2380b7514c5fc84e4c876d40098c1bde7d6458 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-zh-CN-light.svg" alt="SwiftShaders: 适用于 SwiftUI 视图的 Metal 着色器效果：颜色、模糊、扭曲、涟漪和过渡。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="最新版本: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

一个面向 iOS 17+ 和 macOS 14+ 上 SwiftUI 的 Swift GPU 特效包：包含 sepia、duotone、halftone 等颜色特效，渐进模糊，wave、swirl、loupe 等扭曲特效，跟随点击的涟漪，shader 填充以及视图过渡。每个特效都是构建在 SwiftUI 自带的 `colorEffect`、`distortionEffect` 和 `layerEffect` 之上的一个 view modifier，因此可以用在任何视图上：图片、文字、形状，甚至整个屏幕。它面向希望无需编写 Metal 代码就能使用这些特效的应用开发者；对于想自己写 Metal 的开发者，每个 shader 函数也都有文档说明，可以直接调用。该包没有任何依赖。

<p align="center"><img src="docs/images/animated.gif" width="752" alt="用代码绘制的风景画的三个副本：左边的画面各行随波浪摆动，中间有涟漪从中心扩散，右边有一道光带扫过"></p>

## 亮点

- **26 个 view modifier、3 种填充和 5 种过渡** — 数量由源码统计得出，并列在下方的表格中，每一项都有带取值范围的参数文档。
- **不会弄坏 shader 的参数** — 数值会被限制在取值范围内，NaN 会关闭对应特效，角度、位置和时间会被限制在 32 位 float 能够表示的范围内，任何参数都不会导致 SwiftUI 分配比视图加上其对角线更大的离屏图层。
- **干净的边缘** — 需要比较相邻像素的特效只在视图内部读取，因此锐化、浮雕或素描效果的视图不会出现暗边或亮边，颜色特效也会保留文字和符号经过抗锯齿的 alpha。
- **减弱动态效果（Reduce Motion）** — 开启该设置后，动画特效会停在第一帧，涟漪也会忽略点击。
- **经过测试的像素** — 76 个 Swift Testing 测试使用 `ImageRenderer` 渲染特效，并将像素与在 Swift 中计算出的值进行比较，测试在 macOS 和 iPhone 模拟器上运行。另有一个测试会加载编译后的 Metal 库，并检查其中恰好包含 Swift 代码所调用的那些函数。
- **可编译的示例** — 下面的每个示例都来自[示例应用](Examples/ShaderGallery)，CI 会为 iOS 和 macOS 构建它，测试也会渲染其中的每一个示例。

### 包含的内容

| 类型       | 特效                                                                                                                      |
| ---------- | ------------------------------------------------------------------------------------------------------------------------- |
| 颜色（10） | `sepia`、`duotone`、`gradientMap`、`posterize`、`threshold`、`dither`、`vignette`、`scanlines`、`filmGrain`、`shimmer`    |
| 图层（9）  | `pixelate`、`halftone`、`sketch`、`emboss`、`sharpen`、`progressiveBlur`、`chromaticAberration`、`kaleidoscope`、`glitch` |
| 扭曲（5）  | `wave`、`water`、`swirl`、`bulge`、`loupe`                                                                                |
| 涟漪（2）  | `rippleOnTap`、`ripple(origin:elapsedTime:style:)`                                                                        |
| 填充（3）  | 适用于任意 `ShapeStyle` 的 `.checkerboard`、`.stripes`、`.plasma`                                                         |
| 过渡（5）  | `.dissolve`、`.pixelate`、`.swirl`、`.circleReveal`、`.radialWipe`                                                        |

动画特效接受一个 `ShaderTime`：`.animated`、`.animated(speed:)`，或用于单帧的 `.fixed(_:)`。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

将地址粘贴到窗口右上角的搜索框中。保持 **Dependency Rule** 为从 `2.0.0` 起的 **Up to Next Major Version**，然后点击 **Add Package**。在接下来的窗口中，在 **SwiftShaders** 旁边选择你的应用 target，再次点击 **Add Package**。

**2. 导入模块**

```swift
import SwiftShaders
```

将这一行放在使用特效的 Swift 文件顶部，位于 `import SwiftUI` 之下。

**3. 使用它**

在新建的 Xcode 应用中（**File › New › Project… › App**），将 `ContentView.swift` 中的全部内容替换为：

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

按下 **Run**（⌘R）。山峦会呈现为半色调印刷效果：白纸上的蓝色网点，符号所在之处网点大，周围网点小。把 `dotSize` 改为 10 再运行，可以看到更粗的网点。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

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

这些特效是被编译进软件包 bundle 的 `.metal` 文件。Xcode 总是会编译它们；从 Swift 6.4 起，`swift build` 也会编译，因为从该版本开始 SwiftPM 默认使用 Swift Build 引擎。较旧的 `swift build` 只会复制这些文件而不编译，应用了特效的视图将不会被绘制；`SwiftShaders.isMetalLibraryAvailable` 可以告诉你属于哪种情况。

2.0.0 版本（2026 年 10 月）是一个采用全新 API 的新软件包。此前的 1.0.0 版本（2026 年 2 月）无法用当前的 Metal 编译器构建，并且会在应用的 bundle 而不是软件包的 bundle 中查找 shader，因此它的特效从未出现过。2026 年 6 月，它的代码被替换成了占位内容，2026 年 10 月，这个软件包又被从头重写。具体变更请见 [CHANGELOG.md](CHANGELOG.md)。

## 使用

下面的示例复制自
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift)。
示例应用和测试套件都会编译这个文件。

### 组合特效

特效按从视图向外的顺序依次执行：

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

### 表示内容正在加载

`shimmer` 只会提亮已绘制的部分，因此占位形状会闪光，而它们周围的空白保持不变。开启减弱动态效果（Reduce Motion）时，不会显示光带。

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

### 随时间产生动画

动画特效会自行运行。传入 `time: .fixed(seconds)` 可以只显示一帧，例如用于预览和快照测试，也可以用它来由你自己的动画驱动时间。

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

### 在用户点击处产生涟漪

点击会与视图自身的手势同时被识别，因此其中的按钮仍然可以正常使用。

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

### 视图之间的过渡

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

### 自己调用 shader

`ShaderLibrary.swiftShaders` 是编译后的库，可用于 SwiftUI 自带的特效 modifier 或填充。[每个函数的参数列表](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)见文档；以这种方式发起的调用会跳过软件包的参数检查。

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## 演示

将每个特效应用到用代码绘制的风景画上，由 [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) 根据
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift) 渲染：

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="应用了各个颜色特效的风景画：原图、sepia、duotone、gradient map、posterize、threshold、dither、vignette、scanlines、film grain 和 shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="应用了各个图层特效的风景画：pixelate、halftone、sketch、emboss、sharpen、progressive blur、chromatic aberration、kaleidoscope 和 glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="应用了各个扭曲特效的风景画：wave、water、swirl、bulge 和 loupe"></picture>

过渡进行到 0%、25%、50% 和 75% 时的画面：

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="dissolve、pixelate、swirl、circle reveal 和 radial wipe 过渡的各帧"></picture>

示例应用中的 halftone 在 iPhone 模拟器上的效果，由 [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh) 截取：

| 浅色                                                                                   | 深色                                                                                  |
| -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| ![示例应用中带有网点大小滑块的 Halftone 页面，浅色模式](docs/images/gallery-light.png) | ![示例应用中带有网点大小滑块的 Halftone 页面，深色模式](docs/images/gallery-dark.png) |

想亲自试用这些特效，请用 Xcode 打开 [`Examples/ShaderGallery`](Examples/ShaderGallery) 中的 `ShaderGallery.xcodeproj`，选择一个 iPhone 模拟器或 **My Mac**，然后按下 **Run**。每个特效都有一个用于调节主要参数的滑块；详情见 [Examples/README.md](Examples/README.md)。

## 文档

参考文档和文章：

- [API 参考](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  （DocC，从 `main` 分支发布到 GitHub Pages）
- 可以在 Xcode 中通过 **Product › Build Documentation** 在本地构建，也可以在命令行中构建：

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## 指南

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — 添加软件包、应用并组合特效、检查构建工具、Reduce Motion
  （[源文件](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)）。
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — 动画时间、固定时间和自驱动时间，涟漪，以及时间为何每小时回绕一次
  （[源文件](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)）。
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — 颜色、扭曲和图层特效，参数是如何检查的，以及每个 shader 函数的参数列表
  （[源文件](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)）。

## 系统要求

| 平台   | 最低版本              |
| ------ | --------------------- |
| iOS    | 17                    |
| macOS  | 14                    |
| 工具链 | Swift 6.2 · Xcode 26+ |

在命令行中使用 `swift build` 和 `swift test` 需要 Swift 6.4 才能编译 shader（见[安装](#安装)）；Xcode 26 及更高版本在任何情况下都能编译。CI 使用 GitHub `macos-26` runner 镜像的默认 Xcode 构建。该软件包使用 Xcode 27 开发。

## 架构

- `Sources/SwiftShaders/Shaders/` 存放 Metal 代码，每类特效一个文件，辅助函数位于 `ShaderCommon.h`。每个函数都标记为 `[[ stitchable ]]` 并以 `ss` 开头，因此不会与应用中的 shader 冲突。
- `Sources/SwiftShaders/Effects/`、`Fills/` 和 `Transitions/` 存放 Swift API：每个 shader 对应一个 view modifier、填充或过渡，每个只有几行代码，负责检查参数并调用 shader。
- `Core/ShaderEffect.swift` 负责应用 shader：它通过 `visualEffect` 测量视图，为动画特效运行 `TimelineView`（开启 Reduce Motion 时会停止），并将图层特效放入 compositing group。`Core/ShaderInput.swift` 包含所有参数检查，`Core/ShaderTime.swift` 包含动画时间和固定时间，每小时回绕一次。
- 测试使用 `ImageRenderer` 在黑色和白色背景上渲染视图，从而得到每个像素的颜色和 alpha，并与在 Swift 中计算出的值进行比较。`InputSafetyTests` 会向每一类特效传入 NaN、无穷大和极大的值，`LibraryTests` 则将编译后库中的函数名与 Swift 代码所调用的名称进行比较。
- CI 通过 `xcodebuild` 在 macOS 和 iPhone 模拟器上运行测试，为 iOS 和 macOS 构建示例应用，并发布 DocC 文档。

在本地运行测试：

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 路线图

- 将该软件包添加到 Swift Package Index；`.spi.yml` 已经在仓库中。
- 测试并启用 tvOS 和 visionOS，SwiftUI 在这两个平台上有相同的 shader API。
- 渐进模糊的蒙版变体，可跟随任意形状。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。

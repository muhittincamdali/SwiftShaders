<!-- i18n-source: README.md@e5aa36d652a38b1460dd898f7b854b35ee4acfa6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ko-light.svg" alt="SwiftShaders: SwiftUI 뷰를 위한 Metal 셰이더 효과: 색상, 블러, 왜곡, 물결, 전환."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="최신 버전: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

iOS 17+와 macOS 14+의 SwiftUI를 위한 GPU 효과 Swift 패키지입니다. sepia, duotone, halftone 같은 색상 효과, 점진적 블러, wave, swirl, loupe 같은 왜곡, 탭을 따라가는 물결, 셰이더 채우기, 뷰 전환을 제공합니다. 각 효과는 SwiftUI 자체의 `colorEffect`, `distortionEffect`, `layerEffect` 위에 만들어진 view modifier 하나이므로 이미지, 텍스트, 도형, 화면 전체 등 어떤 뷰에든 사용할 수 있습니다. Metal 코드를 작성하지 않고 이런 효과를 쓰고 싶은 앱 개발자를 위한 패키지이며, Metal을 직접 작성하려는 분을 위해 모든 셰이더 함수를 문서로 정리해 두었으므로 직접 호출할 수도 있습니다. 이 패키지는 의존성이 없습니다.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="코드로 그린 풍경 세 장: 왼쪽은 각 행이 물결을 따라 흔들리고, 가운데는 중심에서 물결이 퍼져 나가며, 오른쪽은 빛의 띠가 가로질러 지나간다"></p>

## 주요 기능

- **view modifier 26개, 채우기 3개, 전환 5개** — 소스에서 센 개수이며 아래 표에 나와 있습니다. 각각의 매개변수와 값의 범위가 문서화되어 있습니다.
- **셰이더를 망가뜨릴 수 없는 인자** — 값은 허용 범위로 제한되고, NaN은 효과를 끄며, 각도·위치·시간은 32비트 float가 표현할 수 있는 값으로 유지됩니다. 또한 어떤 인자를 넘기더라도 SwiftUI가 뷰와 그 대각선을 합한 크기보다 큰 오프스크린 레이어를 할당하는 일은 없습니다.
- **깔끔한 가장자리** — 이웃한 픽셀을 비교하는 효과는 뷰 안쪽만 읽으므로, 선명하게 하거나 엠보스 또는 스케치 효과를 준 뷰에 어둡거나 밝은 테두리가 생기지 않습니다. 색상 효과는 텍스트와 심볼의 안티앨리어싱된 알파도 그대로 유지합니다.
- **동작 줄이기(Reduce Motion)** — 이 설정이 켜져 있으면 애니메이션 효과는 첫 프레임에서 멈추고 물결은 탭을 무시합니다.
- **픽셀 단위 테스트** — Swift Testing 테스트 77개가 macOS와 iPhone 시뮬레이터에서 실행됩니다. 그중 61개는 `ImageRenderer`로 효과를 렌더링하고 픽셀을 Swift에서 계산한 값과 비교하고, 14개는 인수와 애니메이션 시간이 어떻게 변환되는지 확인하며, 2개는 컴파일된 Metal 라이브러리를 불러와 Swift 코드가 호출하는 함수가 정확히 들어 있는지 확인합니다.
- **컴파일되는 샘플** — 아래의 모든 샘플은 CI가 iOS와 macOS용으로 빌드하는 [예제 앱](Examples/ShaderGallery)에서 가져온 것이며, 테스트에서도 각 샘플을 렌더링합니다.

### 포함된 항목

| 종류       | 효과                                                                                                                      |
| ---------- | ------------------------------------------------------------------------------------------------------------------------- |
| 색상 (10)  | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| 레이어 (9) | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| 왜곡 (5)   | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| 물결 (2)   | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| 채우기 (3) | 모든 `ShapeStyle`에 쓸 수 있는 `.checkerboard`, `.stripes`, `.plasma`                                                     |
| 전환 (5)   | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

애니메이션 효과는 `ShaderTime`을 받습니다. `.animated`, `.animated(speed:)`, 또는 한 프레임만 보여 주는 `.fixed(_:)`를 사용하세요.

## 빠른 시작

**1. 패키지 추가하기**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

창 오른쪽 위의 검색 필드에 붙여 넣으세요. **Dependency Rule**은 `2.0.0`부터의 **Up to Next Major Version**으로 그대로 두고 **Add Package**를 클릭하세요. 다음 창에서 **SwiftShaders** 옆에 앱 타깃을 선택한 다음 **Add Package**를 다시 클릭하세요.

**2. 모듈 가져오기**

```swift
import SwiftShaders
```

이 줄은 효과를 사용하는 Swift 파일의 맨 위, `import SwiftUI` 아래에 넣으세요.

**3. 사용하기**

새 Xcode 앱(**File › New › Project… › App**)에서 `ContentView.swift`의 내용을 모두 다음으로 바꾸세요.

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

**Run**(⌘R)을 누르세요. 산 모양이 하프톤 인쇄물처럼 나타납니다. 흰 종이 위의 파란 점이 심볼이 있는 곳에서는 크고 그 주변에서는 작습니다. `dotSize`를 10으로 바꾸고 다시 실행하면 더 굵은 점을 볼 수 있습니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

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

효과는 패키지의 번들에 컴파일되어 들어가는 `.metal` 파일입니다. Xcode는 항상 이를 컴파일하며, SwiftPM의 Swift Build 엔진이 기본이 되는 Swift 6.4부터는 `swift build`도 컴파일합니다. 이전 버전의 `swift build`는 파일을 컴파일하지 않고 복사만 하므로 효과가 적용된 뷰는 그려지지 않습니다. 어느 경우인지는 `SwiftShaders.isMetalLibraryAvailable`로 알 수 있습니다.

버전 2.0.0(2026년 10월)은 새로운 API를 갖춘 새 패키지입니다. 이전 릴리스인 1.0.0(2026년 2월)은 현재의 Metal 컴파일러로 빌드되지 않았고, 셰이더를 패키지의 번들이 아닌 앱의 번들에서 찾았기 때문에 효과가 한 번도 나타나지 않았습니다. 2026년 6월에 그 코드는 자리 표시자로 교체되었고, 2026년 10월에 패키지를 처음부터 다시 작성했습니다. 무엇이 바뀌었는지는 [CHANGELOG.md](CHANGELOG.md)에 정리되어 있습니다.

## 사용법

아래 샘플은
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift)
에서 복사한 것입니다. 예제 앱과 테스트 스위트가 모두 이 파일을 컴파일합니다.

### 효과 조합하기

효과는 뷰에서 바깥쪽으로 순서대로 적용됩니다.

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

### 콘텐츠를 불러오는 중임을 표시하기

`shimmer`는 그려진 부분만 밝게 하므로, 자리 표시용 도형은 반짝이고 그 주변의 빈 공간은 그대로 비어 있습니다. Reduce Motion이 켜져 있으면 빛의 띠는 표시되지 않습니다.

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

### 시간에 따라 움직이기

애니메이션 효과는 저절로 실행됩니다. 미리보기나 스냅샷 테스트처럼 한 프레임만 보여 주거나 직접 만든 애니메이션으로 시간을 제어하려면 `time: .fixed(seconds)`를 전달하세요.

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

### 사용자가 탭한 곳에 물결 일으키기

탭은 뷰 자체의 제스처와 함께 인식되므로, 안에 있는 버튼도 계속 동작합니다.

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

### 뷰 사이의 전환

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

### 셰이더를 직접 호출하기

`ShaderLibrary.swiftShaders`는 컴파일된 라이브러리로, SwiftUI 자체의 효과 modifier나 채우기에 사용할 수 있습니다. [모든 함수의 인자 목록](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)은 문서에 있습니다. 이렇게 호출하면 패키지의 인자 검사를 건너뜁니다.

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## 데모

코드로 그린 풍경에 모든 효과를 적용한 모습으로,
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift)를 바탕으로
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh)가 렌더링했습니다.

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="각 색상 효과를 적용한 풍경: 원본, sepia, duotone, gradient map, posterize, threshold, dither, vignette, scanlines, film grain, shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="각 레이어 효과를 적용한 풍경: pixelate, halftone, sketch, emboss, sharpen, progressive blur, chromatic aberration, kaleidoscope, glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="각 왜곡을 적용한 풍경: wave, water, swirl, bulge, loupe"></picture>

전환이 0%, 25%, 50%, 75% 진행된 시점입니다.

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="dissolve, pixelate, swirl, circle reveal, radial wipe 전환의 프레임"></picture>

iPhone 시뮬레이터에서 실행한 예제 앱의 halftone을 [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh)로 캡처한 화면입니다.

| 라이트                                                                                    | 다크                                                                                   |
| ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| ![점 크기 슬라이더가 있는 예제 앱의 Halftone 화면, 라이트](docs/images/gallery-light.png) | ![점 크기 슬라이더가 있는 예제 앱의 Halftone 화면, 다크](docs/images/gallery-dark.png) |

효과를 직접 사용해 보려면 Xcode로 [`Examples/ShaderGallery`](Examples/ShaderGallery)의 `ShaderGallery.xcodeproj`를 열고 iPhone 시뮬레이터 또는 **My Mac**을 선택한 다음 **Run**을 누르세요. 각 효과에는 주요 매개변수를 조절하는 슬라이더가 있습니다. 자세한 내용은 [Examples/README.md](Examples/README.md)를 참고하세요.

## 문서

레퍼런스 문서와 글입니다.

- [API 레퍼런스](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC이며 `main`에서 GitHub Pages로 게시됩니다)
- 로컬에서는 Xcode의 **Product › Build Documentation**으로 빌드하거나 명령줄에서 빌드할 수 있습니다.

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — 패키지 추가, 효과 적용과 조합, 빌드 도구 확인, Reduce Motion
  ([소스](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — 애니메이션 시간, 고정 시간, 직접 구동하는 시간, 물결, 그리고 시간이 매시간 처음으로 돌아가는 이유
  ([소스](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — 색상, 왜곡, 레이어 효과, 인자를 검사하는 방식, 그리고 모든 셰이더 함수의 인자 목록
  ([소스](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## 요구 사항

| 플랫폼 | 최소 버전             |
| ------ | --------------------- |
| iOS    | 17                    |
| macOS  | 14                    |
| 툴체인 | Swift 6.2 · Xcode 26+ |

명령줄의 `swift build`와 `swift test`로 셰이더를 컴파일하려면 Swift 6.4가 필요합니다([설치](#설치) 참고). Xcode 26 이상은 어떤 경우에도 컴파일합니다. CI는 GitHub의 `macos-26` 러너 이미지에 포함된 기본 Xcode로 빌드합니다. 이 패키지는 Xcode 27로 개발합니다.

## 아키텍처

- `Sources/SwiftShaders/Shaders/`에는 Metal 코드가 있으며, 효과 종류마다 파일 하나씩이고 헬퍼는 `ShaderCommon.h`에 있습니다. 모든 함수는 `[[ stitchable ]]`이고 이름이 `ss`로 시작하므로 앱의 셰이더와 충돌하지 않습니다.
- `Sources/SwiftShaders/Effects/`, `Fills/`, `Transitions/`에는 Swift API가 있습니다. 셰이더마다 view modifier, 채우기 또는 전환이 하나씩 있으며, 각각 인자를 검사하고 셰이더를 호출하는 몇 줄짜리 코드입니다.
- `Core/ShaderEffect.swift`는 셰이더를 적용합니다. `visualEffect`로 뷰의 크기를 측정하고, 애니메이션 효과를 위해 `TimelineView`를 실행하며(Reduce Motion이 켜져 있으면 멈춥니다), 레이어 효과는 compositing group에 넣습니다. `Core/ShaderInput.swift`에는 모든 인자 검사가 있고, `Core/ShaderTime.swift`에는 매시간 처음으로 돌아가는 애니메이션 시간과 고정 시간이 있습니다.
- 테스트는 검은색 위와 흰색 위에서 `ImageRenderer`로 뷰를 렌더링해 모든 픽셀의 색상과 알파를 얻고, 이를 Swift에서 계산한 값과 비교합니다. `InputSafetyTests`는 모든 종류의 효과에 NaN, 무한대, 아주 큰 값을 전달하고, `LibraryTests`는 컴파일된 라이브러리의 함수 이름을 Swift 코드가 호출하는 이름과 비교합니다.
- CI는 `xcodebuild`로 macOS와 iPhone 시뮬레이터에서 테스트를 실행하고, 예제 앱을 iOS와 macOS용으로 빌드하며, DocC 문서를 게시합니다.

로컬에서 테스트를 실행하려면 다음과 같이 하세요.

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 로드맵

- 패키지를 Swift Package Index에 추가합니다. `.spi.yml`은 이미 저장소에 있습니다.
- SwiftUI에 같은 셰이더 API가 있는 tvOS와 visionOS에서 테스트하고 활성화합니다.
- 어떤 도형이든 따라가는 점진적 블러의 마스크 변형.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)에 설명된 대로 비공개로 신고해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.

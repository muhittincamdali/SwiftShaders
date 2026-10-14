<!-- i18n-source: README.md@ade474b3f71f0687955e4861aa63ee003c043f4d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-ja-light.svg" alt="SwiftShaders: SwiftUI ビュー向けの Metal シェーダー効果。色、ぼかし、歪み、波紋、トランジション。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="最新バージョン: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

iOS 17+ と macOS 14+ の SwiftUI 向け GPU エフェクトを集めた Swift パッケージです。sepia、duotone、halftone などのカラーエフェクト、プログレッシブブラー、wave、swirl、loupe などの歪み、タップに追従する波紋、シェーダーによる塗りつぶし、ビューのトランジションを備えています。各エフェクトは SwiftUI 標準の `colorEffect`、`distortionEffect`、`layerEffect` の上に作られた 1 つの view modifier なので、画像、テキスト、図形、画面全体など、どんなビューにも使えます。Metal のコードを書かずにこれらのエフェクトを使いたいアプリ開発者向けのパッケージですが、Metal を書きたい方のために、すべてのシェーダー関数にドキュメントがあり、直接呼び出すこともできます。依存関係はありません。

<p align="center"><img src="docs/images/animated.gif" width="752" alt="コードで描いた風景の 3 つのコピー。左は各行が波に合わせて揺れ、中央は中心から波紋が広がり、右は光の帯が横切っている"></p>

## 主な特長

- **26 個の view modifier、3 種類の塗りつぶし、5 種類のトランジション** — ソースコードから数えた数で、下の表に一覧があります。それぞれ、パラメーターとその範囲がドキュメント化されています。
- **シェーダーを壊せない引数** — 値は範囲内に収められ、NaN はエフェクトをオフにし、角度、位置、時間は 32 ビット float で表せる値に保たれ、どの引数を渡してもビューとその対角線を足した大きさを超えるオフスクリーンレイヤーを SwiftUI に確保させることはありません。
- **きれいな縁** — 隣接するピクセルを比較するエフェクトはビューの内側だけを読み取るため、シャープ、エンボス、スケッチを適用したビューに暗い縁や明るい縁は付きません。カラーエフェクトは、テキストやシンボルのアンチエイリアスされたアルファも保ちます。
- **視差効果を減らす（Reduce Motion）** — この設定がオンのとき、アニメーションするエフェクトは最初のフレームで止まり、波紋はタップを無視します。
- **ピクセルまでテスト** — 77 個の Swift Testing テストが macOS と iPhone シミュレーターで実行されます。そのうち 61 個は `ImageRenderer` でエフェクトを描画し、Swift で計算した値とピクセルを比較します。14 個は引数とアニメーション時間の変換を確認し、2 個はコンパイル済みの Metal ライブラリを読み込んで、Swift コードが呼び出す関数がちょうどそのまま含まれていることを確認します。
- **コンパイルできるサンプル** — 以下のサンプルはすべて[サンプルアプリ](Examples/ShaderGallery)のコードです。サンプルアプリは CI が iOS と macOS 向けにビルドし、テストでもそれぞれを描画します。

### 含まれるもの

| 種類                | エフェクト                                                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| カラー（10）        | `sepia`、`duotone`、`gradientMap`、`posterize`、`threshold`、`dither`、`vignette`、`scanlines`、`filmGrain`、`shimmer`    |
| レイヤー（9）       | `pixelate`、`halftone`、`sketch`、`emboss`、`sharpen`、`progressiveBlur`、`chromaticAberration`、`kaleidoscope`、`glitch` |
| 歪み（5）           | `wave`、`water`、`swirl`、`bulge`、`loupe`                                                                                |
| 波紋（2）           | `rippleOnTap`、`ripple(origin:elapsedTime:style:)`                                                                        |
| 塗りつぶし（3）     | 任意の `ShapeStyle` で使える `.checkerboard`、`.stripes`、`.plasma`                                                       |
| トランジション（5） | `.dissolve`、`.pixelate`、`.swirl`、`.circleReveal`、`.radialWipe`                                                        |

アニメーションするエフェクトは `ShaderTime` を受け取ります。`.animated`、`.animated(speed:)`、または 1 フレームだけを表示する `.fixed(_:)` を指定します。

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

URL はウィンドウ右上の検索フィールドに貼り付けます。**Dependency Rule** は `2.0.0` からの **Up to Next Major Version** のままにして、**Add Package** をクリックします。次のウィンドウで **SwiftShaders** の横にあるアプリのターゲットを選び、もう一度 **Add Package** をクリックします。

**2. モジュールをインポートする**

```swift
import SwiftShaders
```

この行は、エフェクトを使う Swift ファイルの先頭、`import SwiftUI` の下に書きます。

**3. 使ってみる**

新しい Xcode アプリ（**File › New › Project… › App**）で、`ContentView.swift` の内容をすべて次のコードに置き換えます。

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

**Run**（⌘R）を押します。山のシンボルがハーフトーン印刷のように表示されます。白い紙に青いドットが並び、シンボルのある部分では大きく、その周りでは小さくなります。`dotSize` を 10 に変えてもう一度実行すると、ドットが粗くなります。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

または、`Package.swift` の `dependencies` に追加します。

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

エフェクトはパッケージのバンドルにコンパイルされる `.metal` ファイルです。Xcode は常にコンパイルします。`swift build` も、SwiftPM の Swift Build エンジンが既定になる Swift 6.4 以降ではコンパイルします。それより古い `swift build` ではファイルがコンパイルされずにコピーされるだけで、エフェクトを適用したビューは描画されません。どちらの状態かは `SwiftShaders.isMetalLibraryAvailable` で確認できます。

バージョン 2.0.0（2026 年 10 月）は、新しい API を持つ新しいパッケージです。以前のリリースである 1.0.0（2026 年 2 月）は、現行の Metal コンパイラーでビルドできず、シェーダーをパッケージではなくアプリのバンドルから探していたため、エフェクトは一度も表示されませんでした。2026 年 6 月にそのコードはプレースホルダーに置き換えられ、2026 年 10 月にパッケージはゼロから書き直されました。変更点は [CHANGELOG.md](CHANGELOG.md) にまとめています。

## 使い方

以下のサンプルは
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift)
からコピーしたものです。サンプルアプリとテストスイートの両方がこのファイルをコンパイルします。

### エフェクトを組み合わせる

エフェクトは、ビューから外側に向かって順に適用されます。

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

### 読み込み中であることを示す

`shimmer` は描画された部分だけを明るくするため、プレースホルダーの図形は光り、その周りの余白は空のままです。Reduce Motion がオンのときは、光の帯は表示されません。

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

### 時間に合わせてアニメーションさせる

アニメーションするエフェクトはひとりでに動きます。プレビューやスナップショットテストなどで 1 フレームだけを表示したいときや、独自のアニメーションで時間を制御したいときは、`time: .fixed(seconds)` を渡します。

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

### ユーザーがタップした場所から波紋を広げる

タップはビュー自身のジェスチャーと並行して認識されるため、内側にあるボタンも引き続き動作します。

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

### ビュー間のトランジション

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

### シェーダーを直接呼び出す

`ShaderLibrary.swiftShaders` はコンパイル済みのライブラリで、SwiftUI 標準のエフェクト modifier や塗りつぶしに使えます。[各関数の引数一覧](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)はドキュメントにあります。この方法で呼び出した場合、パッケージの引数チェックは行われません。

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## デモ

コードで描いた風景にすべてのエフェクトを適用したものです。
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift) をもとに、
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) で生成しています。

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="各カラーエフェクトを適用した風景：オリジナル、sepia、duotone、gradient map、posterize、threshold、dither、vignette、scanlines、film grain、shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="各レイヤーエフェクトを適用した風景：pixelate、halftone、sketch、emboss、sharpen、progressive blur、chromatic aberration、kaleidoscope、glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="各歪みを適用した風景：wave、water、swirl、bulge、loupe"></picture>

トランジションの 0、25、50、75 パーセントの時点です。

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="dissolve、pixelate、swirl、circle reveal、radial wipe の各トランジションのフレーム"></picture>

iPhone シミュレーター上のサンプルアプリの halftone を、[`scripts/capture-gallery.sh`](scripts/capture-gallery.sh) で撮影したものです。

| ライト                                                                                                 | ダーク                                                                                                |
| ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| ![ドットサイズのスライダーがあるサンプルアプリの Halftone 画面、ライト](docs/images/gallery-light.png) | ![ドットサイズのスライダーがあるサンプルアプリの Halftone 画面、ダーク](docs/images/gallery-dark.png) |

エフェクトを自分で試すには、[`Examples/ShaderGallery`](Examples/ShaderGallery) の `ShaderGallery.xcodeproj` を Xcode で開き、iPhone シミュレーターまたは **My Mac** を選んで **Run** を押します。各エフェクトには主要なパラメーター用のスライダーがあります。詳しくは [Examples/README.md](Examples/README.md) を参照してください。

## ドキュメント

リファレンスと記事です。

- [API リファレンス](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  （DocC。`main` から GitHub Pages に公開されます）
- ローカルでは、Xcode の **Product › Build Documentation** で、またはコマンドラインから次のようにビルドできます。

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## ガイド

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — パッケージの追加、エフェクトの適用と組み合わせ、ビルドツールの確認、Reduce Motion
  （[ソース](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)）。
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — アニメーション時間、固定時間、自前で駆動する時間、波紋、そして時間が 1 時間ごとに折り返される理由
  （[ソース](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)）。
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — カラー、歪み、レイヤーの各エフェクト、引数のチェック方法、そしてすべてのシェーダー関数の引数一覧
  （[ソース](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)）。

## 動作要件

| プラットフォーム | 最小バージョン        |
| ---------------- | --------------------- |
| iOS              | 17                    |
| macOS            | 14                    |
| ツールチェーン   | Swift 6.2 · Xcode 26+ |

コマンドラインの `swift build` と `swift test` でシェーダーをコンパイルするには Swift 6.4 が必要です（[インストール](#インストール)を参照）。Xcode 26 以降ならどの場合でもコンパイルされます。CI は GitHub の `macos-26` ランナーイメージの既定の Xcode でビルドします。パッケージの開発には Xcode 27 を使っています。

## アーキテクチャ

- `Sources/SwiftShaders/Shaders/` に Metal のコードがあり、エフェクトの種類ごとに 1 ファイルで、ヘルパーは `ShaderCommon.h` にあります。すべての関数は `[[ stitchable ]]` で、名前が `ss` で始まるため、アプリ内のシェーダーと衝突しません。
- `Sources/SwiftShaders/Effects/`、`Fills/`、`Transitions/` に Swift の API があります。シェーダー 1 つにつき view modifier、塗りつぶし、トランジションが 1 つずつあり、それぞれ数行で引数をチェックしてシェーダーを呼び出します。
- `Core/ShaderEffect.swift` がシェーダーを適用します。`visualEffect` でビューのサイズを測り、アニメーションするエフェクトには `TimelineView` を実行し（Reduce Motion のときは停止します）、レイヤーエフェクトは compositing group に入れます。`Core/ShaderInput.swift` にはすべての引数チェックが、`Core/ShaderTime.swift` には 1 時間ごとに折り返すアニメーション時間と固定時間があります。
- テストでは、黒の上と白の上で `ImageRenderer` によってビューを描画します。これで各ピクセルの色とアルファが得られ、Swift で計算した値と比較します。`InputSafetyTests` はすべての種類のエフェクトに NaN、無限大、巨大な値を渡し、`LibraryTests` はコンパイル済みライブラリの関数名と、Swift コードが呼び出す名前を比較します。
- CI は、`xcodebuild` で macOS と iPhone シミュレーター上のテストを実行し、サンプルアプリを iOS と macOS 向けにビルドして、DocC ドキュメントを公開します。

ローカルでテストを実行するには次のようにします。

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## ロードマップ

- パッケージを Swift Package Index に追加する。`.spi.yml` はすでにリポジトリにあります。
- SwiftUI に同じシェーダー API がある tvOS と visionOS で、テストして有効にする。
- 任意の形に沿う、プログレッシブブラーのマスク付きバリアント。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。

<!-- i18n-source: README.md@cd2380b7514c5fc84e4c876d40098c1bde7d6458 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-tr-light.svg" alt="SwiftShaders: SwiftUI görünümleri için Metal shader efektleri: renk, bulanıklık, bozulma, dalgalanma ve geçişler."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

iOS 17+ ve macOS 14+ üzerinde SwiftUI için GPU efektleri sunan bir Swift paketi: sepya, duoton ve halftone gibi renk efektleri, aşamalı bulanıklık, dalga, girdap ve büyüteç gibi bozulmalar, dokunuşları izleyen dalgalanmalar, shader dolguları ve görünüm geçişleri. Her efekt, SwiftUI'ın kendi `colorEffect`, `distortionEffect` ve `layerEffect` API'lerinin üzerine kurulu tek bir view modifier'dır; bu yüzden bir görsele, metne, şekle ya da tüm ekrana, yani her görünüme uygulanabilir. Paket, bu efektleri Metal kodu yazmadan kullanmak isteyen uygulama geliştiricileri için hazırlandı; Metal yazmak isteyenler için de her shader fonksiyonu belgelenmiştir, böylece doğrudan çağrılabilirler. Paketin hiçbir bağımlılığı yoktur.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Kodla çizilmiş bir manzaranın üç kopyası: solda satırlar dalga gibi sallanıyor, ortada merkezden bir dalgalanma yayılıyor, sağda ise bir ışık bandı boydan boya süpürüyor"></p>

## Öne çıkanlar

- **26 view modifier, 3 dolgu ve 5 geçiş** — kaynak koddan sayıldı ve aşağıdaki tabloda listelendi; her birinin parametreleri ve değer aralıkları belgelenmiştir.
- **Shader'ı bozamayan argümanlar** — değerler kendi aralıklarına sıkıştırılır, NaN bir efekti kapatır, açılar, konumlar ve süreler 32 bitlik bir float'ın taşıyabileceği değerlerle sınırlandırılır ve hiçbir argüman SwiftUI'ın görünümün ve köşegeninin toplamından büyük bir offscreen katman ayırmasına yol açamaz.
- **Temiz kenarlar** — komşu piksellere bakan efektler yalnızca görünümün içinden okur; bu yüzden keskinleştirilmiş, kabartılmış ya da çizim görünümüne çevrilmiş bir görünümde koyu veya parlak kenar oluşmaz, renk efektleri de metin ve sembollerin yumuşatılmış alfa değerini korur.
- **Reduce Motion (Hareketi Azalt)** — ayar açıkken animasyonlu efektler ilk karede durur, dalgalanmalar ise dokunuşları yok sayar.
- **Test edilmiş pikseller** — 76 Swift Testing testi, efektleri `ImageRenderer` ile çizer ve pikselleri Swift'te hesaplanan değerlerle karşılaştırır; testler macOS'ta ve bir iPhone simülatöründe çalışır. Bir başka test, derlenmiş Metal kitaplığını yükler ve içinde Swift kodunun çağırdığı fonksiyonların tam olarak bulunduğunu denetler.
- **Derlenen örnekler** — aşağıdaki her örnek, CI'ın iOS ve macOS için derlediği [örnek uygulamadan](Examples/ShaderGallery) gelir; testler de her birini çizer.

### Neler var

| Tür            | Efektler                                                                                                                  |
| -------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Renk (10)      | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| Katman (9)     | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Bozulma (5)    | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| Dalgalanma (2) | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| Dolgular (3)   | Herhangi bir `ShapeStyle` için `.checkerboard`, `.stripes`, `.plasma`                                                     |
| Geçişler (5)   | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

Animasyonlu efektler bir `ShaderTime` alır: `.animated`, `.animated(speed:)` ya da tek bir kare için `.fixed(_:)`.

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Adresi pencerenin sağ üstündeki arama alanına yapıştırın. **Dependency Rule** ayarını `2.0.0` sürümünden itibaren **Up to Next Major Version** olarak bırakın, ardından **Add Package**'a tıklayın. Açılan pencerede **SwiftShaders** satırının yanından uygulama hedefinizi seçin ve yeniden **Add Package**'a tıklayın.

**2. Modülü içe aktarın**

```swift
import SwiftShaders
```

Bu satırı, bir efekt kullandığınız Swift dosyasının en üstüne, `import SwiftUI` satırının altına ekleyin.

**3. Kullanın**

Yeni bir Xcode uygulamasında (**File › New › Project… › App**) `ContentView.swift` dosyasının tüm içeriğini şununla değiştirin:

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

**Run**'a (⌘R) basın. Dağlar bir halftone baskı olarak görünür: beyaz kâğıt üzerinde mavi noktalar; sembolün olduğu yerde büyük, çevresinde küçük. `dotSize` değerini 10 yapıp yeniden çalıştırırsanız noktalar daha iri görünür.

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

Efektler, paketin bundle'ına derlenen `.metal` dosyalarıdır. Xcode bunları her zaman derler; SwiftPM'in Swift Build motorunun varsayılan olduğu Swift 6.4'ten itibaren `swift build` de derler. Eski bir `swift build` dosyaları derlemeden kopyalar ve efekt uygulanan görünümler çizilmez; hangi durumda olduğunuzu `SwiftShaders.isMetalLibraryAvailable` söyler.

2.0.0 sürümü (Ekim 2026), yeni bir API'ye sahip yeni bir pakettir. Önceki sürüm 1.0.0 (Şubat 2026), güncel Metal derleyicisiyle derlenmiyordu ve shader'larını paketin değil uygulamanın bundle'ında arıyordu; bu yüzden efektleri hiç görünmedi. Haziran 2026'da kodu yer tutucularla değiştirildi, Ekim 2026'da ise paket sıfırdan yeniden yazıldı. Nelerin değiştiği [CHANGELOG.md](CHANGELOG.md) dosyasında listelenir.

## Kullanım

Aşağıdaki örnekler
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift)
dosyasından kopyalanmıştır. Örnek uygulama ve test paketi bu dosyayı birlikte derler.

### Efektleri birleştirin

Efektler görünümden dışa doğru sırayla çalışır:

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

### İçeriğin yüklendiğini gösterin

`shimmer` yalnızca çizilmiş olan kısmı parlatır; bu yüzden yer tutucu şekiller parıldar, çevrelerindeki boşluk ise boş kalır. Reduce Motion açıkken bant gösterilmez.

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

### Zamana göre canlandırın

Animasyonlu efektler kendiliğinden çalışır. Tek bir kareyi göstermek için (örneğin önizlemelerde ve snapshot testlerinde) ya da zamanı kendi animasyonunuzla sürmek için `time: .fixed(seconds)` verin.

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

### Kullanıcının dokunduğu yerde dalgalanma

Dokunuş, görünümün kendi hareketleriyle birlikte algılanır; bu yüzden içindeki düğmeler çalışmaya devam eder.

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

### Görünümler arasında geçiş

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

### Bir shader'ı kendiniz çağırın

`ShaderLibrary.swiftShaders`, SwiftUI'ın kendi efekt modifier'ları ya da dolgular için derlenmiş kitaplıktır. [Her fonksiyonun argüman listesi](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn) dokümantasyondadır; bu şekilde yapılan çağrılar paketin argüman denetimlerini atlar.

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## Demo

Kodla çizilmiş bir manzaraya uygulanan her efekt; [`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift) dosyasından
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) ile çizilmiştir:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="Her renk efektiyle manzara: orijinal, sepya, duoton, gradyan haritası, posterize, eşik, dither, vinyet, tarama çizgileri, film greni ve shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="Her katman efektiyle manzara: pixelate, halftone, çizim, kabartma, keskinleştirme, aşamalı bulanıklık, kromatik sapma, kaleydoskop ve glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="Her bozulmayla manzara: dalga, su, girdap, şişkinlik ve büyüteç"></picture>

Geçişlerin yüzde 0, 25, 50 ve 75'inde:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Dissolve, pixelate, swirl, circle reveal ve radial wipe geçişlerinin kareleri"></picture>

Örnek uygulamadaki halftone, bir iPhone simülatöründe [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh) ile yakalanmıştır:

| Açık                                                                                                    | Koyu                                                                                                   |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| ![Örnek uygulamanın nokta boyutu kaydırıcılı Halftone ekranı, açık tema](docs/images/gallery-light.png) | ![Örnek uygulamanın nokta boyutu kaydırıcılı Halftone ekranı, koyu tema](docs/images/gallery-dark.png) |

Efektleri kendiniz denemek için [`Examples/ShaderGallery`](Examples/ShaderGallery) klasöründeki `ShaderGallery.xcodeproj` dosyasını Xcode ile açın, bir iPhone simülatörü ya da **My Mac** seçin ve **Run**'a basın. Her efektin ana parametresi için bir kaydırıcı vardır; ayrıntılar [Examples/README.md](Examples/README.md) dosyasındadır.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- [API başvurusu](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC; `main` dalından GitHub Pages'e yayımlanır)
- Yerelde Xcode'da **Product › Build Documentation** ile ya da komut satırından derleyebilirsiniz:

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Rehberler

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — paketi ekleme, efektleri uygulama ve birleştirme, derleme aracını denetleme, Reduce Motion
  ([kaynak](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — animasyonlu, sabit ve kendi kendini süren zaman, dalgalanmalar ve zamanın neden her saat başı başa sardığı
  ([kaynak](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — renk, bozulma ve katman efektleri, argümanların nasıl denetlendiği ve her shader fonksiyonunun argüman listesi
  ([kaynak](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Gereksinimler

| Platform     | En düşük sürüm        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| Araç zinciri | Swift 6.2 · Xcode 26+ |

Komut satırından `swift build` ve `swift test` ile shader'ları derlemek için Swift 6.4 gerekir ([Kurulum](#kurulum) bölümüne bakın); Xcode 26 ve sonrası bunları her durumda derler. CI, GitHub'ın `macos-26` runner imajındaki varsayılan Xcode ile derleme yapar. Paket Xcode 27 ile geliştirilmektedir.

## Mimari

- `Sources/SwiftShaders/Shaders/` Metal kodunu barındırır: her efekt türü için bir dosya, yardımcılar ise `ShaderCommon.h` içinde. Her fonksiyon `[[ stitchable ]]` işaretlidir ve `ss` ile başlar; böylece bir uygulamadaki shader'larla çakışamaz.
- `Sources/SwiftShaders/Effects/`, `Fills/` ve `Transitions/` Swift API'sini barındırır: her shader için bir view modifier, dolgu ya da geçiş; her biri argümanları denetleyip shader'ı çağıran birkaç satırdan ibarettir.
- `Core/ShaderEffect.swift` bir shader'ı uygular: görünümü `visualEffect` ile ölçer, animasyonlu efektler için bir `TimelineView` çalıştırır (Reduce Motion ile durdurulur) ve katman efektlerini bir compositing group'a yerleştirir. `Core/ShaderInput.swift` tüm argüman denetimlerini, `Core/ShaderTime.swift` ise her saat başı başa saran animasyonlu ve sabit zamanı barındırır.
- Testler, görünümleri siyah ve beyaz zemin üzerinde `ImageRenderer` ile çizer; bu, her pikselin rengini ve alfa değerini verir, ardından Swift'te hesaplanan değerlerle karşılaştırılır. `InputSafetyTests` her efekt türüne NaN, sonsuz ve çok büyük değerler verir; `LibraryTests` ise derlenmiş kitaplığın fonksiyon adlarını Swift kodunun çağırdığı adlarla karşılaştırır.
- CI, testleri macOS'ta ve `xcodebuild` ile bir iPhone simülatöründe çalıştırır, örnek uygulamayı iOS ve macOS için derler ve DocC dokümantasyonunu yayımlar.

Testleri yerelde çalıştırmak için:

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Yol haritası

- Paketi Swift Package Index'e eklemek; `.spi.yml` zaten depoda.
- SwiftUI'da aynı shader API'sinin bulunduğu tvOS ve visionOS desteğini test edip etkinleştirmek.
- Aşamalı bulanıklığın, herhangi bir şekli izleyen maskeli bir varyantı.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.

<!-- i18n-source: README.md@e5aa36d652a38b1460dd898f7b854b35ee4acfa6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-de-light.svg" alt="SwiftShaders: Metal-Shader-Effekte für SwiftUI-Views: Farbe, Unschärfe, Verzerrung, Wellen und Übergänge."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket mit GPU-Effekten für SwiftUI auf iOS 17+ und macOS 14+: Farbeffekte wie Sepia, Duotone und Halftone, eine progressive Unschärfe, Verzerrungen wie Wave, Swirl und Loupe, Wellen, die Berührungen folgen, Shader-Füllungen und View-Übergänge. Jeder Effekt ist ein einzelner View-Modifier auf Basis von SwiftUIs eigenen `colorEffect`, `distortionEffect` und `layerEffect` und funktioniert deshalb mit jeder View: einem Bild, einem Text, einer Form oder einem ganzen Bildschirm. Das Paket richtet sich an App-Entwickler, die diese Effekte ohne Metal-Code nutzen möchten; wer Metal selbst schreiben will, findet jede Shader-Funktion dokumentiert und kann sie direkt aufrufen. Das Paket hat keine Abhängigkeiten.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Drei Kopien einer im Code gezeichneten Landschaft: links schwingen die Zeilen in einer Welle, in der Mitte breitet sich eine Welle vom Zentrum aus, rechts streicht ein Lichtband darüber"></p>

## Highlights

- **26 View-Modifier, 3 Füllungen und 5 Übergänge** — aus dem Quellcode gezählt und in der Tabelle unten aufgeführt, jeweils mit dokumentierten Parametern und deren Wertebereichen.
- **Argumente, die keinen Shader zerstören können** — Werte werden auf ihren Bereich begrenzt, ein NaN schaltet einen Effekt aus, Winkel, Positionen und Zeiten bleiben auf Werten, die ein 32-Bit-Float fassen kann, und kein Argument kann SwiftUI dazu bringen, eine Offscreen-Ebene anzulegen, die größer ist als die View samt ihrer Diagonale.
- **Saubere Ränder** — Effekte, die benachbarte Pixel vergleichen, lesen nur innerhalb der View. Eine geschärfte, geprägte oder skizzierte View bekommt daher keinen dunklen oder hellen Rand, und Farbeffekte behalten das geglättete Alpha von Text und Symbolen.
- **Bewegung reduzieren (Reduce Motion)** — Animierte Effekte bleiben bei aktivierter Einstellung auf ihrem ersten Frame stehen, und Wellen ignorieren Berührungen.
- **Getestete Pixel** — 77 Swift-Testing-Tests laufen auf macOS und in einem iPhone-Simulator. 61 davon rendern die Effekte mit `ImageRenderer` und vergleichen die Pixel mit in Swift berechneten Werten, 14 prüfen, wie Argumente und die Animationszeit umgerechnet werden, und 2 laden die kompilierte Metal-Bibliothek und prüfen, dass sie genau die Funktionen enthält, die der Swift-Code aufruft.
- **Beispiele, die kompilieren** — Jedes Beispiel unten stammt aus der [Beispiel-App](Examples/ShaderGallery), die CI für iOS und macOS baut; die Tests rendern jedes davon.

### Was enthalten ist

| Art            | Effekte                                                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Farbe (10)     | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| Ebene (9)      | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Verzerrung (5) | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| Wellen (2)     | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| Füllungen (3)  | `.checkerboard`, `.stripes`, `.plasma` für jeden `ShapeStyle`                                                             |
| Übergänge (5)  | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

Animierte Effekte nehmen eine `ShaderTime` entgegen: `.animated`, `.animated(speed:)` oder `.fixed(_:)` für ein einzelnes Bild.

## Schnellstart

**1. Das Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Füge sie in das Suchfeld oben rechts im Fenster ein. Lass **Dependency Rule** auf **Up to Next Major Version** ab `2.0.0` stehen und klicke auf **Add Package**. Wähle im nächsten Fenster neben **SwiftShaders** dein App-Target aus und klicke erneut auf **Add Package**.

**2. Das Modul importieren**

```swift
import SwiftShaders
```

Setze diese Zeile an den Anfang der Swift-Datei, in der du einen Effekt verwendest, unter `import SwiftUI`.

**3. Verwenden**

Ersetze in einer neuen Xcode-App (**File › New › Project… › App**) den gesamten Inhalt von `ContentView.swift` durch:

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

Drücke **Run** (⌘R). Die Berge erscheinen als Halftone-Druck: blaue Punkte auf weißem Papier, groß dort, wo das Symbol ist, und klein darum herum. Ändere `dotSize` auf 10 und starte erneut, um gröbere Punkte zu sehen.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Oder füge es in `dependencies` deiner `Package.swift` ein:

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

Die Effekte sind `.metal`-Dateien, die in das Bundle des Pakets kompiliert werden. Xcode kompiliert sie immer, und `swift build` tut das ab Swift 6.4, wo die Swift-Build-Engine von SwiftPM der Standard ist. Bei einem älteren `swift build` werden die Dateien nur kopiert, ohne kompiliert zu werden, und Views mit einem Effekt werden nicht gezeichnet; `SwiftShaders.isMetalLibraryAvailable` verrät dir, welcher Fall vorliegt.

Version 2.0.0 (Oktober 2026) ist ein neues Paket mit einer neuen API. Das frühere Release 1.0.0 (Februar 2026) ließ sich mit dem aktuellen Metal-Compiler nicht bauen und suchte seine Shader im Bundle der App statt in dem des Pakets, sodass seine Effekte nie erschienen. Im Juni 2026 wurde sein Code durch Platzhalter ersetzt, und im Oktober 2026 wurde das Paket von Grund auf neu geschrieben. [CHANGELOG.md](CHANGELOG.md) listet auf, was sich geändert hat.

## Verwendung

Die Beispiele unten sind kopiert aus
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift).
Die Beispiel-App und die Test-Suite kompilieren beide diese Datei.

### Effekte kombinieren

Effekte werden der Reihe nach angewendet, von der View nach außen:

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

### Anzeigen, dass Inhalte geladen werden

`shimmer` hellt nur auf, was gezeichnet ist: Platzhalterformen schimmern, der Raum um sie herum bleibt leer. Bei aktiviertem Reduce Motion wird das Band nicht angezeigt.

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

### Über die Zeit animieren

Animierte Effekte laufen von selbst. Übergib `time: .fixed(seconds)`, um ein einzelnes Bild zu zeigen, etwa in Vorschauen und Snapshot-Tests, oder um die Zeit mit deiner eigenen Animation zu steuern.

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

### Wellen dort, wo der Nutzer tippt

Das Tippen wird zusammen mit den eigenen Gesten der View erkannt, sodass Buttons darin weiter funktionieren.

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

### Übergang zwischen Views

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

### Einen Shader selbst aufrufen

`ShaderLibrary.swiftShaders` ist die kompilierte Bibliothek, für SwiftUIs eigene Effekt-Modifier oder für Füllungen. Die [Argumentliste jeder Funktion](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn) steht in der Dokumentation; bei Aufrufen auf diesem Weg entfallen die Argumentprüfungen des Pakets.

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

Jeder Effekt, angewendet auf eine im Code gezeichnete Landschaft, gerendert von
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) aus
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift):

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="Die Landschaft mit jedem Farbeffekt: Original, Sepia, Duotone, Gradient Map, Posterize, Threshold, Dither, Vignette, Scanlines, Film Grain und Shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="Die Landschaft mit jedem Ebeneneffekt: Pixelate, Halftone, Sketch, Emboss, Sharpen, Progressive Blur, Chromatic Aberration, Kaleidoscope und Glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="Die Landschaft mit jeder Verzerrung: Wave, Water, Swirl, Bulge und Loupe"></picture>

Die Übergänge nach 0, 25, 50 und 75 Prozent des Wegs:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Frames der Übergänge Dissolve, Pixelate, Swirl, Circle Reveal und Radial Wipe"></picture>

Der Halftone-Effekt in der Beispiel-App auf einem iPhone-Simulator, aufgenommen mit [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh):

| Hell                                                                                                                        | Dunkel                                                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| ![Der Halftone-Bildschirm der Beispiel-App mit einem Schieberegler für die Punktgröße, hell](docs/images/gallery-light.png) | ![Der Halftone-Bildschirm der Beispiel-App mit einem Schieberegler für die Punktgröße, dunkel](docs/images/gallery-dark.png) |

Um die Effekte selbst auszuprobieren, öffne `ShaderGallery.xcodeproj` in [`Examples/ShaderGallery`](Examples/ShaderGallery) mit Xcode, wähle einen iPhone-Simulator oder **My Mac** und drücke **Run**. Jeder Effekt hat einen Schieberegler für seinen wichtigsten Parameter; Einzelheiten stehen in [Examples/README.md](Examples/README.md).

## Dokumentation

Referenzdokumentation und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC, von `main` auf GitHub Pages veröffentlicht)
- Lokal baust du sie in Xcode mit **Product › Build Documentation** oder über die Kommandozeile:

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — das Paket hinzufügen, Effekte anwenden und kombinieren, das Build-Tool prüfen, Reduce Motion
  ([Quelle](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — animierte, feste und selbst gesteuerte Zeit, Wellen und warum die Zeit jede Stunde von vorn beginnt
  ([Quelle](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — Farb-, Verzerrungs- und Ebeneneffekte, wie Argumente geprüft werden, und die Argumentliste
  jeder Shader-Funktion ([Quelle](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Voraussetzungen

| Plattform | Mindestversion        |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

`swift build` und `swift test` auf der Kommandozeile brauchen Swift 6.4, um die Shader zu kompilieren (siehe [Installation](#installation)); Xcode 26 und neuer kompiliert sie in jedem Fall. CI baut mit dem Standard-Xcode des `macos-26`-Runner-Images von GitHub. Das Paket wird mit Xcode 27 entwickelt.

## Architektur

- `Sources/SwiftShaders/Shaders/` enthält den Metal-Code, eine Datei pro Effektart, mit Hilfsfunktionen in `ShaderCommon.h`. Jede Funktion ist `[[ stitchable ]]` und beginnt mit `ss`, sodass sie nicht mit Shadern in einer App kollidieren kann.
- `Sources/SwiftShaders/Effects/`, `Fills/` und `Transitions/` enthalten die Swift-API: pro Shader ein View-Modifier, eine Füllung oder ein Übergang, jeweils wenige Zeilen, die die Argumente prüfen und den Shader aufrufen.
- `Core/ShaderEffect.swift` wendet einen Shader an: Es vermisst die View mit `visualEffect`, führt für animierte Effekte eine `TimelineView` aus (bei Reduce Motion angehalten) und legt Ebeneneffekte in eine Compositing-Gruppe. `Core/ShaderInput.swift` enthält alle Argumentprüfungen und `Core/ShaderTime.swift` die animierte und die feste Zeit, die jede Stunde von vorn beginnt.
- Die Tests rendern Views mit `ImageRenderer` über Schwarz und über Weiß, was Farbe und Alpha jedes Pixels liefert, und vergleichen sie mit in Swift berechneten Werten. `InputSafetyTests` übergibt NaN, unendliche und riesige Werte an jede Effektart, und `LibraryTests` vergleicht die Funktionsnamen der kompilierten Bibliothek mit den Namen, die der Swift-Code aufruft.
- CI führt die Tests auf macOS und in einem iPhone-Simulator über `xcodebuild` aus, baut die Beispiel-App für iOS und macOS und veröffentlicht die DocC-Dokumentation.

Die Tests lokal ausführen:

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roadmap

- Das Paket zum Swift Package Index hinzufügen; `.spi.yml` liegt bereits im Repository.
- tvOS und visionOS testen und aktivieren, wo SwiftUI dieselbe Shader-API hat.
- Eine maskierte Variante der progressiven Unschärfe, die jeder Form folgt.

## Mitwirken

Beiträge sind willkommen. Lies den [Leitfaden zum Mitwirken](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md), bevor du einen Pull Request öffnest. Melde Sicherheitslücken vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).

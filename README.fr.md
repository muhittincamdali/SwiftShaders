<!-- i18n-source: README.md@cd2380b7514c5fc84e4c876d40098c1bde7d6458 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-fr-light.svg" alt="SwiftShaders: Des effets de shaders Metal pour les vues SwiftUI : couleur, flou, distorsion, ondulations et transitions."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Dernière version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

Un package Swift d'effets GPU pour SwiftUI sur iOS 17+ et macOS 14+ : des effets de couleur comme sepia, duotone et halftone, un flou progressif, des distorsions comme wave, swirl et loupe, des ondulations qui suivent les touchers, des remplissages par shader et des transitions de vues. Chaque effet est un view modifier construit sur les propres `colorEffect`, `distortionEffect` et `layerEffect` de SwiftUI ; il fonctionne donc avec n'importe quelle vue : une image, un texte, une forme ou un écran entier. Il s'adresse aux développeurs d'apps qui veulent ces effets sans écrire de code Metal, et, pour ceux qui en écrivent, chaque fonction de shader est documentée afin de pouvoir être appelée directement. Le package n'a aucune dépendance.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Trois copies d'un paysage dessiné en code : à gauche, les lignes ondulent comme une vague ; au milieu, une ondulation se propage depuis le centre ; à droite, une bande de lumière balaie l'image"></p>

## Points forts

- **26 view modifiers, 3 remplissages et 5 transitions** — comptés à partir des sources et listés dans le tableau ci-dessous, chacun avec ses paramètres et leurs plages de valeurs documentés.
- **Des arguments qui ne peuvent pas casser un shader** — les valeurs sont bornées à leur plage, un NaN désactive un effet, les angles, positions et durées sont maintenus à des valeurs qu'un float 32 bits peut représenter, et aucun argument ne peut conduire SwiftUI à allouer une couche hors écran plus grande que la vue augmentée de sa diagonale.
- **Des bords nets** — les effets qui comparent les pixels voisins ne lisent qu'à l'intérieur de la vue ; une vue accentuée, en relief ou en croquis n'a donc aucune bordure sombre ou claire, et les effets de couleur conservent l'alpha lissé du texte et des symboles.
- **Réduire les animations (Reduce Motion)** — lorsque ce réglage est activé, les effets animés s'arrêtent sur leur première image et les ondulations ignorent les touchers.
- **Des pixels testés** — 76 tests Swift Testing affichent les effets avec `ImageRenderer` et comparent les pixels à des valeurs calculées en Swift, sur macOS et sur un simulateur d'iPhone. Un autre test charge la bibliothèque Metal compilée et vérifie qu'elle contient exactement les fonctions appelées par le code Swift.
- **Des exemples qui compilent** — chaque exemple ci-dessous provient de l'[app d'exemple](Examples/ShaderGallery), que la CI compile pour iOS et macOS ; les tests affichent chacun d'eux.

### Ce qui est inclus

| Type             | Effets                                                                                                                    |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Couleur (10)     | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| Couche (9)       | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Distorsion (5)   | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| Ondulations (2)  | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| Remplissages (3) | `.checkerboard`, `.stripes`, `.plasma` pour tout `ShapeStyle`                                                             |
| Transitions (5)  | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

Les effets animés prennent un `ShaderTime` : `.animated`, `.animated(speed:)` ou `.fixed(_:)` pour une seule image.

## Démarrage rapide

**1. Ajoutez le package**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l'URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Collez-la dans le champ de recherche en haut à droite de la fenêtre. Laissez **Dependency Rule** sur **Up to Next Major Version** à partir de `2.0.0`, puis cliquez sur **Add Package**. Dans la fenêtre suivante, choisissez la cible de votre app à côté de **SwiftShaders** et cliquez de nouveau sur **Add Package**.

**2. Importez le module**

```swift
import SwiftShaders
```

Placez cette ligne en haut du fichier Swift où vous utilisez un effet, sous `import SwiftUI`.

**3. Utilisez-le**

Dans une nouvelle app Xcode (**File › New › Project… › App**), remplacez tout le contenu de `ContentView.swift` par :

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

Appuyez sur **Run** (⌘R). Les montagnes apparaissent comme une impression en halftone : des points bleus sur du papier blanc, gros là où se trouve le symbole et petits autour. Remplacez `dotSize` par 10 et relancez pour voir des points plus gros.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l'URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

Les effets sont des fichiers `.metal` compilés dans le bundle du package. Xcode les compile toujours, et `swift build` aussi à partir de Swift 6.4, où le moteur Swift Build de SwiftPM devient le moteur par défaut. Avec un `swift build` plus ancien, les fichiers sont copiés sans être compilés et les vues avec un effet ne s'affichent pas ; `SwiftShaders.isMetalLibraryAvailable` vous indique dans quel cas vous vous trouvez.

La version 2.0.0 (octobre 2026) est un nouveau package avec une nouvelle API. La version précédente, 1.0.0 (février 2026), ne compilait pas avec le compilateur Metal actuel et cherchait ses shaders dans le bundle de l'app au lieu de celui du package ; ses effets n'apparaissaient donc jamais. En juin 2026, son code a été remplacé par des éléments provisoires et, en octobre 2026, le package a été réécrit de zéro. [CHANGELOG.md](CHANGELOG.md) liste ce qui a changé.

## Utilisation

Les exemples ci-dessous sont copiés depuis
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift).
L'app d'exemple et la suite de tests compilent toutes deux ce fichier.

### Combiner des effets

Les effets s'exécutent dans l'ordre, de la vue vers l'extérieur :

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

### Indiquer que le contenu se charge

`shimmer` n'éclaircit que ce qui est dessiné : les formes de remplacement brillent et l'espace autour d'elles reste vide. Lorsque Reduce Motion est activé, la bande n'est pas affichée.

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

### Animer dans le temps

Les effets animés s'exécutent d'eux-mêmes. Passez `time: .fixed(seconds)` pour afficher une seule image, par exemple dans les aperçus et les tests de snapshot, ou pour piloter le temps avec votre propre animation.

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

### Une ondulation là où l'utilisateur touche

Le toucher est reconnu en même temps que les gestes propres à la vue ; les boutons qu'elle contient continuent donc de fonctionner.

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

### Transition entre deux vues

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

### Appeler un shader soi-même

`ShaderLibrary.swiftShaders` est la bibliothèque compilée, pour les modifiers d'effets propres à SwiftUI ou pour les remplissages. La [liste des arguments de chaque fonction](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn) figure dans la documentation ; les appels faits ainsi contournent les vérifications d'arguments du package.

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## Démo

Chaque effet appliqué à un paysage dessiné en code, généré par
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) à partir de
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift) :

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="Le paysage avec chaque effet de couleur : original, sepia, duotone, gradient map, posterize, threshold, dither, vignette, scanlines, film grain et shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="Le paysage avec chaque effet de couche : pixelate, halftone, sketch, emboss, sharpen, progressive blur, chromatic aberration, kaleidoscope et glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="Le paysage avec chaque distorsion : wave, water, swirl, bulge et loupe"></picture>

Les transitions à 0, 25, 50 et 75 pour cent de leur déroulement :

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Images des transitions dissolve, pixelate, swirl, circle reveal et radial wipe"></picture>

Le halftone dans l'app d'exemple sur un simulateur d'iPhone, capturé par [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh) :

| Clair                                                                                                                | Sombre                                                                                                               |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| ![L'écran Halftone de l'app d'exemple avec un curseur de taille de point, mode clair](docs/images/gallery-light.png) | ![L'écran Halftone de l'app d'exemple avec un curseur de taille de point, mode sombre](docs/images/gallery-dark.png) |

Pour essayer les effets vous-même, ouvrez `ShaderGallery.xcodeproj` dans [`Examples/ShaderGallery`](Examples/ShaderGallery) avec Xcode, choisissez un simulateur d'iPhone ou **My Mac**, puis appuyez sur **Run**. Chaque effet dispose d'un curseur pour son paramètre principal ; [Examples/README.md](Examples/README.md) donne les détails.

## Documentation

Documentation de référence et articles :

- [Référence de l'API](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC, publiée sur GitHub Pages depuis `main`)
- Générez-la en local dans Xcode avec **Product › Build Documentation**, ou en ligne de commande :

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — ajouter le package, appliquer et combiner des effets, vérifier l'outil de compilation, Reduce Motion
  ([source](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — temps animé, fixe et piloté par vos soins, ondulations, et pourquoi le temps repart de zéro chaque heure
  ([source](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — effets de couleur, de distorsion et de couche, comment les arguments sont vérifiés, et la liste des arguments
  de chaque fonction de shader ([source](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Prérequis

| Plateforme | Version minimale      |
| ---------- | --------------------- |
| iOS        | 17                    |
| macOS      | 14                    |
| Toolchain  | Swift 6.2 · Xcode 26+ |

`swift build` et `swift test` en ligne de commande nécessitent Swift 6.4 pour compiler les shaders (voir [Installation](#installation)) ; Xcode 26 et les versions ultérieures les compilent dans tous les cas. La CI compile avec le Xcode par défaut de l'image de runner `macos-26` de GitHub. Le package est développé avec Xcode 27.

## Architecture

- `Sources/SwiftShaders/Shaders/` contient le code Metal, un fichier par type d'effet, avec des fonctions utilitaires dans `ShaderCommon.h`. Chaque fonction est `[[ stitchable ]]` et commence par `ss`, de sorte qu'elle ne peut pas entrer en collision avec les shaders d'une app.
- `Sources/SwiftShaders/Effects/`, `Fills/` et `Transitions/` contiennent l'API Swift : un view modifier, un remplissage ou une transition par shader, chacun de quelques lignes qui vérifient les arguments et appellent le shader.
- `Core/ShaderEffect.swift` applique un shader : il mesure la vue avec `visualEffect`, exécute un `TimelineView` pour les effets animés (arrêté avec Reduce Motion) et place les effets de couche dans un compositing group. `Core/ShaderInput.swift` contient toutes les vérifications d'arguments, et `Core/ShaderTime.swift` le temps animé et fixe, qui repart de zéro chaque heure.
- Les tests affichent les vues avec `ImageRenderer` sur du noir et sur du blanc, ce qui donne la couleur et l'alpha de chaque pixel, puis les comparent à des valeurs calculées en Swift. `InputSafetyTests` transmet des NaN, des infinis et des valeurs énormes à chaque type d'effet, et `LibraryTests` compare les noms de fonctions de la bibliothèque compilée aux noms appelés par le code Swift.
- La CI exécute les tests sur macOS et sur un simulateur d'iPhone via `xcodebuild`, compile l'app d'exemple pour iOS et macOS, et publie la documentation DocC.

Exécutez les tests en local :

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Feuille de route

- Ajouter le package au Swift Package Index ; `.spi.yml` est déjà dans le dépôt.
- Tester et activer tvOS et visionOS, où SwiftUI offre la même API de shaders.
- Une variante masquée du flou progressif qui suit n'importe quelle forme.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d'ouvrir une pull request. Signalez les problèmes de sécurité de manière confidentielle, comme décrit dans la [politique de sécurité](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).

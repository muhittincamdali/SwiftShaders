<!-- i18n-source: README.md@cd2380b7514c5fc84e4c876d40098c1bde7d6458 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-es-light.svg" alt="SwiftShaders: Efectos de shaders de Metal para vistas de SwiftUI: color, desenfoque, distorsión, ondas y transiciones."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Última versión: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

Un paquete de Swift con efectos de GPU para SwiftUI en iOS 17+ y macOS 14+: efectos de color como sepia, duotone y halftone, un desenfoque progresivo, distorsiones como wave, swirl y loupe, ondas que siguen los toques, rellenos con shaders y transiciones de vistas. Cada efecto es un view modifier construido sobre los propios `colorEffect`, `distortionEffect` y `layerEffect` de SwiftUI, así que funciona con cualquier vista: una imagen, un texto, una forma o una pantalla completa. Está pensado para desarrolladores de apps que quieren estos efectos sin escribir código Metal; para quienes sí quieren escribirlo, cada función de shader está documentada y se puede llamar directamente. El paquete no tiene dependencias.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Tres copias de un paisaje dibujado con código: a la izquierda las filas se mecen en una onda, en el centro una onda se expande desde el centro y a la derecha una banda de luz barre la imagen"></p>

## Lo más destacado

- **26 view modifiers, 3 rellenos y 5 transiciones** — contados a partir del código fuente y enumerados en la tabla de abajo, cada uno con sus parámetros y rangos documentados.
- **Argumentos que no pueden romper un shader** — los valores se limitan a sus rangos, un NaN desactiva el efecto, los ángulos, las posiciones y los tiempos se mantienen en valores que cabe en un float de 32 bits, y ningún argumento puede hacer que SwiftUI reserve una capa fuera de pantalla mayor que la vista más su diagonal.
- **Bordes limpios** — los efectos que comparan píxeles vecinos leen solo dentro de la vista, de modo que una vista con nitidez, relieve o aspecto de boceto no tiene un borde oscuro ni brillante, y los efectos de color conservan el alfa suavizado del texto y los símbolos.
- **Reducir movimiento (Reduce Motion)** — con este ajuste activado, los efectos animados se detienen en su primer fotograma y las ondas ignoran los toques.
- **Píxeles probados** — 76 tests de Swift Testing renderizan los efectos con `ImageRenderer` y comparan los píxeles con valores calculados en Swift, en macOS y en un simulador de iPhone. Otro test carga la biblioteca de Metal compilada y comprueba que contiene exactamente las funciones que llama el código Swift.
- **Ejemplos que compilan** — cada ejemplo de abajo proviene de la [app de ejemplo](Examples/ShaderGallery), que CI compila para iOS y macOS, y los tests renderizan cada uno.

### Qué incluye

| Tipo             | Efectos                                                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Color (10)       | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| Capa (9)         | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Distorsión (5)   | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| Ondas (2)        | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| Rellenos (3)     | `.checkerboard`, `.stripes`, `.plasma` para cualquier `ShapeStyle`                                                        |
| Transiciones (5) | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

Los efectos animados reciben un `ShaderTime`: `.animated`, `.animated(speed:)` o `.fixed(_:)` para un solo fotograma.

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Pégala en el campo de búsqueda de la parte superior derecha de la ventana. Deja **Dependency Rule** en **Up to Next Major Version** desde `2.0.0` y haz clic en **Add Package**. En la ventana siguiente, elige el target de tu app junto a **SwiftShaders** y haz clic de nuevo en **Add Package**.

**2. Importa el módulo**

```swift
import SwiftShaders
```

Pon esta línea al principio del archivo Swift donde uses un efecto, debajo de `import SwiftUI`.

**3. Úsalo**

En una app nueva de Xcode (**File › New › Project… › App**), sustituye todo el contenido de `ContentView.swift` por:

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

Pulsa **Run** (⌘R). Las montañas aparecen como una impresión de halftone: puntos azules sobre papel blanco, grandes donde está el símbolo y pequeños a su alrededor. Cambia `dotSize` a 10 y ejecútalo de nuevo para ver puntos más gruesos.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

O añádelo a `dependencies` en tu `Package.swift`:

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

Los efectos son archivos `.metal` que se compilan en el bundle del paquete. Xcode siempre los compila, y `swift build` también desde Swift 6.4, donde el motor Swift Build de SwiftPM es el predeterminado. Con un `swift build` anterior, los archivos se copian sin compilarse y las vistas con un efecto no se dibujan; `SwiftShaders.isMetalLibraryAvailable` te indica en cuál de los dos casos estás.

La versión 2.0.0 (octubre de 2026) es un paquete nuevo con una API nueva. La versión anterior, la 1.0.0 (febrero de 2026), no compilaba con el compilador de Metal actual y buscaba sus shaders en el bundle de la app en lugar de en el del paquete, por lo que sus efectos nunca aparecían. En junio de 2026 su código se sustituyó por marcadores de posición y, en octubre de 2026, el paquete se volvió a escribir desde cero. [CHANGELOG.md](CHANGELOG.md) enumera lo que cambió.

## Uso

Los ejemplos de abajo están copiados de
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift).
La app de ejemplo y la suite de tests compilan ese archivo.

### Combina efectos

Los efectos se ejecutan en orden, de la vista hacia fuera:

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

### Indica que el contenido se está cargando

`shimmer` solo ilumina lo que está dibujado, así que las formas de marcador brillan y el espacio a su alrededor queda vacío. Con Reduce Motion activado, la banda no se muestra.

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

### Anima con el tiempo

Los efectos animados se ejecutan por sí solos. Pasa `time: .fixed(seconds)` para mostrar un solo fotograma, por ejemplo en previsualizaciones y tests de snapshots, o para controlar el tiempo con tu propia animación.

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

### Ondas donde toca el usuario

El toque se reconoce junto con los gestos propios de la vista, así que los botones que haya dentro siguen funcionando.

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

### Transición entre vistas

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

### Llama a un shader tú mismo

`ShaderLibrary.swiftShaders` es la biblioteca compilada, para los modifiers de efectos propios de SwiftUI o para rellenos. La [lista de argumentos de cada función](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn) está en la documentación; las llamadas hechas así se saltan las comprobaciones de argumentos del paquete.

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

Cada efecto aplicado a un paisaje dibujado con código, renderizado por
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) a partir de
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift):

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="El paisaje con cada efecto de color: original, sepia, duotone, gradient map, posterize, threshold, dither, vignette, scanlines, film grain y shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="El paisaje con cada efecto de capa: pixelate, halftone, sketch, emboss, sharpen, progressive blur, chromatic aberration, kaleidoscope y glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="El paisaje con cada distorsión: wave, water, swirl, bulge y loupe"></picture>

Las transiciones al 0, 25, 50 y 75 por ciento del recorrido:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Fotogramas de las transiciones dissolve, pixelate, swirl, circle reveal y radial wipe"></picture>

El halftone en la app de ejemplo, en un simulador de iPhone, capturado con [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh):

| Claro                                                                                                                                 | Oscuro                                                                                                                                |
| ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| ![La pantalla Halftone de la app de ejemplo con un control deslizante del tamaño de punto, modo claro](docs/images/gallery-light.png) | ![La pantalla Halftone de la app de ejemplo con un control deslizante del tamaño de punto, modo oscuro](docs/images/gallery-dark.png) |

Para probar los efectos tú mismo, abre `ShaderGallery.xcodeproj` de [`Examples/ShaderGallery`](Examples/ShaderGallery) con Xcode, elige un simulador de iPhone o **My Mac** y pulsa **Run**. Cada efecto tiene un control deslizante para su parámetro principal; [Examples/README.md](Examples/README.md) tiene los detalles.

## Documentación

Documentación de referencia y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC, publicada en GitHub Pages desde `main`)
- Genérala en local en Xcode con **Product › Build Documentation**, o desde la línea de comandos:

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Guías

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — añadir el paquete, aplicar y combinar efectos, comprobar la herramienta de compilación, Reduce Motion
  ([código fuente](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — tiempo animado, fijo y controlado por ti, ondas, y por qué el tiempo vuelve a empezar cada hora
  ([código fuente](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — efectos de color, de distorsión y de capa, cómo se comprueban los argumentos y la lista de argumentos
  de cada función de shader ([código fuente](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Requisitos

| Plataforma | Versión mínima        |
| ---------- | --------------------- |
| iOS        | 17                    |
| macOS      | 14                    |
| Toolchain  | Swift 6.2 · Xcode 26+ |

`swift build` y `swift test` desde la línea de comandos necesitan Swift 6.4 para compilar los shaders (consulta [Instalación](#instalación)); Xcode 26 y posteriores los compilan en cualquier caso. CI compila con el Xcode predeterminado de la imagen de runner `macos-26` de GitHub. El paquete se desarrolla con Xcode 27.

## Arquitectura

- `Sources/SwiftShaders/Shaders/` contiene el código Metal, un archivo por tipo de efecto, con funciones auxiliares en `ShaderCommon.h`. Todas las funciones son `[[ stitchable ]]` y empiezan por `ss`, de modo que no pueden chocar con los shaders de una app.
- `Sources/SwiftShaders/Effects/`, `Fills/` y `Transitions/` contienen la API de Swift: un view modifier, relleno o transición por shader, cada uno de unas pocas líneas que comprueban los argumentos y llaman al shader.
- `Core/ShaderEffect.swift` aplica un shader: mide la vista con `visualEffect`, ejecuta un `TimelineView` para los efectos animados (que se detiene con Reduce Motion) y coloca los efectos de capa en un compositing group. `Core/ShaderInput.swift` contiene todas las comprobaciones de argumentos y `Core/ShaderTime.swift` el tiempo animado y fijo, que vuelve a empezar cada hora.
- Los tests renderizan las vistas con `ImageRenderer` sobre negro y sobre blanco, lo que da el color y el alfa de cada píxel, y los comparan con valores calculados en Swift. `InputSafetyTests` pasa NaN, infinitos y valores enormes a todos los tipos de efecto, y `LibraryTests` compara los nombres de las funciones de la biblioteca compilada con los nombres que llama el código Swift.
- CI ejecuta los tests en macOS y en un simulador de iPhone mediante `xcodebuild`, compila la app de ejemplo para iOS y macOS, y publica la documentación de DocC.

Ejecuta los tests en local:

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Hoja de ruta

- Añadir el paquete al Swift Package Index; `.spi.yml` ya está en el repositorio.
- Probar y habilitar tvOS y visionOS, donde SwiftUI tiene la misma API de shaders.
- Una variante con máscara del desenfoque progresivo que siga cualquier forma.

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir un pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).

<!-- i18n-source: README.md@ade474b3f71f0687955e4861aa63ee003c043f4d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/banner-pt-BR-light.svg" alt="SwiftShaders: Efeitos de shaders Metal para views SwiftUI: cor, desfoque, distorção, ondulações e transições."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftShaders/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftShaders/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftShaders/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

Um pacote Swift de efeitos de GPU para SwiftUI no iOS 17+ e no macOS 14+: efeitos de cor como sepia, duotone e halftone, um desfoque progressivo, distorções como wave, swirl e loupe, ondulações que acompanham os toques, preenchimentos com shaders e transições de views. Cada efeito é um view modifier construído sobre os próprios `colorEffect`, `distortionEffect` e `layerEffect` do SwiftUI, então funciona em qualquer view: uma imagem, um texto, uma forma ou uma tela inteira. Ele é para desenvolvedores de apps que querem esses efeitos sem escrever código Metal; para quem quer escrevê-lo, cada função de shader está documentada e pode ser chamada diretamente. O pacote não tem dependências.

<p align="center"><img src="docs/images/animated.gif" width="752" alt="Três cópias de uma paisagem desenhada em código: à esquerda, as linhas balançam em uma onda; no meio, uma ondulação se espalha a partir do centro; à direita, uma faixa de luz varre a imagem"></p>

## Destaques

- **26 view modifiers, 3 preenchimentos e 5 transições** — contados a partir do código-fonte e listados na tabela abaixo, cada um com parâmetros e intervalos de valores documentados.
- **Argumentos que não quebram um shader** — os valores são limitados aos seus intervalos, um NaN desativa o efeito, ângulos, posições e tempos são mantidos em valores que um float de 32 bits comporta, e nenhum argumento pode fazer o SwiftUI alocar uma camada offscreen maior que a view somada à sua diagonal.
- **Bordas limpas** — efeitos que comparam pixels vizinhos leem apenas dentro da view, então uma view com nitidez, relevo ou aspecto de esboço não ganha borda escura nem clara, e os efeitos de cor preservam o alfa suavizado de textos e símbolos.
- **Reduzir Movimento (Reduce Motion)** — com o ajuste ativado, os efeitos animados param no primeiro quadro e as ondulações ignoram os toques.
- **Pixels testados** — 77 testes do Swift Testing rodam no macOS e em um simulador de iPhone. 61 deles renderizam os efeitos com `ImageRenderer` e comparam os pixels com valores calculados em Swift, 14 verificam como os argumentos e o tempo de animação são convertidos, e 2 carregam a biblioteca Metal compilada e verificam se ela contém exatamente as funções que o código Swift chama.
- **Exemplos que compilam** — cada exemplo abaixo vem do [app de exemplo](Examples/ShaderGallery), que a CI compila para iOS e macOS, e os testes renderizam cada um deles.

### O que está incluído

| Tipo               | Efeitos                                                                                                                   |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| Cor (10)           | `sepia`, `duotone`, `gradientMap`, `posterize`, `threshold`, `dither`, `vignette`, `scanlines`, `filmGrain`, `shimmer`    |
| Camada (9)         | `pixelate`, `halftone`, `sketch`, `emboss`, `sharpen`, `progressiveBlur`, `chromaticAberration`, `kaleidoscope`, `glitch` |
| Distorção (5)      | `wave`, `water`, `swirl`, `bulge`, `loupe`                                                                                |
| Ondulações (2)     | `rippleOnTap`, `ripple(origin:elapsedTime:style:)`                                                                        |
| Preenchimentos (3) | `.checkerboard`, `.stripes`, `.plasma` para qualquer `ShapeStyle`                                                         |
| Transições (5)     | `.dissolve`, `.pixelate`, `.swirl`, `.circleReveal`, `.radialWipe`                                                        |

Os efeitos animados recebem um `ShaderTime`: `.animated`, `.animated(speed:)` ou `.fixed(_:)` para um único quadro.

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Cole-a no campo de busca no canto superior direito da janela. Deixe **Dependency Rule** em **Up to Next Major Version** a partir de `2.0.0` e clique em **Add Package**. Na janela seguinte, escolha o target do seu app ao lado de **SwiftShaders** e clique em **Add Package** novamente.

**2. Importe o módulo**

```swift
import SwiftShaders
```

Coloque esta linha no início do arquivo Swift em que você usa um efeito, abaixo de `import SwiftUI`.

**3. Use**

Em um novo app do Xcode (**File › New › Project… › App**), substitua todo o conteúdo de `ContentView.swift` por:

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

Pressione **Run** (⌘R). As montanhas aparecem como uma impressão em halftone: pontos azuis sobre papel branco, grandes onde está o símbolo e pequenos ao redor dele. Mude `dotSize` para 10 e execute de novo para ver pontos maiores.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftShaders.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

Os efeitos são arquivos `.metal` compilados no bundle do pacote. O Xcode sempre os compila, e o `swift build` também a partir do Swift 6.4, em que o mecanismo Swift Build do SwiftPM é o padrão. Com um `swift build` mais antigo, os arquivos são copiados sem serem compilados e as views com efeito não são desenhadas; `SwiftShaders.isMetalLibraryAvailable` informa em qual caso você está.

A versão 2.0.0 (outubro de 2026) é um pacote novo com uma API nova. A versão anterior, 1.0.0 (fevereiro de 2026), não compilava com o compilador Metal atual e procurava seus shaders no bundle do app em vez de no do pacote, então seus efeitos nunca apareciam. Em junho de 2026, seu código foi substituído por marcadores de posição e, em outubro de 2026, o pacote foi escrito de novo do zero. O [CHANGELOG.md](CHANGELOG.md) lista o que mudou.

## Uso

Os exemplos abaixo foram copiados de
[`Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift`](Examples/ShaderGallery/ShaderGallery/ReadmeSamples.swift).
O app de exemplo e a suíte de testes compilam esse arquivo.

### Combine efeitos

Os efeitos são executados em ordem, da view para fora:

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

### Mostre que o conteúdo está carregando

`shimmer` clareia apenas o que foi desenhado, então as formas de espaço reservado brilham e o espaço ao redor delas continua vazio. Com Reduce Motion ativado, a faixa não é exibida.

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

### Anime ao longo do tempo

Os efeitos animados rodam sozinhos. Passe `time: .fixed(seconds)` para mostrar um único quadro, por exemplo em previews e testes de snapshot, ou para controlar o tempo com a sua própria animação.

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

### Ondulação onde o usuário toca

O toque é reconhecido junto com os gestos da própria view, então os botões que estiverem dentro dela continuam funcionando.

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

### Transição entre views

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

### Chame um shader você mesmo

`ShaderLibrary.swiftShaders` é a biblioteca compilada, para os modifiers de efeito do próprio SwiftUI ou para preenchimentos. A [lista de argumentos de cada função](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn) está na documentação; chamadas feitas dessa forma pulam as verificações de argumentos do pacote.

```swift
struct DirectShaderSample: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(ShaderLibrary.swiftShaders.ssCheckerboard(.float(10), .color(.white), .color(.blue.opacity(0.3))))
            .frame(width: 200, height: 120)
    }
}
```

## Demonstração

Cada efeito aplicado a uma paisagem desenhada em código, renderizado por
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) a partir de
[`Tests/SwiftShadersTests/Screenshots.swift`](Tests/SwiftShadersTests/Screenshots.swift):

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-color-dark.png"><img src="docs/images/effects-color-light.png" width="760" alt="A paisagem com cada efeito de cor: original, sepia, duotone, gradient map, posterize, threshold, dither, vignette, scanlines, film grain e shimmer"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-layer-dark.png"><img src="docs/images/effects-layer-light.png" width="572" alt="A paisagem com cada efeito de camada: pixelate, halftone, sketch, emboss, sharpen, progressive blur, chromatic aberration, kaleidoscope e glitch"></picture>

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/effects-distortion-dark.png"><img src="docs/images/effects-distortion-light.png" width="760" alt="A paisagem com cada distorção: wave, water, swirl, bulge e loupe"></picture>

As transições em 0, 25, 50 e 75 por cento do percurso:

<picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/transitions-dark.png"><img src="docs/images/transitions-light.png" width="720" alt="Quadros das transições dissolve, pixelate, swirl, circle reveal e radial wipe"></picture>

O halftone no app de exemplo em um simulador de iPhone, capturado por [`scripts/capture-gallery.sh`](scripts/capture-gallery.sh):

| Claro                                                                                                                          | Escuro                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| ![A tela Halftone do app de exemplo com um controle deslizante de tamanho do ponto, modo claro](docs/images/gallery-light.png) | ![A tela Halftone do app de exemplo com um controle deslizante de tamanho do ponto, modo escuro](docs/images/gallery-dark.png) |

Para experimentar os efeitos, abra o `ShaderGallery.xcodeproj` em [`Examples/ShaderGallery`](Examples/ShaderGallery) com o Xcode, escolha um simulador de iPhone ou **My Mac** e pressione **Run**. Cada efeito tem um controle deslizante para o seu parâmetro principal; o [Examples/README.md](Examples/README.md) traz os detalhes.

## Documentação

Documentação de referência e artigos:

- [Referência da API](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/)
  (DocC, publicada no GitHub Pages a partir de `main`)
- Gere-a localmente no Xcode com **Product › Build Documentation**, ou pela linha de comando:

```sh
xcodebuild docbuild -scheme SwiftShaders -destination 'generic/platform=macOS'
```

## Guias

- [Getting Started](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/gettingstarted)
  — adicionar o pacote, aplicar e combinar efeitos, verificar a ferramenta de build, Reduce Motion
  ([código-fonte](Sources/SwiftShaders/SwiftShaders.docc/GettingStarted.md)).
- [Animating Effects](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/animatingeffects)
  — tempo animado, fixo e controlado por você, ondulações, e por que o tempo recomeça a cada hora
  ([código-fonte](Sources/SwiftShaders/SwiftShaders.docc/AnimatingEffects.md)).
- [How Effects Are Drawn](https://muhittincamdali.github.io/SwiftShaders/documentation/swiftshaders/howeffectsaredrawn)
  — efeitos de cor, de distorção e de camada, como os argumentos são verificados e a lista de argumentos
  de cada função de shader ([código-fonte](Sources/SwiftShaders/SwiftShaders.docc/HowEffectsAreDrawn.md)).

## Requisitos

| Plataforma | Versão mínima         |
| ---------- | --------------------- |
| iOS        | 17                    |
| macOS      | 14                    |
| Toolchain  | Swift 6.2 · Xcode 26+ |

`swift build` e `swift test` pela linha de comando precisam do Swift 6.4 para compilar os shaders (veja [Instalação](#instalação)); o Xcode 26 e posteriores os compilam em qualquer caso. A CI compila com o Xcode padrão da imagem de runner `macos-26` do GitHub. O pacote é desenvolvido com o Xcode 27.

## Arquitetura

- `Sources/SwiftShaders/Shaders/` contém o código Metal, um arquivo por tipo de efeito, com funções auxiliares em `ShaderCommon.h`. Toda função é `[[ stitchable ]]` e começa com `ss`, então não pode colidir com shaders de um app.
- `Sources/SwiftShaders/Effects/`, `Fills/` e `Transitions/` contêm a API Swift: um view modifier, preenchimento ou transição por shader, cada um com poucas linhas que verificam os argumentos e chamam o shader.
- `Core/ShaderEffect.swift` aplica um shader: mede a view com `visualEffect`, executa um `TimelineView` para efeitos animados (parado com Reduce Motion) e coloca os efeitos de camada em um compositing group. `Core/ShaderInput.swift` contém todas as verificações de argumentos e `Core/ShaderTime.swift` o tempo animado e fixo, que recomeça a cada hora.
- Os testes renderizam views com `ImageRenderer` sobre preto e sobre branco, o que fornece a cor e o alfa de cada pixel, e os comparam com valores calculados em Swift. `InputSafetyTests` passa NaN, infinito e valores enormes para todos os tipos de efeito, e `LibraryTests` compara os nomes das funções da biblioteca compilada com os nomes que o código Swift chama.
- A CI executa os testes no macOS e em um simulador de iPhone por meio do `xcodebuild`, compila o app de exemplo para iOS e macOS e publica a documentação do DocC.

Execute os testes localmente:

```sh
swift test                                    # macOS, Swift 6.4 or later
xcodebuild test -scheme SwiftShaders \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roteiro

- Adicionar o pacote ao Swift Package Index; o `.spi.yml` já está no repositório.
- Testar e habilitar tvOS e visionOS, onde o SwiftUI tem a mesma API de shaders.
- Uma variante com máscara do desfoque progressivo que acompanhe qualquer forma.

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/SwiftShaders/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, conforme descrito na [política de segurança](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).

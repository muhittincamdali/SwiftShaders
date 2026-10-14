import SwiftShaders
import SwiftUI

/// A screen of the gallery.
enum GalleryPage: Hashable {
    case sample(String)
    case effect(String)
    case fills
    case transitions

    /// The page named by `-page <name>` on the command line, which scripts/capture-gallery.sh
    /// uses to open a screen directly: an effect or sample name, "Fills" or "Transitions".
    @MainActor init?(launchArguments: [String]) {
        guard let flag = launchArguments.firstIndex(of: "-page"), launchArguments.indices.contains(flag + 1) else {
            return nil
        }
        let name = launchArguments[flag + 1]
        switch name {
        case "Fills": self = .fills
        case "Transitions": self = .transitions
        case _ where ReadmeSample.all.contains { $0.name == name }: self = .sample(name)
        case _ where EffectDemo.all.contains { $0.name == name }: self = .effect(name)
        default: return nil
        }
    }
}

/// A README sample with the name the gallery lists it under.
struct ReadmeSample: Identifiable {
    let name: String
    let view: AnyView

    var id: String { name }

    @MainActor static let all: [ReadmeSample] = [
        ReadmeSample(name: "Quick start", view: AnyView(ContentView())),
        ReadmeSample(name: "Loading placeholder", view: AnyView(LoadingRowSample())),
        ReadmeSample(name: "Ripple on tap", view: AnyView(RippleCardSample())),
        ReadmeSample(name: "Dissolve transition", view: AnyView(DissolveTransitionSample())),
        ReadmeSample(name: "Waving flag", view: AnyView(WavingFlagSample())),
        ReadmeSample(name: "Retro screen", view: AnyView(RetroScreenSample())),
        ReadmeSample(name: "Calling a shader yourself", view: AnyView(DirectShaderSample())),
    ]
}

struct GalleryView: View {
    @State private var selection: GalleryPage?

    init(initialPage: GalleryPage? = nil) {
        _selection = State(initialValue: initialPage)
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("README samples") {
                    ForEach(ReadmeSample.all) { sample in
                        Text(sample.name).tag(GalleryPage.sample(sample.name))
                    }
                }
                ForEach(EffectGroup.allCases) { group in
                    Section("\(group.rawValue) effects") {
                        ForEach(EffectDemo.all.filter { $0.group == group }) { demo in
                            Text(demo.name).tag(GalleryPage.effect(demo.name))
                        }
                    }
                }
                Section("More") {
                    Text("Fills").tag(GalleryPage.fills)
                    Text("Transitions").tag(GalleryPage.transitions)
                }
            }
            .navigationTitle("SwiftShaders")
        } detail: {
            detail
        }
    }

    @ViewBuilder
    private var detail: some View {
        switch selection {
        case .sample(let name):
            if let sample = ReadmeSample.all.first(where: { $0.name == name }) {
                sample.view
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle(sample.name)
            }
        case .effect(let name):
            if let demo = EffectDemo.all.first(where: { $0.name == name }) {
                EffectDetail(demo: demo).id(demo.name)
            }
        case .fills:
            FillsDetail()
        case .transitions:
            TransitionsDetail()
        case nil:
            ContentUnavailableView("Choose an effect", systemImage: "sparkles")
        }
    }
}

/// One effect on the sample scene, with a slider for its main parameter.
struct EffectDetail: View {
    let demo: EffectDemo
    @State private var value: Double
    @State private var isAnimated = true

    init(demo: EffectDemo) {
        self.demo = demo
        _value = State(initialValue: demo.initialValue)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                demo.view(SampleScene(), value: value, time: isAnimated ? .animated : .fixed(1))
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 16))
                LabeledContent(demo.parameter) {
                    Slider(value: $value, in: demo.range)
                        .frame(maxWidth: 360)
                }
                Toggle("Animate time", isOn: $isAnimated)
            }
            .padding()
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(demo.name)
    }
}

struct FillsDetail: View {
    @State private var start = Date()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.checkerboard(cellSize: 12))
                    .frame(height: 120)
                RoundedRectangle(cornerRadius: 16)
                    .fill(.stripes(width: 12, angle: .degrees(45), .blue, .white))
                    .frame(height: 120)
                TimelineView(.animation) { context in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.plasma(time: context.date.timeIntervalSince(start)))
                        .frame(height: 160)
                }
            }
            .padding()
        }
        .navigationTitle("Fills")
    }
}

struct TransitionsDetail: View {
    private static let transitions: [(String, AnyTransition)] = [
        ("Dissolve", .dissolve),
        ("Pixelate", .pixelate),
        ("Swirl", .swirl),
        ("Circle reveal", .circleReveal()),
        ("Radial wipe", .radialWipe()),
    ]

    @State private var index = 0
    @State private var isShown = true

    var body: some View {
        VStack(spacing: 24) {
            Picker("Transition", selection: $index) {
                ForEach(Self.transitions.indices, id: \.self) { index in
                    Text(Self.transitions[index].0).tag(index)
                }
            }
            .pickerStyle(.menu)
            ZStack {
                if isShown {
                    SampleScene()
                        .aspectRatio(3 / 2, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 16))
                        .transition(Self.transitions[index].1)
                }
            }
            .frame(maxWidth: 600, minHeight: 200)
            Button(isShown ? "Hide" : "Show") {
                withAnimation(.easeInOut(duration: 1.2)) { isShown.toggle() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Transitions")
    }
}

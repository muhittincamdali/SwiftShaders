import SwiftUI
import Testing
@testable import SwiftShaders

@MainActor
@Suite("Transitions")
struct TransitionTests {
    let source = AnyView(grayRamp())

    @Test("Every transition leaves the view unchanged at progress 0")
    func identity() throws {
        let original = try Pixels(source, width: 32, height: 32)
        let views: [AnyView] = [
            AnyView(source.modifier(PixelateTransition(progress: 0, maxCellSize: 24))),
            AnyView(source.modifier(DissolveTransition(progress: 0, grainSize: 3, seed: 0))),
            AnyView(source.modifier(SwirlTransition(progress: 0, angle: .degrees(360)))),
            AnyView(source.modifier(CircleRevealTransition(progress: 0, center: .center))),
            AnyView(source.modifier(RadialWipeTransition(progress: 0, center: .center, startAngle: .degrees(-90)))),
        ]
        for view in views {
            #expect(try Pixels(view, width: 32, height: 32).maxDifference(from: original) <= 1)
        }
    }

    @Test("Every transition hides the view completely at progress 1")
    func fullyHidden() throws {
        let views: [AnyView] = [
            AnyView(source.modifier(PixelateTransition(progress: 1, maxCellSize: 24))),
            AnyView(source.modifier(DissolveTransition(progress: 1, grainSize: 3, seed: 0))),
            AnyView(source.modifier(SwirlTransition(progress: 1, angle: .degrees(360)))),
            AnyView(source.modifier(CircleRevealTransition(progress: 1, center: .center))),
            AnyView(source.modifier(RadialWipeTransition(progress: 1, center: .center, startAngle: .degrees(-90)))),
        ]
        for (index, view) in views.enumerated() {
            let alphas = Set(try Pixels(view, width: 32, height: 32).all.map(\.alpha))
            #expect(alphas == [0], "transition \(index): \(alphas.sorted())")
        }
    }

    @Test("Dissolve hides about the requested share of grains")
    func dissolveShare() throws {
        let pixels = try Pixels(srgb(200, 200, 200).modifier(DissolveTransition(progress: 0.3, grainSize: 2, seed: 4)), width: 64, height: 64)
        let hidden = Double(pixels.all.filter { $0.alpha == 0 }.count) / Double(64 * 64)
        #expect(abs(hidden - 0.3) < 0.08)
        #expect(pixels.all.allSatisfy { $0.alpha == 0 || $0.alpha == 255 })
    }

    @Test("Circle reveal halfway keeps the center and hides the corners")
    func circleReveal() throws {
        let pixels = try Pixels(srgb(200, 200, 200).modifier(CircleRevealTransition(progress: 0.5, center: .center)), width: 40, height: 40)
        #expect(pixels[20, 20].alpha == 255)
        #expect(pixels[0, 0].alpha == 0 && pixels[39, 39].alpha == 0)
    }

    @Test("Radial wipe a quarter of the way hides the quarter clockwise from twelve o'clock")
    func radialWipe() throws {
        let pixels = try Pixels(srgb(200, 200, 200).modifier(RadialWipeTransition(progress: 0.25, center: .center, startAngle: .degrees(-90))), width: 40, height: 40)
        #expect(pixels[30, 10].alpha == 0)    // top right: hidden
        #expect(pixels[30, 30].alpha == 255)  // bottom right
        #expect(pixels[10, 30].alpha == 255)  // bottom left
        #expect(pixels[10, 10].alpha == 255)  // top left
    }
}

import Metal
import SwiftUI
import Testing
@testable import SwiftShaders

@Suite("Shader library")
struct LibraryTests {
    /// Every function the Swift code calls. A rename on either side fails this test instead of
    /// silently drawing nothing.
    static let expectedFunctions: Set<String> = [
        "ssSepia", "ssDuotone", "ssPosterize", "ssThreshold", "ssVignette", "ssScanlines",
        "ssFilmGrain", "ssDither", "ssGradientMap", "ssShimmer",
        "ssPixelate", "ssChromaticAberration", "ssSketch", "ssEmboss", "ssSharpen", "ssHalftone",
        "ssKaleidoscope", "ssGlitch", "ssRipple", "ssProgressiveBlur",
        "ssWave", "ssSwirl", "ssBulge", "ssWater", "ssLoupe",
        "ssCheckerboard", "ssStripes", "ssPlasma",
        "ssDissolve", "ssCircleReveal", "ssRadialWipe",
    ]

    @Test("The compiled Metal library is in the package bundle")
    func metalLibraryIsBundled() {
        #expect(
            SwiftShaders.isMetalLibraryAvailable,
            "default.metallib is missing: build with Xcode or with SwiftPM 6.4 or later"
        )
    }

    @Test("The Metal library contains exactly the functions the Swift code uses")
    func functionNamesMatch() throws {
        let device = try #require(MTLCreateSystemDefaultDevice(), "No Metal device")
        let url = try #require(SwiftShaders.metalLibraryURL)
        let library = try device.makeLibrary(URL: url)
        #expect(Set(library.functionNames) == Self.expectedFunctions)
    }
}

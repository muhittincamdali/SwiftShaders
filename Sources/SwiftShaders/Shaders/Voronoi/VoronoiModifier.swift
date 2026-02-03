import SwiftUI

// MARK: - VoronoiNoiseModifier

/// A view modifier that applies Voronoi (Worley) noise patterns.
///
/// Creates cellular, organic, and crystalline visual effects using
/// procedural Voronoi noise generation.
///
/// ## Overview
///
/// Voronoi noise divides space into cells based on distance to randomly
/// distributed points. This creates natural-looking cellular patterns
/// perfect for organic materials, crystals, and abstract effects.
///
/// ```swift
/// Image("photo")
///     .modifier(VoronoiNoiseModifier(
///         time: animationTime,
///         scale: 10.0,
///         jitter: 1.0,
///         edgeWidth: 0.1
///     ))
/// ```
///
/// ## Topics
///
/// ### Creating Voronoi Effects
/// - ``init(time:scale:jitter:edgeWidth:)``
/// - ``time``
/// - ``scale``
/// - ``jitter``
/// - ``edgeWidth``
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiNoiseModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time for cell movement.
    public var time: Double
    
    /// Scale of the Voronoi cells (higher = more cells).
    public var scale: Double
    
    /// Randomness of cell point positions (0 = regular grid, 1 = fully random).
    public var jitter: Double
    
    /// Width of the cell edges.
    public var edgeWidth: Double
    
    // MARK: - Initialization
    
    /// Creates a Voronoi noise modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale factor (default: 8.0).
    ///   - jitter: Point randomness (default: 1.0).
    ///   - edgeWidth: Edge line width (default: 0.1).
    public init(
        time: Double,
        scale: Double = 8.0,
        jitter: Double = 1.0,
        edgeWidth: Double = 0.1
    ) {
        self.time = time
        self.scale = scale
        self.jitter = jitter
        self.edgeWidth = edgeWidth
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiNoise(
                .float(time),
                .float(scale),
                .float(jitter),
                .float(edgeWidth)
            )
        )
    }
}

// MARK: - VoronoiCellsModifier

/// Applies Voronoi cells with unique colors per cell.
///
/// Each cell receives a procedurally generated color based on its ID,
/// creating a mosaic or stained-glass-like appearance.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiCellsModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var jitter: Double
    public var colorVariation: Double
    
    /// Creates a Voronoi cells modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale factor.
    ///   - jitter: Point randomness.
    ///   - colorVariation: Amount of color variation between cells (0-1).
    public init(
        time: Double,
        scale: Double = 8.0,
        jitter: Double = 1.0,
        colorVariation: Double = 0.5
    ) {
        self.time = time
        self.scale = scale
        self.jitter = jitter
        self.colorVariation = colorVariation
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiCells(
                .float(time),
                .float(scale),
                .float(jitter),
                .float(colorVariation)
            )
        )
    }
}

// MARK: - VoronoiEdgeGlowModifier

/// Applies a glowing effect along Voronoi cell edges.
///
/// Creates neon-like outlines around each cell with customizable
/// glow color and width.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiEdgeGlowModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var jitter: Double
    public var glowWidth: Double
    public var glowColor: Color
    
    /// Creates a Voronoi edge glow modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale factor.
    ///   - jitter: Point randomness.
    ///   - glowWidth: Width of the glow effect.
    ///   - glowColor: Color of the edge glow.
    public init(
        time: Double,
        scale: Double = 8.0,
        jitter: Double = 1.0,
        glowWidth: Double = 0.15,
        glowColor: Color = .cyan
    ) {
        self.time = time
        self.scale = scale
        self.jitter = jitter
        self.glowWidth = glowWidth
        self.glowColor = glowColor
    }
    
    public func body(content: Content) -> some View {
        let components = glowColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiEdgeGlow(
                .float(time),
                .float(scale),
                .float(jitter),
                .float(glowWidth),
                .float3(Float(components.red), Float(components.green), Float(components.blue))
            )
        )
    }
}

// MARK: - VoronoiCrystalModifier

/// Creates a crystalline/gemstone pattern effect.
///
/// Simulates light refraction through crystal facets with
/// prismatic color separation.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiCrystalModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var facetSharpness: Double
    public var refractAmount: Double
    
    /// Creates a crystal effect modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Crystal facet scale.
    ///   - facetSharpness: Sharpness of facet edges (higher = sharper).
    ///   - refractAmount: Amount of color refraction.
    public init(
        time: Double,
        scale: Double = 6.0,
        facetSharpness: Double = 0.5,
        refractAmount: Double = 0.2
    ) {
        self.time = time
        self.scale = scale
        self.facetSharpness = facetSharpness
        self.refractAmount = refractAmount
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiCrystal(
                .float(time),
                .float(scale),
                .float(facetSharpness),
                .float(refractAmount)
            )
        )
    }
}

// MARK: - VoronoiShatteredModifier

/// Creates a shattered glass effect.
///
/// Divides the view into irregular shards with visible crack lines,
/// simulating broken glass or ice.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiShatteredModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var crackWidth: Double
    public var crackColor: Color
    
    /// Creates a shattered glass modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Size of glass shards.
    ///   - crackWidth: Width of crack lines.
    ///   - crackColor: Color of the cracks.
    public init(
        time: Double,
        scale: Double = 10.0,
        crackWidth: Double = 0.02,
        crackColor: Color = .black
    ) {
        self.time = time
        self.scale = scale
        self.crackWidth = crackWidth
        self.crackColor = crackColor
    }
    
    public func body(content: Content) -> some View {
        let components = crackColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiShattered(
                .float(time),
                .float(scale),
                .float(crackWidth),
                .float3(Float(components.red), Float(components.green), Float(components.blue))
            )
        )
    }
}

// MARK: - VoronoiCellularModifier

/// Creates an organic cell membrane pattern.
///
/// Simulates biological cell structures with visible membranes
/// and nuclei, perfect for organic/scientific visualizations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiCellularModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var membraneWidth: Double
    public var membraneColor: Color
    
    /// Creates a cellular pattern modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell size.
    ///   - membraneWidth: Width of cell membranes.
    ///   - membraneColor: Color of cell membranes.
    public init(
        time: Double,
        scale: Double = 6.0,
        membraneWidth: Double = 0.1,
        membraneColor: Color = .green
    ) {
        self.time = time
        self.scale = scale
        self.membraneWidth = membraneWidth
        self.membraneColor = membraneColor
    }
    
    public func body(content: Content) -> some View {
        let components = membraneColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiCellular(
                .float(time),
                .float(scale),
                .float(membraneWidth),
                .float3(Float(components.red), Float(components.green), Float(components.blue))
            )
        )
    }
}

// MARK: - VoronoiHoneycombModifier

/// Creates a honeycomb-like pattern.
///
/// Generates more regular cell patterns resembling honeycomb
/// or hexagonal tile structures.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiHoneycombModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var wallWidth: Double
    public var wallColor: Color
    
    /// Creates a honeycomb pattern modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Honeycomb cell size.
    ///   - wallWidth: Width of honeycomb walls.
    ///   - wallColor: Color of the walls.
    public init(
        time: Double,
        scale: Double = 8.0,
        wallWidth: Double = 0.08,
        wallColor: Color = .orange
    ) {
        self.time = time
        self.scale = scale
        self.wallWidth = wallWidth
        self.wallColor = wallColor
    }
    
    public func body(content: Content) -> some View {
        let components = wallColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiHoneycomb(
                .float(time),
                .float(scale),
                .float(wallWidth),
                .float3(Float(components.red), Float(components.green), Float(components.blue))
            )
        )
    }
}

// MARK: - VoronoiDistortModifier

/// Applies Voronoi-based position distortion.
///
/// Creates organic warping effects based on Voronoi cell boundaries.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiDistortModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var distortAmount: Double
    
    /// Creates a Voronoi distortion modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Distortion cell scale.
    ///   - distortAmount: Strength of distortion.
    public init(
        time: Double,
        scale: Double = 6.0,
        distortAmount: Double = 0.5
    ) {
        self.time = time
        self.scale = scale
        self.distortAmount = distortAmount
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.voronoiDistort(
                .float(time),
                .float(scale),
                .float(distortAmount)
            ),
            maxSampleOffset: CGSize(width: 50, height: 50)
        )
    }
}

// MARK: - VoronoiLiquidModifier

/// Creates a liquid/fluid movement effect.
///
/// Applies organic, flowing distortion that simulates liquid motion.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiLiquidModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var flowSpeed: Double
    public var flowAmount: Double
    
    /// Creates a liquid flow modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Flow cell scale.
    ///   - flowSpeed: Speed of the flow animation.
    ///   - flowAmount: Intensity of the flow distortion.
    public init(
        time: Double,
        scale: Double = 5.0,
        flowSpeed: Double = 1.0,
        flowAmount: Double = 0.3
    ) {
        self.time = time
        self.scale = scale
        self.flowSpeed = flowSpeed
        self.flowAmount = flowAmount
    }
    
    public func body(content: Content) -> some View {
        content.distortionEffect(
            ShaderLibrary.voronoiLiquid(
                .float(time),
                .float(scale),
                .float(flowSpeed),
                .float(flowAmount)
            ),
            maxSampleOffset: CGSize(width: 30, height: 30)
        )
    }
}

// MARK: - VoronoiLavaModifier

/// Creates a lava/magma cracks effect.
///
/// Simulates hot lava flowing through cooled rock cracks with
/// glowing heat emission.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiLavaModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var heatIntensity: Double
    public var coolColor: Color
    public var hotColor: Color
    
    /// Creates a lava effect modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Crack pattern scale.
    ///   - heatIntensity: Intensity of the heat glow.
    ///   - coolColor: Color of cooled rock surface.
    ///   - hotColor: Color of hot lava.
    public init(
        time: Double,
        scale: Double = 6.0,
        heatIntensity: Double = 1.0,
        coolColor: Color = Color(red: 0.2, green: 0.1, blue: 0.05),
        hotColor: Color = Color(red: 1.0, green: 0.4, blue: 0.0)
    ) {
        self.time = time
        self.scale = scale
        self.heatIntensity = heatIntensity
        self.coolColor = coolColor
        self.hotColor = hotColor
    }
    
    public func body(content: Content) -> some View {
        let cool = coolColor.rgbComponents
        let hot = hotColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiLava(
                .float(time),
                .float(scale),
                .float(heatIntensity),
                .float3(Float(cool.red), Float(cool.green), Float(cool.blue)),
                .float3(Float(hot.red), Float(hot.green), Float(hot.blue))
            )
        )
    }
}

// MARK: - VoronoiPlasmaModifier

/// Creates an electric plasma web effect.
///
/// Generates glowing plasma tendrils along cell edges with
/// animated pulsing.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiPlasmaModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var pulseSpeed: Double
    public var plasmaColor: Color
    
    /// Creates a plasma effect modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Plasma cell scale.
    ///   - pulseSpeed: Speed of pulse animation.
    ///   - plasmaColor: Color of the plasma.
    public init(
        time: Double,
        scale: Double = 5.0,
        pulseSpeed: Double = 1.0,
        plasmaColor: Color = .purple
    ) {
        self.time = time
        self.scale = scale
        self.pulseSpeed = pulseSpeed
        self.plasmaColor = plasmaColor
    }
    
    public func body(content: Content) -> some View {
        let components = plasmaColor.rgbComponents
        return content.colorEffect(
            ShaderLibrary.voronoiPlasma(
                .float(time),
                .float(scale),
                .float(pulseSpeed),
                .float3(Float(components.red), Float(components.green), Float(components.blue))
            )
        )
    }
}

// MARK: - VoronoiCausticsModifier

/// Creates water caustics pattern.
///
/// Simulates the light patterns seen at the bottom of a pool,
/// with animated interference patterns.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiCausticsModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var brightness: Double
    public var sharpness: Double
    
    /// Creates a caustics effect modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Caustic pattern scale.
    ///   - brightness: Overall brightness.
    ///   - sharpness: Sharpness of caustic lines.
    public init(
        time: Double,
        scale: Double = 8.0,
        brightness: Double = 0.5,
        sharpness: Double = 2.0
    ) {
        self.time = time
        self.scale = scale
        self.brightness = brightness
        self.sharpness = sharpness
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiCaustics(
                .float(time),
                .float(scale),
                .float(brightness),
                .float(sharpness)
            )
        )
    }
}

// MARK: - VoronoiStainedGlassModifier

/// Creates a stained glass window effect.
///
/// Divides the view into colorful panes with dark leading
/// between them, like a church window.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiStainedGlassModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var leadWidth: Double
    public var saturation: Double
    
    /// Creates a stained glass modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Size of glass panes.
    ///   - leadWidth: Width of lead dividers.
    ///   - saturation: Color saturation of panes.
    public init(
        time: Double,
        scale: Double = 8.0,
        leadWidth: Double = 0.06,
        saturation: Double = 1.0
    ) {
        self.time = time
        self.scale = scale
        self.leadWidth = leadWidth
        self.saturation = saturation
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiStainedGlass(
                .float(time),
                .float(scale),
                .float(leadWidth),
                .float(saturation)
            )
        )
    }
}

// MARK: - VoronoiFrostModifier

/// Creates a frosted/cracked ice pattern.
///
/// Simulates ice with visible cracks and frost accumulation,
/// complete with occasional sparkles.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct VoronoiFrostModifier: ViewModifier {
    
    public var time: Double
    public var scale: Double
    public var crackDepth: Double
    public var frostiness: Double
    
    /// Creates a frost effect modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Crack pattern scale.
    ///   - crackDepth: Depth/darkness of cracks.
    ///   - frostiness: Amount of frost overlay.
    public init(
        time: Double,
        scale: Double = 8.0,
        crackDepth: Double = 1.0,
        frostiness: Double = 0.5
    ) {
        self.time = time
        self.scale = scale
        self.crackDepth = crackDepth
        self.frostiness = frostiness
    }
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.voronoiFrost(
                .float(time),
                .float(scale),
                .float(crackDepth),
                .float(frostiness)
            )
        )
    }
}

// MARK: - Color Extension

extension Color {
    /// Extracts RGB components from a Color.
    var rgbComponents: (red: Double, green: Double, blue: Double) {
        #if canImport(UIKit)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self).usingColorSpace(.deviceRGB) ?? NSColor.black
        return (Double(nsColor.redComponent), Double(nsColor.greenComponent), Double(nsColor.blueComponent))
        #else
        return (0.5, 0.5, 0.5)
        #endif
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies Voronoi noise pattern.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale.
    ///   - jitter: Point randomness.
    ///   - edgeWidth: Edge width.
    /// - Returns: A view with Voronoi noise effect.
    func voronoiNoise(
        time: Double,
        scale: Double = 8.0,
        jitter: Double = 1.0,
        edgeWidth: Double = 0.1
    ) -> some View {
        modifier(VoronoiNoiseModifier(
            time: time,
            scale: scale,
            jitter: jitter,
            edgeWidth: edgeWidth
        ))
    }
    
    /// Applies colored Voronoi cells.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale.
    ///   - jitter: Point randomness.
    ///   - colorVariation: Color variation amount.
    /// - Returns: A view with colored cells.
    func voronoiCells(
        time: Double,
        scale: Double = 8.0,
        jitter: Double = 1.0,
        colorVariation: Double = 0.5
    ) -> some View {
        modifier(VoronoiCellsModifier(
            time: time,
            scale: scale,
            jitter: jitter,
            colorVariation: colorVariation
        ))
    }
    
    /// Applies Voronoi edge glow.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale.
    ///   - glowWidth: Glow width.
    ///   - glowColor: Glow color.
    /// - Returns: A view with edge glow.
    func voronoiEdgeGlow(
        time: Double,
        scale: Double = 8.0,
        glowWidth: Double = 0.15,
        glowColor: Color = .cyan
    ) -> some View {
        modifier(VoronoiEdgeGlowModifier(
            time: time,
            scale: scale,
            jitter: 1.0,
            glowWidth: glowWidth,
            glowColor: glowColor
        ))
    }
    
    /// Applies crystal effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Facet scale.
    ///   - facetSharpness: Sharpness.
    ///   - refractAmount: Refraction.
    /// - Returns: A view with crystal effect.
    func voronoiCrystal(
        time: Double,
        scale: Double = 6.0,
        facetSharpness: Double = 0.5,
        refractAmount: Double = 0.2
    ) -> some View {
        modifier(VoronoiCrystalModifier(
            time: time,
            scale: scale,
            facetSharpness: facetSharpness,
            refractAmount: refractAmount
        ))
    }
    
    /// Applies shattered glass effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Shard scale.
    ///   - crackWidth: Crack width.
    ///   - crackColor: Crack color.
    /// - Returns: A view with shattered effect.
    func voronoiShattered(
        time: Double,
        scale: Double = 10.0,
        crackWidth: Double = 0.02,
        crackColor: Color = .black
    ) -> some View {
        modifier(VoronoiShatteredModifier(
            time: time,
            scale: scale,
            crackWidth: crackWidth,
            crackColor: crackColor
        ))
    }
    
    /// Applies cellular membrane pattern.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale.
    ///   - membraneWidth: Membrane width.
    ///   - membraneColor: Membrane color.
    /// - Returns: A view with cellular pattern.
    func voronoiCellular(
        time: Double,
        scale: Double = 6.0,
        membraneWidth: Double = 0.1,
        membraneColor: Color = .green
    ) -> some View {
        modifier(VoronoiCellularModifier(
            time: time,
            scale: scale,
            membraneWidth: membraneWidth,
            membraneColor: membraneColor
        ))
    }
    
    /// Applies honeycomb pattern.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Cell scale.
    ///   - wallWidth: Wall width.
    ///   - wallColor: Wall color.
    /// - Returns: A view with honeycomb pattern.
    func voronoiHoneycomb(
        time: Double,
        scale: Double = 8.0,
        wallWidth: Double = 0.08,
        wallColor: Color = .orange
    ) -> some View {
        modifier(VoronoiHoneycombModifier(
            time: time,
            scale: scale,
            wallWidth: wallWidth,
            wallColor: wallColor
        ))
    }
    
    /// Applies Voronoi distortion.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Distortion scale.
    ///   - distortAmount: Distortion amount.
    /// - Returns: A view with distortion.
    func voronoiDistort(
        time: Double,
        scale: Double = 6.0,
        distortAmount: Double = 0.5
    ) -> some View {
        modifier(VoronoiDistortModifier(
            time: time,
            scale: scale,
            distortAmount: distortAmount
        ))
    }
    
    /// Applies liquid flow effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Flow scale.
    ///   - flowSpeed: Flow speed.
    ///   - flowAmount: Flow intensity.
    /// - Returns: A view with liquid flow.
    func voronoiLiquid(
        time: Double,
        scale: Double = 5.0,
        flowSpeed: Double = 1.0,
        flowAmount: Double = 0.3
    ) -> some View {
        modifier(VoronoiLiquidModifier(
            time: time,
            scale: scale,
            flowSpeed: flowSpeed,
            flowAmount: flowAmount
        ))
    }
    
    /// Applies lava effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Crack scale.
    ///   - heatIntensity: Heat intensity.
    /// - Returns: A view with lava effect.
    func voronoiLava(
        time: Double,
        scale: Double = 6.0,
        heatIntensity: Double = 1.0
    ) -> some View {
        modifier(VoronoiLavaModifier(
            time: time,
            scale: scale,
            heatIntensity: heatIntensity
        ))
    }
    
    /// Applies plasma effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Plasma scale.
    ///   - pulseSpeed: Pulse speed.
    ///   - plasmaColor: Plasma color.
    /// - Returns: A view with plasma effect.
    func voronoiPlasma(
        time: Double,
        scale: Double = 5.0,
        pulseSpeed: Double = 1.0,
        plasmaColor: Color = .purple
    ) -> some View {
        modifier(VoronoiPlasmaModifier(
            time: time,
            scale: scale,
            pulseSpeed: pulseSpeed,
            plasmaColor: plasmaColor
        ))
    }
    
    /// Applies water caustics effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Caustic scale.
    ///   - brightness: Brightness.
    ///   - sharpness: Sharpness.
    /// - Returns: A view with caustics.
    func voronoiCaustics(
        time: Double,
        scale: Double = 8.0,
        brightness: Double = 0.5,
        sharpness: Double = 2.0
    ) -> some View {
        modifier(VoronoiCausticsModifier(
            time: time,
            scale: scale,
            brightness: brightness,
            sharpness: sharpness
        ))
    }
    
    /// Applies stained glass effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Pane scale.
    ///   - leadWidth: Lead width.
    ///   - saturation: Color saturation.
    /// - Returns: A view with stained glass.
    func voronoiStainedGlass(
        time: Double,
        scale: Double = 8.0,
        leadWidth: Double = 0.06,
        saturation: Double = 1.0
    ) -> some View {
        modifier(VoronoiStainedGlassModifier(
            time: time,
            scale: scale,
            leadWidth: leadWidth,
            saturation: saturation
        ))
    }
    
    /// Applies frost effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - scale: Crack scale.
    ///   - crackDepth: Crack depth.
    ///   - frostiness: Frost amount.
    /// - Returns: A view with frost effect.
    func voronoiFrost(
        time: Double,
        scale: Double = 8.0,
        crackDepth: Double = 1.0,
        frostiness: Double = 0.5
    ) -> some View {
        modifier(VoronoiFrostModifier(
            time: time,
            scale: scale,
            crackDepth: crackDepth,
            frostiness: frostiness
        ))
    }
}

import SwiftUI

// MARK: - RaymarchingModifier

/// A view modifier that applies raymarched 3D effects.
///
/// Raymarching is a rendering technique that uses signed distance functions
/// to create complex 3D scenes entirely on the GPU.
///
/// ## Overview
///
/// ```swift
/// Rectangle()
///     .modifier(RaymarchingModifier(
///         time: animationTime,
///         cameraDistance: 3.0,
///         rotationSpeed: 0.5
///     ))
/// ```
///
/// ## Topics
///
/// ### Creating Effects
/// - ``init(time:cameraDistance:rotationSpeed:)``
/// - ``MetaballsModifier``
/// - ``SDFShapesModifier``
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct RaymarchingModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time for continuous motion.
    public var time: Double
    
    /// Distance of camera from origin.
    public var cameraDistance: Double
    
    /// Speed of automatic rotation.
    public var rotationSpeed: Double
    
    /// Ambient occlusion strength.
    public var aoStrength: Double
    
    /// Shadow softness factor.
    public var shadowSoftness: Double
    
    // MARK: - Initialization
    
    /// Creates a raymarching modifier with basic scene.
    /// - Parameters:
    ///   - time: Animation time value.
    ///   - cameraDistance: Camera distance from center (default: 3.0).
    ///   - rotationSpeed: Auto-rotation speed (default: 0.3).
    ///   - aoStrength: Ambient occlusion strength (default: 0.5).
    ///   - shadowSoftness: Shadow edge softness (default: 8.0).
    public init(
        time: Double,
        cameraDistance: Double = 3.0,
        rotationSpeed: Double = 0.3,
        aoStrength: Double = 0.5,
        shadowSoftness: Double = 8.0
    ) {
        self.time = time
        self.cameraDistance = cameraDistance
        self.rotationSpeed = rotationSpeed
        self.aoStrength = aoStrength
        self.shadowSoftness = shadowSoftness
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.raymarching(
                .float(time),
                .float(cameraDistance),
                .float(rotationSpeed),
                .float(aoStrength),
                .float(shadowSoftness)
            )
        )
    }
}

// MARK: - MetaballsModifier

/// Creates organic metaball/blob shapes using raymarching.
///
/// Metaballs are implicit surfaces defined by the sum of distance fields,
/// creating smooth blending between shapes.
///
/// ## Usage
///
/// ```swift
/// Circle()
///     .modifier(MetaballsModifier(
///         time: animationTime,
///         blobCount: 5,
///         smoothness: 0.5
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct MetaballsModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Number of metaballs in scene.
    public var blobCount: Int
    
    /// Blending smoothness between blobs.
    public var smoothness: Double
    
    /// Scale of the metaball formation.
    public var scale: Double
    
    /// Movement speed of blobs.
    public var moveSpeed: Double
    
    /// Primary color hue.
    public var hue: Double
    
    // MARK: - Initialization
    
    /// Creates a metaballs modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - blobCount: Number of blobs (default: 5).
    ///   - smoothness: Blend smoothness (default: 0.5).
    ///   - scale: Overall scale (default: 1.0).
    ///   - moveSpeed: Animation speed (default: 1.0).
    ///   - hue: Primary hue 0-1 (default: 0.6).
    public init(
        time: Double,
        blobCount: Int = 5,
        smoothness: Double = 0.5,
        scale: Double = 1.0,
        moveSpeed: Double = 1.0,
        hue: Double = 0.6
    ) {
        self.time = time
        self.blobCount = min(max(blobCount, 2), 10)
        self.smoothness = smoothness
        self.scale = scale
        self.moveSpeed = moveSpeed
        self.hue = hue
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.metaballs(
                .float(time),
                .float(Double(blobCount)),
                .float(smoothness),
                .float(scale),
                .float(moveSpeed),
                .float(hue)
            )
        )
    }
}

// MARK: - SDFShapesModifier

/// Renders geometric SDF primitives with boolean operations.
///
/// Signed Distance Functions allow combining simple shapes using
/// union, subtraction, and intersection operations.
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .modifier(SDFShapesModifier(
///         time: animationTime,
///         operation: .subtraction
///     ))
/// ```
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct SDFShapesModifier: ViewModifier {
    
    // MARK: - Types
    
    /// Boolean operation type for combining shapes.
    public enum Operation: Int {
        /// Combines all shapes into one.
        case union = 0
        /// Subtracts secondary shapes from primary.
        case subtraction = 1
        /// Shows only intersecting regions.
        case intersection = 2
        /// Smooth blending union.
        case smoothUnion = 3
    }
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Boolean operation type.
    public var operation: Operation
    
    /// Rotation speed around Y axis.
    public var rotationSpeed: Double
    
    /// Smooth operation blend factor.
    public var smoothFactor: Double
    
    /// Primary shape scale.
    public var shapeScale: Double
    
    // MARK: - Initialization
    
    /// Creates an SDF shapes modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - operation: Boolean operation (default: .smoothUnion).
    ///   - rotationSpeed: Rotation speed (default: 0.5).
    ///   - smoothFactor: Smooth blend amount (default: 0.2).
    ///   - shapeScale: Overall scale (default: 0.5).
    public init(
        time: Double,
        operation: Operation = .smoothUnion,
        rotationSpeed: Double = 0.5,
        smoothFactor: Double = 0.2,
        shapeScale: Double = 0.5
    ) {
        self.time = time
        self.operation = operation
        self.rotationSpeed = rotationSpeed
        self.smoothFactor = smoothFactor
        self.shapeScale = shapeScale
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.sdfShapes(
                .float(time),
                .float(Double(operation.rawValue)),
                .float(rotationSpeed),
                .float(smoothFactor),
                .float(shapeScale)
            )
        )
    }
}

// MARK: - InfiniteGridModifier

/// Creates an infinite procedural grid using raymarching.
///
/// Renders an endless grid pattern with perspective, useful for
/// retro-style backgrounds and sci-fi scenes.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct InfiniteGridModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time for grid movement.
    public var time: Double
    
    /// Grid cell size.
    public var gridSize: Double
    
    /// Forward movement speed.
    public var moveSpeed: Double
    
    /// Grid line thickness.
    public var lineWidth: Double
    
    /// Horizon fog distance.
    public var fogDistance: Double
    
    /// Grid line color hue.
    public var hue: Double
    
    // MARK: - Initialization
    
    /// Creates an infinite grid modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - gridSize: Cell size (default: 1.0).
    ///   - moveSpeed: Forward speed (default: 2.0).
    ///   - lineWidth: Line thickness (default: 0.02).
    ///   - fogDistance: Fog distance (default: 20.0).
    ///   - hue: Line color hue (default: 0.5).
    public init(
        time: Double,
        gridSize: Double = 1.0,
        moveSpeed: Double = 2.0,
        lineWidth: Double = 0.02,
        fogDistance: Double = 20.0,
        hue: Double = 0.5
    ) {
        self.time = time
        self.gridSize = gridSize
        self.moveSpeed = moveSpeed
        self.lineWidth = lineWidth
        self.fogDistance = fogDistance
        self.hue = hue
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.infiniteGrid(
                .float(time),
                .float(gridSize),
                .float(moveSpeed),
                .float(lineWidth),
                .float(fogDistance),
                .float(hue)
            )
        )
    }
}

// MARK: - TunnelModifier

/// Creates an infinite tunnel effect using raymarching.
///
/// Renders a procedural tunnel with configurable shape and texturing,
/// perfect for music visualizers and hypnotic effects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct TunnelModifier: ViewModifier {
    
    // MARK: - Types
    
    /// Tunnel cross-section shape.
    public enum TunnelShape: Int {
        /// Circular tunnel.
        case circular = 0
        /// Square tunnel.
        case square = 1
        /// Hexagonal tunnel.
        case hexagonal = 2
        /// Star-shaped tunnel.
        case star = 3
    }
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Tunnel cross-section shape.
    public var shape: TunnelShape
    
    /// Forward travel speed.
    public var speed: Double
    
    /// Tunnel radius.
    public var radius: Double
    
    /// Wall pattern frequency.
    public var patternFrequency: Double
    
    /// Twist amount per unit distance.
    public var twist: Double
    
    // MARK: - Initialization
    
    /// Creates a tunnel modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - shape: Tunnel shape (default: .circular).
    ///   - speed: Forward speed (default: 2.0).
    ///   - radius: Tunnel radius (default: 1.0).
    ///   - patternFrequency: Pattern frequency (default: 8.0).
    ///   - twist: Twist amount (default: 0.5).
    public init(
        time: Double,
        shape: TunnelShape = .circular,
        speed: Double = 2.0,
        radius: Double = 1.0,
        patternFrequency: Double = 8.0,
        twist: Double = 0.5
    ) {
        self.time = time
        self.shape = shape
        self.speed = speed
        self.radius = radius
        self.patternFrequency = patternFrequency
        self.twist = twist
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.tunnel(
                .float(time),
                .float(Double(shape.rawValue)),
                .float(speed),
                .float(radius),
                .float(patternFrequency),
                .float(twist)
            )
        )
    }
}

// MARK: - CloudsVolumetricModifier

/// Creates volumetric cloud effects using raymarching.
///
/// Renders realistic 3D cloud formations with proper light scattering
/// and density variations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct CloudsVolumetricModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Cloud density.
    public var density: Double
    
    /// Cloud coverage amount.
    public var coverage: Double
    
    /// Wind speed for cloud movement.
    public var windSpeed: Double
    
    /// Light direction angle.
    public var lightAngle: Double
    
    /// Cloud detail level.
    public var detail: Double
    
    // MARK: - Initialization
    
    /// Creates a volumetric clouds modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - density: Cloud density (default: 0.5).
    ///   - coverage: Cloud coverage (default: 0.5).
    ///   - windSpeed: Wind speed (default: 0.1).
    ///   - lightAngle: Light angle in radians (default: 0.7).
    ///   - detail: Detail level 1-5 (default: 3.0).
    public init(
        time: Double,
        density: Double = 0.5,
        coverage: Double = 0.5,
        windSpeed: Double = 0.1,
        lightAngle: Double = 0.7,
        detail: Double = 3.0
    ) {
        self.time = time
        self.density = density
        self.coverage = coverage
        self.windSpeed = windSpeed
        self.lightAngle = lightAngle
        self.detail = detail
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.cloudsVolumetric(
                .float(time),
                .float(density),
                .float(coverage),
                .float(windSpeed),
                .float(lightAngle),
                .float(detail)
            )
        )
    }
}

// MARK: - FractalTerrainModifier

/// Creates procedural fractal terrain using raymarching.
///
/// Renders mountainous terrain with configurable height and detail,
/// suitable for landscape visualizations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct FractalTerrainModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Maximum terrain height.
    public var height: Double
    
    /// Terrain detail octaves.
    public var octaves: Int
    
    /// Camera height above terrain.
    public var cameraHeight: Double
    
    /// Forward movement speed.
    public var moveSpeed: Double
    
    /// Snow line altitude.
    public var snowLine: Double
    
    // MARK: - Initialization
    
    /// Creates a fractal terrain modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - height: Terrain height (default: 0.5).
    ///   - octaves: Detail octaves (default: 6).
    ///   - cameraHeight: Camera height (default: 0.3).
    ///   - moveSpeed: Forward speed (default: 0.5).
    ///   - snowLine: Snow altitude (default: 0.4).
    public init(
        time: Double,
        height: Double = 0.5,
        octaves: Int = 6,
        cameraHeight: Double = 0.3,
        moveSpeed: Double = 0.5,
        snowLine: Double = 0.4
    ) {
        self.time = time
        self.height = height
        self.octaves = min(max(octaves, 2), 10)
        self.cameraHeight = cameraHeight
        self.moveSpeed = moveSpeed
        self.snowLine = snowLine
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.fractalTerrain(
                .float(time),
                .float(height),
                .float(Double(octaves)),
                .float(cameraHeight),
                .float(moveSpeed),
                .float(snowLine)
            )
        )
    }
}

// MARK: - BlackHoleModifier

/// Creates a gravitational lensing black hole effect.
///
/// Simulates the visual distortion caused by extreme gravity,
/// including accretion disk and event horizon.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public struct BlackHoleModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Animation time.
    public var time: Double
    
    /// Black hole mass affecting lensing strength.
    public var mass: Double
    
    /// Accretion disk brightness.
    public var diskBrightness: Double
    
    /// Disk rotation speed.
    public var diskSpeed: Double
    
    /// Star field density.
    public var starDensity: Double
    
    // MARK: - Initialization
    
    /// Creates a black hole modifier.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - mass: Black hole mass (default: 1.0).
    ///   - diskBrightness: Disk brightness (default: 1.0).
    ///   - diskSpeed: Disk rotation speed (default: 0.5).
    ///   - starDensity: Background star density (default: 100.0).
    public init(
        time: Double,
        mass: Double = 1.0,
        diskBrightness: Double = 1.0,
        diskSpeed: Double = 0.5,
        starDensity: Double = 100.0
    ) {
        self.time = time
        self.mass = mass
        self.diskBrightness = diskBrightness
        self.diskSpeed = diskSpeed
        self.starDensity = starDensity
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content.colorEffect(
            ShaderLibrary.blackHole(
                .float(time),
                .float(mass),
                .float(diskBrightness),
                .float(diskSpeed),
                .float(starDensity)
            )
        )
    }
}

// MARK: - View Extension

@available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
public extension View {
    
    /// Applies basic raymarching scene effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - cameraDistance: Camera distance from center.
    ///   - rotationSpeed: Auto-rotation speed.
    /// - Returns: Modified view with raymarching effect.
    func raymarching(
        time: Double,
        cameraDistance: Double = 3.0,
        rotationSpeed: Double = 0.3
    ) -> some View {
        modifier(RaymarchingModifier(
            time: time,
            cameraDistance: cameraDistance,
            rotationSpeed: rotationSpeed
        ))
    }
    
    /// Applies metaballs effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - blobCount: Number of blobs.
    ///   - smoothness: Blend smoothness.
    /// - Returns: Modified view with metaballs effect.
    func metaballs(
        time: Double,
        blobCount: Int = 5,
        smoothness: Double = 0.5
    ) -> some View {
        modifier(MetaballsModifier(
            time: time,
            blobCount: blobCount,
            smoothness: smoothness
        ))
    }
    
    /// Applies SDF shapes effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - operation: Boolean operation type.
    /// - Returns: Modified view with SDF shapes effect.
    func sdfShapes(
        time: Double,
        operation: SDFShapesModifier.Operation = .smoothUnion
    ) -> some View {
        modifier(SDFShapesModifier(
            time: time,
            operation: operation
        ))
    }
    
    /// Applies infinite grid effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - gridSize: Grid cell size.
    ///   - moveSpeed: Forward movement speed.
    /// - Returns: Modified view with infinite grid effect.
    func infiniteGrid(
        time: Double,
        gridSize: Double = 1.0,
        moveSpeed: Double = 2.0
    ) -> some View {
        modifier(InfiniteGridModifier(
            time: time,
            gridSize: gridSize,
            moveSpeed: moveSpeed
        ))
    }
    
    /// Applies tunnel effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - shape: Tunnel cross-section shape.
    ///   - speed: Forward travel speed.
    /// - Returns: Modified view with tunnel effect.
    func tunnel(
        time: Double,
        shape: TunnelModifier.TunnelShape = .circular,
        speed: Double = 2.0
    ) -> some View {
        modifier(TunnelModifier(
            time: time,
            shape: shape,
            speed: speed
        ))
    }
    
    /// Applies volumetric clouds effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - density: Cloud density.
    ///   - coverage: Cloud coverage amount.
    /// - Returns: Modified view with volumetric clouds effect.
    func volumetricClouds(
        time: Double,
        density: Double = 0.5,
        coverage: Double = 0.5
    ) -> some View {
        modifier(CloudsVolumetricModifier(
            time: time,
            density: density,
            coverage: coverage
        ))
    }
    
    /// Applies fractal terrain effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - height: Terrain height.
    ///   - octaves: Detail level.
    /// - Returns: Modified view with fractal terrain effect.
    func fractalTerrain(
        time: Double,
        height: Double = 0.5,
        octaves: Int = 6
    ) -> some View {
        modifier(FractalTerrainModifier(
            time: time,
            height: height,
            octaves: octaves
        ))
    }
    
    /// Applies black hole effect.
    /// - Parameters:
    ///   - time: Animation time.
    ///   - mass: Black hole mass.
    ///   - diskBrightness: Accretion disk brightness.
    /// - Returns: Modified view with black hole effect.
    func blackHole(
        time: Double,
        mass: Double = 1.0,
        diskBrightness: Double = 1.0
    ) -> some View {
        modifier(BlackHoleModifier(
            time: time,
            mass: mass,
            diskBrightness: diskBrightness
        ))
    }
}

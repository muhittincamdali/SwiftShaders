// Mosaic Effect Modifier
// SwiftUI wrapper for mosaic and tile shader effects
// Author: Muhittin Camdali
// License: MIT

import SwiftUI

// MARK: - Mosaic Configuration

/// Mosaic tile pattern types
public enum MosaicPattern: String, CaseIterable, Sendable {
    case square      // Regular square tiles
    case hexagon     // Honeycomb pattern
    case voronoi     // Stained glass (organic)
    case brick       // Brick pattern
    case diamond     // Diamond/45° rotated squares
    case circular    // Radial segments
}

/// Mosaic shader configuration
public struct MosaicConfiguration: Sendable {
    /// Tile size in points
    public var tileSize: Float
    
    /// Grout/border width
    public var groutWidth: Float
    
    /// Grout color
    public var groutColor: Color
    
    /// Randomness for Voronoi (0.0-1.0)
    public var randomness: Float
    
    /// Brick dimensions
    public var brickWidth: Float
    public var brickHeight: Float
    
    public init(
        tileSize: Float = 20.0,
        groutWidth: Float = 2.0,
        groutColor: Color = .black,
        randomness: Float = 1.0,
        brickWidth: Float = 40.0,
        brickHeight: Float = 20.0
    ) {
        self.tileSize = tileSize
        self.groutWidth = groutWidth
        self.groutColor = groutColor
        self.randomness = randomness
        self.brickWidth = brickWidth
        self.brickHeight = brickHeight
    }
    
    // Presets
    public static let small = MosaicConfiguration(tileSize: 10.0, groutWidth: 1.0)
    public static let medium = MosaicConfiguration(tileSize: 20.0, groutWidth: 2.0)
    public static let large = MosaicConfiguration(tileSize: 40.0, groutWidth: 3.0)
    
    public static let stainedGlass = MosaicConfiguration(
        tileSize: 30.0,
        groutWidth: 3.0,
        groutColor: Color(white: 0.2)
    )
    
    public static let pixelArt = MosaicConfiguration(
        tileSize: 8.0,
        groutWidth: 0.0
    )
}

// MARK: - Helper

private func colorToFloat3(_ color: Color) -> (Float, Float, Float) {
    let resolved = color.resolve(in: EnvironmentValues())
    return (resolved.red, resolved.green, resolved.blue)
}

// MARK: - View Modifiers

/// Square tile mosaic
public struct MosaicSquareModifier: ViewModifier {
    let configuration: MosaicConfiguration
    
    public init(configuration: MosaicConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.groutColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.mosaicSquare(
                        .float2(proxy.size),
                        .float(configuration.tileSize),
                        .float(configuration.groutWidth),
                        .float3(r, g, b)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.tileSize,
                        height: configuration.tileSize
                    )
                )
            }
    }
}

/// Hexagonal mosaic
public struct MosaicHexagonModifier: ViewModifier {
    let configuration: MosaicConfiguration
    
    public init(configuration: MosaicConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.groutColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.mosaicHexagon(
                        .float2(proxy.size),
                        .float(configuration.tileSize),
                        .float(configuration.groutWidth),
                        .float3(r, g, b)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.tileSize * 2,
                        height: configuration.tileSize * 2
                    )
                )
            }
    }
}

/// Voronoi/stained glass mosaic
public struct MosaicVoronoiModifier: ViewModifier {
    let configuration: MosaicConfiguration
    
    public init(configuration: MosaicConfiguration = .stainedGlass) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.groutColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.mosaicVoronoi(
                        .float2(proxy.size),
                        .float(configuration.tileSize),
                        .float(configuration.groutWidth),
                        .float3(r, g, b),
                        .float(configuration.randomness)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.tileSize * 2,
                        height: configuration.tileSize * 2
                    )
                )
            }
    }
}

/// Brick pattern mosaic
public struct MosaicBrickModifier: ViewModifier {
    let configuration: MosaicConfiguration
    
    public init(configuration: MosaicConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.groutColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.mosaicBrick(
                        .float2(proxy.size),
                        .float(configuration.brickWidth),
                        .float(configuration.brickHeight),
                        .float(configuration.groutWidth),
                        .float3(r, g, b)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.brickWidth,
                        height: configuration.brickHeight
                    )
                )
            }
    }
}

/// Diamond pattern mosaic
public struct MosaicDiamondModifier: ViewModifier {
    let configuration: MosaicConfiguration
    
    public init(configuration: MosaicConfiguration = .medium) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        let (r, g, b) = colorToFloat3(configuration.groutColor)
        
        return content
            .visualEffect { view, proxy in
                view.layerEffect(
                    ShaderLibrary.mosaicDiamond(
                        .float2(proxy.size),
                        .float(configuration.tileSize),
                        .float(configuration.groutWidth),
                        .float3(r, g, b)
                    ),
                    maxSampleOffset: CGSize(
                        width: configuration.tileSize * 2,
                        height: configuration.tileSize * 2
                    )
                )
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies square tile mosaic
    func mosaicSquare(
        tileSize: Float = 20.0,
        groutWidth: Float = 2.0,
        groutColor: Color = .black
    ) -> some View {
        modifier(MosaicSquareModifier(configuration: MosaicConfiguration(
            tileSize: tileSize,
            groutWidth: groutWidth,
            groutColor: groutColor
        )))
    }
    
    /// Applies hexagonal mosaic
    func mosaicHexagon(
        tileSize: Float = 20.0,
        groutWidth: Float = 2.0
    ) -> some View {
        modifier(MosaicHexagonModifier(configuration: MosaicConfiguration(
            tileSize: tileSize,
            groutWidth: groutWidth
        )))
    }
    
    /// Applies stained glass effect
    func stainedGlass(cellSize: Float = 30.0) -> some View {
        modifier(MosaicVoronoiModifier(configuration: MosaicConfiguration(
            tileSize: cellSize,
            groutWidth: 3.0,
            groutColor: Color(white: 0.15)
        )))
    }
    
    /// Applies brick pattern
    func mosaicBrick(
        brickWidth: Float = 40.0,
        brickHeight: Float = 20.0
    ) -> some View {
        modifier(MosaicBrickModifier(configuration: MosaicConfiguration(
            brickWidth: brickWidth,
            brickHeight: brickHeight
        )))
    }
    
    /// Applies diamond mosaic
    func mosaicDiamond(tileSize: Float = 20.0) -> some View {
        modifier(MosaicDiamondModifier(configuration: MosaicConfiguration(
            tileSize: tileSize
        )))
    }
    
    /// Applies pixel art style (no grout)
    func pixelArt(pixelSize: Float = 8.0) -> some View {
        modifier(MosaicSquareModifier(configuration: MosaicConfiguration(
            tileSize: pixelSize,
            groutWidth: 0.0
        )))
    }
}

// MARK: - Preview

#if DEBUG
struct MosaicModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange, .yellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 150)
                .mosaicSquare()
            
            Image(systemName: "photo.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 200, height: 150)
                .stainedGlass()
        }
        .padding()
    }
}
#endif

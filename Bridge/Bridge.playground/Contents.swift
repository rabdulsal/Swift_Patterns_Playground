import UIKit
import Foundation

// ******* BRIDGE *********

/*
 A mechanism that decouples an interface (heirachy) from an implementation (heirachy)
 Designed to prevent 'Cartesian product' complexity explosion
 */

protocol BridgeRenderer {
    func renderCircle(_ radius: Float)
}

class BridgeVectorRenderer : BridgeRenderer {
    func renderCircle(_ radius: Float) {
        print("Drawing a circle of radius: \(radius)")
    }
}

class BridgeRasterRenderer : BridgeRenderer {
    func renderCircle(_ radius: Float) {
        print("Drawing pixels for circle of radius: \(radius)")
    }
}

protocol BridgeShape {
    func draw()
    func resize(_ factor: Float)
}

class BridgeCircle : BridgeShape {
    var radius: Float
    var renderer: BridgeRenderer
    
    init(_ renderer: BridgeRenderer, _ radius: Float) {
        self.renderer = renderer
        self.radius = radius
    }
    
    func draw() {
        renderer.renderCircle(radius)
    }
    
    func resize(_ factor: Float) {
        radius *= factor
    }
}

func bridgeMain() {
    let raster = BridgeRasterRenderer()
//    let vector = BridgeVectorRenderer()
    let circle = BridgeCircle(raster, 5)
    circle.draw()
    circle.resize(2)
    circle.draw()
}

//bridgeMain()

// --- TEST ---

protocol BridgeTestRenderer {
    var whatToRenderAs: String { get }
}

class BridgeTestShape : CustomStringConvertible
{
    var name: String
    var renderer: BridgeTestRenderer
    
    init(_ renderer: BridgeTestRenderer, _ name: String) {
        self.name = name
        self.renderer = renderer
    }
    
    var description: String {
        return "Drawing \(name) as \(renderer.whatToRenderAs)"
    }
}

class BridgeTestTriangle : BridgeTestShape
{
    override init(_ renderer: BridgeTestRenderer, _ name: String = "Triangle") {
        super.init(renderer, name)
    }
}

class BridgeTestSquare : BridgeTestShape
{
    override init(_ renderer: BridgeTestRenderer, _ name: String = "Square")
    {
        super.init(renderer, name)
    }
}

class BridgeTestVectorRenderer : BridgeTestRenderer {
    var whatToRenderAs: String {
        return "lines"
    }
}

class BridgeTestRasterRenderer : BridgeTestRenderer {
    var whatToRenderAs: String {
        return "pixels"
    }
}

/*
 Want to avoid doing 'VectorTriangle', 'RasterTriangle' etc. here
 BridgeTestSquare(BridgeTestVectorRenderer()).description ~> Should return "Drawing Triangle as pixels"
 */

func bridgeTestMain() {
    let triangleDesc = BridgeTestTriangle(BridgeTestRasterRenderer()).description
    let squareDescr = BridgeTestSquare(BridgeTestVectorRenderer()).description
    print(triangleDesc)
    print(squareDescr)
}

//bridgeTestMain()
// ******* END BRIDGE *******

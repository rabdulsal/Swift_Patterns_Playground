import UIKit
import Foundation

// ********** ADAPTER *********

// DEFINITION: A construct which adapts an existing interface X to conform to the required interface Y.

class AdapterPoint : CustomStringConvertible, Hashable
{
    var x = 0
    var y = 0
    
    var description: String {
        return "X: \(x) Y: \(y)"
    }
    
    init() {}
    
    init(_ x: Int, _ y: Int)
    {
        self.x = x
        self.y = y
    }
    
    var hashValue: Int {
        return (x * 397)^y
    }
    
    static func == (lhs: AdapterPoint, rhs: AdapterPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class AdapterLine : CustomStringConvertible, Hashable
{
    var start = AdapterPoint()
    var end = AdapterPoint()
    
    var description: String {
        return "Start: \(start.description), End: \(end.description)"
    }
    
    init(_ start: AdapterPoint, _ end: AdapterPoint)
    {
        self.start = start
        self.end = end
    }
    
    var hashValue: Int {
        return (start.hashValue * 397) ^ end.hashValue
    }
    
    static func == (lhs: AdapterLine, rhs: AdapterLine) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

class VectorObject : Sequence {
    var lines = [AdapterLine]()
    
    func makeIterator() -> IndexingIterator<Array<AdapterLine>> {
        
        return IndexingIterator(_elements: lines)
    }
}

class VectorRectangle : VectorObject {
    init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        super.init()
        lines.append(AdapterLine(AdapterPoint(x,y), AdapterPoint(x+width, y)))
        lines.append(AdapterLine(AdapterPoint(x+width,y), AdapterPoint(x+width,y+height)))
        lines.append(AdapterLine(AdapterPoint(x,y), AdapterPoint(x,y+height)))
        lines.append(AdapterLine(AdapterPoint(x,y+height), AdapterPoint(x+width,y+height)))
    }
}

class LineToPointAdapter : Sequence {
    private static var count = 0
    var hash: Int
    static var cache = [Int: [AdapterPoint]]()
    
    init(_ line: AdapterLine) {
        hash = line.hashValue
        if type(of:self).cache[hash] != nil { return }
    }
    
    func makeIterator() -> IndexingIterator<Array<AdapterPoint>> {
        return IndexingIterator(_elements: type(of: self).cache[hash]!)
    }
}

func drawPoint(_ p: AdapterPoint) {
    print(".", terminator: "")
}

let vectorObjects = [
    VectorRectangle(1,1,10,10),
    VectorRectangle(3,3,6,6)
]

func draw() {
//    for vo in vectorObjects {
////        var line in vo {
////            let adapter = LineToPointAdapter(line)
////            adapter.forEach{ drawPoint($0) }
////        }
//    }
}

// --- TEST ---
// INCOMPLETE!!!
func adapterTestMain() {
    
}

//adapterTestMain()

// ********* END ADAPTER **********

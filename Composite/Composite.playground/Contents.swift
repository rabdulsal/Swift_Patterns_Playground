import UIKit
import Foundation

// ******** COMPOSITE **********

// DEFINITION: A mechanism for treating individual (scalar) objects and compositions of objects in a uniform manner

class CompGraphicObject: CustomStringConvertible {
    var name: String = "Group"
    var color: String = ""
    var children = [CompGraphicObject]()
    
    private func print(_ buffer: inout String, _ depth: Int) {
        buffer.append(String(repeating: "*", count: depth))
        buffer.append(color.isEmpty ? "" : "\(color) ")
        buffer.append("\(name)\n")
        
            for child in children {
            child.print(&buffer, depth+1)
        }
    }
    
    var description: String {
        var buffer = ""
        print(&buffer, 0)
        return buffer
    }
    
    init() {}
    init(name: String) { self.name = name }
    
}

class CompSquare : CompGraphicObject {
    init(_ color: String) {
        super.init(name: "Square")
        self.color = color
    }
}

class CompCircle : CompGraphicObject {
    init(_ color: String) {
        super.init(name: "Circle")
        self.color = color
    }
}

func compMain() {
    let drawing = CompGraphicObject(name: "My Drawing")
    drawing.children.append(CompSquare("Red"))
    drawing.children.append(CompCircle("Blue"))
    
    let group = CompGraphicObject()
    group.children.append(CompCircle("Green"))
    group.children.append(CompSquare("Purple"))
    
    drawing.children.append(group)
    
    print(drawing)
}

//compMain()

// ~~~~~~~~~~~~

class CompNeuron : Sequence {
    var inputs = [CompNeuron]()
    var outputs = [CompNeuron]()
    
    func makeIterator() -> IndexingIterator<Array<CompNeuron>> {
        return IndexingIterator(_elements: [self])
    }
}

class CompNeuronLayer : Sequence {
    private var neurons: [CompNeuron]
    
    init(_ count: Int) {
        neurons = [CompNeuron](repeating: CompNeuron(), count: count)
    }
    
    func makeIterator() -> IndexingIterator<Array<CompNeuron>> {
        return IndexingIterator(_elements: neurons)
    }
}

extension Sequence {
    func connect<Seq: Sequence>(to other: Seq)
    where Seq.Iterator.Element == CompNeuron,
    Self.Iterator.Element == CompNeuron {
        for from in self {
            for to in other {
                from.outputs.append(to)
                to.outputs.append(from)
            }
        }
    }
}

func neuronMain() {
    let neuron1 = CompNeuron()
    let neuron2 = CompNeuron()
    let layer1 = CompNeuronLayer(10)
    let layer2 = CompNeuronLayer(20)
    
    neuron1.connect(to: neuron2)
    neuron1.connect(to: layer1)
    layer1.connect(to: neuron1)
    layer2.connect(to: layer2)
}

//neuronMain()


// ------- TEST --------
// INCOMPLETE!!!

/*
 Composite Coding Exercise
 Consider the code presented below. The sum()  extension method adds up all the values in a list of Sequence -conforming elements it gets passed. We can have a single value or a set of values, all of them get added up together.
 
 Please complete the implementation of the extension so that sum()  begins to work correctly.
 
 Here is an example of how the extension method might be used:
 
 let singleValue = SingleValue(1)
 let manyValues = ManyValues()
 manyValues.add(2)
 manyValues.add(3)
 let s = [AnySequence(singleValue), AnySequence(manyValues)].sum() // s = 6
 
 */
struct Test {
    class SingleValue : Sequence
    {
        var value = 0
        
        init() {}
        init(_ value: Int)
        {
            self.value = value
        }
        
        func makeIterator() -> IndexingIterator<Array<Int>>
        {
            return IndexingIterator(_elements: [value])
        }
    }

    class ManyValues : Sequence
    {
        var values = [Int]()
        
        func makeIterator() -> IndexingIterator<Array<Int>>
        {
            return IndexingIterator(_elements: values)
        }
        
        func add(_ value: Int)
        {
            values.append(value)
        }
    }
    
    static func main() {
        let singleValue = SingleValue()
        let manyValues = ManyValues()
        manyValues.add(2)
        manyValues.add(3)
        //    let s = [AnySequence(singleValue), AnySequence(manyValues)].sum() // s = 6
    }
}

extension Sequence where Self.Iterator.Element == Int
{
    func sum() -> Int
    {
        var counter = 0
        for e in self {
            counter += e
        }
        return counter
    }
}

//Test.main()

// ******** END COMPOSITE *********

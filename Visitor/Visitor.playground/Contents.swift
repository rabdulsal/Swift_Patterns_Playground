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

func runTestComp() {
    let singleValue = SingleValue()
    let manyValues = ManyValues()
    manyValues.add(2)
    manyValues.add(3)
//    let s = [AnySequence(singleValue), AnySequence(manyValues)].sum() // s = 6
}

//runTestComp()

// ******** END COMPOSITE *********

// ********* DECORATOR **********

// DEFINITION: Facilitates the addition of behaviors to individual objects w/out inheriting from them

// ~~~~ Protocols
protocol ICanFly {
    func fly()
}

protocol ICanCrawl {
    func crawl()
}

protocol Shape1 : CustomStringConvertible {
    init()
    var description: String { get }
}

protocol Shape2 : CustomStringConvertible {
    var description: String { get }
}

struct Decorator {
    class DecCodeBuilder : CustomStringConvertible {
        private var buffer: String = ""
        
        init() {    }
        init(_ buffer: String) {
            self.buffer = buffer
        }
        
        var description: String {
            return buffer
        }
        
        func append(_ s: String) -> DecCodeBuilder {
            buffer.append(s)
            return self
        }
        
        func appendLine(_ s: String) -> DecCodeBuilder {
            buffer.append("\(s)\n")
            return self
        }
        
        static func +=(cb: inout DecCodeBuilder, s: String) {
            cb.buffer.append(s)
        }
    }

    func stringMain() {
        var cb = DecCodeBuilder()
        
        cb.appendLine("class Foo")
            .appendLine("{")
        
        cb += " // testing!\n"
        
        cb.appendLine("}")
        
        print(cb)
    }

    //stringMain()

    class Bird : ICanFly {
        func fly(){}
    }

    class Lizard : ICanCrawl {
        func crawl(){}
    }

    class Dragon : ICanCrawl, ICanFly {
        func fly() {
            //
        }
        
        func crawl() {
            //
        }
    }

    // ~~~~ Shapes


    class DecCircle : Shape2 {
        private var radius: Float = 0
        
        init(_ radius: Float) {
            self.radius = radius
        }
        
        func resize(_ factor: Float) {
            radius *= factor
        }
        
        var description: String {
            return "A circle of radius \(radius)"
        }
    }

    class DecSquare : Shape2 {
        private var side: Float = 0
        
        init(_ side: Float) {
            self.side = side
        }
        
        var description: String {
            return "A square with side \(side)"
        }
    }

    class DecColoredShape : Shape2 {
        var shape: Shape2
        var color: String
        
        init(_ shape: Shape2, _ color: String) {
            self.shape = shape
            self.color = color
        }
        
        var description: String {
            return "\(shape) has color \(color)"
        }
    }

    class TransparentShape: Shape2 {
        var shape: Shape2
        var transparency: Float
        init(_ shape: Shape2, _ transparency: Float) {
            self.shape = shape
            self.transparency = transparency
        }
        
        var description: String {
            return "\(shape) with transparency \(transparency*100)%"
        }
    }

    func decMain() {
        let square = DecSquare(1.23)
        let redSquare = DecColoredShape(square, "red")
        let transShape = TransparentShape(redSquare, 0.4)
        print(square)
        print(redSquare)
        print(transShape)
    }

    //decMain()

    // ~~~~ Static

    

    class StatDecCircle : Shape2 {
        private var radius: Float = 0
        
        required init() {}
        init(_ radius: Float) {
            self.radius = radius
        }
        
        func resize(_ factor: Float) {
            radius *= factor
        }
        
        var description: String {
            return "A circle of radius \(radius)"
        }
    }

    class StatDecSquare : Shape2 {
        private var side: Float = 0
        required init() {}
        init(_ side: Float) {
            self.side = side
        }
        
        var description: String {
            return "A square with side \(side)"
        }
    }

    class StatDecColoredShape<T> : Shape1 where T: Shape1 {
        private var color = "black"
        private var shape: T = T()
        required init() {}
        init(_ color: String) {
            self.color = color
        }
        
        var description: String {
            return "\(shape) has color \(color)"
        }
    }

    class StatTransparentShape<T>: Shape1 where T: Shape1 {
        private var shape: T = T()
        private var transparency: Float = 0
        required init() {}
        init(_ transparency: Float) {
            self.transparency = transparency
        }
        
        var description: String {
            return "\(shape) with transparency \(transparency*100)%"
        }
    }


    func staticMain() {
//        let blueCircle = StatDecColoredShape<StatDecCircle>("blue")
//        print(blueCircle)
//
//        let blackHalfSquare = StatTransparentShape<StatDecColoredShape<StatDecSquare>>(0.5)
//        print(blackHalfSquare)
    }

    // --- TEST ---
    // INCOMPLETE!!!
    struct Test {
        class DecTestBird
        {
            var age = 0
            
            func fly() -> String
            {
                return (age < 10) ? "flying" : "too old"
            }
        }

        class DecTestLizard
        {
            var age = 0
            
            func crawl() -> String
            {
                return (age > 1) ? "crawling" : "too young"
            }
        }

        class DecTestDragon
        {
            // todo: reuse bird/lizard functionality here
            
            var age: Int { return 0 /* todo */ }
            func fly() -> String { return "" /* todo */ }
            func crawl() -> String { return "" /* todo */ }
        }
        
        static func main() {
            
        }
    }
}
//Decorator().staticMain()
//Decorator.Test.main()
// ******** END DECORATOR *********

// ********** FACADE ***********

// DEFINITION: Provides a simple, easy to usnderstand/user interface over a large and sophisticated body of code

struct Facade {
    
    class Buffer {
        var width, height: Int
        var buffer: [Character]
    
        init(_ width: Int, _ height: Int) {
            self.width = width
            self.height = height
            buffer = [Character](repeating: " ", count: width*height )
        }
    
        subscript(_ index: Int) -> Character {
            return buffer[index]
        }
    }

    class Viewport {
        var buffer: Buffer
        var offset = 0
        init(_ buffer: Buffer) {
            self.buffer = buffer
        }
        
        func getCharacterAt(_ index: Int) -> Character {
            return buffer[offset+index]
        }
    }

    class FacadeConsole {
        var buffers = [Buffer]()
        var viewports = [Viewport]()
        var offset = 0
        
        init() {
            let b = Buffer(30,20)
            let v = Viewport(b)
            buffers.append(b)
            viewports.append(v)
        }
        
        func getCharacterAt(_ index: Int) -> Character {
            return viewports[0].getCharacterAt(index)
        }
    }

    func main() {
        let c = FacadeConsole()
        let u = c.getCharacterAt(1)
    }

    // --- TEST --- INCOMPLETE!!!

    class Test {
        
        class Generator
        {
            func generate(_ count: Int) -> [Int]
            {
                var result = [Int]()
                for _ in 1...count
                {
                    result.append(1 + Int(arc4random_uniform(9)))
                }
                return result
            }
        }
        
        class Splitter
        {
            func split(_ array: [[Int]]) -> [[Int]]
            {
                var result = [[Int]]()
                
                let rowCount = array.count
                let colCount = array[0].count
                
                // get the rows
                for r in 0..<rowCount
                {
                    var theRow = [Int]()
                    for c in 0..<colCount
                    {
                        theRow.append(array[r][c])
                    }
                    result.append(theRow)
                }
                
                // get the columns
                for c in 0..<colCount
                {
                    var theCol = [Int]()
                    for r in 0..<rowCount
                    {
                        theCol.append(array[r][c])
                    }
                    result.append(theCol)
                }
                
                // get the diagonals
                var diag1 = [Int]()
                var diag2 = [Int]()
                for c in 0..<colCount
                {
                    for r in 0..<rowCount
                    {
                        if c == r
                        {
                            diag1.append(array[r][c])
                        }
                        let r2 = rowCount - r - 1
                        if c == r2
                        {
                            diag2.append(array[r][c])
                        }
                    }
                }
                
                result.append(diag1)
                result.append(diag2)
                
                return result
            }
        }
        
        class Verifier
        {
            func verify(_ arrays: [[Int]]) -> Bool
            {
                let first = arrays[0].reduce(0, +)
                for arr in 1..<arrays.count
                {
                    if (arrays[arr].reduce(0, +)) != first
                    {
                        return false
                    }
                }
                return true
            }
        }
        
        class MagicSquareGenerator
        {
            let generator = Generator()
            let splitter = Splitter()
            let verifier = Verifier()
            
            func generate(_ size: Int) -> [[Int]]
            {
                let generatedArry = generator.generate(size)
                let splitted = splitter.split([generatedArry])
                let isVerified = verifier.verify(splitted)
                return isVerified ? splitted : [[Int]]()
            }
        }
        
        func main() {
            let msg = MagicSquareGenerator()
            print("Generated: \(msg.generate(2))")
        }
    }
}

Facade.Test().main()


// ******** END FACADE **********

// ******** INTERPRETER *********

// DEFINITION: A component that processes structered text data, doing so by turning it into lexical tokens (lexing), then interpreting sequences of said tokens (parsing)
extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    var isNumber : Bool {
        get {
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

struct Interpreter {
    class Lexing {
        struct Token : CustomStringConvertible {
            
            var description: String {
                return "`\(text)`"
            }
            
            enum TokenType {
                case integer, plus, minus, lparen, rparen
            }
            
            var tokenType: TokenType
            var text: String
            
            init(_ tokenType: TokenType, _ text: String) {
                self.tokenType = tokenType; self.text = text
            }
        }
        
        func lex(_ input: String) -> [Token] {
            var result = [Token]()
            var i = 0
            while i < input.count {
                switch input[i] {
                case "+":
                    result.append(Token(.plus, "+"))
                case "-":
                    result.append(Token(.minus, "-"))
                case "(":
                    result.append(Token(.lparen, "("))
                case ")":
                    result.append(Token(.rparen, ")"))
                default:
                    var s = String(input[i])
                    for j in (i+1)..<input.count {
                        if String(input[j]).isNumber {
                            s.append(input[j])
                            i += 1
                        } else {
                            result.append(Token(.integer, s))
                            break
                        }
                    }
                }
                i += 1
            }
            return result
        }
    }
    
    class Parsing {
        class Integer: Element {
            var value: Int
            init(_ value: Int) {
                self.value = value
            }
        }
        
        class BinaryOperation: Element {
            var opType: OpType
            var left: Element
            var right: Element
            var value: Int {
                switch opType {
                case .addition: return left.value + right.value
                case .subtraction: return left.value - right.value
                }
            }
            enum OpType {
                case addition, subtraction
            }
            
            init(){
                // dummy values
                self.opType = OpType.addition
                self.left = Integer(0)
                self.right = Integer(0)
            }
            
            init(_ left: Element, _ right: Element, _ opType: OpType) {
                self.opType = opType
                self.left = left
                self.right = right
            }
        }
        
        func parse(_ tokens: [Lexing.Token]) -> Element {
            let result = BinaryOperation()
            var haveLHS = false
            
            var i = 0
            while i < tokens.count {
                let token = tokens[i]
                switch token.tokenType {
                case .integer:
                    let integer = Integer(Int(token.text)!)
                    if !haveLHS {
                        result.left = integer
                        haveLHS = true
                    } else {
                        result.right = integer
                    }
                case .plus: result.opType = .addition
                case .minus: result.opType = .subtraction
                case .lparen:
                    var j = i
                    let t = tokens[j]
                    while j < tokens.count {
                        if t.tokenType == Lexing.Token.TokenType.rparen { break }
                        j += 1
                    }
                    // process subexpression w/out opening (
                    let subexpression = tokens[(i+1)..<j]
                    let element = parse(Array(subexpression))
                    if !haveLHS { result.left = element; haveLHS = true }
                    else { result.right = element }
                    i = j // advance
                default: break
                }
                i += 1
            }
            return result
        }
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    struct Test {
        /*
            Interpreter Coding Exercise
            You are asked to write an expression processor for simple numeric expressions with the following constraints:
         
            Expressions use integral values (e.g., '13' ), single-letter variables defined in Variables, as well as + and - operators only
            There is no need to support braces or any other operations
            If a variable is not found in variables  (or if we encounter a variable with >1 letter, e.g. ab), the evaluator returns 0 (zero)
            In case of any parsing failure, evaluator returns 0
            Example:
         
            calculate("1+2+3")  should return 6
            calculate("1+2+xy")  should return 0
            calculate("10-2-x")  when x=3 is in variables should return 5
        */
        
        class ExpressionProcessor
        {
            var variables = [Character:Int]()
            func calculate(_ expression: String) -> Int
            {
                // todo
                return 0
            }
        }
        
        static func main() {
            
            Interpreter.Test.ExpressionProcessor().calculate("1+2+3")  // should return 6
            Interpreter.Test.ExpressionProcessor().calculate("1+2+xy")  // should return 0
            Interpreter.Test.ExpressionProcessor().calculate("10-2-x")  // when x=3 is in variables should return 5
        }
    }
    
    static func main() {
        let input = "(13+4)-(12-1)"
        let tokens = Lexing().lex(input)
        print(tokens)
        
        let parsed = Parsing().parse(tokens)
        print("\(input) = \(parsed.value)")
    }
}

protocol Element {
    var value: Int { get }
}

//Interpreter.main()

// ******* END INTERPRETER ********

// ********** ITERATOR ***********

// DEFINITION: An object (or method) that facilitates the traversal of a data structure.

struct Iterator {
    
    class Node<T> {
        var value: T
        var left: Node<T>? = nil
        var right: Node<T>? = nil
        var parent: Node<T>? = nil
        
        init(_ value: T) {
            self.value = value
        }
        
        init(_ value: T, _ left: Node<T>, _ right: Node<T>) {
            self.value = value
            self.right = right
            self.left = left
            
            left.parent = self
            right.parent = self
        }
    }
    
    class InOrderIterator<T> : IteratorProtocol {
        
        var current: Node<T>?
        var root: Node<T>
        var yieldedStart = false
        
        init(_ root: Node<T>) {
            self.root = root
            current = root
            while current!.left != nil {
                current = current!.left!
            }
        }
    
        func reset() {
            current = root
            yieldedStart = false
        }
        
        func next() -> Node<T>? {
            if !yieldedStart {
                yieldedStart = true
                return current
            }
            
            if current!.right != nil {
                current = current!.right
                while current!.left != nil {
                    current = current!.left
                }
                return current
            } else {
                var p = current!.parent
                while p != nil  && current === p!.right {
                    current = p!
                    p = p!.parent
                }
                current = p
                return current
            }
        }
    }
    
    class BinaryTree<T> : Sequence {
        private let root: Node<T>
        
        init(_ root: Node<T>) {
             self.root = root
        }
        
        func makeIterator() -> InOrderIterator<T> {
            return InOrderIterator<T>(self.root)
        }
        
    }
    
    static func main() {
        let root = Iterator.Node(1, Iterator.Node(2), Iterator.Node(3))
        let it = InOrderIterator(root)
        while let element = it.next() {
            print(element.value, terminator: " ")
        }
        print()
        
        let nodes = AnySequence{InOrderIterator(root)}
        print(nodes.map{ $0.value })
        
        let tree = BinaryTree(root)
        print(tree.map{ $0.value })
    }
    
    // Example 2: - Array-Backed Properties -
    struct Array_Backed {
        
        class Creature : Sequence {
            var stats = [Int](repeating: 0, count: 3)
            
            private let _strength = 0
            private let _agility = 1
            private let _intelligence = 2
            
            var strength: Int {
                get { return stats[_strength] }
                set(value) { stats[_strength] = value }
            }
            
            var agility: Int {
                get { return stats[_agility] }
                set(value) { stats[_agility] = value }
            }
            
            var intelligence: Int {
                get { return stats[_intelligence] }
                set(value) { stats[_intelligence] = value }
            }
            
            var averageStat: Int {
                return stats.reduce(0, +) / stats.count
            }
            
            func makeIterator() -> IndexingIterator<Array<Int>> {
                return IndexingIterator(_elements: stats)
            }
            
            subscript(index: Int) -> Int {
                get { return stats[index] }
                set(value) { stats[index] = value }
            }
        }
        
        static func main() {
            let c = Creature()
            c.strength = 10
            c.agility = 15
            c.intelligence = 11
            
            print(c.averageStat)
            
            for s in c {
                print(s)
            }
        }
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    
    struct Test {
        
        /*
         Given the following definition of a Node<T>, implement 'predorder traversal' that returns a sequence of Ts.
        */
        
        class Node<T>
        {
            let value: T
            var left: Node<T>? = nil
            var right: Node<T>? = nil
            var parent: Node<T>? = nil
            
            init(_ value: T)
            {
                self.value = value
            }
            
            init(_ value: T, _ left: Node<T>, _ right: Node<T>)
            {
                self.value = value
                self.left = left
                self.right = right
                
                // todo: try to guess what's missing here
            }
            
            
//            public var preOrder: [T]
//            {
//                // todo
//            }
        }
        
        static func main() {
            
        }
    }
}

//Iterator.main()
//Iterator.Array_Backed.main()

// ******** END ITERATOR **********

// ******* OBSERVER *******

// DEFINITION: An observer is an object that wishes to be informed about events happening in the system. The entity generating the events is an 'observable'

protocol Observer_Invocable : class {
    func invoke(_ data: Any)
}

protocol Observer_Disposable {
    func dispose()
}

struct Observer {
    
    class Person {
        
        // event
        let fallsIll = Event<String>()
        
        init(){}
        
        func catchCold() {
            fallsIll.raise("123 London Road")
        }
    }
    
    class Demo {
        init() {
            let p = Person()
            let sub = p.fallsIll.addHandler(
                target: self, handler: Demo.callDoctor
            )
            
            p.catchCold()
            
            sub.dispose()
            
            p.catchCold()
        }
        func callDoctor(address: String) {
            print("We need a doctor at \(address)")
        }
    }
    
    static func main() {
        let _ = Demo()
    }
    
    class Event<T> {
        typealias EventHandler = (T) -> ()
        var eventHandlers = [Observer_Invocable]()
        
        func raise(_ data: T) {
            for handler in eventHandlers {
                handler.invoke(data)
            }
        }
        
        func addHandler<U: AnyObject>(
            target: U,
            handler: @escaping (U) -> EventHandler) -> Observer_Disposable {
            let subscription = Subscription(target: target, handler: handler, event: self)
            eventHandlers.append(subscription)
            return subscription
        }
    }
    
    class Subscription<T: AnyObject, U> : Observer_Invocable, Observer_Disposable {
        weak var target: T?
        let handler: (T) -> (U) -> ()
        let event: Event<U>
        
        init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
            self.target = target; self.event = event; self.handler = handler
        }
        
        func invoke(_ data: Any) {
            if let t = target {
                handler(t)(data as! U)
            }
        }
        
        func dispose() {
            event.eventHandlers = event.eventHandlers.filter
                { $0 as AnyObject? !== self }
        }
    }
    
    // --- Example 2 ---
    
    struct PropertyObserver {
        
        class Person {
            var age: Int = 0 {
                willSet(newValue) {
                    print("About to set age to \(newValue)")
                }
                didSet {
                    print("we just changed age from \(oldValue) to \(age)")
                }
            }
        }
        
        class Demo {
            
            init(){
                let p = Person()
                p.age = 20
                p.age = 22
            }
        }
        
        static func main() {
            let _ = Demo()
        }
    }
    
    struct DependentPropertyObserver {
        
        class Person {
            private var oldCanVote = false
            var age: Int = 0 {
                willSet(newValue) {
                    print("About to set age to \(newValue)")
                    oldCanVote = canVote
                }
                didSet {
                    print("we just changed age from \(oldValue) to \(age)")
                    
                    if age != oldValue {
                        propertyChanged.raise(("age", age))
                    }
                    if canVote != oldCanVote {
                        propertyChanged.raise(("canVote", canVote))
                    }
                }
            }
            
            var canVote : Bool {
                return age >= 16
            }
            
            let propertyChanged = Event<(String, Any)>()
        }
        
        class Person2 {
            private var _age: Int = 0
            
            var age: Int {
                get { return _age }
                set(value) {
                    if _age == value { return }
                    
                    // cache
                    let oldCanvote = canVote
                    
                    let cancelSet = RefBool(false)
                    propertyChanging.raise(("age", value, cancelSet))
                    if cancelSet.value { return }
                    
                    // assigne & notify
                    _age = value
                    propertyChanged.raise(("age", _age))
                    if oldCanvote != canVote { propertyChanged.raise(("canVote",canVote)) }
                }
            }
            
            var canVote: Bool { return age >= 16 }
            
            let propertyChanged = Event<(String, Any)>()
            let propertyChanging = Event<(String, Any, RefBool)>()
        }
        
        final class RefBool {
            var value: Bool
            init(_ value: Bool) {
                self.value = value
            }
        }
        
        class Demo {
            
            init(){
                let p = Person2()
                p.propertyChanged.addHandler(target: self, handler: Demo.propChanged)
                p.propertyChanging.addHandler(target: self, handler: Demo.propChanging)
                p.age = 20
                p.age = 22
                
                p.age = 12
            }
            
            func propChanged(args: (String, Any)) {
                var prependedString = ""
                switch args.0 {
                case "age": prependedString = "Person's age"
                case "canVote": prependedString = "Voting status"
                default: break
                }
                print("\(prependedString) has changed to \(args.1)")
            }
            
            func propChanging(args: (String, Any, RefBool)) {
                if args.0 == "age" && (args.1 as! Int) < 14 {
                    print("Cannot allow setting age < 14")
                    args.2.value = true
                }
            }
        }
        
        static func main() {
            let _ = Demo()
        }
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    struct Test {
        
        /*
         Observer Coding Exercise
         Imagine a game where one or more rats can attack a player. Each individual rat has an attack  value of 1. However, rats attack as a swarm, so each rat's attack  value is equal to the total number of rats in play.
         
         Given that a rat enters play through the constructor and leaves play (dies) via its kill()  method (rat murder is satisfying!), please implement the Game  and Rat  classes so that, at any point in the game, the attack  value of a rat is always consistent.
         
         This exercise has two simple rules:
         
         The Game class cannot contain properties. It can only contain events and methods.
         The Rat class' attack property is strictly defined as var attack = 1 , i.e. it doesn't have a custom getter or setter.
        */
        
        class Event<T> {
            typealias EventHandler = (T) -> ()
            var eventHandlers = [Observer_Invocable]()
            
            func raise(_ data: T) {
                for handler in eventHandlers {
                    handler.invoke(data)
                }
            }
            
            func addHandler<U: AnyObject>(
                target: U,
                handler: @escaping (U) -> EventHandler) -> Observer_Disposable {
                let subscription = Subscription(target: target, handler: handler, event: self)
                eventHandlers.append(subscription)
                return subscription
            }
        }
        
        class Subscription<T: AnyObject, U> : Observer_Invocable, Observer_Disposable {
            weak var target: T?
            let handler: (T) -> (U) -> ()
            let event: Event<U>
            
            init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
                self.target = target; self.event = event; self.handler = handler
            }
            
            func invoke(_ data: Any) {
                if let t = target {
                    handler(t)(data as! U)
                }
            }
            
            func dispose() {
                event.eventHandlers = event.eventHandlers.filter
                    { $0 as AnyObject? !== self }
            }
        }
        
        class Game
        {
            // todo - Will likely need a method/notification to fire whenever a new Rat instance is created, to update RatAttackModifier packCount
            
            func ratJoinedPack(_ rat: Rat) {
                // Pass in rat as variable, and
                // Set listener for Rat so when a new rat joins previous Rat(s) are notified
                // Set listener for Rat to respond when other rats announce packCount
                // Fire Notification 'New Rat has joined"
                RatAttackModifier.ratPackChangedAttack.addHandler(target: self, handler: Game.updatePackAttack)
                RatAttackModifier.addRatToPack(rat)
            }
            
            func ratLeftPack(_ rat: Rat) {
                RatAttackModifier.ratWasKilled.addHandler(target: self, handler: Game.resetKilledRat)
                RatAttackModifier.removeRatFromPack(rat)
            }
            
            func updatePackAttack(_ attackValue: Int) {
                // Pass in pack count as Int
                // Fire Notification
                RatAttackModifier.updatePackAttack(attackValue)
            }
            
            func resetKilledRat(rat: Rat) {
                rat.resetAttack()
            }
        }
        
        class Rat : CustomStringConvertible, Equatable
        {
            static func == (lhs: Observer.Test.Rat, rhs: Observer.Test.Rat) -> Bool {
                return lhs.id == rhs.id
            }
            
            /*
             Publishes events to Game object when rats enter/leave the Game
            */
            private let game: Game
            var attack = 1
            var id = 0
            
            var description: String {
                return "My attack is \(attack)"
            }
            
            let ratPackChanged = Event<Int>()
            
            init(_ game: Game)
            {
                /*
                 Inform Game existence of new Rat, and subscribe to RAM events
                */
                self.game = game
                self.game.ratJoinedPack(self)
            }
            
            func kill() {
                /*
                 Inform Game of desistance of specific Rat, and unsubscribe to RAM events?
                */
                game.ratLeftPack(self)
            }
            
            func resetAttack() {
                attack = 1
            }
        }
        
        /*
         Class with static reference to Array of current Rats in Game, and tracks count
         Fires events to notify member rats to update attack values
        */
        class RatAttackModifier : NSObject {
            private static var ratPack = [Rat]()
            private static var packCount : Int {
                /*
                 1. Listens for updates from Game as new Rat created, and increases packCount
                 2. Triggers 'packCountNotification' back to the Game
                 3. value will increase

                 */
                return ratPack.count
            }

            static let ratPackChangedAttack = Event<Int>()
            static let ratWasKilled = Event<Rat>()
//            static let propertyChanging = Event<(String, Any, RefBool)>()

            static func addRatToPack(_ rat: Rat) {
                rat.id = ratPack.count
                self.ratPack.append(rat)
                ratPackChangedAttack.raise(packCount)
            }

            static func removeRatFromPack(_ rat: Rat) {
                self.ratPack.remove(at: ratPack.index(of: rat) ?? 0)
                ratWasKilled.raise(rat)
                ratPackChangedAttack.raise(packCount)
            }

            static func updatePackAttack(_ value: Int) {
                for rat in ratPack {
                    rat.attack = value
                }
            }
        }
        
        static func main() {
            /*
             As new rat instances are created, each individual rat's attack value should increase to match total rat instances (packCount), included the newest rat instance created
            */
            let g = Game()
            let r1 = Rat(g)
            print("Rat1: \(r1)")
            let r2 = Rat(g)
            print("Rat1: \(r1) after Rat2")
            print("Rat2: \(r2)")
            let g2 = Game()
            let r3 = Rat(g2) // FAILURE: No accounting for a separately initialized Game -- can't do g == g2
            print("Before Kill -- Rat3: \(r3)\nRat2: \(r2)\nRat1: \(r1)")
            r1.kill()
            print("After Kill -- Rat3: \(r3)\nRat2: \(r2)\nRat1: \(r1)")
        }
    }
}

//Observer.main()
//Observer.PropertyObserver.main()
//Observer.DependentPropertyObserver.main()
Observer.Test.main()


// ***** END OBSERVER **********

// ******** VISITOR ********

// DEFINITION: A pattern where a component (visitor) is allowed to traverse the entire inheritance hierarchy. Implemented by propogating a single visit() method throughout the entire hierarchy.
protocol Expression {
    func print(_ buffer: inout String)
}
struct Visitor {
    
    struct Intrusive {
        class DoubleExpression : Expression {
            private var value: Double
            
            init(_ value: Double) {
                self.value = value
            }
            
            func print(_ buffer: inout String) {
                buffer.append(String(value))
            }
        }
        
        class AdditionExpression : Expression {
            private var left, right: Expression
            init(_ left: Expression, _ right: Expression) {
                self.left = left
                self.right = right
            }
            
            func print(_ buffer: inout String) {
                buffer.append("(")
                left.print(&buffer)
                buffer.append("+")
                right.print(&buffer)
                buffer.append(")")
            }
        }
    }
    
    struct NonIntrusive {
        class DoubleExpression : NonIntrusiveExpression {
            let value: Double
            
            init(_ value: Double) {
                self.value = value
            }
            
            func print(_ buffer: inout String) {
                buffer.append(String(value))
            }
            
            func accept(_ visitor: ExpressionVisitor) {
                visitor.visit(self) // double-dispatch
            }
        }
        
        class AdditionExpression : NonIntrusiveExpression {
            let left, right: NonIntrusiveExpression
            init(_ left: NonIntrusiveExpression, _ right: NonIntrusiveExpression) {
                self.left = left
                self.right = right
            }
            
            func accept(_ visitor: ExpressionVisitor) {
                visitor.visit(self) // double-dispatch
            }
        }
        
        class ExpressionPrinter : ExpressionVisitor, CustomStringConvertible {
            private var buffer = ""
            
            var description: String { return buffer }
            func visit(_ de: Visitor.NonIntrusive.DoubleExpression) {
                buffer.append(String(de.value))
            }
            
            func visit(_ ae: Visitor.NonIntrusive.AdditionExpression) {
                buffer.append("(")
                ae.left.accept(self)
                buffer.append("+")
                ae.right.accept(self)
                buffer.append(")")
            }
        }
        
        class ExpressionCalculator: ExpressionVisitor {
            var result = 0.0
            
            func visit(_ de: Visitor.NonIntrusive.DoubleExpression) {
                result = de.value
            }
            
            func visit(_ ae: Visitor.NonIntrusive.AdditionExpression) {
                ae.left.accept(self)
                let a = result
                ae.right.accept(self)
                let b = result
                result = a + b
            }
        }
        
        static func main() {
            let e = NonIntrusive.AdditionExpression(NonIntrusive.DoubleExpression(1), NonIntrusive.AdditionExpression(NonIntrusive.DoubleExpression(2),NonIntrusive.DoubleExpression(3)))
            let ep = ExpressionPrinter()
            ep.visit(e)
            let calc = NonIntrusive.ExpressionCalculator()
            calc.visit(e)
            print("\(ep) = \(calc.result)")
        }
    }
    
    static func main() {
        // 1 + (2+3)
//        let e = Intrusive.AdditionExpression(Intrusive.DoubleExpression(1), Intrusive.AdditionExpression(Intrusive.DoubleExpression(2),Intrusive.DoubleExpression(3)))
//        var s = ""
//        e.print(&s)
//        print(s)
    }
    
    // --- TEST ---
    
    struct Test {
        /*
         Visitor Coding Exercise
         You are asked to implement a double-dispatch visitor called ExpressionPrinter  for printing different mathematical expressions. The range of expressions covers addition and multiplication - please put round brackets around addition operations! Also, please avoid any blank spaces in output.
         
         Here's the kind of unit test that will be applied to your code
         
         let simple = AdditionExpression(
         Value(2), Value(3)
         )
         let ep = ExpressionPrinter()
         ep.accept(simple)
         XCTAssertEqual("(2+3)", ep.description)
        */
        
        class Value : Test_Expression
        {
            
            let value: Int
            init(_ value: Int)
            {
                self.value = value
            }
            func visit(_ ev: Test_ExpressionVisitor)
            {
                // todo
                ev.accept(self)
            }
        }
        
        class AdditionExpression : Test_Expression
        {
            
            let lhs, rhs: Test_Expression
            init(_ lhs: Test_Expression, _ rhs: Test_Expression)
            {
                self.lhs = lhs
                self.rhs = rhs
            }
            func visit(_ ev: Test_ExpressionVisitor)
            {
                // todo
                ev.accept(self)
            }
        }
        
        class MultiplicationExpression : Test_Expression
        {
            
            let lhs, rhs: Test_Expression
            init(_ lhs: Test_Expression, _ rhs: Test_Expression)
            {
                self.lhs = lhs
                self.rhs = rhs
            }
            func visit(_ ev: Test_ExpressionVisitor)
            {
                // todo
                ev.accept(self)
            }
        }
        
        class ExpressionPrinter :
            Test_ExpressionVisitor, CustomStringConvertible
        {
            // todo
            private var buffer = ""
            
            var description: String { return buffer }
            
            func accept(_ visitor: Value) {
                buffer.append(String(visitor.value))
            }
            
            func accept(_ visitor: MultiplicationExpression) {
                visitor.lhs.visit(self)
                buffer.append("*")
                visitor.rhs.visit(self)
            }
            
            func accept(_ visitor: AdditionExpression) {
                buffer.append("(")
                visitor.lhs.visit(self)
                buffer.append("+")
                visitor.rhs.visit(self)
                buffer.append(")")
            }
        }
        
        static func main() {
            let simple = AdditionExpression(
                Value(2), Value(3)
            )
            let ep = ExpressionPrinter()
            ep.accept(simple)
            print(ep.description)
            print("(2+3)" == ep.description)
        }
    }
}
    
// --- Test ---
protocol Test_ExpressionVisitor
{
    // todo
    func accept(_ visitor: Visitor.Test.AdditionExpression)
    func accept(_ visitor: Visitor.Test.MultiplicationExpression)
    func accept(_ visitor: Visitor.Test.Value)
}
protocol Test_Expression
{
//    func visit(_ me: Visitor.Test.MultiplicationExpression)
    func visit(_ ev: Test_ExpressionVisitor)
}
    
// --- End Test ---

protocol ExpressionVisitor {
    func visit(_ de: Visitor.NonIntrusive.DoubleExpression)
    func visit(_ ae: Visitor.NonIntrusive.AdditionExpression)
}
protocol NonIntrusiveExpression {
    func accept(_ visitor: ExpressionVisitor)
}

//Visitor.NonIntrusive.main()
Visitor.Test.main()

// ****** END VISITOR ********

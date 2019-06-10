import UIKit
import Foundation

// ********* BUILDER ***********
class HtmlElement : CustomStringConvertible {
    var name = ""
    var text = ""
    var elements = [HtmlElement]()
    private let indentSize = 2
    
    init(){}
    init(name: String, text: String) {
        self.name = name
        self.text = text
    }
    
    private func description(_ indent: Int) -> String {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result += "\(i)<\(name)>\n"
        
        if !text.isEmpty {
            result += String(repeating: " ", count: (indent+1))
            result += text
            result += "\n"
        }
        
        for e in elements {
            result += e.description(indent+1)
        }
        
        result += "\(i)</\(name)>\n"
        
        return result
    }
    
    public var description: String {
        return description(0)
    }
}

class HtmlBuilder : CustomStringConvertible {
    private let rootName: String
    var root = HtmlElement()
    
    init(rootName: String) {
        self.rootName = rootName
        root.name = rootName
    }
    
    var description: String {
        return root.description
    }
    
    func clear() {
        root = HtmlElement(name: rootName, text: "")
    }
    
    func addChild(name: String, text: String) {
        let e = HtmlElement(name: name, text: text)
        root.elements.append(e)
    }
    
    func addChildFluent(name: String, text: String) -> HtmlBuilder {
        let e = HtmlElement(name: name, text: text)
        root.elements.append(e)
        return self
    }
}

class Person : CustomStringConvertible {
    // Address
    var streetAddress = "", postCode = "", city = ""
    // Employment
    var companyName = "", position = "", annualIncome = 0
    
    var description: String {
        return "I live at \(streetAddress), \(postCode), \(city). " + "I work at \(companyName) as a \(position), earning \(annualIncome)."
    }
}

class PersonBuilder {
    var person = Person()
    var lives : PersonAddressBuilder {
        return PersonAddressBuilder(person)
    }
    var works : PersonJobBuilder {
        return PersonJobBuilder(person)
    }
    func build() -> Person {
        return person
    }
}

class PersonJobBuilder : PersonBuilder {
    init(_ person: Person) {
        super.init()
        self.person = person
    }
    func at(_ companyName: String) -> PersonJobBuilder {
        person.companyName = companyName
        return self
    }
    func asA(_ position: String) -> PersonJobBuilder {
        person.position = position
        return self
    }
    func earning(_ annualIncome: Int) -> PersonJobBuilder {
        person.annualIncome = annualIncome
        return self
    }
}

class PersonAddressBuilder : PersonBuilder {
    init(_ person: Person) {
        super.init()
        self.person = person
    }
    func at(_ address: String) -> PersonAddressBuilder {
        person.streetAddress = address
        return self
    }
    func withPostcode(_ postcode: String) -> PersonAddressBuilder {
        person.postCode = postcode
        return self
    }
    func inCity(_ city: String) -> PersonAddressBuilder {
        person.city = city
        return self
    }
}

func builderMain() {
    
//    let builder = HtmlBuilder(rootName: "ul")
//    builder.addChildFluent(name: "li", text: "hello")
//        .addChildFluent(name: "li", text: "world")
//
//    print(builder)
    let pb = PersonBuilder()
    let p = pb
        .lives.at("123 London Road").inCity("London").withPostcode("Sw12BC")
        .works.at("Fabrikam").asA("engineer").earning(123000).build()
    print(p)
}

//builderMain()

// ********* BUILDER TEST ************
class CodeElement {
    var name = ""
    var type = ""
    private let indentSize = 2
    
    init(){}
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    private func description(_ indent: Int) -> String {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result += "{"
        
        if !type.isEmpty {
            result += String(repeating: " ", count: (indent+1))
            result += "var \(name): \(type)"
            result += "\n"
        }
        
//        for e in elements {
//            result += e.description(indent+1)
//        }
        
        result += "}"
        
        return result
    }
    
    public var description: String {
        return description(0)
    }
}

class CodeBuilder : CustomStringConvertible
{
    private var elements = [CodeElement]()
//    private var
    var rootName: String
    init(_ rootName: String)
    {
        self.rootName = rootName
//        root.name = rootName
    }
    
    func addField(called name: String, ofType type: String) -> CodeBuilder
    {
        self.elements.append(CodeElement(name: name, type: type))
        return self
    }
    
    public var description: String
    {
        var result = ""
        result += "class \(self.rootName)\n"
        result += "{\n"
        for e in elements {
            let i = String(repeating: " ", count: 2)
            result += "\(i)var \(e.name): \(e.type)\n"
        }
        result += "}"
        return result
    }
}

func testMain() {
    let cb = CodeBuilder("Person").addField(called: "name", ofType: "String").addField(called: "age", ofType: "Int")
    print(cb.description)
    
    /*
     Output:
     
     class Person
     {
        var name: String
        var age: Int
     }
    */
}

//testMain()
// ********* END BUILDER / TEST *************

// ********** FACTORIES ************

class Point : CustomStringConvertible {
    private var x, y: Double
    var description: String {
        return "x = \(x), y = \(y)"
    }
    private init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    private init(rho: Double, theta: Double) {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }
    // Inner Factory with Factory class as a Singleton
    static let factory = Factory.instance
    
    class Factory {
        private init() {}
        static let instance = Factory()
        // Public initializers now more descriptive, static methods
        func createCartesian(x: Double, y: Double) -> Point {
            return Point(x:x, y:y)
        }
        
        func createPolar(rho: Double, theta: Double) -> Point {
            return Point(rho: rho, theta: theta)
        }
    }
}

func factoryMain() {
    let p = Point.factory.createCartesian(x: 1, y: 2)
    print(p)
}

//factoryMain()

// --- ABSTRACT FACTORY ---

protocol HotDrink {
    func consume()
}

class Tea: HotDrink {
    func consume() {
        print("This tea is nice bu I'd prefere it with lemon.")
    }
}

class Coffee: HotDrink {
    func consume() {
        print("This coffee is delicious!")
    }
}

protocol HotDrinkFactory {
    init()
    func prepare(amount: Int) -> HotDrink
}

class TeaFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Put in tea bag, boil water, pour \(amount)ml, add milk, enjoy!")
        return Tea()
    }
}

class CoffeeFactory {
    required init() {}
    func prepare(amount: Int) -> HotDrink {
        print("Grind some beans, boil water, pour \(amount)ml, add cream and sugar, enjoy!")
        return Coffee()
    }
}

class HotDrinkMachine {
    enum AvailableDrink : String {
        case coffee = "Coffee"
        case tea = "Tea"
        
        static let all = [coffee, tea]
    }
    
    internal var namedFactories = [(String, HotDrinkFactory)]()
    
    init() {
        for drink in AvailableDrink.all {
            let type = NSClassFromString("\(drink.rawValue)Factory")
            let factory = (type as! HotDrinkFactory.Type).init()
            namedFactories.append((drink.rawValue, factory))
        }
    }
    
    func makeDrink() -> HotDrink {
        print("Available drinks:")
        for i in 0..<namedFactories.count {
            let tuple = namedFactories[i]
            print("\(i): \(tuple.0)")
        }
        let input = Int(readLine()!)!
        return namedFactories[input].1.prepare(amount: 250)
    }
}

func abstractFactoryMain() {
    let machine = HotDrinkMachine()
    print(machine.namedFactories.count)
    let drink = machine.makeDrink()
    drink.consume()
}

//abstractFactoryMain() // NOTE: Currently throwing Error

// -- FACTORY TEST --

class FactoryTestPerson : CustomStringConvertible
{
    var id: Int
    var name: String
    var description: String {
        return "My name is \(name) my ID is \(id)"
    }
    init(called name: String, withId id: Int)
    {
        self.name = name
        self.id = id
    }
}

class PersonFactory : CustomStringConvertible
{
    init(){}
    
    var description: String {
        return person.description
    }
    private static var people = [FactoryTestPerson]()
    var person : FactoryTestPerson!
    func createPerson(name: String) -> FactoryTestPerson
    {
        let id = PersonFactory.people.count
        person = FactoryTestPerson(called: name, withId: id)
        PersonFactory.people.append(person)
        return person
    }
}

func factoryTestMain() {
    let p1 = PersonFactory().createPerson(name: "John")
    let p2 = PersonFactory().createPerson(name: "Sam")
    print(p1)
    print(p2)
}

//factoryTestMain()
// ********* END FACTORIES ***********

// *********** PROTOTYPES ************

// DEFINITION: A partially of fully initialized object that you copy (clone) and make use of.
protocol Copying {
//    init(copyFrom other: Self) // Use with Class
    func clone() -> Self // Use w/ Struct aka "Deep Copying"
}

class Address : CustomStringConvertible, Copying {
    
    var streetAddress: String, city: String
    var description: String {
        return "\(streetAddress), \(city)"
    }
    // func copyFrom init
//    required init(copyFrom other: Address) {
//        streetAddress = other.streetAddress; city = other.city
//    }
    init(_ street: String, _ city: String) {
        streetAddress = street; self.city = city
    }
    
    func clone() -> Self {
        return cloneImp()
    }
    
    private func cloneImp<T>() -> T {
        return Address(streetAddress, city) as! T
    }
}
struct Employee : CustomStringConvertible, Copying {
    var name: String
    var address: Address
    
    init(_ name: String, _ address: Address) {
        self.name = name; self.address = address
    }
    // func copyFrom init
//    required init(copyFrom other: Employee) {
//        self.name = other.name
//        // Approach 1
////        address = Address(other.address.streetAddress, other.address.city)
//
//        // Approach 2
//        address = Address(copyFrom: other.address)
//    }
    
    var description: String {
        return "My name is \(name) and I live at \(address)."
    }
    
    func clone() -> Employee {
        return Employee(name, address.clone())
    }
}

func prototypesMain() {
    let john = Employee("John", Address("123 Address Lane", "Chicago, IL"))
//    let chris = Employee(copyFrom: john)
    var chris = john.clone()
    chris.name = "Chris"
    chris.address.streetAddress = "124 Address Lane"
    print(john)
    print(chris)
}

//prototypesMain()

// --- TEST PROTOTYPE ---

protocol DeepCopy {
    func deepCopy() -> Self
}

class ProtoPoint : CustomStringConvertible, DeepCopy
{
    var x = 0
    var y = 0
    
    var description: String {
        return "X: \(x) Y: \(y)"
    }
    
    init() {}
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
    }
    
    func deepCopy() -> Self {
        return deepCopyImpl()
    }
    
    private func deepCopyImpl<T>() -> T {
        return ProtoPoint(x: x, y: y) as! T
    }
}

class ProtoLine : CustomStringConvertible, DeepCopy
{
    var start = ProtoPoint()
    var end = ProtoPoint()
    
    var description: String {
        return "Start: \(start.description), End: \(end.description)"
    }
    
    init(start: ProtoPoint, end: ProtoPoint)
    {
        self.start = start
        self.end = end
    }
    
    func deepCopy() -> Self
    {
        return self.deepCopyImpl()
    }
    
    private func deepCopyImpl<T>() -> T {
        return ProtoLine(start: start.deepCopy(), end: end.deepCopy()) as! T
    }
}

func protoTestMain() {
    let point1 = ProtoPoint(x: 5, y: 6)
    let point2 = point1.deepCopy()
    point2.y = 12
    let line1 = ProtoLine(start: point1, end: point2)
    let line2 = line1.deepCopy()
    line2.start.x = -2
    line2.end.y = 30
    print(line1)
    print(line2)
}

//protoTestMain()
// ********* END PROTOTYPES ***********

// *********** SINGLETONS **************

// DEFINITION: A component whic is instantiated only once

struct Singleton {
    
    struct Test {
        
        static func main() {
            
        }
    }
}

// ********* END SINGLETONS ***********

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

// ************ FLYWEIGHT ***********

// DEFINITION: A space optimization technique that lets us use less memory by storing externally the data associated with similar objects

struct FlyWeight {
    
    class User {
        var fullname: String
        init(_ fullname: String) {
            self.fullname = fullname
        }
        
        var charCount: Int {
            return fullname.utf8.count
        }
    }
    
    func main() {
        let user1 = User("John Smith")
        let user2 = User("Jane Smith")
        let user3 = User("Jane Doe")
        let totalChars = user1.charCount + user2.charCount + user3.charCount
        print("Total number of chars used: \(totalChars)")
        2
        let user4 = User2("John Smith")
        let user5 = User2("Jane Smith")
        let user6 = User2("Jane Doe")
        print("Total number of chars used: \(User2.charCount)")
    }
    
    class User2 {
        static var string = [String]()
        private var names = [Int]()
        
        init(_ fullname: String) {
            
            func getOrAdd(_ s: String) -> Int {
                if let idx = type(of: self).string.firstIndex(of: s) {
                    return idx
                }
                type(of: self).string.append(s)
                return type(of: self).string.count-1
            }
            names = fullname.components(separatedBy: " ").map { getOrAdd($0) }
        }
        
        static var charCount : Int {
            return string.map{ $0.utf8.count }.reduce(0,+)
        }
    }
    
    // ~~~~ Example 2
    class FormattedText : CustomStringConvertible {
        private var text: String
        private var capitalize: [Bool]
        
        init(_ text: String) {
            self.text = text
            capitalize = [Bool](repeating: false, count: text.utf8.count)
        }
        
        func capitalize(_ start: Int, _ end: Int) {
            for i in start...end {
                capitalize[i] = true
            }
        }
        
        var description: String {
            var s = ""
            for i in 0..<text.utf8.count {
                let c = text.substring(i,1)!
                s += capitalize[i] ? c.capitalized : c
            }
            return s
        }
    }
    
    func main2() {
        let ft = FormattedText("This is a brave new world")
        ft.capitalize(10,15)
        print(ft)
        
        let bft = BetterFormattedText("This is a brave new world")
        bft.getRange(10, 15).capitalize = true
        print(bft)
    }
    
    class BetterFormattedText : CustomStringConvertible {
        private var text: String
        private var formatting = [TextRange]()
        
        init(_ text: String) {
            self.text = text
        }
        
        func getRange(_ start: Int, _ end: Int) -> TextRange {
            let range = TextRange(start, end)
            formatting.append(range)
            return range
        }
        
        var description: String {
            var s = ""
            for i in 0..<text.utf8.count {
                var c = text.substring(i,1)!
                for range in formatting {
                    if range.covers(i) && range.capitalize {
                        c = c.capitalized
                    }
                }
                s += c
            }
            return s
        }
        
        class TextRange {
            
            
            var start, end: Int
            var capitalize = false
            
            init(_ start: Int, _ end: Int) {
                self.start = start; self.end = end
            }
            
            func covers(_ position: Int) -> Bool {
                return position >= start && position <= end
            }
        }
        
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    struct Test {
        class Sentence : CustomStringConvertible
        {
//            init(_ plainText: String)
//            {
//                // todo
//            }
//
//            subscript(index: Int) -> WordToken
//            {
//                // todo
//            }
            
            var description: String
            {
                // todo
                return ""
            }
//
//            class WordToken
//            {
//                var capitalize: Bool = false
//                // todo
//            }
        }
        
        
        
        static func main() {
//            let sentence = Sentence("hello world")
//            sentence[1].capitalize = true
//            print(sentence) // writes "hello WORLD"
        }
    }
    
}

// ~~~~~~ Example 2

extension String {
    func substring(_ location: Int, _ length: Int) -> String? {
        guard count >= location + length else { return nil }
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: location + length)
        return substring(with: start..<end)
    }
}

//FlyWeight().main()
FlyWeight().main2()
FlyWeight.Test.main()

// ******** END FLYWEIGHT ***********

// ******** PROXY *********

// DEFINITION: A class that functions as an interfact to a particular resource. That resource may be remote, expensive to construct, or may require logging or some other added functionality.

// ~~~~ Protection Proxy
// Guards access to functionality
protocol ProxyVehicle {
    func drive()
}

struct Proxy {
    
    class Car {
        func drive() {
            print("Car being driven")
        }
    }
    
    class CarProxy: ProxyVehicle {
        private let car = Car()
        private let driver: Driver
        
        init(driver: Driver) {
            self.driver = driver
        }
        
        func drive() {
            self.driver.age >= 16 ? car.drive() : print("Sorry Driver too young!")
        }
    }
    
    class Driver {
        var age: Int
        init(age: Int) {
            self.age = age
        }
    }
    
    static func main() {
        let car: ProxyVehicle = CarProxy(driver: Driver(age: 19))
        car.drive()
    }
    
    // ~~~~ Example 2
    
    class Creature {
        private let _agility = Property<Int>(0)
        
        var agility: Int {
            get { return _agility.value }
            set(value) { _agility.value = value }
        }
    }
    
    class Property<T: Equatable> {
        private var _value: T
        
        public var value: T {
            get {
                return _value
            }
            set(value) {
                if value == _value { return }
                print("Setting value to \(value)")
                _value = value
            }
        }
        
        init(_ value: T) {
            _value = value
        }
    }
    
    func propertyMain() {
        let c = Creature()
        c.agility = 10
        
        print(c.agility)
    }
    
    // --- TEST ---
    /*
        You are given the Person  class and asked to write a ResponsiblePerson  proxy that does the following:
     
        Allows person to drink unless they are younger than 18 (in that case, return "too young")
        Allows person to drive unless they are younger than 16 (otherwise, "too young")
        In case of driving while drink, returns "dead"
    */

    struct Test {
        class Person
        {
            var age: Int = 0
            
            func drink() -> String
            {
                return "drinking"
            }
            
            func drive() -> String
            {
                return "driving"
            }
            
            func drinkAndDrive() -> String
            {
                return "driving while drunk"
            }
        }
        
        class ResponsiblePerson
        {
            private let person: Person

            init(person: Person)
            {
                self.person = person
            }
            
            private let _age = Property<Int>(0)
            
            var age: Int {
                get { return _age.value }
                set(value) { _age.value = value }
            }
            
            func drink() -> String
            {
                return age >= 18 ? person.drink() : "too young"
            }
            
            func drive() -> String
            {
                return age >= 16 ? person.drive() : "too young"
            }
            
            func drinkAndDrive() -> String
            {
                return "dead"
            }
        }
        
        func main() {
            let p = Person()
            p.age = 16
            print(p.drink())
            print(p.drinkAndDrive())
            let rp = ResponsiblePerson(person: p)
            rp.age = 14
            print(rp.drink())
            print(rp.drinkAndDrive())
            
        }
    }
}

extension Proxy.Property: Equatable {}

func == <T>(lhs: Proxy.Property<T>, rhs: Proxy.Property<T>) -> Bool {
    return lhs.value == rhs.value
}

//Proxy.main()
//Proxy().propertyMain()
//Proxy.Test().main()


// ******** END PROXY **********

// ******** CHAIN OR RESPONSIBILITY *********

// DEFINITION: A chain of components who all get a chance to process a command or a query, optionally having default processing implementation and an ability to terminate the processing chain

struct ChainOfResponsibility {
    class Creature : CustomStringConvertible {
        var name: String
        var attack: Int
        var defense: Int
        var description: String {
            return "Name: \(name), A - \(attack), D - \(defense)"
        }
        
        init(_ name: String, _ attack: Int, _ defense: Int) {
            self.name = name; self.attack = attack; self.defense = defense
        }
    }
    
    class CreatureModifier {
        let creature: Creature
        var next: CreatureModifier?
        
        init(_ creature: Creature) {
            self.creature = creature
        }
        
        func add(_ cm: CreatureModifier) {
            if next != nil {
                next!.add(cm)
            } else {
                next = cm
            }
        }
        
        func handle() {
            next?.handle()
        }
    }
    
    class DoubleAttackModifier : CreatureModifier {
        override func handle() {
            print("Doubling \(creature.name)'s attack")
            creature.attack *= 2
            super.handle()
        }
    }
    
    class IncreaseDefenceModifier : CreatureModifier {
        override func handle() {
            print("Increasing \(creature.name)'s defense ")
            creature.defense += 3
            super.handle()
        }
    }
    
    class NoBonusesModifier : CreatureModifier {
        override func handle() {
            // Do nothing so no bonuses if say cursed by a witch
        }
    }
    
    func main() {
        let goblin = Creature("Goblin", 2, 2)
        print(goblin)
        
        let root = CreatureModifier(goblin)
        
        print("Cursed by Witch!")
        root.add(NoBonusesModifier(goblin))
        
        print("Let's double the goblin's attack")
        root.add(DoubleAttackModifier(goblin))
        
        print("Let's increase goblin's defense")
        root.add(IncreaseDefenceModifier(goblin))
        
        root.handle()
        print(goblin)
    }
    
    // ~~~~ BROKER CHAIN ~~~~
    struct  Broker {
        public class Event<T> {
            public typealias EventHandler = (T) -> ()
            var eventHandlers = [CoR_Invocable]()
            
            public func raise(_ data: T) {
                for handler in self.eventHandlers {
                    handler.invoke(data)
                }
            }
            
            public func addHandler<U: AnyObject>
                (target: U, handler: @escaping (U) -> EventHandler) -> CoR_Disposable {
                let subscription = Subscription(target, handler, self)
                eventHandlers.append(subscription)
                return subscription
            }
        }
        
        class Subscription<T: AnyObject, U> : CoR_Disposable, CoR_Invocable {
            weak var target: T?
            let handler: (T) -> (U) -> ()
            let event: Event<U>
            
            init(_ target: T?, _ handler: @escaping (T) -> (U) -> (), _ event: Event<U>) {
                self.target = target
                self.handler = handler
                self.event = event
            }
            
            func invoke(_ data: Any) {
                if let t = target {
                    handler(t)(data as! U)
                }
            }
            
            func dispose() {
                event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
            }
        }
        
        class Query {
            var creatureName: String
            enum Argument {
                case attack, defense
            }
            var whatToQuery: Argument
            var value: Int
            
            init(_ name: String, _ whatToQuery: Argument, _ value: Int) {
                self.creatureName = name
                self.whatToQuery = whatToQuery
                self.value = value
            }
        }
        
        class Game {
            let queries = Event<Query>()
            
            func performQuery(_ q: Query) {
                queries.raise(q)
            }
        }
        
        class Creature : CustomStringConvertible {
            var name: String
            private let _attack, _defense: Int
            private let game: Game
            
            var description: String {
                return "Name: \(name), A - \(attack), D - \(defense)"
            }
            init(_ game: Game, _ name: String, _ attack: Int, _ defense: Int) {
                self.game = game; self.name = name; _attack = attack; _defense = defense
            }
            
            var attack: Int {
                let q = Query(name, .attack, _attack)
                game.performQuery(q)
                return q.value
            }
            
            var defense: Int {
                let q = Query(name, .defense, _defense)
                game.performQuery(q)
                return q.value
                
            }
        }
        
        class CreatureModifier : CoR_Disposable {
            let game: Game
            let creature: Creature
            var event: CoR_Disposable? = nil
            
            init(_ game: Game, _ creature: Creature) {
                self.game = game; self.creature = creature; event = self.game.queries.addHandler(target: self, handler: CreatureModifier.handle)
            }
            
            func handle(_ q: Query) {
                // Do nothing to indicate no modifications made
            }
            
            func dispose() {
                event?.dispose()
            }
        }
        
        class DoubleAttackModifier: CreatureModifier {
            override func handle(_ q: Query) {
                if q.creatureName == creature.name && q.whatToQuery
                 == .attack {
                    q.value *= 2
                }
            }
        }
        
        class IncreaseDefenseModifier: CreatureModifier {
            override func handle(_ q: Query) {
                if q.creatureName == creature.name && q.whatToQuery
                    == .defense {
                    q.value += 2
                }
            }
        }
        
        static func main() {
            let game = Game()
            let goblin = Creature(game, "Strong Goblin", 3, 3)
            print("Baseline goblin: \(goblin)")
            
            let dam = DoubleAttackModifier(game, goblin)
            print("Goblin with 2x attack: \(goblin)")
            
            let idm = IncreaseDefenseModifier(game, goblin)
            print("Goblin with 2x attack & increased defense: \(goblin)")
            
            idm.dispose(); print("Goblin is now \(goblin)")
            dam.dispose(); print("Goblin in now \(goblin)")
            
        }
    } // --- Broker Scope ---
    
    // --- TEST ---
    
    struct Test {
        // INCOMPLETE!!
        /*
         Game Rules:
         1. A goblin has base 1 attack/1 defense(1/1), a goblin king is 3/3
         2. When the Goblin King is in play, every other goblin gets +1 Attack.
         3. Goblins get +1 to Defense for every other Goblin in play--a GoblinKing is a Goblin
        */
        
        class Creature
        {
            // todo
        }
        
        class Goblin : Creature
        {
            // todo
            var attack = 0
            var defense = 0
            init(game: Game)
            {
                // todo
            }
        }
        
        class GoblinKing : Goblin
        {
//            init(game: Game)
//            {
//                // todo
//            }
        }
        
        class Game
        {
            var creatures = [Creature]()
        }
        
        static func main() {
            let game = Game()
            let goblin = Goblin(game: game)
            game.creatures.append(goblin)
            
            let goblin2 = Goblin(game: game)
            game.creatures.append(goblin2)
            
            print(1 == goblin.attack)
            print(2 == goblin.defense)
        }
    }
}// --- Chain of Responsibility Scope ---

protocol CoR_Invocable : class {
    func invoke(_ data: Any)
}

public protocol CoR_Disposable {
    func dispose()
}

import XCTest

//ChainOfResponsibility().main()
//ChainOfResponsibility.Broker.main()

// ******** END CHAIN OR RESPONSIBILITY *********


// ********* COMMAND ********

// DEFINITION: An object which represents and instruction to perform a particular action, continain all the information necessary for the action to be taken

struct Command_Pattern {
    
    class BankAccount : CustomStringConvertible {
        private var balance = 0
        private let overdraftLimit = -500
        
        var description: String {
            return "Balance = \(balance)"
        }
        
        func deposit(_ amount: Int) {
            balance += amount
            print("Deposited \(amount), balance is now \(balance)")
        }
        
        func withdraw(_ amount: Int) -> Bool {
            if (balance - amount >= overdraftLimit) {
                balance -= amount
                print("Withdrew \(amount), balance is now \(balance)")
                return true
            }
            return false
        }
    }
    
    static func main() {
        let ba = BankAccount()
        let commands = [
            BankAccountCommand(ba, .deposit, 100),
            BankAccountCommand(ba, .withdraw, 25)
        ]
        
        print(ba)
        
        commands.forEach{ $0.call() }
        
        print(ba)
        
        commands.reversed().forEach{ $0.undo() }
        
        print(ba)
    }
    
    class BankAccountCommand : Command {
        private var account: BankAccount
        
        enum Action {
            case deposit, withdraw
        }
        
        private var action: Action
        private var amount: Int
        private var succeeded = false
        
        init(_ account: BankAccount, _ action: Action, _ amount: Int) {
            self.account = account; self.action = action; self.amount = amount
        }
        
        func call() {
            switch action {
            case .deposit:
                account.deposit(amount)
                succeeded = true
            case .withdraw:
                succeeded = account.withdraw(amount)
            }
        }
        
        func undo() {
            if !succeeded { return }
            
            switch action {
            case .deposit:
                account.withdraw(amount)
            case .withdraw:
                account.deposit(amount)
            }
        }
    }
    
    struct Test {
        class Command
        {
            enum Action
            {
                case deposit
                case withdraw
            }
            
            var action: Action
            var amount: Int
            var success = false
            
            init(_ action: Action, _ amount: Int)
            {
                self.action = action
                self.amount = amount
            }
        }
        
        class Account
        {
            private let zeroBalance = 0
            var balance = 0
            
            func process(_ c: Command)
            {
                // todo
                switch c.action {
                case .deposit:
                    deposit(c.amount)
                    c.success = true
                case .withdraw:
                    c.success = withdraw(c.amount)
                }
            }
            
            func deposit(_ amount: Int) {
                balance += amount
                print("Deposited \(amount), balance is now \(balance)")
            }
            
            func withdraw(_ amount: Int) -> Bool {
                if (balance - amount > zeroBalance) {
                    balance -= amount
                    print("Withdrew \(amount), balance is now \(balance)")
                    return true
                }
                return false
            }
        }
        
        static func main() {
            let commands1 =  [
                Command(.deposit, 100),
                Command(.withdraw, 99)
            ]
            let commands2 =  [
                Command(.deposit, 100),
                Command(.withdraw, 101)
            ]
            let a = Account()
            a.process(commands2[0])
            a.process(commands2[1])
            
            XCTAssert(a.balance == 100, "Withdrawal should fail due to overdraft.")
        }
    }
}

protocol Command {
    func call()
    func undo()
}

//Command_Pattern.main()
//Command_Pattern.Test.main()

// ******* END COMMAND *******

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

// ******* MEDIATOR **********

// DEFINITION: A component that facilitates communication between other components w/out them necessarily being aware of each other or having direact (reference) access to each other

struct Mediator {
    
    class Person {
        var name: String
        var room: ChatRoom?=nil
        private var chatLog = [String]()
        
        init(_ name: String) {
            self.name = name
        }
        
        func say(_ message: String) {
            room?.broadcast(sender: name, message: message)
        }
        
        func receive(sender: String, message: String) {
            let s = "\(sender): `\(message)`"
            print("[\(name)'s chat session \(s)]")
            chatLog.append(s)
        }
        
        func privateMessage(to target: Person, message: String) {
            room?.message(sender: name, destination: target.name, message: message)
        }
    }
    
    class ChatRoom {
        private var people = [Person]()
        
        func broadcast(sender: String, message: String) {
            for p in people {
                if p.name != sender {
                    p.receive(sender: sender, message: message)
                }
            }
        }
        
        func join(_ p: Person) {
            let joinMsg = "\(p.name) joins the chat"
            broadcast(sender: "room", message: joinMsg)
            p.room = self
            people.append(p)
        }
        
        func message(sender: String, destination: String, message: String) {
            people.first { $0.name == destination }?.receive(sender: sender, message: message)
        }
    }
    
    static func main() {
        let room = ChatRoom()
        let john = Person("John")
        let jane = Person("Jane")
        
        room.join(john)
        room.join(jane)
        
        john.say("hi room")
        jane.say("oh, hey john")
        
        let simon = Person("Simon")
        room.join(simon)
        simon.say("hi everyone!")
        
        jane.privateMessage(to: simon, message: "glad you could join us!")
    }
    
    // --- TEST ---
    
    struct Test {
        /*
            Mediator Coding Exercise
            Our system has any number of instances of Participant  classes. Each Participant has a Value  integer, initially zero.
         
            A participant can Say()  a particular value, which is broadcast to all other participants. At this point in time, every other participant is obliged to increase their Value  by the value being broadcast.
         
            Example:
         
            Two participants start with values 0 and 0 respectively
            Participant 1 broadcasts the value 3. We now have Participant 1 value = 0, Participant 2 value = 3
            Participant 2 broadcasts the value 2. We now have Participant 1 value = 2, Participant 2 value = 3
        */
        
        class Participant : Equatable, CustomStringConvertible
        {
            static func == (lhs: Participant, rhs: Participant) -> Bool {
                return lhs.id == rhs.id
            }
            
            private let mediator: Mediator
            var value = 0
            private let id: Int
            
            var description: String {
                let pID = self.mediator.participants.firstIndex(of: self)!
                return "\(pID) value: \(self.value)"
            }
            
            init(_ mediator: Mediator)
            {
                self.mediator = mediator
                self.id = mediator.participants.count
                self.mediator.participants.append(self)
            }
            
            func say(_ n: Int)
            {
                self.mediator.broadcast(self, n)
            }
        }
        
        class Mediator : CustomStringConvertible
        {
            var participants = [Participant]()
            
            var description: String {
                return "Participants count: \(self.participants.count)"
            }
            init(){}
            
            func broadcast(_ broadCaster: Participant, _ value: Int) {
                for participant in participants where participant != broadCaster {
                    participant.value += value
                }
            }
        }
        
        static func main() {
            let mediator = Mediator()
            let p1 = Participant(mediator)
            let p2 = Participant(mediator)
            
            print(mediator)
            print(p1)
            print(p2)
            
            p1.say(3)
            p2.say(2)
            
            print(p1)
            print(p2)
        }
    }
}

//Mediator.main()
//Mediator.Test.main()

// ******* END MEDIATOR ********

// ***** MEMENTO ******

// DEFINITION: A token/handle representing the system state. Let us roll back to the state when the token was generated. May or may not directly expose state information.

struct Memento {
    
    class BankAccount : CustomStringConvertible {
        
        var description: String {
            return "Balance - \(balance)"
        }
        
        private var balance: Int
        private var changes = [Memento]()
        private var current = 0
        
        init(_ balance: Int) {
            self.balance = balance
            changes.append(Memento(balance))
        }
        
        func deposit(_ amount: Int) -> Memento {
            balance += amount
            let m = Memento(balance)
            changes.append(m)
            current += 1
            return m
        }
        
        func undo() -> Memento? {
            if current > 0 {
                current -= 1
                let m = changes[current]
                balance = m.balance
                return m
            }
            return nil
        }
        
        func redo() -> Memento? {
            if (current+1) < changes.count {
                current += 1
                let m = changes[current]
                balance = m.balance
                return m
            }
            return nil
        }
        
        func restore(_ m: Memento?) {
            if let mm = m {
                balance = mm.balance
                changes.append(mm)
                current = changes.count-1
            }
        }
        
        class Memento {
            let balance: Int
            init(_ balance: Int) {
                self.balance = balance
            }
        }
    }
    
    static func main() {
        let ba = BankAccount(100)
        let m1 = ba.deposit(50)
        let m2 = ba.deposit(25)
        print(ba)
        
        ba.undo()
        print("Undo 1: \(ba)")
        ba.undo()
        print("Undo 2: \(ba)")
        ba.redo()
        print("Redo 1: \(ba)")
        
    }
    
    // --- TEST ---
    
    struct Test {
        /*
         Memento Coding Exercise
         You are given a class called TokenMachine which keeps tokens. Each token is a class with a single value. The TokenMachine actually has two members: one takes an integer and another takes an already-made token.
         
         Both overloads need to add its tokens to the set of tokens and return a Memento that allows us to subsequently call revert(to:) to roll the system back to the original state.
         
         Please implement the missing members.
        */
        
        class Token
        {
            var value = 0
            init(_ value: Int)
            {
                self.value = value
            }
            // todo: any extra members you need
            
            // please keep this operator! it will be
            // used for testing!
            static func ==(_ lhs: Token, _ rhs: Token) -> Bool
            {
                return lhs.value == rhs.value
            }
        }
        
        class Memento
        {
            var tokens = [Token]()
            
            init(_ tokens: [Token]) {
                self.tokens = tokens
            }
        }
        
        class TokenMachine
        {
            var tokens = [Token]()
            
            private var changes = [Memento]()
            private var current = 0
            
            func addToken(_ value: Int) -> Memento
            {
                let token = Token(value)
                tokens.append(token)
                let memento = Memento(tokens)
                changes.append(memento)
                current += 1
                return memento
            }
            
            func addToken(_ token: Token) -> Memento
            {
                tokens.append(token)
                let memento = Memento(tokens)
                changes.append(memento)
                current += 1
                return memento
            }
            
            func revert(to m: Memento?)
            {
                if let memento = m {
                    tokens = memento.tokens
                    changes.append(memento)
                    current = changes.count-1
                }
            }
        }
        
        static func main() {
            
        }
    }
}

//Memento.main()
//Memento.Test.main()

// **** END MEMENTO *****

// ***** NULL OBJECT *****

// DEFINITION: A no-op oject that conforms to the required ointerface, satisfying a dependency requirement of some other object.

protocol NullObject_Log {
    func info(_ msg: String)
    func warn(_ msg: String)
}

struct NullObject {
    
    class ConsoleLog : NullObject_Log {
        func info(_ msg: String) {
            print(msg)
        }
        
        func warn(_ msg: String) {
            print("WARNING: \(msg)")
        }
    }
    
    class BankAccount {
        var balance = 0
        var log: NullObject_Log
        
        init(_ log: NullObject_Log) {
            self.log = log
        }
        
        func deposit(_ amount: Int) {
            balance += amount
            log.info("Deposited \(amount), balance is now \(balance)")
        }
    }
    
    class NullLog : NullObject_Log {
        func info(_ msg: String) {}
        func warn(_ msg: String) {}
    }
    
    
    static func main() {
//        let log = ConsoleLog()
        let log = NullLog()
        let ba = BankAccount(log)
        ba.deposit(100)
    }
    
    // --- TEST ---
    
    /*
     Null Object Coding Exercise
     In this example, we have a class Account  that is very tightly coupled to the Log protocol... it also breaks SRP by performing all sorts of weird checks in someOperation() .
     
     Your mission, should you choose to accept it, is to implement a NullLog  class that can be fed into an Account  and that doesn't throw any exceptions, for virtually infinite repetitions.
    */
    
    struct Test {
        
        
        enum LogError : Error
        {
            case recordNotUpdated
            case logSpaceExceeded
        }
        
        class Account
        {
            private var log: Log
            
            init(_ log: Log)
            {
                self.log = log
            }
            
            func someOperation() throws
            {
                let c = log.recordCount
                log.logInfo("Performing an operation")
                if (c+1) != log.recordCount
                {
                    throw LogError.recordNotUpdated
                }
                if log.recordCount >= log.recordLimit
                {
                    throw LogError.logSpaceExceeded
                }
            }
        }
        
        class NullLog : Log
        {
            var recordLimit: Int = 2
            
            var recordCount: Int = 0
            
            func logInfo(_ message: String) {
                print(message)
                recordCount += 1
                recordLimit += 1
            }
        }
        
        static func main() {
            let nL = NullLog()
            let a = Account(nL)
            for _ in 0...10 {
                do {
                    try a.someOperation()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

protocol Log
{
    var recordLimit: Int { get }
    var recordCount: Int { get set }
    func logInfo(_ message: String)
}

//NullObject.Test.main()

// *** END NULL OBJECT ****

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

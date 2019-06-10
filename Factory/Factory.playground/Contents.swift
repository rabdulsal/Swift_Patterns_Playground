import UIKit
import Foundation

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

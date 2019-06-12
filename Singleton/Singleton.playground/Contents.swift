import UIKit
import Foundation

// *********** SINGLETONS **************

// DEFINITION: A component whic is instantiated only once

protocol Database {
    func getPopulation(_ name: String) -> Int
}

struct Cities {
    static var Data : [String:Int] {
        return [
            "Tokyo" : 3200000,
            "New York" : 17800000,
            "Sao Paolo" : 17200000,
            "Seoul" : 17500000,
            "Mexico City" : 17400000,
            "Osaka" : 16425000,
            "Manila" : 14750000,
            "Mumbai" : 14350000,
            "Delhi" : 14300000,
            "Jakarta" : 14250000
        ]
    }
}

class SingletonDatabase : Database {
    var capitals = [String : Int]()
    static var instanceCount = 0
    static let instance = SingletonDatabase()
    
    private init () {
        type(of: self).instanceCount += 1
        print("Initializing database")
        self.capitals = Cities.Data
    }
    
    func getPopulation(_ name: String) -> Int {
        return capitals[name]!
    }
}

class SingletonRecordFinder {
    
    func totalPpoulation(_ names: [String]) -> Int {
        var result = 0
        for name in names {
            result += SingletonDatabase.instance.getPopulation(name)
        }
        return result
    }
}

class DummyDatabase : Database {
    func getPopulation(_ name: String) -> Int {
        return ["alpha":1, "beta":2, "gamma":3][name]!
    }
}

class ConfigurableRecordFinder {
    let database: Database
    init(_ database: Database) {
        self.database = database
    }
    
    func totalPpoulation(_ names: [String]) -> Int {
        var result = 0
        for name in names {
            result += database.getPopulation(name)
        }
        return result
    }
}

class SingletonTests {
    func test_singletonPopulationTest() {
        let rf = SingletonRecordFinder()
        let names = ["Seoul","Mexico City"]
        let tp = rf.totalPpoulation(names)
        print(tp == (17500000+17400000))
    }
    
    func test_dependantTotalPopulationTest() {
        let db = DummyDatabase()
        let names = ["alpha", "gamma"]
        let rf = ConfigurableRecordFinder(db)
        print(rf.totalPpoulation(names) == 4)
        
    }
}

func main() {
    SingletonTests().test_singletonPopulationTest()
    SingletonTests().test_dependantTotalPopulationTest()
}

func main_old() {
    let db = SingletonDatabase.instance
    var city = "Tokyo"
    print("\(city) has population \(db.getPopulation(city))")
    
    let db2 = SingletonDatabase.instance
    city = "Manila"
    print("\(city) has population \(db2.getPopulation(city))")
    print(SingletonDatabase.instanceCount)
}

struct Monostate {
    
    class CEO : CustomStringConvertible {
        private static var _name = ""
        private static var _age = 0
        
        var name: String {
            get { return type(of: self)._name }
            set(value) { type(of: self)._name = value }
        }
        
        var age: Int {
            get { return type(of: self)._age }
            set(value) { type(of: self)._age = value }
        }
        
        var description: String {
            return "\(name) is \(age) years old."
        }
    }
    
    static func main() {
        let ceo = CEO()
        ceo.name = "Adam Smith"
        ceo.age = 55
        
        let ceo2 = CEO()
        ceo.age = 65
        
        print(ceo)
        print(ceo2)
    }
}

// --- TEST ---

/*
 
 Singleton Coding Exercise
 Since implementing a singleton is easy, you have a different challenge: write a method called isSingleton() . This method takes a lambda (actually, a factory method) that returns an object and it's up to you to determine whether or not the object being returned is, in fact, a singleton.
 
 */

struct Test {
    class SingletonTester
    {
        static func isSingleton(factory: () -> AnyObject) -> Bool
        {
            /*
             Solution: Instantiate 2 instances of the factory object, get their memory addresses, then compare the addresses
             Rationale: Instances of Singletons will point to the same memory address vs. instances of regular Classes
            */
            
            let obj1 = factory()
            let obj2 = factory()
            let objAdd = Unmanaged.passUnretained(obj1).toOpaque()
            let obj2Add = Unmanaged.passUnretained(obj2).toOpaque()
            return objAdd == obj2Add
        }
    }
    
    static func main() {
        class Foo { static let instance = Foo(); private init(){} }
        
        class Bar {}
        
        func makeFoo() -> Foo { return Foo.instance }
        
        func makeBar() -> Bar { return Bar() }
        
        print(SingletonTester.isSingleton(factory: makeFoo))
        print(SingletonTester.isSingleton(factory: makeBar))
    }
}

//main_old()
//main()
//Monostate.main()
Test.main()

// ********* END SINGLETONS ***********

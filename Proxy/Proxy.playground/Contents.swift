import UIKit
import Foundation

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

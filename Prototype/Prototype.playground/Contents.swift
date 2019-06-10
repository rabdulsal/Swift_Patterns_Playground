import UIKit
import Foundation

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

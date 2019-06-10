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

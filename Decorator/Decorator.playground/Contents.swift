import UIKit
import Foundation

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
    
    /*
     Decorator Coding Exercise
     The following code scenario shows a Dragon  which is both a Bird  and a Lizard .
     
     Complete the Dragon 's interface (there's no need to extract protocols out of either Bird  or Lizard ).
     
     Take special care when implementing the Age  property!
     
    */
    struct Test {
        class Bird
        {
            var age = 0
            
            func fly() -> String
            {
                return (age < 10) ? "flying" : "too old"
            }
        }

        class Lizard
        {
            var age = 0
            
            func crawl() -> String
            {
                return (age > 1) ? "crawling" : "too young"
            }
        }

        class Dragon
        {
            // todo: reuse bird/lizard functionality here
            private var birdlike = Bird()
            private var lizardlike = Lizard()
            var age = 0
            
//            var age: Int {
//                /* todo */
//
//
//                return _age
//            }
            func fly() -> String {
                /* todo */
                
                
                return birdlike.fly()
            }
            func crawl() -> String {
                /* todo */
                return lizardlike.crawl()
            }
        }
        
        static func main() {
            let dragon = Dragon()
            dragon.age = 20
            dragon.fly() // Should say "flying"?
            dragon.crawl() // Should say "too young"?
        }
    }
}
//Decorator().staticMain()
//Decorator.Test.main()
// ******** END DECORATOR *********

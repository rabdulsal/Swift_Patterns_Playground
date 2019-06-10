import UIKit
import Foundation

// ****** STRATEGY ********

// DEFINITION: Enables the exact behavior of a system to be selected either at run-time (dynamic) or compile-time (static). Also known as a 'policy' (esp. in the C++ world).
protocol ListStrategy {
    
    init()
    func start(_ buffer: inout String)
    func end(_ buffer: inout String)
    func addListItem(buffer: inout String, item: String)
}

struct Strategy {
    
    // --- Dynamic Strategy
    
    struct DynamicStrategy {
        enum OutputFormat {
            case markdown
            case html
        }
        
        class TextProcessor : CustomStringConvertible {
            
            private var buffer = ""
            private var listStrategy: ListStrategy
            var description: String { return buffer }
            
            init(_ outputFormat: OutputFormat) {
                switch outputFormat {
                case .markdown:
                    listStrategy = MarkdownListStrategy()
                case .html:
                    listStrategy = HtmlListStrategy()
                }
            }
            
            func setOutputFormat(_ outputFormat: OutputFormat) {
                switch outputFormat {
                case .markdown:
                    listStrategy = MarkdownListStrategy()
                case .html:
                    listStrategy = HtmlListStrategy()
                }
            }
            
            func appendList(_ items: [String]) {
                listStrategy.start(&buffer)
                for item in items {
                    listStrategy.addListItem(buffer: &buffer, item: item)
                }
                listStrategy.end(&buffer)
            }
            
            func clear() {
                buffer = ""
            }
        }
        
        class MarkdownListStrategy: ListStrategy {
            required init() {}
            func start(_ buffer: inout String) {
            
            }
            func end(_ buffer: inout String) {
                
            }
            func addListItem(buffer: inout String, item: String) {
                buffer.append(" * \(item)\n")
            }
        }
        
        class HtmlListStrategy: ListStrategy {
            required init() {}
            func start(_ buffer: inout String) {
                buffer.append("<ul>\n")
            }
            func end(_ buffer: inout String) {
                buffer.append("</ul>\n")
            }
            func addListItem(buffer: inout String, item: String) {
                buffer.append("  <li>\(item)</li>\n")
            }
        }
        
        static func main() {
            let tp = TextProcessor(.markdown)
            tp.appendList(["foo","bar", "baz"])
            print(tp)
            
            tp.clear()
            tp.setOutputFormat(.html)
            tp.appendList(["foo","bar", "baz"])
            print(tp)
        }
    }
    // --- End Dynamic Strategy
    
    struct StaticStrategy {
        
        enum OutputFormat {
            case markdown
            case html
        }
        
        class TextProcessor<LS> : CustomStringConvertible where LS: ListStrategy {
            
            private var buffer = ""
            private var listStrategy = LS()
            var description: String { return buffer }
            
            func appendList(_ items: [String]) {
                listStrategy.start(&buffer)
                for item in items {
                    listStrategy.addListItem(buffer: &buffer, item: item)
                }
                listStrategy.end(&buffer)
            }
            
            func clear() {
                buffer = ""
            }
        }
        
        class MarkdownListStrategy: ListStrategy {
            required init() {}
            func start(_ buffer: inout String) {
                
            }
            func end(_ buffer: inout String) {
                
            }
            func addListItem(buffer: inout String, item: String) {
                buffer.append(" * \(item)\n")
            }
        }
        
        class HtmlListStrategy: ListStrategy {
            required init() {}
            func start(_ buffer: inout String) {
                buffer.append("<ul>\n")
            }
            func end(_ buffer: inout String) {
                buffer.append("</ul>\n")
            }
            func addListItem(buffer: inout String, item: String) {
                buffer.append("  <li>\(item)</li>\n")
            }
        }
        static func main() {
            let tp = TextProcessor<MarkdownListStrategy>()
            tp.appendList(["foo","bar", "baz"])
            print(tp)
            
            let tp2 = TextProcessor<HtmlListStrategy>()
            tp2.appendList(["foo","bar", "baz"])
            print(tp2)
        }
    }
    // --- End Static Strategy
    
    
    
    // --- Test ---
    
    struct Test {
        
        /*
         
         
         Strategy Coding Exercise
         Consider the quadratic equation and its canonical solution:
         
         
         
         The part b^2-4*a*c is called the discriminant. Suppose we want to provide an API with two different strategies for calculating the discriminant:
         
         In OrdinaryDiscriminantStrategy , If the discriminant is negative, we simply return the discriminant as-is.
         In RealDiscriminantStrategy , if the discriminant is negative, the return value is NaN (not a number). NaN propagates throughout the calculation, so the equation solver gives two NaN values.
         Please implement both of these strategies as well as the equation solver itself. With regards to plus-minus in the formula, please return the + result as the first element and - as the second.
        */
        
        class OrdinaryDiscriminantStrategy : DiscriminantStrategy
        {
            // todo
            func calculateDiscriminant(_ a: Double, _ b: Double, _ c
                : Double) -> Double {
                
                return 0.0
            }
        }
        class RealDiscriminantStrategy : DiscriminantStrategy
        {
            // todo
            func calculateDiscriminant(_ a: Double, _ b: Double, _ c
                : Double) -> Double {
                
                return 0.0
            }
        }
        static func main() {
            
        }
    }
}

protocol DiscriminantStrategy
{
    func calculateDiscriminant(_ a: Double, _ b: Double, _ c
        : Double) -> Double
}
//Strategy.DynamicStrategy.main()
//Strategy.StaticStrategy.main()

// ***** END STRATEGY ******

import UIKit
import Foundation

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

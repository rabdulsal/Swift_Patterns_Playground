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
    
    static func main1() {
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
    
    static func main2() {
        let ft = FormattedText("This is a brave new world")
        ft.capitalize(10,15)
        print(ft)
        
        let bft = BetterFormattedText("This is a brave new world")
        bft.getRange(10, 15).capitalize = true
        print(bft)
    }
    
    // --- TEST ---
    /*
     Flyweight Coding Exercise
     You are given a class called Sentence , which takes a string such as "hello world". You need to provide an interface such that the subscript of the class returns a WordToken  which can be used to capitalize a particular word in the sentence.
     
     Typical use would be something like:
     
     var sentence = Sentence("hello world")
     sentence[1].capitalize = true
     print(sentence); // writes "hello WORLD"
    */
    struct Test {
        class Sentence : CustomStringConvertible
        {
            private var buffer: String
            private var formattingBuffer = WordToken()
            init(_ plainText: String)
            {
                self.buffer = plainText
            }

            subscript(index: Int) -> WordToken
            {
                let desiredPhrase = self.buffer.components(separatedBy: .whitespaces)[index]
                formattingBuffer = WordToken(desiredPhrase)
                return formattingBuffer
            }
            
            var description: String
            {
                let stringToFormat = formattingBuffer.targetText
                let formattedString = formattingBuffer.capitalize ? formattingBuffer.targetText.uppercased() : stringToFormat
                return buffer.replacingOccurrences(of: stringToFormat, with: formattedString)
            }
            class WordToken
            {
                var capitalize: Bool = false
                var targetText: String = ""
                init(){}
                init(_ text: String) {
                    targetText = text
                }
            }
        }
        
        static func main() {
            let sentence = Sentence("hello world")
            sentence[1].capitalize = true
            print("\(sentence)" == "hello WORLD") // writes "hello WORLD"
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

//FlyWeight.main()
//FlyWeight.main2()
FlyWeight.Test.main()

// ******** END FLYWEIGHT ***********

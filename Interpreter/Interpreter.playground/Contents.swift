import UIKit
import Foundation

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

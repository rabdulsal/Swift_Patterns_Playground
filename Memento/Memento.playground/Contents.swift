import UIKit
import Foundation

// ***** MEMENTO ******

// DEFINITION: A token/handle representing the system state. Let us roll back to the state when the token was generated. May or may not directly expose state information.

struct Memento {
    
    class BankAccount : CustomStringConvertible {
        
        var description: String {
            return "Balance - \(balance)"
        }
        
        private var balance: Int
        private var changes = [Memento]()
        private var current = 0
        
        init(_ balance: Int) {
            self.balance = balance
            changes.append(Memento(balance))
        }
        
        func deposit(_ amount: Int) -> Memento {
            balance += amount
            let m = Memento(balance)
            changes.append(m)
            current += 1
            return m
        }
        
        func undo() -> Memento? {
            if current > 0 {
                current -= 1
                let m = changes[current]
                balance = m.balance
                return m
            }
            return nil
        }
        
        func redo() -> Memento? {
            if (current+1) < changes.count {
                current += 1
                let m = changes[current]
                balance = m.balance
                return m
            }
            return nil
        }
        
        func restore(_ m: Memento?) {
            if let mm = m {
                balance = mm.balance
                changes.append(mm)
                current = changes.count-1
            }
        }
        
        class Memento {
            let balance: Int
            init(_ balance: Int) {
                self.balance = balance
            }
        }
    }
    
    static func main() {
        let ba = BankAccount(100)
        let m1 = ba.deposit(50)
        let m2 = ba.deposit(25)
        print(ba)
        
        ba.undo()
        print("Undo 1: \(ba)")
        ba.undo()
        print("Undo 2: \(ba)")
        ba.redo()
        print("Redo 1: \(ba)")
        
    }
    
    // --- TEST ---
    
    struct Test {
        /*
         Memento Coding Exercise
         You are given a class called TokenMachine which keeps tokens. Each token is a class with a single value. The TokenMachine actually has two members: one takes an integer and another takes an already-made token.
         
         Both overloads need to add its tokens to the set of tokens and return a Memento that allows us to subsequently call revert(to:) to roll the system back to the original state.
         
         Please implement the missing members.
        */
        
        class Token
        {
            var value = 0
            init(_ value: Int)
            {
                self.value = value
            }
            // todo: any extra members you need
            
            // please keep this operator! it will be
            // used for testing!
            static func ==(_ lhs: Token, _ rhs: Token) -> Bool
            {
                return lhs.value == rhs.value
            }
        }
        
        class Memento
        {
            var tokens = [Token]()
            
            init(_ tokens: [Token]) {
                self.tokens = tokens
            }
        }
        
        class TokenMachine
        {
            var tokens = [Token]()
            
            private var changes = [Memento]()
            private var current = 0
            
            func addToken(_ value: Int) -> Memento
            {
                let token = Token(value)
                tokens.append(token)
                let memento = Memento(tokens)
                changes.append(memento)
                current += 1
                return memento
            }
            
            func addToken(_ token: Token) -> Memento
            {
                tokens.append(token)
                let memento = Memento(tokens)
                changes.append(memento)
                current += 1
                return memento
            }
            
            func revert(to m: Memento?)
            {
                if let memento = m {
                    tokens = memento.tokens
                    changes.append(memento)
                    current = changes.count-1
                }
            }
        }
        
        static func main() {
            
        }
    }
}

//Memento.main()
//Memento.Test.main()

// **** END MEMENTO *****

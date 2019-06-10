import UIKit
import Foundation

// ********* COMMAND ********

// DEFINITION: An object which represents and instruction to perform a particular action, continain all the information necessary for the action to be taken

struct Command_Pattern {
    
    class BankAccount : CustomStringConvertible {
        private var balance = 0
        private let overdraftLimit = -500
        
        var description: String {
            return "Balance = \(balance)"
        }
        
        func deposit(_ amount: Int) {
            balance += amount
            print("Deposited \(amount), balance is now \(balance)")
        }
        
        func withdraw(_ amount: Int) -> Bool {
            if (balance - amount >= overdraftLimit) {
                balance -= amount
                print("Withdrew \(amount), balance is now \(balance)")
                return true
            }
            return false
        }
    }
    
    static func main() {
        let ba = BankAccount()
        let commands = [
            BankAccountCommand(ba, .deposit, 100),
            BankAccountCommand(ba, .withdraw, 25)
        ]
        
        print(ba)
        
        commands.forEach{ $0.call() }
        
        print(ba)
        
        commands.reversed().forEach{ $0.undo() }
        
        print(ba)
    }
    
    class BankAccountCommand : Command {
        private var account: BankAccount
        
        enum Action {
            case deposit, withdraw
        }
        
        private var action: Action
        private var amount: Int
        private var succeeded = false
        
        init(_ account: BankAccount, _ action: Action, _ amount: Int) {
            self.account = account; self.action = action; self.amount = amount
        }
        
        func call() {
            switch action {
            case .deposit:
                account.deposit(amount)
                succeeded = true
            case .withdraw:
                succeeded = account.withdraw(amount)
            }
        }
        
        func undo() {
            if !succeeded { return }
            
            switch action {
            case .deposit:
                account.withdraw(amount)
            case .withdraw:
                account.deposit(amount)
            }
        }
    }
    
    struct Test {
        class Command
        {
            enum Action
            {
                case deposit
                case withdraw
            }
            
            var action: Action
            var amount: Int
            var success = false
            
            init(_ action: Action, _ amount: Int)
            {
                self.action = action
                self.amount = amount
            }
        }
        
        class Account
        {
            private let zeroBalance = 0
            var balance = 0
            
            func process(_ c: Command)
            {
                // todo
                switch c.action {
                case .deposit:
                    deposit(c.amount)
                    c.success = true
                case .withdraw:
                    c.success = withdraw(c.amount)
                }
            }
            
            func deposit(_ amount: Int) {
                balance += amount
                print("Deposited \(amount), balance is now \(balance)")
            }
            
            func withdraw(_ amount: Int) -> Bool {
                if (balance - amount > zeroBalance) {
                    balance -= amount
                    print("Withdrew \(amount), balance is now \(balance)")
                    return true
                }
                return false
            }
        }
        
        static func main() {
            let commands1 =  [
                Command(.deposit, 100),
                Command(.withdraw, 99)
            ]
            let commands2 =  [
                Command(.deposit, 100),
                Command(.withdraw, 101)
            ]
            let a = Account()
            a.process(commands2[0])
            a.process(commands2[1])
            
            print(a.balance == 100)
        }
    }
}

protocol Command {
    func call()
    func undo()
}

//Command_Pattern.main()
//Command_Pattern.Test.main()

// ******* END COMMAND *******

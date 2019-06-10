import UIKit
import Foundation

// ***** NULL OBJECT *****

// DEFINITION: A no-op oject that conforms to the required ointerface, satisfying a dependency requirement of some other object.

protocol NullObject_Log {
    func info(_ msg: String)
    func warn(_ msg: String)
}

struct NullObject {
    
    class ConsoleLog : NullObject_Log {
        func info(_ msg: String) {
            print(msg)
        }
        
        func warn(_ msg: String) {
            print("WARNING: \(msg)")
        }
    }
    
    class BankAccount {
        var balance = 0
        var log: NullObject_Log
        
        init(_ log: NullObject_Log) {
            self.log = log
        }
        
        func deposit(_ amount: Int) {
            balance += amount
            log.info("Deposited \(amount), balance is now \(balance)")
        }
    }
    
    class NullLog : NullObject_Log {
        func info(_ msg: String) {}
        func warn(_ msg: String) {}
    }
    
    
    static func main() {
//        let log = ConsoleLog()
        let log = NullLog()
        let ba = BankAccount(log)
        ba.deposit(100)
    }
    
    // --- TEST ---
    
    /*
     Null Object Coding Exercise
     In this example, we have a class Account  that is very tightly coupled to the Log protocol... it also breaks SRP by performing all sorts of weird checks in someOperation() .
     
     Your mission, should you choose to accept it, is to implement a NullLog  class that can be fed into an Account  and that doesn't throw any exceptions, for virtually infinite repetitions.
    */
    
    struct Test {
        
        
        enum LogError : Error
        {
            case recordNotUpdated
            case logSpaceExceeded
        }
        
        class Account
        {
            private var log: Log
            
            init(_ log: Log)
            {
                self.log = log
            }
            
            func someOperation() throws
            {
                let c = log.recordCount
                log.logInfo("Performing an operation")
                if (c+1) != log.recordCount
                {
                    throw LogError.recordNotUpdated
                }
                if log.recordCount >= log.recordLimit
                {
                    throw LogError.logSpaceExceeded
                }
            }
        }
        
        class NullLog : Log
        {
            var recordLimit: Int = 2
            
            var recordCount: Int = 0
            
            func logInfo(_ message: String) {
                print(message)
                recordCount += 1
                recordLimit += 1
            }
        }
        
        static func main() {
            let nL = NullLog()
            let a = Account(nL)
            for _ in 0...10 {
                do {
                    try a.someOperation()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

protocol Log
{
    var recordLimit: Int { get }
    var recordCount: Int { get set }
    func logInfo(_ message: String)
}

//NullObject.Test.main()

// *** END NULL OBJECT ****

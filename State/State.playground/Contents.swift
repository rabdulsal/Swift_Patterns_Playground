import UIKit
import Foundation

// ******** STATE *********

// DEFINITION: A pattern in which the object's behavior is determined by its state. An object transitions from one state to another (something needs to trigger a transition). A formalized contstruct which manages state and transitions is called a *state machine*.


struct State {
    
    enum State {
        case offHook, connecting, connected, onHold
    }
    
    enum Trigger {
        case callDialed, hungUp, callConnected, placedOnHold, takenOffHold, leftMessage
    }
    
    let rules = [
        State.offHook : [
            (Trigger.callDialed, State.connecting)
        ],
        State.connecting: [
            (Trigger.hungUp, State.offHook),
            (Trigger.callConnected, State.connected)
        ],
        State.connected: [
            (Trigger.leftMessage, State.offHook),
            (Trigger.hungUp, State.offHook),
            (Trigger.placedOnHold, State.onHold)
        ],
        State.onHold: [
            (Trigger.takenOffHold, State.connected),
            (Trigger.hungUp, State.offHook)
        ]
    ]
    func main() {
        var state = State.offHook
        
        while true {
            print("The phone is currently \(state)")
            print("Select a trigger:")
            
            for i in 0..<rules[state]!.count {
                let (t, _) = rules[state]![i]
                print("\(i), \(t)")
            }
            
            if let input = Int(readLine()!) {
                let (_, s) = rules[state]![input]
                state = s
            }
        }
    }
    
    
    struct Test {
        
        
        static func main() {
            
        }
    }
}

//State().main()

// ****** END STATE ******

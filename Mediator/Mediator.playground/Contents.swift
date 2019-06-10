import UIKit
import Foundation

// ******* MEDIATOR **********

// DEFINITION: A component that facilitates communication between other components w/out them necessarily being aware of each other or having direact (reference) access to each other

struct Mediator {
    
    class Person {
        var name: String
        var room: ChatRoom?=nil
        private var chatLog = [String]()
        
        init(_ name: String) {
            self.name = name
        }
        
        func say(_ message: String) {
            room?.broadcast(sender: name, message: message)
        }
        
        func receive(sender: String, message: String) {
            let s = "\(sender): `\(message)`"
            print("[\(name)'s chat session \(s)]")
            chatLog.append(s)
        }
        
        func privateMessage(to target: Person, message: String) {
            room?.message(sender: name, destination: target.name, message: message)
        }
    }
    
    class ChatRoom {
        private var people = [Person]()
        
        func broadcast(sender: String, message: String) {
            for p in people {
                if p.name != sender {
                    p.receive(sender: sender, message: message)
                }
            }
        }
        
        func join(_ p: Person) {
            let joinMsg = "\(p.name) joins the chat"
            broadcast(sender: "room", message: joinMsg)
            p.room = self
            people.append(p)
        }
        
        func message(sender: String, destination: String, message: String) {
            people.first { $0.name == destination }?.receive(sender: sender, message: message)
        }
    }
    
    static func main() {
        let room = ChatRoom()
        let john = Person("John")
        let jane = Person("Jane")
        
        room.join(john)
        room.join(jane)
        
        john.say("hi room")
        jane.say("oh, hey john")
        
        let simon = Person("Simon")
        room.join(simon)
        simon.say("hi everyone!")
        
        jane.privateMessage(to: simon, message: "glad you could join us!")
    }
    
    // --- TEST ---
    
    struct Test {
        /*
            Mediator Coding Exercise
            Our system has any number of instances of Participant  classes. Each Participant has a Value  integer, initially zero.
         
            A participant can Say()  a particular value, which is broadcast to all other participants. At this point in time, every other participant is obliged to increase their Value  by the value being broadcast.
         
            Example:
         
            Two participants start with values 0 and 0 respectively
            Participant 1 broadcasts the value 3. We now have Participant 1 value = 0, Participant 2 value = 3
            Participant 2 broadcasts the value 2. We now have Participant 1 value = 2, Participant 2 value = 3
        */
        
        class Participant : Equatable, CustomStringConvertible
        {
            static func == (lhs: Participant, rhs: Participant) -> Bool {
                return lhs.id == rhs.id
            }
            
            private let mediator: Mediator
            var value = 0
            private let id: Int
            
            var description: String {
                let pID = self.mediator.participants.firstIndex(of: self)!
                return "\(pID) value: \(self.value)"
            }
            
            init(_ mediator: Mediator)
            {
                self.mediator = mediator
                self.id = mediator.participants.count
                self.mediator.participants.append(self)
            }
            
            func say(_ n: Int)
            {
                self.mediator.broadcast(self, n)
            }
        }
        
        class Mediator : CustomStringConvertible
        {
            var participants = [Participant]()
            
            var description: String {
                return "Participants count: \(self.participants.count)"
            }
            init(){}
            
            func broadcast(_ broadCaster: Participant, _ value: Int) {
                for participant in participants where participant != broadCaster {
                    participant.value += value
                }
            }
        }
        
        static func main() {
            let mediator = Mediator()
            let p1 = Participant(mediator)
            let p2 = Participant(mediator)
            
            print(mediator)
            print(p1)
            print(p2)
            
            p1.say(3)
            p2.say(2)
            
            print(p1)
            print(p2)
        }
    }
}

//Mediator.main()
//Mediator.Test.main()

// ******* END MEDIATOR ********

import UIKit
import Foundation

// ******* OBSERVER *******

// DEFINITION: An observer is an object that wishes to be informed about events happening in the system. The entity generating the events is an 'observable'

protocol Observer_Invocable : class {
    func invoke(_ data: Any)
}

protocol Observer_Disposable {
    func dispose()
}

struct Observer {
    
    class Person {
        
        // event
        let fallsIll = Event<String>()
        
        init(){}
        
        func catchCold() {
            fallsIll.raise("123 London Road")
        }
    }
    
    class Demo {
        init() {
            let p = Person()
            let sub = p.fallsIll.addHandler(
                target: self, handler: Demo.callDoctor
            )
            
            p.catchCold()
            
            sub.dispose()
            
            p.catchCold()
        }
        func callDoctor(address: String) {
            print("We need a doctor at \(address)")
        }
    }
    
    static func main() {
        let _ = Demo()
    }
    
    class Event<T> {
        typealias EventHandler = (T) -> ()
        var eventHandlers = [Observer_Invocable]()
        
        func raise(_ data: T) {
            for handler in eventHandlers {
                handler.invoke(data)
            }
        }
        
        func addHandler<U: AnyObject>(
            target: U,
            handler: @escaping (U) -> EventHandler) -> Observer_Disposable {
            let subscription = Subscription(target: target, handler: handler, event: self)
            eventHandlers.append(subscription)
            return subscription
        }
    }
    
    class Subscription<T: AnyObject, U> : Observer_Invocable, Observer_Disposable {
        weak var target: T?
        let handler: (T) -> (U) -> ()
        let event: Event<U>
        
        init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
            self.target = target; self.event = event; self.handler = handler
        }
        
        func invoke(_ data: Any) {
            if let t = target {
                handler(t)(data as! U)
            }
        }
        
        func dispose() {
            event.eventHandlers = event.eventHandlers.filter
                { $0 as AnyObject? !== self }
        }
    }
    
    // --- Example 2 ---
    
    struct PropertyObserver {
        
        class Person {
            var age: Int = 0 {
                willSet(newValue) {
                    print("About to set age to \(newValue)")
                }
                didSet {
                    print("we just changed age from \(oldValue) to \(age)")
                }
            }
        }
        
        class Demo {
            
            init(){
                let p = Person()
                p.age = 20
                p.age = 22
            }
        }
        
        static func main() {
            let _ = Demo()
        }
    }
    
    struct DependentPropertyObserver {
        
        class Person {
            private var oldCanVote = false
            var age: Int = 0 {
                willSet(newValue) {
                    print("About to set age to \(newValue)")
                    oldCanVote = canVote
                }
                didSet {
                    print("we just changed age from \(oldValue) to \(age)")
                    
                    if age != oldValue {
                        propertyChanged.raise(("age", age))
                    }
                    if canVote != oldCanVote {
                        propertyChanged.raise(("canVote", canVote))
                    }
                }
            }
            
            var canVote : Bool {
                return age >= 16
            }
            
            let propertyChanged = Event<(String, Any)>()
        }
        
        class Person2 {
            private var _age: Int = 0
            
            var age: Int {
                get { return _age }
                set(value) {
                    if _age == value { return }
                    
                    // cache
                    let oldCanvote = canVote
                    
                    let cancelSet = RefBool(false)
                    propertyChanging.raise(("age", value, cancelSet))
                    if cancelSet.value { return }
                    
                    // assigne & notify
                    _age = value
                    propertyChanged.raise(("age", _age))
                    if oldCanvote != canVote { propertyChanged.raise(("canVote",canVote)) }
                }
            }
            
            var canVote: Bool { return age >= 16 }
            
            let propertyChanged = Event<(String, Any)>()
            let propertyChanging = Event<(String, Any, RefBool)>()
        }
        
        final class RefBool {
            var value: Bool
            init(_ value: Bool) {
                self.value = value
            }
        }
        
        class Demo {
            
            init(){
                let p = Person2()
                p.propertyChanged.addHandler(target: self, handler: Demo.propChanged)
                p.propertyChanging.addHandler(target: self, handler: Demo.propChanging)
                p.age = 20
                p.age = 22
                
                p.age = 12
            }
            
            func propChanged(args: (String, Any)) {
                var prependedString = ""
                switch args.0 {
                case "age": prependedString = "Person's age"
                case "canVote": prependedString = "Voting status"
                default: break
                }
                print("\(prependedString) has changed to \(args.1)")
            }
            
            func propChanging(args: (String, Any, RefBool)) {
                if args.0 == "age" && (args.1 as! Int) < 14 {
                    print("Cannot allow setting age < 14")
                    args.2.value = true
                }
            }
        }
        
        static func main() {
            let _ = Demo()
        }
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    struct Test {
        
        /*
         Observer Coding Exercise
         Imagine a game where one or more rats can attack a player. Each individual rat has an attack  value of 1. However, rats attack as a swarm, so each rat's attack  value is equal to the total number of rats in play.
         
         Given that a rat enters play through the constructor and leaves play (dies) via its kill()  method (rat murder is satisfying!), please implement the Game  and Rat  classes so that, at any point in the game, the attack  value of a rat is always consistent.
         
         This exercise has two simple rules:
         
         The Game class cannot contain properties. It can only contain events and methods.
         The Rat class' attack property is strictly defined as var attack = 1 , i.e. it doesn't have a custom getter or setter.
        */
        
        class Event<T> {
            typealias EventHandler = (T) -> ()
            var eventHandlers = [Observer_Invocable]()
            
            func raise(_ data: T) {
                for handler in eventHandlers {
                    handler.invoke(data)
                }
            }
            
            func addHandler<U: AnyObject>(
                target: U,
                handler: @escaping (U) -> EventHandler) -> Observer_Disposable {
                let subscription = Subscription(target: target, handler: handler, event: self)
                eventHandlers.append(subscription)
                return subscription
            }
        }
        
        class Subscription<T: AnyObject, U> : Observer_Invocable, Observer_Disposable {
            weak var target: T?
            let handler: (T) -> (U) -> ()
            let event: Event<U>
            
            init(target: T?, handler: @escaping (T) -> (U) -> (), event: Event<U>) {
                self.target = target; self.event = event; self.handler = handler
            }
            
            func invoke(_ data: Any) {
                if let t = target {
                    handler(t)(data as! U)
                }
            }
            
            func dispose() {
                event.eventHandlers = event.eventHandlers.filter
                    { $0 as AnyObject? !== self }
            }
        }
        
        class Game
        {
            // todo - Will likely need a method/notification to fire whenever a new Rat instance is created, to update RatAttackModifier packCount
            
            func ratJoinedPack(_ rat: Rat) {
                // Pass in rat as variable, and
                // Set listener for Rat so when a new rat joins previous Rat(s) are notified
                // Set listener for Rat to respond when other rats announce packCount
                // Fire Notification 'New Rat has joined"
                RatAttackModifier.ratPackChangedAttack.addHandler(target: self, handler: Game.updatePackAttack)
                RatAttackModifier.addRatToPack(rat)
            }
            
            func ratLeftPack(_ rat: Rat) {
                RatAttackModifier.ratWasKilled.addHandler(target: self, handler: Game.resetKilledRat)
                RatAttackModifier.removeRatFromPack(rat)
            }
            
            func updatePackAttack(_ attackValue: Int) {
                // Pass in pack count as Int
                // Fire Notification
                RatAttackModifier.updatePackAttack(attackValue)
            }
            
            func resetKilledRat(rat: Rat) {
                rat.resetAttack()
            }
        }
        
        class Rat : CustomStringConvertible, Equatable
        {
            static func == (lhs: Observer.Test.Rat, rhs: Observer.Test.Rat) -> Bool {
                return lhs.id == rhs.id
            }
            
            /*
             Publishes events to Game object when rats enter/leave the Game
            */
            private let game: Game
            var attack = 1
            var id = 0
            
            var description: String {
                return "My attack is \(attack)"
            }
            
            let ratPackChanged = Event<Int>()
            
            init(_ game: Game)
            {
                /*
                 Inform Game existence of new Rat, and subscribe to RAM events
                */
                self.game = game
                self.game.ratJoinedPack(self)
            }
            
            func kill() {
                /*
                 Inform Game of desistance of specific Rat, and unsubscribe to RAM events?
                */
                game.ratLeftPack(self)
            }
            
            func resetAttack() {
                attack = 1
            }
        }
        
        /*
         Class with static reference to Array of current Rats in Game, and tracks count
         Fires events to notify member rats to update attack values
        */
        class RatAttackModifier : NSObject {
            private static var ratPack = [Rat]()
            private static var packCount : Int {
                /*
                 1. Listens for updates from Game as new Rat created, and increases packCount
                 2. Triggers 'packCountNotification' back to the Game
                 3. value will increase

                 */
                return ratPack.count
            }

            static let ratPackChangedAttack = Event<Int>()
            static let ratWasKilled = Event<Rat>()
//            static let propertyChanging = Event<(String, Any, RefBool)>()

            static func addRatToPack(_ rat: Rat) {
                rat.id = ratPack.count
                self.ratPack.append(rat)
                ratPackChangedAttack.raise(packCount)
            }

            static func removeRatFromPack(_ rat: Rat) {
                self.ratPack.remove(at: ratPack.index(of: rat) ?? 0)
                ratWasKilled.raise(rat)
                ratPackChangedAttack.raise(packCount)
            }

            static func updatePackAttack(_ value: Int) {
                for rat in ratPack {
                    rat.attack = value
                }
            }
        }
        
        static func main() {
            /*
             As new rat instances are created, each individual rat's attack value should increase to match total rat instances (packCount), included the newest rat instance created
            */
            let g = Game()
            let r1 = Rat(g)
            print("Rat1: \(r1)")
            let r2 = Rat(g)
            print("Rat1: \(r1) after Rat2")
            print("Rat2: \(r2)")
            let g2 = Game()
            let r3 = Rat(g2) // FAILURE: No accounting for a separately initialized Game -- can't do g == g2
            print("Before Kill -- Rat3: \(r3)\nRat2: \(r2)\nRat1: \(r1)")
            r1.kill()
            print("After Kill -- Rat3: \(r3)\nRat2: \(r2)\nRat1: \(r1)")
        }
    }
}

//Observer.main()
//Observer.PropertyObserver.main()
//Observer.DependentPropertyObserver.main()
Observer.Test.main()


// ***** END OBSERVER **********

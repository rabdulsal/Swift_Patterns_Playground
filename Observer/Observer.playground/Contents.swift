import UIKit
import Foundation

// ******* OBSERVER *******

// DEFINITION: An observer is an object that wishes to be informed about events happening in the system. The entity generating the events is an 'observable'

protocol Invokable : class {
    func invoke(_ data: Any)
}

protocol Disposable {
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
    
    struct Test {
        
        /*
         Observer Coding Exercise
         Imagine a game where one or more rats can attack a player. Each individual rat has an attack  value of 1. However, rats attack as a swarm, so each rat's attack  value is equal to the total number of rats in play.
         
         Given that a rat enters play through the constructor and leaves play (dies) via its kill()  method (rat murder is satisfying!), please implement the Game  and Rat  classes so that, at any point in the game, the attack  value of a rat is always consistent.
         
         This exercise has two simple rules:
         
         The Game class cannot contain properties. It can only contain events and methods.
         The Rat class' attack property is strictly defined as var attack = 1 , i.e. it doesn't have a custom getter or setter.
         
         ADDED CHALLENGE:
         - Consider giving RatAttackModifier a parent CreatureModifier class which is Disposable, that initializes Games and Events (+Queries?), and can reset Rat attacks using .dispose()
         - This approach *may also obviate the need for RAM needing a Dictionary to bucket packs by gameID, as the CreatureModifier might be able to naturally scope Events
        */
        
        class Game
        {
            // todo - Will likely need a method/notification to fire whenever a new Rat instance is created, to update RatAttackModifier packCount
            
            func ratJoinedPack(_ rat: Rat) {
                // Set handler to appropriately update attack of all Rats in Game
                // Fire RAM class method to update ratPackHash
                RatAttackModifier.ratPackChangedAttack.addHandler(target: self, handler: Game.updatePackAttack)
                RatAttackModifier.addRatToPack(rat)
            }
            
            func ratLeftPack(_ rat: Rat) {
                // Set handler to appropriately update attack of all Rats in Game
                // Fire RAM class method to update ratPackHash
                RatAttackModifier.ratWasKilled.addHandler(target: self, handler: Game.resetKilledRat)
                RatAttackModifier.removeRatFromPack(rat)
            }
            
            func updatePackAttack(args: (Rat,Int)) {
                // Pass along tuple with Rat instance & Int representing packCount for said Rat
                RatAttackModifier.updatePackAttack(args.0,args.1)
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
            private let baseAttack = 1
            var attack: Int
            var gameID = 0
            var id = 0
            
            var description: String {
                return "My attack is \(attack)"
            }
            
            let ratPackChanged = Event<Int>()
            
            init(_ game: Game)
            {
                /*
                 Set relevant variables and inform Game of existence of new Rat
                */
                self.attack = baseAttack
                self.game = game
                self.gameID = unsafeBitCast(game, to: Int.self) // NOTE: New method learned -- sets gameID to memory address of Game instance
                self.game.ratJoinedPack(self)
            }
            
            func kill() {
                /*
                 Inform Game of desistance of specific Rat
                */
                game.ratLeftPack(self)
            }
            // TODO: Update to use dispose() method of Disposable protocol
            func resetAttack() {
                attack = baseAttack
            }
        }
        
        /*
         Class with static reference to Hash of current Rat-Arrays--representing current Rats in play, indexed by Rat-instance gameIDs
         Fires events to notify member rats to update attack values
        */
        class RatAttackModifier {
            private static var ratPackHash = Dictionary<Int,Array<Rat>>()

            static let ratPackChangedAttack = Event<(Rat,Int)>()
            static let ratWasKilled = Event<Rat>()

            static func addRatToPack(_ rat: Rat) {
                var ratPack = RatAttackModifier.getRatPack(rat)
                rat.id = ratPack.count
                ratPack.append(rat)
                // Update ratPackHash
                RatAttackModifier.ratPackHash[rat.gameID] = ratPack
                ratPackChangedAttack.raise((rat,ratPack.count))
            }

            static func removeRatFromPack(_ rat: Rat) {
                var ratPack = RatAttackModifier.getRatPack(rat)
                ratPack.remove(at: ratPack.firstIndex(of: rat) ?? 0)
                ratWasKilled.raise(rat)
                ratPackChangedAttack.raise((rat,ratPack.count))
            }
            
            private static func getCountForRatPack(_ rat: Rat) -> Int {
                return RatAttackModifier.getRatPack(rat).count
            }

            static func updatePackAttack(_ rat: Rat, _ value: Int) {
                let gameID = rat.gameID
                let ratPack = RatAttackModifier.getRatPack(rat)
                for rat in ratPack {
                    rat.attack = value
                }
                // Ensure ratPackHash is updated
                RatAttackModifier.ratPackHash[gameID] = ratPack
            }
            
            private static func getRatPack(_ rat: Rat) -> [Rat] {
                guard let pack = RatAttackModifier.ratPackHash[rat.gameID] else { return [Rat]() }
                return pack
            }
        }
        
        static func main() {
            /*
             As new rat instances are created, each Rat instance within a particular Game instance, should increase attack value to match total Rat instances, including the newest rat instance created
            */
            let g = Game()
            let r1 = Rat(g)
            print("Rat1: \(r1)")
            let r2 = Rat(g)
            print("Rat1: \(r1) after Rat2")
            print("Rat2: \(r2)")
            let g2 = Game()
            let r3 = Rat(g2)
            print("Rat3: \(r3)")
            r1.kill()
            let r4 = Rat(g2)
            print("After Kill: Rat4: \(r4)\nRat3: \(r3)\nRat2: \(r2)\nRat1: \(r1)")
        }
    }
}

class Event<T> {
    typealias EventHandler = (T) -> ()
    var eventHandlers = [Invokable]()
    
    func raise(_ data: T) {
        for handler in eventHandlers {
            handler.invoke(data)
        }
    }
    
    func addHandler<U: AnyObject>(
        target: U,
        handler: @escaping (U) -> EventHandler) -> Disposable {
        let subscription = Subscription(target: target, handler: handler, event: self)
        eventHandlers.append(subscription)
        return subscription
    }
}

class Subscription<T: AnyObject, U> : Invokable, Disposable {
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

//Observer.main()
//Observer.PropertyObserver.main()
//Observer.DependentPropertyObserver.main()
Observer.Test.main()


// ***** END OBSERVER **********

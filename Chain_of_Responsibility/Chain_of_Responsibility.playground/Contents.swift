import UIKit
import Foundation

// ******** CHAIN OF RESPONSIBILITY *********

// DEFINITION: A chain of components who all get a chance to process a command or a query, optionally having default processing implementation and an ability to terminate the processing chain

struct ChainOfResponsibility {
    class Creature : CustomStringConvertible {
        var name: String
        var attack: Int
        var defense: Int
        var description: String {
            return "Name: \(name), A - \(attack), D - \(defense)"
        }
        
        init(_ name: String, _ attack: Int, _ defense: Int) {
            self.name = name; self.attack = attack; self.defense = defense
        }
    }
    
    class CreatureModifier {
        let creature: Creature
        var next: CreatureModifier?
        
        init(_ creature: Creature) {
            self.creature = creature
        }
        
        func add(_ cm: CreatureModifier) {
            if next != nil {
                next!.add(cm)
            } else {
                next = cm
            }
        }
        
        func handle() {
            next?.handle()
        }
    }
    
    class DoubleAttackModifier : CreatureModifier {
        override func handle() {
            print("Doubling \(creature.name)'s attack")
            creature.attack *= 2
            super.handle()
        }
    }
    
    class IncreaseDefenceModifier : CreatureModifier {
        override func handle() {
            print("Increasing \(creature.name)'s defense ")
            creature.defense += 3
            super.handle()
        }
    }
    
    class NoBonusesModifier : CreatureModifier {
        override func handle() {
            // Do nothing so no bonuses if say cursed by a witch
        }
    }
    
    func main() {
        let goblin = Creature("Goblin", 2, 2)
        print(goblin)
        
        let root = CreatureModifier(goblin)
        
        print("Cursed by Witch!")
        root.add(NoBonusesModifier(goblin))
        
        print("Let's double the goblin's attack")
        root.add(DoubleAttackModifier(goblin))
        
        print("Let's increase goblin's defense")
        root.add(IncreaseDefenceModifier(goblin))
        
        root.handle()
        print(goblin)
    }
    
    // ~~~~ BROKER CHAIN ~~~~
    struct  Broker {
        
        class Game {
            let queries = Event<Query>()
            
            func performQuery(_ q: Query) {
                queries.raise(q)
            }
        }
        
        class Creature : CustomStringConvertible {
            var name: String
            private let _attack, _defense: Int
            private let game: Game
            
            var description: String {
                return "Name: \(name), A - \(attack), D - \(defense)"
            }
            init(_ game: Game, _ name: String, _ attack: Int, _ defense: Int) {
                self.game = game; self.name = name; _attack = attack; _defense = defense
            }
            
            var attack: Int {
                let q = Query(name, .attack, _attack)
                game.performQuery(q)
                return q.value
            }
            
            var defense: Int {
                let q = Query(name, .defense, _defense)
                game.performQuery(q)
                return q.value
                
            }
        }
        
        class CreatureModifier : Disposable {
            let game: Game
            let creature: Creature
            var event: Disposable? = nil
            
            init(_ game: Game, _ creature: Creature) {
                self.game = game; self.creature = creature; event = self.game.queries.addHandler(target: self, handler: CreatureModifier.handle)
            }
            
            func handle(_ q: Query) {
                // Do nothing to indicate no modifications made
            }
            
            func dispose() {
                event?.dispose()
            }
        }
        
        class DoubleAttackModifier: CreatureModifier {
            override func handle(_ q: Query) {
                if q.creatureName == creature.name && q.whatToQuery
                 == .attack {
                    q.value *= 2
                }
            }
        }
        
        class IncreaseDefenseModifier: CreatureModifier {
            override func handle(_ q: Query) {
                if q.creatureName == creature.name && q.whatToQuery
                    == .defense {
                    q.value += 2
                }
            }
        }
        
        static func main() {
            let game = Game()
            let goblin = Creature(game, "Strong Goblin", 3, 3)
            print("Baseline goblin: \(goblin)")
            
            let dam = DoubleAttackModifier(game, goblin)
            print("Goblin with 2x attack: \(goblin)")
            
            let idm = IncreaseDefenseModifier(game, goblin)
            print("Goblin with 2x attack & increased defense: \(goblin)")
            
            idm.dispose(); print("Goblin is now \(goblin)")
            dam.dispose(); print("Goblin in now \(goblin)")
            
        }
    } // --- Broker Scope ---
    
    // --- TEST ---
    
    struct Test {
        // INCOMPLETE!!
        /*
         
         Chain of Responsibility Coding Exercise
         You are given a game scenario with classes Goblin and GoblinKing. Please implement the following rules:
         
         Game Rules:
         1. A goblin has base 1 attack/1 defense(1/1), a goblin king is 3/3
         2. When the Goblin King is in play, every other goblin gets +1 Attack.
         3. Goblins get +1 to Defense for every other Goblin in play--a GoblinKing is a Goblin
         
         Example:
         
         Suppose you have 3 ordinary goblins in play. Each one is a 1/3 (1/1 + 0/2 defense bonus).
         A goblin king comes into play. Now every ordinary goblin is a 2/4 (1/1 + 0/3 defense bonus from each other + 1/0 from goblin king)
         The state of all the goblins has to be consistent as goblins are added to the game.

        */
        
        class Creature
        {
            // todo
            enum CreatureType : String {
                case goblin = "Goblin"
                case goblinKing = "Goblin King"
            }
            var _attack, _defense: Int
            let game: Game
            var creatureType: CreatureType
            
            var attack: Int {
                let q = Query(creatureType.rawValue, .attack, _attack)
                game.performQuery(q)
                return q.value
            }
            
            var defense: Int {
                let q = Query(creatureType.rawValue, .defense, _defense)
                game.performQuery(q)
                return q.value
                
            }
            
            init(_ game: Game, _ attack: Int, _ defense: Int, _ type: CreatureType) {
                self.game = game; self._attack = attack; self._defense = defense; self.creatureType = type
            }
        }
        
        class Goblin : Creature
        {
            // todo
            init(game: Game)
            {
                // todo
                super.init(game, 1, 1, .goblin)
                // Add Defense Buff
                IncreaseDefenseModifier(self.game, self)
                IncreaseAttackModifier(self.game, self)
            }
        }
        
        class GoblinKing : Goblin
        {
            override init(game: Game)
            {
                // todo
                super.init(game: game)
                self.creatureType = .goblinKing
                self._attack = 3
                self._defense = 3
            }
        }
        
        class Game
        {
            var creatures = [Creature]()
            
            let queries = Event<Query>()
            
            func performQuery(_ q: Query) {
                queries.raise(q)
            }
        }
        
        // -- Begin My Stuff
        
        class CreatureModifier : Disposable {
            let game: Game
            let creature: Creature
            var event: Disposable? = nil
            
            init(_ game: Game, _ creature: Creature) {
                self.game = game; self.creature = creature; event = self.game.queries.addHandler(target: self, handler: CreatureModifier.handle)
            }
            
            func handle(_ q: Query) {
                // Do nothing to indicate no modifications made
            }
            
            func dispose() {
                event?.dispose()
            }
        }
        
        class IncreaseAttackModifier: CreatureModifier {
            override func handle(_ q: Query) {
                let kingCount = self.game.creatures.filter { $0.creatureType == .goblinKing }.count
                if q.creatureName == Creature.CreatureType.goblin.rawValue && q.whatToQuery
                    == .attack {
                    q.value = kingCount+1
                }
            }
        }
        
        class IncreaseDefenseModifier: CreatureModifier {
            override func handle(_ q: Query) {
                let defenseMultiplier = self.game.creatures.count
                if (
                    q.creatureName == Creature.CreatureType.goblin.rawValue ||
                    q.creatureName == Creature.CreatureType.goblinKing.rawValue
                    ) && q.whatToQuery  == .defense {
                    q.value = defenseMultiplier
                }
            }
        }
        
        // -- End My Stuff
        
        static func main() {
            let game = Game()
            let goblinK2 = GoblinKing(game: game)
            game.creatures.append(goblinK2)
            let goblin = Goblin(game: game)
            game.creatures.append(goblin)
            
            let goblin2 = Goblin(game: game)
            game.creatures.append(goblin2)
            
            let goblin3 = Goblin(game: game)
            game.creatures.append(goblin3)
            
            print("Goblin3 attack: \(goblin3.attack) defense: \(goblin3.defense)")
//            for goblin in game.creatures {
//                print("Goblin name: \(goblin.creatureType.rawValue), Attack: \(goblin.attack), Defense: \(goblin.defense)") // "Expecting all to be = 1/3"
//            }
//
//            let goblinK = GoblinKing(game: game)
//            game.creatures.append(goblinK)
//
//            for goblin in game.creatures {
//                print("Goblin name: \(goblin.creatureType.rawValue), Attack: \(goblin.attack), Defense: \(goblin.defense)") // "Expecting all to be = 1/3"
//            }
//            print("Creatures count: \(game.creatures.count)")
//            print("Goblin attack \(1 == goblin.attack ? "MATCHES" : "DOESN'T MATCH") -- \(goblin.attack)") // "Expecting goblin attack to be = 1"
//            print("Goblin defense \(2 == goblin.defense ? "MATCHES" : "DOESN'T MATCH") -- \(goblin.defense)") // "Expecting goblin defense to be = 2 (1 baseline, +1 from othe goblin"
        }
    }
}// --- Chain of Responsibility Scope ---

protocol Invokable : class {
    func invoke(_ data: Any)
}

public protocol Disposable {
    func dispose()
}

public class Event<T> {
    public typealias EventHandler = (T) -> ()
    var eventHandlers = [Invokable]()
    
    public func raise(_ data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }
    
    public func addHandler<U: AnyObject>
        (target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let subscription = Subscription(target, handler, self)
        eventHandlers.append(subscription)
        return subscription
    }
}

class Subscription<T: AnyObject, U> : Disposable, Invokable {
    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: Event<U>
    
    init(_ target: T?, _ handler: @escaping (T) -> (U) -> (), _ event: Event<U>) {
        self.target = target
        self.handler = handler
        self.event = event
    }
    
    func invoke(_ data: Any) {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 as AnyObject? !== self }
    }
}

class Query {
    var creatureName: String
    enum Argument {
        case attack, defense
    }
    var whatToQuery: Argument
    var value: Int
    
    init(_ name: String, _ whatToQuery: Argument, _ value: Int) {
        self.creatureName = name
        self.whatToQuery = whatToQuery
        self.value = value
    }
}

import XCTest

//ChainOfResponsibility().main()
//ChainOfResponsibility.Broker.main()
ChainOfResponsibility.Test.main()

// ******** END CHAIN OR RESPONSIBILITY *********

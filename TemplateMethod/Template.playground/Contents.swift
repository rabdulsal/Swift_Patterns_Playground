import UIKit
import Foundation

// ***** TEMPLATE METHOD ******

// DEFINITION: Allows us to define the 'skeleton' of the algorithm, with concrete implementations defined in subclasses

struct TemplateMethod {
    
    class Game {
        func run() {
            start()
            while !haveWinner {
                takeTurn()
            }
            print("Player \(winningPlayer) wins!")
        }
        
        internal func start() {
            precondition(false, "this method needs to be overridden")
        }
        
        internal func takeTurn() {
            precondition(false, "this method needs to be overridden")
        }
        
        internal var winningPlayer: Int {
            get {
                precondition(false, "this method needs to be overridden")
            }
        }
        
        internal var haveWinner: Bool {
            get {
                precondition(false, "this method needs to be overridden")
            }
        }
        
        internal var currentPlayer = 0
        internal let numberOfPlayers: Int
        
        init(_ numberOfPlayers: Int) {
            self.numberOfPlayers = numberOfPlayers
        }
    }
    
    class Chess : Game {
        private let maxTurns = 10
        private var turn = 1
        
        init() {
            super.init(2)
        }
        
        override func start() {
            print("Starting a game of chess with \(numberOfPlayers) players.")
        }
        
        override var haveWinner: Bool {
            return turn == maxTurns
        }
        
        override func takeTurn() {
            print("Turn \(turn) taken by player \(currentPlayer).")
            currentPlayer = (currentPlayer + 1) % numberOfPlayers
            turn += 1
        }
        
        override var winningPlayer: Int {
            return currentPlayer
        }
    }
    
    static func main() {
        let chess = Chess()
        chess.run()
    }
    
    // --- TEST ---
    // --- INCOMPLETE!!!
    struct Test {
        
        /*
         -- Template Method Coding Exercise --
         
         Imagine a typical collectible card game which has cards representing creatures. Each creature has two properties: attack  and health . Creatures can fight each other, dealing their attack  damage, thereby reducing their opponent's health .
         
         The class CardGame implements the logic for two creatures fighting one another. However, the exact mechanics of how damage is dealt is different:
         
         TemporaryCardDamage : In some games (e.g., Magic: the Gathering), unless the creature has been killed, its health returns to the original value at the end of combat.
         PermanentCardDamage : In other games (e.g., Hearthstone), health damage persists.
         You are asked to implement classes TemporaryCardDamageGame  and PermanentCardDamageGame  that would allow us to simulate combat between creatures.
         
         To help you on your journey, the CardGame class has a template method called combat() which calls the implementor method hit() that needs to appear within both of the derived game classes.
         
         Some examples:
         
         With temporary damage, creatures 1/2 and 1/3 can never kill one another. With permanent damage, second creature will win after 2 rounds of combat.
         With either temporary or permanent damage, two 2/2 creatures kill one another.
        */
        
        class Creature : Equatable
        {
            static func == (lhs: TemplateMethod.Test.Creature, rhs: TemplateMethod.Test.Creature) -> Bool {
                return lhs.id == rhs.id
            }
            
            public var attack, health: Int
            public var id = 0
            init(_ attack: Int, _ health: Int)
            {
                self.attack = attack
                self.health = health
            }
        }
        
        class CardGame : CustomStringConvertible
        {
            internal enum GameState {
                case inCombat
                case winner
                case draw
            }
            
            var creatures: [Creature]
            
            var description: String {
                guard let winner = winningCreature else {
                    return "It was a draw"
                }
                return "Winning Creature: \(winner.id)"
            }
            
            internal var winningCreature: Creature?
            internal var haveWinner = false
            internal var currentAttacker: Creature
            internal var gameState : GameState = .inCombat
            
            init(_ creatures: [Creature])
            {
                self.creatures = creatures
                // Set creature id
                for i in 0..<creatures.count {
                    creatures[i].id = i
                }
                currentAttacker = creatures.first!
            }
            
            // the arguments creature1 and creature2 are indices in the 'creatures array'
            //
            // method returns the index of the creature that won the fight
            // returns -1 if there is no clear winner (both alive or both dead)
            func combat(_ creature1: Int, _ creature2: Int) -> Int
            {
                // implement this template method
                // use hit() for one creature hitting another
                
                /*
                 States:
                 Fighting -> Neither A nor B health == 0
                 A kills B / B kills A
                 A & B Dead
                */
                var reps = 0
                let maxReps = 10
                while reps != maxReps || !haveWinner  {
                    takeTurn(creature1, creature2)
                    reps += 1
                }
                switch gameState {
                case .inCombat,.draw:
//                    print("Draw: Creature 1 and 2")
                    return -1
                case .winner:
//                    let winningIdx = creatures.index(of: winningCreature!)!
                    return winningCreature!.id
                }
                
//                if c1.health <= 0 {
//                    return creature2
//                } else if c2.health <= 0 {
//                    return creature1
//                } else { return -1 }
                
            }
            
            internal func hit(_ attacker: Creature, _ other: Creature)
            {
                precondition(false, "this method needs to be overridden")
            }
            
            internal func takeTurn(_ creature1: Int, _ creature2: Int) {
                let c1 = creatures[creature1]
                let c2 = creatures[creature2]
                hit(c1, c2)
                hit(c2, c1)
            }
        }
        
        class TemporaryCardDamageGame : CardGame
        {
            override func hit(_ attacker: Creature, _ other: Creature)
            {
                // todo
                let maxDamage = other.health
                other.health -= attacker.attack
                if other.health <= 0 {
                    haveWinner = true
                    winningCreature = attacker
                    gameState = .winner
                    return
                }
                other.health = maxDamage
            }
        }
        
        class PermanentCardDamage : CardGame
        {
            override func hit(_ attacker: Creature, _ other: Creature)
            {
                // todo
                other.health -= attacker.attack
                if other.health <= 0 {
                    haveWinner = true
                    winningCreature = attacker
                    gameState = .winner
                }
            }
        }
        
        static func main() {
            /*
             With temporary damage, creatures 1/2 and 1/3 can never kill one another. With permanent damage, second creature will win after 2 rounds of combat.
             With either temporary or permanent damage, two 2/2 creatures kill one another.
            */
            
            // 1/3 Creature
//            let C1_3 = Creature(1, 3)
//            // 1/2 Creature
//            let C1_2 = Creature(1,2)
//            let cg = TemporaryCardDamageGame([C1_3,C1_2])
//            cg.combat(0, 1)
//            // 2/2 Creature
//            let C2_2 = Creature(2,2)
//            // 2/2 Creature
//            let C2_2_Two = Creature(2,2)
//            let cg2 = PermanentCardDamage([C2_2,C2_2_Two])
//            cg2.combat(0, 1)
////            print(cg)
//            print(cg2)
        }
    }
}

//TemplateMethod.main()
//TemplateMethod.Test.main()
// ***** END TEMPLATE METHOD ******

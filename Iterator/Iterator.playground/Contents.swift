import UIKit
import Foundation

// ********** ITERATOR ***********

// DEFINITION: An object (or method) that facilitates the traversal of a data structure.

struct Iterator {
    
    class Node<T> {
        var value: T
        var left: Node<T>? = nil
        var right: Node<T>? = nil
        var parent: Node<T>? = nil
        
        init(_ value: T) {
            self.value = value
        }
        
        init(_ value: T, _ left: Node<T>, _ right: Node<T>) {
            self.value = value
            self.right = right
            self.left = left
            
            left.parent = self
            right.parent = self
        }
    }
    
    class InOrderIterator<T> : IteratorProtocol {
        
        var current: Node<T>?
        var root: Node<T>
        var yieldedStart = false
        
        init(_ root: Node<T>) {
            self.root = root
            current = root
            while current!.left != nil {
                current = current!.left!
            }
        }
    
        func reset() {
            current = root
            yieldedStart = false
        }
        
        func next() -> Node<T>? {
            if !yieldedStart {
                yieldedStart = true
                return current
            }
            
            if current!.right != nil {
                current = current!.right
                while current!.left != nil {
                    current = current!.left
                }
                return current
            } else {
                var p = current!.parent
                while p != nil  && current === p!.right {
                    current = p!
                    p = p!.parent
                }
                current = p
                return current
            }
        }
    }
    
    class BinaryTree<T> : Sequence {
        private let root: Node<T>
        
        init(_ root: Node<T>) {
             self.root = root
        }
        
        func makeIterator() -> InOrderIterator<T> {
            return InOrderIterator<T>(self.root)
        }
        
    }
    
    static func main() {
        let root = Iterator.Node(1, Iterator.Node(2), Iterator.Node(3))
        let it = InOrderIterator(root)
        while let element = it.next() {
            print(element.value, terminator: " ")
        }
        print()
        
        let nodes = AnySequence{InOrderIterator(root)}
        print(nodes.map{ $0.value })
        
        let tree = BinaryTree(root)
        print(tree.map{ $0.value })
    }
    
    // Example 2: - Array-Backed Properties -
    struct Array_Backed {
        
        class Creature : Sequence {
            var stats = [Int](repeating: 0, count: 3)
            
            private let _strength = 0
            private let _agility = 1
            private let _intelligence = 2
            
            var strength: Int {
                get { return stats[_strength] }
                set(value) { stats[_strength] = value }
            }
            
            var agility: Int {
                get { return stats[_agility] }
                set(value) { stats[_agility] = value }
            }
            
            var intelligence: Int {
                get { return stats[_intelligence] }
                set(value) { stats[_intelligence] = value }
            }
            
            var averageStat: Int {
                return stats.reduce(0, +) / stats.count
            }
            
            func makeIterator() -> IndexingIterator<Array<Int>> {
                return IndexingIterator(_elements: stats)
            }
            
            subscript(index: Int) -> Int {
                get { return stats[index] }
                set(value) { stats[index] = value }
            }
        }
        
        static func main() {
            let c = Creature()
            c.strength = 10
            c.agility = 15
            c.intelligence = 11
            
            print(c.averageStat)
            
            for s in c {
                print(s)
            }
        }
    }
    
    // --- TEST ---
    // INCOMPLETE!!!
    
    struct Test {
        
        /*
         Given the following definition of a Node<T>, implement 'predorder traversal' that returns a sequence of Ts.
        */
        
        class Node<T>
        {
            let value: T
            var left: Node<T>? = nil
            var right: Node<T>? = nil
            var parent: Node<T>? = nil
            
            init(_ value: T)
            {
                self.value = value
            }
            
            init(_ value: T, _ left: Node<T>, _ right: Node<T>)
            {
                self.value = value
                self.left = left
                self.right = right
                
                // todo: try to guess what's missing here
            }
            
            
//            public var preOrder: [T]
//            {
//                // todo
//            }
        }
        
        static func main() {
            
        }
    }
}

//Iterator.main()
//Iterator.Array_Backed.main()

// ******** END ITERATOR **********

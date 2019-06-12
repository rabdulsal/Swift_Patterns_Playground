import UIKit
import Foundation

// ********** FACADE ***********

// DEFINITION: Provides a simple, easy to usnderstand/user interface over a large and sophisticated body of code

struct Facade {
    
    class Buffer {
        var width, height: Int
        var buffer: [Character]
    
        init(_ width: Int, _ height: Int) {
            self.width = width
            self.height = height
            buffer = [Character](repeating: " ", count: width*height )
        }
    
        subscript(_ index: Int) -> Character {
            return buffer[index]
        }
    }

    class Viewport {
        var buffer: Buffer
        var offset = 0
        init(_ buffer: Buffer) {
            self.buffer = buffer
        }
        
        func getCharacterAt(_ index: Int) -> Character {
            return buffer[offset+index]
        }
    }

    class FacadeConsole {
        var buffers = [Buffer]()
        var viewports = [Viewport]()
        var offset = 0
        
        init() {
            let b = Buffer(30,20)
            let v = Viewport(b)
            buffers.append(b)
            viewports.append(v)
        }
        
        func getCharacterAt(_ index: Int) -> Character {
            return viewports[0].getCharacterAt(index)
        }
    }

    func main() {
        let c = FacadeConsole()
        let u = c.getCharacterAt(1)
    }

    // --- TEST --- INCOMPLETE!!!
    
    /*
     Façade Coding Exercise
     A magic square is a square matrix of numbers where the sum in each row, each column, and each of the diagonals is the same.
     
     You are given a system of 3 classes that can be used to make a magic square. The classes are:
     
     Generator: this class generates a 1-dimensional array of random digits in range 1 to 9.
     Splitter: this class takes a 2D array and splits it into all possible arrangements of 1D arrays. It gives you the columns, the rows and the two diagonals.
     Verifier: this class takes a 2D array and verifies that the sum of elements in every subarray is the same.
     Please implement a Façade class called MagicSquareGenerator  which simply generates the magic square of a given size.
     
    */

    class Test {
        
        class Generator
        {
            func generate(_ count: Int) -> [Int]
            {
                var result = [Int]()
                for _ in 1...count
                {
                    result.append(1 + Int(arc4random_uniform(9)))
//                    result.append(1 + Int.random(in: 0 ..< 10))
//                    result.append(1 + random()%9)
                }
                return result
            }
        }
        
        class Splitter
        {
            func split(_ array: [[Int]]) -> [[Int]]
            {
                var result = [[Int]]()
                
                let rowCount = array.count
                let colCount = array[0].count
                
                // get the rows
                for r in 0..<rowCount
                {
                    var theRow = [Int]()
                    for c in 0..<colCount
                    {
                        theRow.append(array[r][c])
                    }
                    result.append(theRow)
                }
                
                // get the columns
                for c in 0..<colCount
                {
                    var theCol = [Int]()
                    for r in 0..<rowCount
                    {
                        theCol.append(array[r][c])
                    }
                    result.append(theCol)
                }
                
                // get the diagonals
                var diag1 = [Int]()
                var diag2 = [Int]()
                for c in 0..<colCount
                {
                    for r in 0..<rowCount
                    {
                        if c == r
                        {
                            diag1.append(array[r][c])
                        }
                        let r2 = rowCount - r - 1
                        if c == r2
                        {
                            diag2.append(array[r][c])
                        }
                    }
                }
                
                result.append(diag1)
                result.append(diag2)
                
                return result
            }
        }
        
        class Verifier
        {
            func verify(_ arrays: [[Int]]) -> Bool
            {
                let first = arrays[0].reduce(0, +)
                for arr in 1..<arrays.count
                {
                    if (arrays[arr].reduce(0, +)) != first
                    {
                        return false
                    }
                }
                return true
            }
        }
        
        class MagicSquareGenerator
        {
            let generator = Generator()
            let splitter = Splitter()
            let verifier = Verifier()
            
            func generate(_ size: Int) -> [[Int]]
            {
                let generatedArry = generator.generate(size)
                let splitted = splitter.split([generatedArry])
                let isVerified = verifier.verify(splitted)
                return isVerified ? splitted : [[Int]]()
//                return splitted
            }
        }
        
        func main() {
            let msg = MagicSquareGenerator()
            print("Generated: \(msg.generate(2))")
        }
    }
}

Facade.Test().main()


// ******** END FACADE **********

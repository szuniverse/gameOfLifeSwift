//
//  Node.swift
//  GameOfLife
//
//  Created by David Szurma on 2/7/17.
//

import Foundation

struct Node: Equatable, Hashable {
    var x: Int
    var y: Int
    
    var hashValue: Int {
        return x * 1000 + y
    }
    
    func neighbourNodes(maxSize: Int) -> [Node] {
        var nodes = [Node]()
        
        for x in -1...1 {
            for y in -1...1 {
                let node = Node(x: self.x + x, y: self.y + y)
                if !(node.x < 0 || node.y < 0 || node.x > maxSize - 1 || node.y > maxSize - 1) {
                    if node != self {
                        nodes.append(node)
                    }
                }
            }
        }
        
        return nodes
    }
}

func ==(lhs: Node, rhs: Node) -> Bool{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

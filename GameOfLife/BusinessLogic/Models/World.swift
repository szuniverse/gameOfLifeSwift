//
//  World.swift
//  GameOfLife
//
//  Created by David Szurma on 2/6/17.
//

import Foundation

final class World {
    
    var aliveNodes = [Node]()
    var maxSize : Int!
    
    func addCell(_ node:Node) {
        if !aliveNodes.contains(node) {
            aliveNodes.append(node)
        }
    }
    
    func prepareExamples() {
        addCell(Node(x: 0, y: 17))
        addCell(Node(x: 1, y: 17))
        addCell(Node(x: 2, y: 17))
        addCell(Node(x: 2, y: 18))
        addCell(Node(x: 1, y: 19))
    }
    
    func checkNeighbours() {
        
        var emptyCellsHash = [Node: Int]()
        var newCells = checkAliveNodes(hash: &emptyCellsHash)
        
        checkNodesNextGeneration(hash: &emptyCellsHash, nodes: &newCells)
        
        aliveNodes = newCells.unique
    }
    
    private func checkAliveNodes(hash: inout [Node:Int]) -> [Node] {
        
        var newCells = [Node]()
        
        aliveNodes.forEach { (node) in
            
            var neighboursCount = 0
            let possibleNeighbours = node.neighbourNodes(maxSize: maxSize)
            
            aliveNodes.forEach({ (aliveNode) in
                if possibleNeighbours.contains(aliveNode) {
                    neighboursCount += 1
                }
            })
            
            if neighboursCount == 2 || neighboursCount == 3 {
                newCells.append(node)
            }
            
            possibleNeighbours.forEach({ (node) in
                
                if let value = hash[node] {
                    hash[node] = value + 1
                }
                else {
                    hash[node] =  1
                }
                
            })
        }
        
        return newCells
    }
    
    private func checkNodesNextGeneration(hash: inout [Node:Int], nodes: inout [Node]) {
        
        aliveNodes.forEach { (node) in
            hash.removeValue(forKey: node)
        }
        
        nodes = nodes.unique
        for (node,count) in hash {
            if count == 3 {
                nodes.append(node)
            }
        }
        
    }
}




//
//  GameScene.swift
//  GameOfLife
//
//  Created by David Szurma on 2/6/17.
//

import Foundation
import SpriteKit

final class GameScene: SKScene {
    
    static let fileName = "GameScene"
    
    private var world = World()
    private var nodeChilds = [SKSpriteNode]()

    private var lastTime : TimeInterval?
    private var refreshTime : TimeInterval = 0.1
    private static let defaultSize: Int = 20
    
    var shouldAvoidCalculation = true
    
    var pixelSize: CGFloat {
        return self.view!.frame.width / CGFloat(dimension)
    }
    
    var dimension: Int = GameScene.defaultSize {
        didSet {
            self.removeAllChildren()
            self.world.maxSize = dimension
            createMap()
            createCells()
        }
    }

    //MARK: Override methods
    override func didMove(to view: SKView) {
        
        createMap()
        world.prepareExamples()
        createCells()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        shouldAvoidCalculation = true
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = convertPixelsToPoint(pixel: location)
            
            if !world.aliveNodes.contains(node) {
                world.addCell(node)
                nodeChilds.append(createSpriteNode(node: node))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if shouldAvoidCalculation {
            return
        }
        
        guard let lastTime = lastTime  else {
            self.lastTime = currentTime
            return
        }
        
        if currentTime - refreshTime >= lastTime {
            self.lastTime = currentTime
            
            nodeChilds.forEach({ (skNode) in
                skNode.removeFromParent()
            })
            nodeChilds.removeAll()
            
            world.checkNeighbours()
            createCells()
        }

    }
    
    //MARK: Private methods
    private func createMap() {
        world.maxSize = dimension
        for i in 1..<dimension {
            let point = CGFloat(i) * self.frame.width / CGFloat(dimension)
            drawline(startX: point, startY: 0, endX: point, endY: self.frame.height)
            drawline(startX: 0, startY: point, endX: self.frame.width, endY: point)
        }
    }
    
    private func drawline(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x:startX, y:startY))
        path.addLine(to: CGPoint(x:endX, y:endY))
        
        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = UIColor.white
        shape.lineWidth = 1
        shape.zPosition = 1
        addChild(shape)
    }
    
    private func createCells(){
        for node in world.aliveNodes {
            nodeChilds.append(createSpriteNode(node: node))
        }
    }
    
    private func convertPointToPixels(node: Node) -> CGPoint {
        return CGPoint(x: CGFloat(node.x) * pixelSize + pixelSize / 2, y: CGFloat(node.y) * pixelSize + pixelSize / 2)
    }
    
    private func convertPixelsToPoint(pixel: CGPoint) -> Node {
        return Node(x: Int(pixel.x / pixelSize), y: Int(pixel.y / pixelSize))
    }
    
    private func createSpriteNode(node: Node) -> SKSpriteNode {
        let sprite = SKSpriteNode()
        sprite.color = UIColor.black
        sprite.size = CGSize(width: pixelSize, height: pixelSize)
        sprite.position = convertPointToPixels(node: node)
        sprite.zPosition = 0
        self.addChild(sprite)
        return sprite
    }
}

//
//  SKNode.swift
//  GameOfLife
//
//  Created by David Szurma on 2/7/17.
//

import Foundation
import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile(file : String) -> SKNode? {
        
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        }
        
        return nil
    }
    
}

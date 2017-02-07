//
//  ViewController.swift
//  GameOfLife
//
//  Created by David Szurma on 2/6/17.
//

import UIKit
import SpriteKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var skViewContainer: SKView!

    fileprivate var mainGameScene: GameScene!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        preapareScene()
    }
    
    // MARK: Action methods
    @IBAction func playOrPauseButtonTapped(_ sender: Any) {
        self.mainGameScene.shouldAvoidCalculation = !self.mainGameScene.shouldAvoidCalculation
    }
    
    @IBAction func modifyAreaButtonTapped(_ sender: Any) {
        
        self.mainGameScene.shouldAvoidCalculation = true
        
        let alertController = UIAlertController(title: AppMessages.changeTitle, message: AppMessages.changeMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = AppMessages.sizePlaceholder
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: AppMessages.change, style: UIAlertActionStyle.default) { (alertAction) in
            let fieldSize = Int(alertController.textFields![0].text!)!
            if fieldSize > 0 && fieldSize < 201 {
                self.mainGameScene.dimension = fieldSize
            }
            else {
                self.showBoundsErrorMessage()
            }
        }
        
        let cancelAction = UIAlertAction(title: AppMessages.cancel, style: UIAlertActionStyle.cancel) { (alertAction) in
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

private extension ViewController {
    
    func showBoundsErrorMessage() {
        let alert = UIAlertController(title: "Hey", message: "Please type a number between 1 and 200", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func preapareScene() {
        
        if let gameScene = GameScene.unarchiveFromFile(file: GameScene.fileName) as? GameScene {
            mainGameScene = gameScene
            skViewContainer.showsFPS = true
            skViewContainer.showsNodeCount = true
            skViewContainer.ignoresSiblingOrder = true
            
            mainGameScene.size = skViewContainer.bounds.size
            mainGameScene.scaleMode = .aspectFill
            
            skViewContainer.presentScene(mainGameScene)
        }
    }

}


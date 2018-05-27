//
//  MainMenuScene.swift
//  Colourful Hexagon
//
//  Created by Tianhao Zhang on 28/5/18.
//  Copyright © 2018 Tianhao Zhang. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene
{
    var playLabel = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        playLabel = self.childNode(withName: "playLabel") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches
        {
            let pointITouched = touch.location(in: self)
            
            if playLabel.contains(pointITouched)
            {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let sceneTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
            }
        }
    }
}

//
//  GameScene.swift
//  Colourful Hexagon
//
//  Created by Tianhao Zhang on 10/5/18.
//  Copyright © 2018 Tianhao Zhang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    var colorWheelBase = SKShapeNode()
    
    let spinColorWheel = SKAction.rotate(byAngle: -convertDegreesToRadians(degrees: 60/6), duration: 0.2)
    
    var currentGameState: gameState = gameState.beforeGame
    
    let TapToStartLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    let scoreLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    let highScoreLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    
    var highScore = UserDefaults.standard.integer(forKey: "highScoreSaved")
    
    override func didMove(to view: SKView)
    {
        score = 0
        ballMovementSpeed = 2
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "gameBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -1
        self.addChild(background)
        
        colorWheelBase = SKShapeNode(rectOf: CGSize(width: self.size.width*0.8, height: self.size.width*0.8))
        colorWheelBase.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        colorWheelBase.fillColor = SKColor.clear
        colorWheelBase.strokeColor = SKColor.clear
        self.addChild(colorWheelBase)
        
        prepColorWheel()
        
        TapToStartLabel.text = "Tap To Start"
        TapToStartLabel.fontSize = 180
        TapToStartLabel.fontColor = SKColor.white
        TapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        self.addChild(TapToStartLabel)
        
        scoreLabel.text = "0"
        scoreLabel.position =  CGPoint(x: self.size.width/2, y: self.size.height*0.85)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 120
        self.addChild(scoreLabel)
        
        highScoreLabel.text = "Best: \(highScore)"
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.fontSize = 150
        self.addChild(highScoreLabel)
        
    }
   
    func prepColorWheel(){
        for i in 0...5
        {
        let side = Side(type: colorWheelOrder[i])
        let basePosition = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        side.position = convert(basePosition, to: colorWheelBase)
        side.zRotation = -colorWheelBase.zRotation
        colorWheelBase.addChild(side)
        
        colorWheelBase.zRotation += convertDegreesToRadians(degrees: 360/6)
        }
        
        for side in colorWheelBase.children{
            let sidePosition = side.position
            let positionInScence = convert(sidePosition, from: colorWheelBase)
            sidePositions.append(positionInScence)
        }
    }
    
    func spawnball()
    {
        let ball = Ball()
        ball.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(ball)
        
    }
    
    func startTheGame()
    {
        spawnball()
        currentGameState = .inGame
        
        let scaleDown = SKAction.scale(to: 0, duration: 0.2)
        let deleteLabel = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([scaleDown, deleteLabel])
        TapToStartLabel.run(deleteSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        if currentGameState == .beforeGame
        {
            //start the game
            startTheGame()
        }
        else if currentGameState == .inGame
        {
            //spin the color wheel
            colorWheelBase.run(spinColorWheel)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        let ball: Ball
        let side: Side
        
        if contact.bodyA.categoryBitMask == PhysicsCategories.Ball
        {
            ball = contact.bodyA.node! as! Ball
            side = contact.bodyB.node! as! Side
        }
        else
        {
             ball = contact.bodyB.node! as! Ball
             side = contact.bodyA.node! as! Side
        }
        
        if ball.isActive == true
        {
            checkMatch(ball: ball, side: side)
          
        }
    }
    
    func checkMatch(ball: Ball, side: Side)
    {
        if ball.type == side.type
        {
            //correct
            correctMatch(ball: ball)
            print("Correct!!")
        }
        else
        {
            //incorrect
            wrongMatch(ball: ball)
            print("Incorrect!!")
        }
    }
    
    func correctMatch(ball:Ball)
    {
        ball.delete()
        
        
        score  += 1
        scoreLabel.text = "\(score)"
        
        switch score
        {
            case 5: ballMovementSpeed = 1.8
            case 15: ballMovementSpeed = 1.6
            case 25: ballMovementSpeed = 1.5
            case 40: ballMovementSpeed = 1.4
            case 60: ballMovementSpeed = 1.3
            default: print("")
        }
        
        spawnball()
        
        if score > highScore
        {
            highScoreLabel.text = "Best: \(score)"
        }
        
        
    }
    
    func wrongMatch(ball: Ball)
    {
        //ebd the game
        if score > highScore
        {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScoreSaved")
        }
        
        ball.flash()
        
        currentGameState = .afterGame
        colorWheelBase.removeAllActions()
        
        let waitToChangeScene = SKAction.wait(forDuration: 3)
        let changeScene = SKAction.run
        {
            let sceneToMoveTo = GameOverScene(fileNamed: "GameOverScene")!
            sceneToMoveTo.scaleMode = self.scaleMode
            let sceneTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        }
        
        let sceneChangeSequence =  SKAction.sequence([waitToChangeScene,changeScene])
        self.run(sceneChangeSequence)
    }
}

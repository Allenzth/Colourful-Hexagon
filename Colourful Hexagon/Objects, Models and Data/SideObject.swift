//
//  SideObject.swift
//  Colourful Hexagon
//
//  Created by Tianhao Zhang on 26/5/18.
//  Copyright © 2018 Tianhao Zhang. All rights reserved.
//

import Foundation
import SpriteKit

class Side: SKSpriteNode
{
    
    let type: colorType
    
    init(type: colorType)
    {
        self.type = type
        let sideTexture = SKTexture(imageNamed: "side_\(self.type)")
        super.init(texture: sideTexture, color: SKColor.clear, size: sideTexture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategories.Side
        self.physicsBody!.contactTestBitMask = PhysicsCategories.None
        self.physicsBody!.contactTestBitMask = PhysicsCategories.Ball
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

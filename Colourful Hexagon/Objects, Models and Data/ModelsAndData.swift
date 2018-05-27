//
//  ModelsAndData.swift
//  Colourful Hexagon
//
//  Created by Tianhao Zhang on 26/5/18.
//  Copyright © 2018 Tianhao Zhang. All rights reserved.
//

import Foundation
import SpriteKit

//Sides and ball Information
enum colorType{
    case Red
    case Pink
    case Blue
    case Yellow
    case Purple
    case Green 
}

let colorWheelOrder:[colorType] = [
.Red, //0
.Yellow, //1
.Blue, //2
.Pink, //3
.Green, //4
.Purple //5
]

var sidePositions: [CGPoint] = []


//Game State
enum gameState
{
    case beforeGame
    case inGame
    case afterGame
}


//Physics Categories
struct PhysicsCategories{
    static let None: UInt32 = 0 //0
    static let Ball: UInt32 = 0b1 //1
    static let Side: UInt32 = 0b10 //2
}


//Score System
var score: Int = 0


//Level System
var ballMovementSpeed: TimeInterval = 2

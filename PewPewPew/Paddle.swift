//
//  Paddle.swift
//  PewPewPew
//
//  Created by Gabe on 7/8/17.
//  Copyright © 2017 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class Paddle : SKSpriteNode{
    
    
    init(size: CGSize) {
        super.init(texture: SKTexture.init(), color: SKColor.red, size: size)
        
        setPaddlePhysics()
    }
    
    func setPaddlePhysics() {
        
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.mass = 1000
        physicsBody?.contactTestBitMask = 0b0001
        physicsBody?.allowsRotation = false
        physicsBody?.friction = 1.0
        name = "paddle"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

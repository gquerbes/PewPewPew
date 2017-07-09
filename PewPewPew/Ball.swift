//
//  Ball.swift
//  PewPewPew
//
//  Created by Gabe on 7/8/17.
//  Copyright © 2017 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit

class Ball : SKSpriteNode{
    
    init(){
        //create node
        super.init(texture: nil, color: SKColor.blue, size: CGSize(width: 20.0, height: 20.0))

        //set properties
        //setProperties()
        
        //set physics
        setPhysics()
        
        
    }
    
    
    func setPhysics(){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = 0b0001
        
        
    }
    
    func setProperties(){
        self.name = "Ball"
    }
    
    
    func setColor(color : UIColor){
        self.color = color
        setProperties()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}

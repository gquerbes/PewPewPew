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
    
    enum BallType {
        case red, redUpsideDown, blue, blueSpecial, greenBall, greenBall2
    }
    
    var type : BallType?
    
    init(){
        //create node
        super.init(texture: SKTexture.init(), color: UIColor.clear, size: CGSize(width: 80.0, height: 80.0))
    
        //set properties
        setProperties()
        
        //set physics
        setPhysics()
        
    }
    
    
    func setTexture(type: BallType){
        self.texture = Ball.getTexture(type: type)
        self.type = type;
    }
    
    
    
    static func getTexture(type: BallType) -> SKTexture{
        var textureImage : UIImage?
        switch type {
        case .blue:
            textureImage = #imageLiteral(resourceName: "BlueBall")
        case .blueSpecial:
            textureImage = #imageLiteral(resourceName: "BlueBall_Special")
        case.greenBall:
            textureImage = #imageLiteral(resourceName: "GreenBall")
        case.greenBall2:
            textureImage = #imageLiteral(resourceName: "GreenBall_2")
        case.red:
            textureImage = #imageLiteral(resourceName: "RedBall")
        case.redUpsideDown:
            textureImage = #imageLiteral(resourceName: "RedBall_UpsideDown")
    
        }
        
        return SKTexture.init(image: textureImage!)
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
        self.alpha = 0.2
        setProperties()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    


}

//
//  MainScene.swift
//  PewPewPew
//
//  Created by Gabe on 7/8/17.
//  Copyright © 2017 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit


class MainScene : SKScene{
    
    private var paddle : SKSpriteNode?
    private var paddleXPosition : CGFloat?
    private var paddleYPosition : CGFloat? // does not change
    private var lastUpdate : TimeInterval = 0
    private var ball : Ball?
    
    
    override func sceneDidLoad() {
        
      
        
        // create paddle
        if(paddle == nil){
            let w = (self.size.width + self.size.height) * 0.05
            self.paddle = SKSpriteNode(color: SKColor.red, size: CGSize(width: w, height: w/4))
            
            paddleXPosition = UIScreen.main.bounds.width * -0.05
            paddleYPosition = UIScreen.main.bounds.height * -0.5
            paddle?.position = CGPoint.init(x: paddleXPosition!, y: paddleYPosition!)
            paddle?.color = SKColor.red
            paddle?.physicsBody = SKPhysicsBody(rectangleOf: (paddle?.size)!)
            paddle?.physicsBody?.affectedByGravity = false
            paddle?.physicsBody?.mass = 1000
            paddle?.physicsBody?.collisionBitMask = 0b0001
            
            
            self.addChild(paddle!)
          
        }
        
        if(ball == nil){
            ball = Ball.init()
            ball?.position = CGPoint(x: (paddle?.position.x)!, y: UIScreen.main.bounds.height)
            
            ball?.run(SKAction.sequence([SKAction.wait(forDuration: 10.0), SKAction.removeFromParent()]))
            
            
        }
        
        
        
        
    }
    
    func dropBall(){
        if let newball = self.ball?.copy() as! SKSpriteNode?{
            self.addChild(newball)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint){
       let moveAction =  SKAction.moveTo(x: pos.x, duration: 0.02)
        
        paddle?.run(moveAction)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{self.touchDown(atPoint: t.location(in: self))}
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if(self.lastUpdate == 0){
            self.lastUpdate = currentTime
            
        }
        
        let dt = currentTime - self.lastUpdate
        
        if(dt > 1){
            dropBall()
            self.lastUpdate = currentTime
            
            //clean up old children
            for child in self.children{
                if(!child.intersects(self) && child.position.y < (paddle?.position.y)!){
                    child.removeFromParent()
                }
            }
        }
        
        
        
    }
 
    
}

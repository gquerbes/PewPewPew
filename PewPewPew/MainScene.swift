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
    
    override func sceneDidLoad() {
        
        if(paddle == nil){
            // create paddle
            let w = (self.size.width + self.size.height) * 0.05
//            self.paddle = SKSpriteNode.init(rectOf: CGSize.init(width: w, height: w/4), radius: w * 0.3)
            self.paddle = SKSpriteNode(color: SKColor.red, size: CGSize(width: w, height: w/4))

            
            paddleXPosition = UIScreen.main.bounds.width * -0.05
            paddleYPosition = UIScreen.main.bounds.height * -0.5
            paddle?.position = CGPoint.init(x: paddleXPosition!, y: paddleYPosition!)
            paddle?.color = SKColor.red
            
            self.addChild(paddle!)
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
}

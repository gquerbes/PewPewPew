//
//  MainScene.swift
//  PewPewPew
//
//  Created by Gabe on 7/8/17.
//  Copyright © 2017 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class MainScene : SKScene, SKPhysicsContactDelegate{
    
    private var ball : Ball?
    private var paddle : Paddle?
    private var paddleXPosition : CGFloat?
    private var paddleYPosition : CGFloat? // does not change
    private var lastUpdate : TimeInterval = 0
    private var score : Int32 = 0
    private var scoreLabel : SKLabelNode?
    
    
    override func sceneDidLoad() {
        //get reference to score label from MainScene.sks
         self.scoreLabel = self.childNode(withName: "//ScoreLabel") as? SKLabelNode
        
        // create paddle
        if(paddle == nil){
            let w = (self.size.width + self.size.height) * 0.05
            self.paddle = Paddle.init(size: CGSize(width: w, height: w/4))
            
            paddleXPosition = UIScreen.main.bounds.width * -0.05
            paddleYPosition = UIScreen.main.bounds.height * -0.5
            paddle?.position = CGPoint.init(x: paddleXPosition!, y: paddleYPosition!)
          
            self.addChild(paddle!)
        }

        //create ball
        if(ball == nil){
            ball = Ball.init()
            ball?.position = CGPoint(x: (paddle?.position.x)!, y: UIScreen.main.bounds.height)
            
            ball?.run(SKAction.sequence([SKAction.wait(forDuration: 10.0), SKAction.removeFromParent()]))
        }
        

        self.physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
    }
    
    
    

    func dropBall(){
        if let newball = self.ball?.copy() as! Ball?{
            newball.setColor(color: getRandomColor())
            newball.position = CGPoint(x: getRandomPosition(), y: newball.position.y)
            self.addChild(newball)
        }
    }
    
    func getRandomPosition() -> CGFloat{
        let x =  GKRandomDistribution.init(lowestValue: Int((self.size.width)/2) * -1, highestValue: Int((self.size.width)/2) - 10).nextInt()
        return CGFloat(x)
    }
    
    
    var colorRed = "";
    var colorBlue = "";
    var colorOrange = "";
    var colorBlack = "";
    var colorCyan = "";
    func getRandomColor() -> UIColor{
        print("\nred \(colorRed)\nblue\(colorBlue)\norange \(colorOrange)\ncyan \(colorCyan)\nblack \(colorBlack)")
        let x = GKShuffledDistribution.init(lowestValue: 0, highestValue: 50)
        
        print(x.nextInt())

        switch x.nextInt() {
        case 0..<10:
            colorRed += "*"
            return UIColor.red
        case 10..<20:
            colorBlue += "*"
            return UIColor.blue
        case 20..<30:
            colorOrange += "*"
            return UIColor.orange
        case 30..<40:
            colorCyan += "*"
            return UIColor.cyan
        default:
            colorBlack += "*"
            return UIColor.black
        }
    }
    
    
    
    // MARK: Interaction
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
                if(!child.intersects(self) && child.position.y < (paddle?.position.y)! - 1){
                    child.removeFromParent()
                }
            }
        }
    }
    
    
    
    //shockwave
    let shockWaveAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 50, duration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.5)])
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        return sequence
    }()
  
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.collisionImpulse > 5 &&
            contact.bodyA.node?.name == "Paddle" &&
            contact.bodyB.node?.name == "Ball" {
        
            let ball = contact.bodyB.node as! Ball
            
            if(ball.color == UIColor.red){
                paddle?.shrink(byAmount: 15)
                score -= 10
            }
            else if(ball.color == UIColor.blue){
                paddle?.grow(byAmount: 5)
                score += 10
            }
            else{
                score += 5
            }
            //update score
            updateScoreLabel()

            //remove ball
            ball.removeFromParent()
            
            //play shockwave
            let shockwave = SKShapeNode(circleOfRadius: 1)
            shockwave.position = contact.contactPoint
            shockwave.fillColor = ball.color
            shockwave.strokeColor = UIColor.yellow
            self.addChild(shockwave)
            shockwave.run(shockWaveAction)
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text =  String(score)
        scoreLabel?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.fadeIn(withDuration: 0.5)]))
    }
    
}

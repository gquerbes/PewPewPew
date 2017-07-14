//
//  MainScene.swift
//  PewPewPew
// Catch the Green to grow paddle, catch red to shrink paddle, miss blue and SOMETHING BADDDDD happens
//  Created by Gabe on 7/8/17.
//  Copyright © 2017 Fourteen66. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class MainScene : SKScene, SKPhysicsContactDelegate{
    
    //MARK: Assets
    private var ball : Ball?
    private var paddle : Paddle?
    
    //MARK: Game variables
    private var lastUpdate : TimeInterval = 0
    
    private var score : Int32 = 0
    private var scoreLabel : SKLabelNode?
    private var highScore : Int32?

    private var level : Int = 1;
    
    
    override func sceneDidLoad() {
        //get reference to score label from MainScene.sks
         self.scoreLabel = self.childNode(withName: "//ScoreLabel") as? SKLabelNode
        
        // create paddle
        if(paddle == nil){
            let w = (self.size.width + self.size.height) * 0.05
            self.paddle = Paddle.init(size: CGSize(width: w, height: w/4))
            
            let paddleXPosition = UIScreen.main.bounds.width * -0.05
            let paddleYPosition = UIScreen.main.bounds.height * -0.5
            paddle?.position = CGPoint.init(x: paddleXPosition, y: paddleYPosition)
          
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
            newball.setPhysics(velocity: CGFloat(level))
//            newball.setColor(color: getRandomColor())
            newball.setTexture(type: getRandomBall()   )
            newball.position = CGPoint(x: getRandomPosition(), y: newball.position.y)
            self.addChild(newball)
            print(newball.physicsBody!.velocity.dy);
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
    func getRandomBall() -> Ball.BallType{
        print("\nred \(colorRed)\nblue\(colorBlue)\norange \(colorOrange)\ncyan \(colorCyan)\nblack \(colorBlack)")
        let x = GKShuffledDistribution.init(lowestValue: 0, highestValue: 59)
        
        print(x.nextInt())

        switch x.nextInt() {
        case 0..<10:
            colorRed += "*"
            level += 1
            return Ball.BallType.blueSpecial
        case 10..<20:
            colorBlue += "*"
            return Ball.BallType.blue
        case 20..<30:
            colorOrange += "*"
            return Ball.BallType.greenBall
        case 30..<40:
            colorCyan += "*"
            return Ball.BallType.greenBall2
        case 40..<50:
            return Ball.BallType.red
        case 50..<60:
            return Ball.BallType.redUpsideDown
        default:
            colorBlack += "*"
            return Ball.BallType.redUpsideDown
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
            let shockwaveColor : UIColor
            let shockwaveRadius : CGFloat
            if(ball.type == Ball.BallType.redUpsideDown){
                paddle?.shrink(byAmount: 15)
                score -= 10
                shockwaveColor = UIColor.red
                shockwaveRadius = 4
            }
            else if(ball.type == Ball.BallType.red){
                paddle?.shrink(byAmount: 10)
                score -= 5
                shockwaveColor = UIColor.red
                shockwaveRadius = 2
            }
                
            else if(ball.type == Ball.BallType.blueSpecial){
                paddle?.grow(byAmount: 10)
                score += 15
                shockwaveColor = UIColor.blue
                shockwaveRadius = 1
            }
            else if(ball.type == Ball.BallType.blue){
                paddle?.grow(byAmount: 5)
                score += 10
                shockwaveColor = UIColor.blue
                shockwaveRadius = 1
            }
            else{
                score += 5
                shockwaveColor = UIColor.green
                shockwaveRadius = 1
            }
            //update score
            updateScoreLabel()

            //remove ball
            ball.removeFromParent()
            
            //play shockwave
            let shockwave = SKShapeNode(circleOfRadius: shockwaveRadius)
            shockwave.position = contact.contactPoint
            shockwave.strokeColor = shockwaveColor
            self.addChild(shockwave)
            shockwave.run(shockWaveAction)
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text =  String(score)
        scoreLabel?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.fadeIn(withDuration: 0.5)]))
    }
    
}

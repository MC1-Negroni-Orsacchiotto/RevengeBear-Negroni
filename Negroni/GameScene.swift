//
//  GameScene.swift
//  Negroni
//
//  Created by Marco Spina on 04/11/2019.
//  Copyright © 2019 Marco Spina. All rights reserved.
//


import SpriteKit
import GameplayKit
import AVFoundation
import CoreAudio

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    Varibili e costanti
    var gameScene:SKScene?
    var player:SKSpriteNode?
    var floor:SKSpriteNode?
    var monster:SKSpriteNode?
    var monster1:SKSpriteNode?
    var projectile:SKSpriteNode?
    var recorder:AVAudioRecorder?
    var levelTimer = Timer()
    var leftButton:SKSpriteNode?
    var rightButton:SKSpriteNode?
    let Level_Threshold:Float = -6.0
    var movementRight = true
    var is_jumped = false
    
    var texturesRun:[SKTexture] = [SKTexture(imageNamed: "Polar-Bear-Stand"),SKTexture(imageNamed: "Polar-Bear-Step-1")]

    
    
    var image_bear_array:[SKTexture]?
    
    
   
    var scoreLabel: SKLabelNode!
    var score: Int = 0 { didSet { scoreLabel.text = "Score: \(score)" } }
    

    
    
    
    
    
    let playerCategory:UInt32 = 0x1 << 0
    let groundCategory:UInt32 = 0x1 << 1
    let monsterCategory:UInt32 = 0x1 << 2
    let projectileCategory:UInt32 = 0x1 << 3
     
    
    
//    funzione dello score
    func spawnscore(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster"); scoreLabel.text = "Score: \(score)"; scoreLabel.horizontalAlignmentMode = .right; scoreLabel.position = CGPoint(x: 180, y: 345);
        scoreLabel.color = .black
        addChild(scoreLabel)
        
        
    }
    
   
     
    
//    funzione inserisci giocatore
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed: "Polar-Bear-Stand")
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 81, height: 80))
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = groundCategory
        player?.physicsBody?.contactTestBitMask = monsterCategory
        player?.size = CGSize(width: 81, height: 106)
        player?.anchorPoint = CGPoint(x: 0, y: 0)
        player?.position = CGPoint(x: size.width * 0.1, y: size.height * 0.7)
        
        
        
        addChild(player!)
        
        let range = SKRange(lowerLimit: 0, upperLimit: 650)
        let lockToCenter = SKConstraint.positionX(range)
        player?.constraints = [lockToCenter]
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
    }
    
//    funzione inserisci pavimenti
    func spawnFloor() {
        floor = self.childNode(withName: "floor") as? SKSpriteNode
        floor?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4000, height: 86))
        floor?.physicsBody?.categoryBitMask = groundCategory
        floor?.physicsBody?.collisionBitMask = playerCategory
        floor?.physicsBody?.affectedByGravity = true
        floor?.physicsBody?.isDynamic = false
    }
    
//    funzione inserisci mostri
    func spawnMonsters() {
        if(monster != nil)
        {
            monster1 = monster
        }
        
        monster = SKSpriteNode(imageNamed: "monster")
        monster?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
        monster?.physicsBody?.categoryBitMask = monsterCategory
        monster?.physicsBody?.collisionBitMask = groundCategory
        monster?.physicsBody?.linearDamping = 0
        monster?.size = CGSize(width: 81, height: 106)
        monster?.anchorPoint = CGPoint(x: 0, y: 0)
        monster?.position = CGPoint(x: size.width * 0.8, y: size.height * 0.6)
        addChild(monster!)
        let monsterMoveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
        let repeatAction = SKAction.repeatForever(monsterMoveAction)
        monster?.run(repeatAction)
//        let actionMove = SKAction.move(to: CGPoint(x: -100, y: 0), duration: TimeInterval(2))
//        let actionMoveDone = SKAction.removeFromParent()
//
//        monster?.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
//    funzione inserisci proiettile
    func spawnProjectile() {
        projectile = SKSpriteNode(imageNamed: "projectile.png")
        //projectile?.physicsBody? = SKPhysicsBody(circleOfRadius: projectile!.size.width / 2)
        projectile?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 80)) // temp for testing
        projectile?.physicsBody?.categoryBitMask = projectileCategory
        projectile?.physicsBody?.collisionBitMask = 0
        projectile?.physicsBody?.contactTestBitMask = monsterCategory
        projectile?.physicsBody?.linearDamping = 0
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.anchorPoint = CGPoint(x: 0, y: 0)
        projectile?.position = CGPoint(x: (player?.position.x)! + 80, y: (player?.position.y)! + 60)
        projectile?.size = CGSize(width: 10, height: 10)
        addChild(projectile!)
        
        var projectileMoveAction:SKAction?
            
        if(movementRight == true)
        {
            projectileMoveAction = SKAction.moveBy(x: 3, y: 0, duration: 0.01)
        }
        
        else
        {
            projectile?.position = CGPoint(x: (player?.position.x)! - 7, y: (player?.position.y)! + 60)
            projectileMoveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
        }
        let repeatAction = SKAction.repeatForever(projectileMoveAction!)
        projectile?.run(repeatAction)
    }
    
//    funzione movimento
    func move(direction: Bool) {
        if direction == true {
            
            if(movementRight == false) {
                movementRight = true
                player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand")
            }
            let characterAnimation = SKAction.repeatForever(SKAction.animate(with: texturesRun, timePerFrame: 0.2))
            let moveAction = SKAction.moveBy(x: 3, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(characterAnimation)
            player?.run(repeatAction)
        } //End IF
        else {
            if(movementRight == true) {
                movementRight = false
                player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand-Reflect")
            }
            let moveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        }
    }
    
//    funzione salto
    func jump() {
        
        let jumpAction = SKAction.moveBy(x: 0, y: 660, duration: 1.0)
        player?.run(jumpAction)
        
        if(movementRight == false) {
            player?.texture = SKTexture(imageNamed: "Polar-Bear-Jump-Reflect")
        }
        
        else if(movementRight == true) {
            player?.texture = SKTexture(imageNamed: "Polar-Bear-Jump")
        }
        
        
        
        if(is_jumped == true)
        {
            let wait = SKAction.wait(forDuration: 0.8)
            let run = SKAction.run {
                
                if(self.movementRight == false) {
//                    self.movementRight = true
                    self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand-Reflect")
                }
                
                if(self.movementRight == true) {
//                    self.movementRight = false
                    self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand")
                }
                
                //self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand")
            }
            self.run(SKAction.sequence([wait, run]))
        }
           
    }
    
//        microphone
    func activateMic() {
        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [AVFormatIDKey: kAudioFormatAppleIMA4, AVSampleRateKey: 44100.0, AVNumberOfChannelsKey: 0, AVEncoderBitRateKey: 12800, AVLinearPCMBitDepthKey: 16, AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue]
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
    } catch {
        return
    }
    
    recorder?.prepareToRecord()
    recorder?.isMeteringEnabled = true
    recorder?.record()
    
    levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func levelTimerCallback() {
        recorder?.updateMeters()
            
        let level = recorder!.averagePower(forChannel: 0)
        if level > Level_Threshold {
            print("mic activated")
        }
        
    }
// end microphone
    
//    reset
    func resetGame() {
        player?.position = CGPoint(x: size.width * 0.1, y: size.height * 0.7)
        let range = SKRange(lowerLimit: 0, upperLimit: 650)
        let lockToCenter = SKConstraint.positionX(range)
        player?.constraints = [lockToCenter]
        
        if(monster != nil)
            
        { score = 0
            monster1?.position = CGPoint(x: 3000, y: 4000)
        }
        
        
        monster?.position = CGPoint(x: size.width * 0.8, y: size.height * 0.6)
        
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        spawnFloor()
        spawnPlayer()
        activateMic()
        spawnscore()
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnMonsters),
                SKAction.wait(forDuration: 2.5)
                ])
        ), withKey: "repeater")
        
        leftButton = self.childNode(withName: "left") as? SKSpriteNode
        rightButton = self.childNode(withName: "right") as? SKSpriteNode

        
    }
    
    //This function transition the scene to a game over scene, it's called when a monster touches the player
    func gameOver() {
        let transition = SKTransition.fade(withDuration: 1)
        gameScene = SKScene(fileNamed: "GameOverScene")
        gameScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: transition)
    }
    
// tasti
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if (node?.name == "right") && (scene?.isPaused == false)  {
                move(direction: true)
                rightButton?.texture = SKTexture(imageNamed: "ButtonRightPressed")
            }
            else if node?.name == "left" && scene?.isPaused == false {
                move(direction: false)
                leftButton?.texture = SKTexture(imageNamed: "ButtonLeftPressed")
            }
            else if node?.name == "jump" && scene?.isPaused == false {
                jump()
            }
            else if node?.name == "shoot" && scene?.isPaused == false {
                spawnProjectile()
            }
            else if node?.name == "reset" {
                resetGame()
            }
            else if node?.name == "pause", let scene = self.scene {
                if scene.isPaused {
                    scene.isPaused = false
                }
                else {
                    scene.isPaused = true
                }
            }

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            player?.removeAllActions()
        
            if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
                
            if node?.name == "jump" {
                is_jumped = false
                
                if(self.movementRight == false) {
//                    self.movementRight = true
                    self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand-Reflect")
                }
                
                if(self.movementRight == true) {
//                    self.movementRight = false
                    self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand")
                }
                
            }
                
                leftButton?.texture = SKTexture(imageNamed: "ButtonLeftUnpressed")
                rightButton?.texture = SKTexture(imageNamed: "ButtonRightUnpressed")

       
       }
    }
       
       override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           player?.removeAllActions()
        
        
            if let touch = touches.first {
                let location = touch.previousLocation(in: self)
                let node = self.nodes(at: location).first
                    
                if node?.name == "jump" {
                    is_jumped = false
                    
                    if(self.movementRight == false) {
    //                    self.movementRight = true
                        self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand-Reflect")
                    }
                    
                    if(self.movementRight == true) {
    //                    self.movementRight = false
                        self.player?.texture = SKTexture(imageNamed: "Polar-Bear-Stand")
                    }
                    
                }
                
                leftButton?.texture = SKTexture(imageNamed: "ButtonLeftUnpressed")
                rightButton?.texture = SKTexture(imageNamed: "ButtonRightUnpressed")


            }
        }
//    end tasti
    
//    collisioni e fisica
        func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
             print("monster hit 3")
            
             score+=1
               
               
             
            
             projectile.position = CGPoint(x: -4000, y: -4000)
                

             monster.position = CGPoint(x: -4000, y: -4000)
            
             projectile.removeFromParent()
             monster.removeFromParent()
        
         }
    
        func didBegin(_ contact: SKPhysicsContact) {
            
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

            switch contactMask {
            case projectileCategory | monsterCategory:
                print("monster hit")
                projectileDidCollideWithMonster(projectile: projectile!, monster: monster!)
            case playerCategory | monsterCategory:
                print("monster hit player")
                gameOver()
            
                
            default:
                print("undetected collision")
                
            }
            
            //Switch controllo salto
            switch contactMask {
                case playerCategory | groundCategory:
                    is_jumped = false
                default:
                    is_jumped = true
            }
            
        }
}




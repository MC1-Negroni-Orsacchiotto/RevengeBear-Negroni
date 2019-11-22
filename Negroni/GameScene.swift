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
    var smog:SKSpriteNode?
    var m_projectile:SKSpriteNode?
    var recorder:AVAudioRecorder?
    var levelTimer = Timer()
    var leftButton:SKSpriteNode?
    var rightButton:SKSpriteNode?
    let Level_Threshold:Float = -4.8
    var movementRight = true
    var is_jumped = false
    var backgroundMusic:SKAudioNode?
    var playerLife = 3
    var smogTutorial:SKLabelNode?
    
    var texturesRun:[SKTexture] = [SKTexture(imageNamed: "Polar-Bear-Stand"),SKTexture(imageNamed: "Polar-Bear-Step-Left"), SKTexture(imageNamed: "Polar-Bear-Stand"), SKTexture(imageNamed: "Polar-Bear-Step-Right")]
    
    var texturesRun2:[SKTexture] = [SKTexture(imageNamed: "PlayerStandLeft"),SKTexture(imageNamed: "PlayerStepLeft"), SKTexture(imageNamed: "PlayerStandLeft"), SKTexture(imageNamed: "PlayerStepLeft")]

    
    var monsterRun:[SKTexture] = [SKTexture(imageNamed: "monster"), SKTexture(imageNamed: "ShitmanEnemyStep")]
    
    
    var monsterReflectRun:[SKTexture] = [SKTexture(imageNamed: "monster_reflect"), SKTexture(imageNamed: "ShitmanEnemyStepLeft")]
    
    
    var image_bear_array:[SKTexture]?
    
    
   
    var scoreLabel: SKLabelNode!
    var score: Int = 0 { didSet { scoreLabel.text = "Score: \(score)" } }
    

    
    
    
    
    
    let playerCategory:UInt32 = 0x1 << 0
    let groundCategory:UInt32 = 0x1 << 1
    let monsterCategory:UInt32 = 0x1 << 2
    let projectileCategory:UInt32 = 0x1 << 3
    let m_projectileCategory:UInt32 = 0x1 << 4
     
    
    
//    funzione dello score
    func spawnscore(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster"); scoreLabel.text = "Score: \(score)"; scoreLabel.horizontalAlignmentMode = .left; scoreLabel.position = CGPoint(x: 40, y: 351);
        scoreLabel.fontColor = .black
        
        
        
        addChild(scoreLabel)
        
        
    }
    
   
     
    
//    funzione inserisci giocatore
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed: "Polar-Bear-Stand")
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 75, height: 75))
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = groundCategory
        player?.physicsBody?.contactTestBitMask = monsterCategory
        player?.size = CGSize(width: 81, height: 106)
        player?.anchorPoint = CGPoint(x: 0, y: 0)
        player?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.7)
        
        
        
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
        // GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        
        monster = SKSpriteNode(imageNamed: "monster")
        monster?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
        monster?.physicsBody?.categoryBitMask = monsterCategory
        monster?.physicsBody?.collisionBitMask = groundCategory
        monster?.physicsBody?.linearDamping = 0
        monster?.size = CGSize(width: 81, height: 106)
        monster?.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        if GKRandomSource.sharedRandom().nextBool() == true {
//            monster?.position = CGPoint(x: size.width * 0.9, y: size.height * 0.1)
//            let monsterMoveAction = SKAction.moveBy(x: -2, y: 0, duration: 0.08)
            
            var monsterMoveAction:SKAction?
            
            monster?.position = CGPoint(x: size.width * 1.0, y: size.height * 0.2)
            
            
            if(score <= 10)
            {
                monsterMoveAction = SKAction.moveBy(x: -1, y: 0, duration: 0.02)
            }
            else if(score > 10 && score <= 25)
            {
                monsterMoveAction = SKAction.moveBy(x: -2, y: 0, duration: 0.02)
            }
            else if(score > 20 && score <= 45)
            {
                monsterMoveAction = SKAction.moveBy(x: -2, y: 0, duration: 0.01)
            }
            else
            {
                monsterMoveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
            }
            
            let repeatAction = SKAction.repeatForever(monsterMoveAction!)
            monster?.texture = SKTexture(imageNamed: "monster_reflect")
            
            let characterAnimation = SKAction.repeatForever(SKAction.animate(with: monsterReflectRun, timePerFrame: 0.2))
            monster?.run(characterAnimation)
            
            monster?.run(repeatAction)
            //let wait = SKAction.wait(forDuration: 0.3)
//            let run = SKAction.run {
//
//                //self.monsterFire(is_left: true)
//
//
//            }
//            self.run(SKAction.sequence([wait, run]))
            

        }
        else {
//            monster?.position = CGPoint(x: size.width * 0.1, y: size.height * 0.2)
//            let monsterMoveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.08)
            
            monster?.position = CGPoint(x: size.width * -0.2, y: size.height * 0.2)
             
            var monsterMoveAction:SKAction?
            if(score <= 10)
            {
                monsterMoveAction = SKAction.moveBy(x: 1, y: 0, duration: 0.02)
            }
            else if(score > 10 && score <= 25)
            {
                monsterMoveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.02)
            }
            else if(score > 20 && score <= 45)
            {
                monsterMoveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.01)
            }
            else
            {
                monsterMoveAction = SKAction.moveBy(x: 3, y: 0, duration: 0.01)
            }
            
            
            let repeatAction = SKAction.repeatForever(monsterMoveAction!)
            
            let characterAnimation = SKAction.repeatForever(SKAction.animate(with: monsterRun, timePerFrame: 0.2))
            monster?.run(characterAnimation)
            
            monster?.run(repeatAction)
            
//            let wait = SKAction.wait(forDuration: 0.3)
//            let run = SKAction.run {
//
//                //self.monsterFire(is_left: false)
//
//
//            }
//            self.run(SKAction.sequence([wait, run]))
        }
        addChild(monster!)
        
        
//        let actionMove = SKAction.move(to: CGPoint(x: -100, y: 0), duration: TimeInterval(2))
//        let actionMoveDone = SKAction.removeFromParent()
//
//        monster?.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    func monsterFire(is_left: Bool)
    {
        
        
        
        m_projectile = SKSpriteNode(imageNamed: "ShitBullet")
        
        m_projectile?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 50)) // temp for testing
        m_projectile?.physicsBody?.categoryBitMask = m_projectileCategory
        m_projectile?.physicsBody?.collisionBitMask = 0
        m_projectile?.physicsBody?.contactTestBitMask = playerCategory
        m_projectile?.physicsBody?.linearDamping = 0
        m_projectile?.physicsBody?.affectedByGravity = false
        m_projectile?.anchorPoint = CGPoint(x: 0, y: 0)
        m_projectile?.size = CGSize(width: 10, height: 10)
//        m_projectile?.physicsBody = SKPhysicsBody(circleOfRadius: m_projectile!.size.width / 2)
        
        if(is_left == true)
        {
            m_projectile?.position = CGPoint(x: (monster?.position.x)! - 80, y: (monster?.position.y)! + 60)
        }
        else
        {
            m_projectile?.position = CGPoint(x: (monster?.position.x)! + 80, y: (monster?.position.y)! + 60)
        }
        
        
        let projectileSound = SKAction.playSoundFileNamed("shoot.m4a", waitForCompletion: false)
        run(projectileSound)
        addChild((m_projectile!))
        
        var projectileMoveAction2:SKAction?
            
        if(is_left == true)
        {
            projectileMoveAction2 = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
        }
        
        else
        {
            projectileMoveAction2 = SKAction.moveBy(x: 3, y: 0, duration: 0.01)
        }
        let repeatAction = SKAction.repeatForever(projectileMoveAction2!)
        m_projectile?.run(repeatAction)
    }
    
    
//    funzione inserisci proiettile
    func spawnProjectile() {
        projectile = SKSpriteNode(imageNamed: "projectile.png")
        //projectile?.physicsBody? = SKPhysicsBody(circleOfRadius: projectile!.size.width / 2)
        projectile?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 70)) // temp for testing
        projectile?.physicsBody?.categoryBitMask = projectileCategory
        projectile?.physicsBody?.collisionBitMask = 0
        projectile?.physicsBody?.contactTestBitMask = monsterCategory
        projectile?.physicsBody?.linearDamping = 0
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.anchorPoint = CGPoint(x: 0, y: 0)
        projectile?.position = CGPoint(x: (player?.position.x)! + 80, y: (player?.position.y)! + 60)
        projectile?.size = CGSize(width: 10, height: 10)
//        projectile?.physicsBody = SKPhysicsBody(circleOfRadius: projectile!.size.width / 2)
        
        let projectileSound = SKAction.playSoundFileNamed("shoot.m4a", waitForCompletion: false)
        run(projectileSound)
        addChild(projectile!)
        
        var projectileMoveAction:SKAction?
            
        if(movementRight == true)
        {
            projectileMoveAction = SKAction.moveBy(x: 5, y: 0, duration: 0.01)
        }
        
        else
        {
            projectile?.position = CGPoint(x: (player?.position.x)! - 7, y: (player?.position.y)! + 60)
            projectileMoveAction = SKAction.moveBy(x: -5, y: 0, duration: 0.01)
        }
        let repeatAction = SKAction.repeatForever(projectileMoveAction!)
        projectile?.run(repeatAction)
    }
    
    func spawnSmog() {
        smog = SKSpriteNode(imageNamed: "SmogAlternative")
        smog?.size = CGSize(width: 3322, height: 614)
        smog?.position = CGPoint(x: size.width * 1.1, y: size.height * 0.5)
        let smogMoveAction = SKAction.moveBy(x: -480, y: 0, duration: 1.05)
        smog?.run(smogMoveAction)
        addChild(smog!)
        activateMic()
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
             let characterAnimation2 = SKAction.repeatForever(SKAction.animate(with: texturesRun2, timePerFrame: 0.2))
            let moveAction = SKAction.moveBy(x: -3, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(characterAnimation2)
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
            let smogMoveAction = SKAction.moveBy(x: 6000, y: 0, duration: 1.50)
            smog?.run(smogMoveAction)
            recorder?.isMeteringEnabled = false

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
        
        playerLife = 3
        childNode(withName: "Heart_3")?.alpha = 2.0
        childNode(withName: "Heart_2")?.alpha = 2.0
        childNode(withName: "Heart_1")?.alpha = 2.0
        
        monster?.position = CGPoint(x: size.width * 0.8, y: size.height * 0.6)
        
    }
    
    func loseLife() {
        playerLife -= 1
        let knockBackAction = SKAction.moveBy(x: -30, y: 20, duration: 0.1)
        player?.run(knockBackAction)
        
        if playerLife == 2 {
            childNode(withName: "Heart_3")?.alpha = 0.0
        } else if playerLife == 1 {
            childNode(withName: "Heart_2")?.alpha = 0.0
        } else if playerLife == 0 {
            childNode(withName: "Heart_1")?.alpha = 0.0
            gameOver()
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        spawnFloor()
        spawnPlayer()
        spawnscore()

        if let musicURL = Bundle.main.url(forResource: "bgm", withExtension: "m4a") {
                   backgroundMusic = SKAudioNode(url: musicURL)
            let volume:SKAction? = SKAction.changeVolume(to: 100, duration: 0)
            backgroundMusic?.run(volume!)
                       addChild(backgroundMusic!)
               }
        
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
        gameScene?.scaleMode = .aspectFit
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
               
            if score % 10 == 0 {
                spawnSmog()
            }
             
            
             projectile.position = CGPoint(x: -4000, y: -4000)
                

             monster.position = CGPoint(x: -4000, y: -4000)
            
             projectile.removeFromParent()
             monster.removeFromParent()
        
         }
    
    
    func projectileDidCollideWithPlayer(m_projectile: SKSpriteNode, player: SKSpriteNode)
    {
        
        loseLife()
        m_projectile.position = CGPoint(x: -4000, y: -4000)
        m_projectile.removeFromParent()

    }
    
        func didBegin(_ contact: SKPhysicsContact) {
            
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

            switch contactMask {
            case projectileCategory | monsterCategory:
                print("monster hit")
                monster = contact.bodyA.node as? SKSpriteNode
                projectile = contact.bodyB.node as? SKSpriteNode
                projectileDidCollideWithMonster(projectile: projectile!, monster: monster!)
            case playerCategory | monsterCategory:
                print("monster hit player")
                monster?.removeFromParent()
                loseLife()
//            case m_projectileCategory | playerCategory:
//                print("monster fire player")
//                projectileDidCollideWithPlayer(m_projectile: m_projectile!, player: player!)
                
                
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




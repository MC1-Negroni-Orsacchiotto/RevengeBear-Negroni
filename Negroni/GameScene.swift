//
//  GameScene.swift
//  Negroni
//
//  Created by Marco Spina on 04/11/2019.
//  Copyright © 2019 Marco Spina. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player:SKSpriteNode?
    
    func spawnPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player?.size = CGSize(width: 81, height: 106)
        player?.anchorPoint = CGPoint(x: 0, y: 0)
        player?.position = CGPoint(x: size.width * 0.1, y: size.height * 0.18)
        addChild(player!)
    }
    
    func move(direction: Bool) {
        
    }
    
    override func didMove(to view: SKView) {
        spawnPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "right" {
                print("move right")
            }
          else if node?.name == "left" {
                print("move left")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


import SpriteKit

class GameOverScene : SKScene {
    
    var gameScene:SKScene?
    var playButton:SKSpriteNode?
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "restartButton") as? SKSpriteNode

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!, transition: transition)
                
           }
        }
    }
    
}

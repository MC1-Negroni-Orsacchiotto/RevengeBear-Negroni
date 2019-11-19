
import SpriteKit

class StartScene: SKScene {
    
    var playButton:SKSpriteNode?
    var gameScene:SKScene!
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "startButton") as? SKSpriteNode
        print("ok")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                           let transition = SKTransition.fade(withDuration: 1)
                           gameScene = SKScene(fileNamed: "GameScene")
                           gameScene.scaleMode = .aspectFit
                           self.view?.presentScene(gameScene, transition: transition)
                           
            }
        }
    }
}

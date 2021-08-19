//
//  MenuScene.swift
//  BubbleGame
//
//  Created by OSMAN ÇETİN on 18.05.2020.
//  Copyright © 2020 OSMAN ÇETİN. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {

    var startButton = SKSpriteNode()
    var infoButton = SKSpriteNode()
    var titleLabel = SKLabelNode()
//    var bn = S
    
    override func didMove(to view: SKView) {
    
    
        //titleLabel
//        titleLabel = self.childNode(withName: "titleLabel") as! SKLabelNode;()
        titleLabel.fontName = "AmericanTypewriter-Bold"
        titleLabel.fontSize = 60
        titleLabel.text = "The Choice"
        titleLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        titleLabel.fontColor = UIColor.blue
        titleLabel.zPosition = 2
        self.addChild(titleLabel)
        
        
        //startButton
//        startButton = self.childNode(withName: "startButton") as! SKSpriteNode;()
        let textureStart = SKTexture(imageNamed: "jump_fall")
        startButton = SKSpriteNode(texture: textureStart)
//        startButton.size = CGSize(width: self.frame.width / 6, height: self.frame.height / 10)
        startButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.6)
        startButton.zPosition = 2
        startButton.name = "startButton"
        self.addChild(startButton)
        
        //infoButton
//        infoButton = self.childNode(withName: "infoButton") as! SKSpriteNode;()
        let textureInfo = SKTexture(imageNamed: "jump_fall")
        infoButton = SKSpriteNode(texture: textureInfo)
//        infoButton.size = CGSize(width: self.frame.width / 6, height: self.frame.height / 10)
        infoButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.9)
        infoButton.zPosition = 2
        infoButton.name = "infoButton"
        self.addChild(infoButton)

        
        // physics Body
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first
        
        if let touchLocation = touch?.location(in: self) {
            let nodesArray = self.nodes(at: touchLocation)
            if nodesArray.first?.name == "startButton"{
                
                let transition = SKTransition.fade(withDuration: 0.4)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                
            } else if nodesArray.first?.name == "infoButton"{
//                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
//                let transition = SKTransition.fade(with: patternColor , duration: 0.5)
//                let transition = SKTransition.doorsOpenVertical(withDuration: 2)
//                let transition = SKTransition.moveIn(with: .right, duration: 0.5)
//                let transition = SKTransition.push(with: SKTransitionDirection(rawValue: 20)!, duration: 1)
                let transition = SKTransition.fade(withDuration: 0.4)
                let infoScene = InfoScene(size: self.size)
                self.view?.presentScene(infoScene, transition: transition)
                
            }
        }
    }
}

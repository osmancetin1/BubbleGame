//
//  InfoScene.swift
//  BubbleGame
//
//  Created by OSMAN ÇETİN on 20.05.2020.
//  Copyright © 2020 OSMAN ÇETİN. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class InfoScene: SKScene {

    var titleLabel = SKLabelNode()
    var infoLabel = SKLabelNode()
    var backButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
    
        //titleLabel
//        titleLabel = self.childNode(withName: "titleLabel") as! SKLabelNode;()
        titleLabel.fontName = "AmericanTypewriter-Bold"
        titleLabel.fontSize = 60
        titleLabel.text = "The Choice"
        titleLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        titleLabel.fontColor = UIColor.red
        titleLabel.zPosition = 2
        self.addChild(titleLabel)
        
        
        //infoLabel
//        infoLabel = self.childNode(withName: "titleLabel") as! SKLabelNode;()
        infoLabel.fontName = "AmericanTypewriter-Bold"
        infoLabel.fontSize = 30
        infoLabel.text = "inelenen "
        infoLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.7)
        infoLabel.fontColor = UIColor.white
        infoLabel.zPosition = 2
        self.addChild(infoLabel)
        
        
        //backButton
//        backButton = self.childNode(withName: "backButton") as! SKSpriteNode;()
        let texture = SKTexture(imageNamed: "jump_fall")
        backButton = SKSpriteNode(texture: texture)
//        backButton.size = CGSize(width: self.frame.width / 6, height: self.frame.height / 10)
        backButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        backButton.zPosition = 2
        backButton.name = "backButton"
        self.addChild(backButton)
        
//        self.info = UITextView(frame: framer)
//        self.info.font = UIFont(name: "Chalkduster", size: 20)
//        self.info.textAlignment = .center
//        self.info.textColor = UIColor.white
//        self.info.backgroundColor = UIColor.black
        
        
        // physics Body
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            let touch = touches.first
            
            if let touchLocation = touch?.location(in: self) {
                let nodesArray = self.nodes(at: touchLocation)
                if nodesArray.first?.name == "backButton"{
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    let menuScene = MenuScene(size: self.size)
                    self.view?.presentScene(menuScene, transition: transition)
                    
                }
            }
        }
    
}

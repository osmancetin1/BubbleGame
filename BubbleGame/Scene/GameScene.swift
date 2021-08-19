//
//  GameScene.swift
//  BubbleGame
//
//  Created by OSMAN ÇETİN on 12.05.2020.
//  Copyright © 2020 OSMAN ÇETİN. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bug = SKSpriteNode()
    var background = SKSpriteNode()
    var particleRain = SKEmitterNode()
    
//    var gameTimer = Timer() // diffirent timer
    var counter = 0
    var counterC = 0 // counter Control
    var timeInterval = 0 // base TimeInterval actually beginner 1
    var timer:Timer!
    var ifTimer:Timer!
    var timerFinish: Timer!
    var gameStarted = false // if game start
    var gameFirstTouch = false // if game clicked
    var loopBroker = false
    var scoreC = 0 // score Control
    var score = 0{ // base score
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel = SKLabelNode()
    var highScore = 0
    var highScoreLabel = SKLabelNode()
    var i = 0
    
    
    override func didMove(to view: SKView) {
        
        layoutSetup()
        
        //Highscore check
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "Highscore: \(highScore)"
        }
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highScoreLabel.text = "Highscore: \(highScore)"
        }

        // physics Body
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
//        self.scene?.scaleMode = .aspectFit //bg bozuluyor
        self.physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
 
    
    @objc func firstChallange()  {
        // firt challange
        counter = 5
        timeInterval = 2
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
//                ifTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.countDown) , userInfo: nil, repeats: true)
        //        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.changePosition) , userInfo: nil, repeats: true)
                counterC = counter
        print("firstChallange is start")
    }
    
    @objc func secondChallange()  {
        timeInterval = 1
//        if  loopBroker == false{
            print("secondChallange is start")
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
//        }else {
//            print("secondChallange islemi olmadi")
//        }
    }
    

    @objc func timerFunc()  {
        
        i += timeInterval
        changePosition()
        if score >= i {
            print("sorun yok")
        }else {
            print("yandin")
            
//            bug.isUserInteractionEnabled = false
            gameStarted = false
            gameOver()
//            if loopBroker == false {
//                gameOver()
//            }
            
        }
    }
    
    // daha sonra . gelince gameover sayfasina gelecek
    @objc func gameOver()  {
        let transition = SKTransition.flipHorizontal(withDuration: 0.3)
        let menuScene = MenuScene(size: self.size)
        self.view?.presentScene(menuScene, transition: transition)
        
        loopBroker = true
        print("gameOver devreye girdi")
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        // Her dokunuldugunda koordinat farki ve yercekimndden etkilenme
        bird.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 100))
        bird.physicsBody?.affectedByGravity = true
        */
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                // ilk dokunus gerceklestiyse devam
                if gameFirstTouch == true {
                    if touchNodes.isEmpty == false {
                        for node in touchNodes {
                            if let sprite = node as? SKSpriteNode {
                                // dokunulan yer bug ile ayni mi
                                if sprite == bug {
                                    score += 1
                                    scoreLabel.text = String(score)
                                    print("buga dokundun")
                                    soundAndEffect(bug: bug)
//                                    if score == 5 {
//                                        print("score 5 oldu")
//                                        secondChallange()
//                                    }
//                                    let a = 5
//                                    let b = 10
//                                    switch score {
//                                    case a:
//                                        secondChallange()
//                                    case b:
//                                        thirdChallange()
//                                    default:
//                                        print("Bu hic yazilmayacak")
//                                    }
                                    // eger farkliysa
                                } else {
                                    print("bug harici dokundun")
                                    scoreC+=1
                                    if scoreC*2 != scoreC+score {
                                        // Resetleme yapilacak
                                        print("oldu")
                                        gameStarted = true
                                        gameOver()
                                    }
                                    //HighScore
                                    if self.score > self.highScore {
                                        self.highScore = self.score
                                        highScoreLabel.text = "Highscore: \(self.highScore)"
                                        UserDefaults.standard.set(self.highScore, forKey: "highscore")
                                    }

                                }//end of else
                            }// end of if let sprite
                        }
                    }// end of if touchNodes.isEmpty == false
                }else{
                    self.gameFirstTouch = true
                    firstChallange()
                }
            }
        }
    }
    

    
    func soundAndEffect (bug:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "ParticleSmoke")!
        explosion.position = bug.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("ChiptuneFinal.m4a", waitForCompletion: false))
//        self.run(SKAction.)
        self.run(SKAction.wait(forDuration: 1)) {
            explosion.removeFromParent()
            
        }
    }

    @objc func changePosition(){
        
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(lo: Int(self.frame.minX)+Int(bug.size.width), hi: Int(self.frame.maxX)-Int(bug.size.width))
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(lo: Int(self.frame.minY)+Int(bug.size.height), hi: Int(self.frame.maxY)-Int(bug.size.height))
        bug.position = CGPoint(x: randomX, y: randomY)
    }
    
    // Aldigi degerleri int olarak randon donduren func
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    
    func layoutSetup(){

                // bug
                let textureBug = SKTexture(imageNamed: "jump_fall")
                bug = SKSpriteNode(texture: textureBug)
                bug.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                bug.size = CGSize(width: self.frame.width / 6, height: self.frame.height / 10)
                bug.zPosition = 1
                bug.name = "bug"

                bug.physicsBody = SKPhysicsBody(circleOfRadius: bug.size.width/2)
                //bug.physicsBody = SKPhysicsBody(circleOfRadius: bugTexture.size().height / 13)
                bug.physicsBody?.affectedByGravity = false
                bug.physicsBody?.isDynamic = false
                bug.physicsBody?.mass = 0.15

                
        //      bug.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        //      bug.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        //      bug.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
                self.addChild(bug)
                
                // Arka plan yagmur
                particleRain = SKEmitterNode(fileNamed: "ParticleRain")!
                particleRain.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height )
                particleRain.advanceSimulationTime(10)
                particleRain.zPosition = -1
        //        particleRain.particleSize =  self.frame.width,  self.frame.height
                particleRain.particlePositionRange = CGVector(dx: self.frame.width , dy: self.frame.height)
        //        particleRain.particleE
                self.addChild(particleRain)
                
                
                // background
                let textureBg = SKTexture(imageNamed: "background")
                background = SKSpriteNode(texture: textureBg)
                background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                background.size = CGSize(width: self.frame.width, height: self.frame.height)
                background.zPosition = -2
                background.isUserInteractionEnabled = false
                background.accessibilityRespondsToUserInteraction = false
                background.name = "background"
                self.addChild(background)
                
                //scoreLabel
                scoreLabel.fontName = "AmericanTypewriter-Bold"
                scoreLabel.fontSize = 70
                scoreLabel.text = "0"
                scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.2)
                scoreLabel.fontColor = UIColor.white
                scoreLabel.zPosition = 2
                self.addChild(scoreLabel)
                
                //highScoreLabel
                highScoreLabel.fontName = "AmericanTypewriter-Bold"
                highScoreLabel.fontSize = 30
                highScoreLabel.text = "Highscore: \(self.highScore)"
                highScoreLabel.position = CGPoint(x: 200, y: 50)
                highScoreLabel.zPosition = scoreLabel.zPosition
                self.addChild(highScoreLabel)
        
    }
    

    
    func touchDown(atPoint pos : CGPoint) {
    }
    func touchMoved(toPoint pos : CGPoint) {
    }
    func touchUp(atPoint pos : CGPoint) {
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

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

    var bug          = SKSpriteNode()
    var bugAnimation = SKAction()
    var background   = SKSpriteNode()
    var particleRain = SKEmitterNode()
    var playableRect = CGRect()
    var optionBlue   = SKSpriteNode()
    var optionRed    = SKSpriteNode()

    var scoreLabel           = SKLabelNode()
    var highScore            = 0
    var highScoreLabel       = SKLabelNode()
    var scoreBefore          = -1
    var hiddenScore          = 0
    var counter              = 0
    var counterC             = 0 // counter Control
    var timeInterval : Float = 0
    var gameStarted          = false
    var gameFirstTouch       = false
    var scoreC               = 0 // score Control
    var score                = 0{
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var timer:Timer!
    var timerFinish: Timer!
    var timerControl: Timer!



    let secondChallangeNum  = 5
    let thirdChallangeNum   = 10
    let forthChallangeNum   = 15
    let fifthChallangeNum   = 20
    let sixthChallangeNum   = 25
    let seventhChallangeNum = 30


    override init(size: CGSize) {

        let MaxAspestRatio:CGFloat = 9.0/16.0
        let playableHeight = size.width / MaxAspestRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x:0, y: playableMargin, width: size.width, height: playableHeight)


        var textures:[SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "bug\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        bugAnimation = SKAction.animate(with: textures,timePerFrame: 0.2)

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        // ekranda olacak itemleri yerlestirir
        layoutSetup()
        gameFirstTouch = false

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

    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> else
    @objc func firstChallange()  {
        timeInterval = 1.5
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }

    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
    @objc func secondChallange()  {
        print("secondChallange is start")
        timeInterval = timeInterval*0.75
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }

    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
    @objc func thirdChallange()  {
        print("thirdChallange is start")
        bug.size = CGSize(width: bug.size.width * 0.75, height: bug.size.height * 0.75)
//        bug.physicsBody = bug.physicsBody*0.75
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }


    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
    @objc func fourthChallange()  {
        spawnTree()
        print("fourthChallange is start")
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }
    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
    @objc func fifthChallange()  {
        spawnBee()
        print("fifthChallange is start")
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }
    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
    @objc func sixthChallange()  {
        bug.physicsBody!.affectedByGravity = true
        print("sixthChallange is start")
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.timerFunc) , userInfo: nil, repeats: true)
    }
    //used in firstChallange() -> timer
    //used in secondChallange() -> timer
    //used in thirdChallange() -> timer
    @objc func timerFunc()  {
        scoreBefore += 1
        changePosition()
        if score >= scoreBefore {
            print("sorun yok")

        }else {
            print("patladin")
            timer.invalidate()
            //bug.isUserInteractionEnabled = false
            gameStarted = true
            timerFinish = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector:#selector(GameScene.gameOver) , userInfo: nil, repeats: false)
        }
    }

    // daha sonra . gelince gameover sayfasina gelecek
    // used in timerFunc() -> timerFinish
    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug -> else
    @objc func gameOver()  {
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let menuScene = MenuScene(size: self.size)
        self.view?.presentScene(menuScene, transition: transition)
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
                if gameFirstTouch == true {
                    if touchNodes.isEmpty == false {
                        for node in touchNodes {
                            if let sprite = node as? SKSpriteNode {
                                if sprite == bug {
                                         score += 1
                                         scoreLabel.text = String(score)
                                         hiddenScore = score
                                         print("buga dokundun")
                                         soundAndEffect(bug: bug)

                                         switch score {
                                         case secondChallangeNum:
                                            HiddenAndStart()
                                         case thirdChallangeNum:
                                             HiddenAndStart()
                                        case forthChallangeNum:
                                            HiddenAndStart()
                                        case fifthChallangeNum:
                                            HiddenAndStart()
                                         case sixthChallangeNum:
                                             HiddenAndStart()
                                         default:
                                             print("")
                                         }
                                }else {
                                    print("bug harici dokundun")
                                    scoreC+=1
                                    if scoreC*2 != scoreC + hiddenScore {
                                        // Resetleme yapilacak
                                        print("score denetleme oldu")
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
                }else{ // if gameFirstTouch
                    gameFirstTouch = true
                    firstChallange()
                }
            }
        }

        if let touch = touches.first {
        let touchLocation = touch.location(in: self)
        let touchNodes = nodes(at: touchLocation)

        if touchNodes.isEmpty == false {
            for node in touchNodes {
                if let sprite = node as? SKSpriteNode {
                    if optionBlue.isHidden == false || optionRed.isHidden == false {
                        if sprite == optionBlue {
                            gameStarted = false
                            optionBlue.isHidden = true
                            optionRed.isHidden = true
                            switch score {

                            case secondChallangeNum:
                                HiddenAndStart()
                             case thirdChallangeNum:
                                 HiddenAndStart()
                            case forthChallangeNum:
                                HiddenAndStart()
                            case fifthChallangeNum:
                                HiddenAndStart()
                             case sixthChallangeNum:
                                 HiddenAndStart()
                             default:
                                 print("")
                             }
                            fifthChallange()
                            print("2. sectin")

                        } else if sprite == optionRed{
                            gameStarted = false
                            optionBlue.isHidden = true
                            optionRed.isHidden = true
                            sixthChallange()
                            print("3. sectin")
                        }else {
                            spawnChooseLabel()
                            print("Bir secim yapmalisin")

                        }
                    }

                }
            }
        }

        }

    }
    func HiddenAndStart() {
        timer.invalidate()
         timer = nil
         optionBlue.isHidden = false
         optionRed.isHidden = false
        gameStarted = true
    }

    // used in if gameStarted == false -> if let touch = touches.first ->  if gameFirstTouch == true -> if touchNodes.isEmpty == false  -> for node in touchNodes -> if let sprite = node as? SKSpriteNode -> if sprite == bug
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


        // used in timerFunc()
        @objc func changePosition(){

            bug.run (SKAction.sequence([SKAction.wait (forDuration: TimeInterval(timeInterval - 0.1)),SKAction.scale(to: 0, duration: 0.1)])) //wait and disappear

            let randomX = randomInRange(lo: Int(self.frame.minX)+Int(bug.size.width), hi: Int(self.frame.maxX)-Int(bug.size.width))
            // y coordinate between MinY (top) and MidY (middle):
            let randomY = randomInRange(lo: Int(self.frame.minY)+Int(bug.size.height), hi: Int(self.frame.maxY)-Int(bug.size.height))
            bug.position = CGPoint(x: randomX, y: randomY)
//            bug.position = CGPoint(
//                x: CGFloat.random(
//                    min: playableRect.minY,
//                    max: playableRect.maxY),
//                y: CGFloat.random(
//                    min: playableRect.minY,
//                    max: playableRect.maxY))
            bug.setScale(0)
            let appear = SKAction.scale(to: 1.0, duration: 0.1)
            bug.zRotation = -3.14/16.0
            let wait = SKAction.wait (forDuration: 2)
            let actions = [appear, wait]
            bug.run (SKAction.sequence(actions))


        }
    // Aldigi degerleri int olarak randon donduren func
    // used in changePosition()
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }

    func createBug(){

        let textureBug = SKTexture(imageNamed: "jump_fall")
        bug = SKSpriteNode(texture: textureBug)
//        bug.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        bug.size = CGSize(width: self.frame.width / 3, height: self.frame.height / 6)
        bug.zPosition = 2
        bug.name = "bug"
        bug.physicsBody = SKPhysicsBody(circleOfRadius: bug.size.width/2)
        bug.physicsBody?.affectedByGravity = false
        bug.physicsBody?.isDynamic = false
        bug.physicsBody?.mass = 0.10
        bug.run(SKAction.repeatForever(bugAnimation))
        //      bug.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        //      bug.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        //      bug.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
    }

    //used in override func didMove(to view: SKView)
     func layoutSetup(){



                 // bug
                createBug()
                bug.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        addChild(bug)

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
                 scoreLabel.zPosition = 3
                 self.addChild(scoreLabel)

                 //highScoreLabel
                 highScoreLabel.fontName = "AmericanTypewriter-Bold"
                 highScoreLabel.fontSize = 30
                 highScoreLabel.text = "Highscore: \(self.highScore)"
                 highScoreLabel.position = CGPoint(x: 150, y: 5)
                 highScoreLabel.zPosition = scoreLabel.zPosition
                 self.addChild(highScoreLabel)


        let textureOptionBlue = SKTexture(imageNamed: "64x64_blue")
        optionBlue = SKSpriteNode(texture: textureOptionBlue )
        optionBlue.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 10)
        optionBlue.size = CGSize(width: self.frame.width / 3.5, height: self.frame.height / 9)
        optionBlue.zPosition = 2
        optionBlue.isHidden = true
        optionBlue.name = "optionBlue"
        self.addChild(optionBlue)

        let textureOptionRed = SKTexture(imageNamed: "64x64_red")
        optionRed = SKSpriteNode(texture: textureOptionRed )
        optionRed.position = CGPoint(x: self.frame.width / (4/3), y: self.frame.height / 10)
        optionRed.size = optionBlue.size
        optionRed.zPosition = optionBlue.zPosition
        optionRed.isHidden = optionBlue.isHidden
        optionRed.name = "optionRed"
        self.addChild(optionRed)

     }

    func spawnChooseLabel() {

        let ChooseLabel = SKSpriteNode(imageNamed: "options_locked")
        ChooseLabel.zPosition = 5
        ChooseLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        ChooseLabel.setScale(0)
        addChild(ChooseLabel)

        let appear = SKAction.scale(to: 1.0, duration: 0.2)
        ChooseLabel.zRotation = -3.14/16.0
        let wait = SKAction.wait (forDuration: 1)
        let disappear = SKAction.scale(to: 0, duration: 0.2)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, wait, disappear, removeFromParent]
        ChooseLabel.run (SKAction.sequence(actions))
    }

    func spawnBee() {
        let bee = SKSpriteNode(imageNamed: "bee")
        bee.size = bug.size
        bee.zPosition = 1
        bee.position = CGPoint(
            x: size.width + bee.size.width/2,
            y: CGFloat.random(
                min: playableRect.minY + bee.size.height/2,
                max: playableRect.maxY - bee.size.height/2))
        addChild(bee)

        let actionMove = SKAction.moveTo(x: -bee.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()

        bee.run(SKAction.sequence([actionMove,actionRemove]))
    }

    func spawnTree() {
        let tree = SKSpriteNode(imageNamed: "tree")
        tree.size = bug.size
        tree.zPosition = 1
        tree.position = CGPoint(
            x: CGFloat.random(
                min: playableRect.minY,
                max: playableRect.maxY),
            y: CGFloat.random(
                min: playableRect.minY,
                max: playableRect.maxY))
        tree.setScale(0)
        addChild(tree)

        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        tree.zRotation = -3.14/16.0
        let wait = SKAction.wait (forDuration: 10)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, wait, disappear, removeFromParent]
        tree.run (SKAction.sequence(actions))
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

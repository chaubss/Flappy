//
//  GameScene.swift
//  Flappy
//
//  Created by Aryan Chaubal on 1/22/16.
//  Copyright (c) 2016 Aryan Chaubal. All rights reserved.
//

import SpriteKit
/*
 to fix:
 pauses music when launched
 timer continues when app enters background, pipes continue to spawn

 
 */
class GameScene: SKScene, SKPhysicsContactDelegate {
    let textureAtlas = SKTextureAtlas(named: "Bird.atlas")
    var bkgColors = [SKColor]()
    
    let impact = UIImpactFeedbackGenerator()
    
    var playedSound = Bool()
    var textureArray = [SKTexture]()
    let bird = SKSpriteNode(imageNamed: "Bird1.png")
    let scoreLabel = SKLabelNode(fontNamed: "04b19")
    var barrier = SKSpriteNode(imageNamed: "TpPipe")
    let highscoreLabel = SKLabelNode(fontNamed: "04b19")
    let tapLabel = SKLabelNode(fontNamed: "04b19")
    var highscore = 0
    var restart: SKSpriteNode? = nil
    var score: Int = 0
    var moveAndRemove = SKAction()
    var died = false
    var gameStarted = false
    var timer = Timer()
    func setupBarrier(){
        barrier.size = CGSize(width: self.frame.width, height: 2)
        barrier.position = CGPoint(x: self.frame.width/2, y: self.frame.height-2)
        barrier.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 2))
        
        barrier.physicsBody?.isDynamic = false
        barrier.physicsBody?.allowsRotation = false
        barrier.physicsBody?.affectedByGravity = false
        barrier.alpha = 0
        self.addChild(barrier)
        
        
        
        
        
        
    }
    
    
    
    
    func setUpColors(){
        bkgColors.append(SKColor(red: 255/255, green: 165/255, blue: 0, alpha: 1))
                bkgColors.append(SKColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 1))
                bkgColors.append(SKColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1))
                bkgColors.append(SKColor(red: 0/255, green: 250/255, blue: 154/255, alpha: 1))
                bkgColors.append(SKColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1))
                bkgColors.append(SKColor(red: 255/255, green: 160/255, blue: 122/255, alpha: 1))
                bkgColors.append(SKColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1))
                bkgColors.append(SKColor(red: 205/255, green: 92/255, blue: 92/255, alpha: 1))
                bkgColors.append(SKColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1))
                bkgColors.append(SKColor(red: 128/255, green: 128/255, blue: 0/255, alpha: 1))
                bkgColors.append(SKColor(red: 107/255, green: 142/255, blue: 35/255, alpha: 1))
                bkgColors.append(SKColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1))
    }
    
    
    
    
    
    
    
    
    
    func setUpBird(){
        // This sets up the bird
        
        playedSound = false
        if UIDevice.current.userInterfaceIdiom == .pad{
            bird.size = CGSize(width: 50, height: 50)
            
        }else if UIDevice.current.userInterfaceIdiom == .phone{
            bird.size = CGSize(width: 40, height: 40)
            
        }else{
            bird.size = CGSize(width: 50, height: 50)
            
        }
        
        
        
        bird.position = CGPoint(x: self.frame.midX - bird.size.width, y: self.frame.height / 2)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.zRotation = 0
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.allowsRotation = true
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.topPipe | PhysicsCategory.btmPipe
        bird.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.topPipe | PhysicsCategory.btmPipe
        bird.name = "bird"
        
        for a in 1...textureAtlas.textureNames.count{
            textureArray.append(SKTexture(imageNamed: "Bird\(a).png"))
        }
        
        
        
        
        
        self.addChild(bird)
        
        
    }
    
    
    func setUpGround(){
        tapLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 100)
        tapLabel.fontSize = 40
        tapLabel.fontColor = SKColor.white
        tapLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeIn(withDuration: 1), SKAction.fadeOut(withDuration: 1)])))
        tapLabel.text = "Tap To Flap"
        highscoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 100)
        highscoreLabel.fontSize = 30
        if let defaults = UserDefaults.standard.value(forKey: "highscore"){
            let newHighscore = defaults as! Int
            highscore = newHighscore
            highscoreLabel.text = "Highscore = \(highscore)"
        }else{
            highscoreLabel.text = ""
        }
        self.addChild(highscoreLabel)
        self.addChild(tapLabel)
        // set UP the looping backgroud 
        for i in 0...1{
            // Setup the ground
            let ground = SKSpriteNode(imageNamed: "ground")
            let invisGround = SKSpriteNode(imageNamed: "random")
            invisGround.size = CGSize(width: self.frame.width, height: self.frame.height/6)
            
            invisGround.position = CGPoint(x: self.frame.width/2, y: self.frame.height/12)
            ground.zPosition = -2
            ground.size = CGSize(width: self.frame.width, height: (self.frame.height / 6))
            ground.anchorPoint = CGPoint(x: 0, y: 0)
            
            // Set up the physics body for the ground
            invisGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width,height: self.frame.height / 6))
            invisGround.physicsBody?.isDynamic = false
            
            
            
            
            
            invisGround.alpha = 0
            
            
            
            
            invisGround.physicsBody?.categoryBitMask = PhysicsCategory.ground
            invisGround.physicsBody?.contactTestBitMask = PhysicsCategory.bird
            invisGround.physicsBody?.contactTestBitMask = PhysicsCategory.bird
            invisGround.name = "invisground"
            ground.name = "ground"
            ground.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            self.addChild(ground)
            self.addChild(invisGround)
            
            let background = SKSpriteNode(imageNamed: "TransBackground")
            background.size = CGSize(width: self.frame.width, height: self.frame.height)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.zPosition = -100
            self.addChild(background)
            
        }
        
        
        
        
    }
    @objc func spawnPipes(){
        
        
        
        
        
        
        let topPipe = SKSpriteNode(imageNamed: "BtmPipe")
        let btmPipe = SKSpriteNode(imageNamed: "BtmPipe")
        let ht = self.frame.height - (self.frame.height / 6)
        let spaceBtwPipes = CGFloat(250)
        let obj = SKSpriteNode(color: SKColor.black, size: CGSize(width: 20, height: spaceBtwPipes))
        let min = 180
        let max = 390
        let range = max - min
        let randomHt = CGFloat(UInt32(min) + (arc4random() % UInt32(range)))
        topPipe.size.height = randomHt - spaceBtwPipes/2
        topPipe.size.width = 80
        topPipe.position.x = self.frame.size.width + 30
        topPipe.position.y = self.frame.height - (topPipe.size.height / 2)
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.categoryBitMask = PhysicsCategory.topPipe
        topPipe.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        topPipe.physicsBody?.collisionBitMask = PhysicsCategory.bird
        topPipe.name = "pipe"
        btmPipe.size.width = 80
        btmPipe.size.height = (ht - topPipe.size.height) - spaceBtwPipes/2
        btmPipe.position.y = (self.frame.height / 6) + btmPipe.size.height / 2
        btmPipe.position.x = topPipe.position.x
        btmPipe.physicsBody = SKPhysicsBody(rectangleOf: btmPipe.size)
        btmPipe.physicsBody?.isDynamic = false
        btmPipe.physicsBody?.categoryBitMask = PhysicsCategory.btmPipe
        btmPipe.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        btmPipe.physicsBody?.collisionBitMask = PhysicsCategory.bird
        btmPipe.name = "pipe"
        obj.position.x = topPipe.position.x
        obj.position.y = self.frame.height - randomHt
        obj.physicsBody = SKPhysicsBody(rectangleOf: obj.size)
        obj.physicsBody?.affectedByGravity = false
        obj.physicsBody?.isDynamic = false
        obj.physicsBody?.categoryBitMask = PhysicsCategory.scoreNode
        obj.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        let spawn = SKAction.sequence([SKAction.moveTo(x: -btmPipe.size.width, duration: 4), SKAction.removeFromParent()])
        topPipe.run(spawn)
        btmPipe.run(spawn)
        obj.run(spawn)
        obj.name = "obj"
        obj.alpha = 0;
        self.addChild(btmPipe)
        self.addChild(topPipe)
        self.addChild(obj)
        
        
    }
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        
        
        setUpColors()
        
        
        self.backgroundColor = bkgColors[Int(arc4random_uniform(UInt32(bkgColors.count)))]
        
        
        
        
        
        
        
        
        
        
        setUpBird()
        setupBarrier()
        setUpGround()
        
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 90)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.zPosition = 6
        
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            
            bird.physicsBody?.affectedByGravity = true
            highscoreLabel.removeFromParent()
            self.physicsWorld.contactDelegate = self
            bird.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
            tapLabel.removeAllActions()
            tapLabel.removeFromParent()
            if !died{
                self.run(SKAction.playSoundFileNamed("bird_flap.wav", waitForCompletion: false))
                if UIDevice.current.userInterfaceIdiom == .phone{
                    let impulse = CGVector(dx: 0, dy: 25)
                    bird.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.2)))
                    bird.physicsBody?.applyImpulse(impulse)
                    
                    
                }else{
                    let impulse = CGVector(dx: 0, dy: 40)
                    bird.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.2)))
                    bird.physicsBody?.applyImpulse(impulse)
                }
                
            }
            if !gameStarted{
                gameStarted = true
                self.addChild(scoreLabel)
                
                if !died{
                    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameScene.spawnPipes), userInfo: nil, repeats: true)
                    
                    
                    
                }
            }
            
            if died{
                
                if (restart?.contains(touch.location(in: self)))! && (restart?.xScale)! > CGFloat(0.5) && (restart?.yScale)! > CGFloat(0.5){
                    self.restartGame()
                    
                }
                
            }
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let first = contact.bodyA.node as! SKSpriteNode
        let second = contact.bodyB.node as! SKSpriteNode
        if (first.name == "bird" && second.name == "obj"){
            second.removeFromParent()
            score += 1;
            scoreLabel.text = String(score)
            if score > highscore{
                highscore = score
                let defaults = UserDefaults.standard
                defaults.set(highscore, forKey: "highscore")
                defaults.synchronize()
            }
        }else if(second.name == "bird" && first.name == "obj"){
            first.removeFromParent()
            score += 1;
            scoreLabel.text = String(score)
            if score > highscore{
                highscore = score
                let defaults = UserDefaults.standard
                defaults.set(highscore, forKey: "highscore")
                defaults.synchronize()
            }
        }
        
        if (first.name == "pipe" && second.name == "bird"){
            if !playedSound{
                impact.impactOccurred()
                
                self.run(SKAction.playSoundFileNamed("bird_collision.wav", waitForCompletion: false))
                playedSound = true
                
                
                
                
                
                
            }
            enumerateChildNodes(withName: "pipe", using: { (node, _) -> Void in
                node.speed = 0
                self.timer.invalidate()
                if !self.died{
                    self.died = true
                    self.loadRestartButton()
                }
                self.scoreLabel.text = String(self.score)
            })
            enumerateChildNodes(withName: "obj", using: { (node:SKNode, _)-> Void in
                node.speed = 0
            })
            
        }
        else if(first.name == "bird" && second.name == "pipe"){
            if !playedSound{
                self.run(SKAction.playSoundFileNamed("bird_collision.wav", waitForCompletion: false))
                playedSound = true
                impact.impactOccurred()
                
                
                
            }
            enumerateChildNodes(withName: "pipe", using: { (node, _) -> Void in
                node.speed = 0
                self.timer.invalidate()
                if !self.died{
                    self.died = true
                    self.loadRestartButton()
                    
                }
                
            })
            enumerateChildNodes(withName: "obj", using: { (node:SKNode, _)-> Void in
                node.speed = 0
            })
        }
        
        if first.name == "invisground" && second.name == "bird"{
            
            //            self.run(SKAction.playSoundFileNamed("bird_fall.wav", waitForCompletion: false))
            timer.invalidate()
            if !self.died{
                self.died = true
                self.impact.impactOccurred()
                
                self.loadRestartButton()
            }
            
            enumerateChildNodes(withName: "pipe", using: { (node, _) -> Void in
                node.speed = 0
                
                self.scoreLabel.text = String(self.score)
            })
            enumerateChildNodes(withName: "obj", using: { (node:SKNode, _)-> Void in
                node.speed = 0
            })
        }else if first.name == "bird" && second.name == "invisground"{
            self.run(SKAction.playSoundFileNamed("bird_fall.wav", waitForCompletion: false))
            timer.invalidate()
            if !self.died{
                self.impact.impactOccurred()
                
                self.died = true
                self.loadRestartButton()
            }
            enumerateChildNodes(withName: "pipe", using: { (node, _) -> Void in
                node.speed = 0
                
                self.scoreLabel.text = String(self.score)
            })
            enumerateChildNodes(withName: "obj", using: { (node:SKNode, _)-> Void in
                node.speed = 0
            })
        }
        
        
        
        
    }
    
    func loadRestartButton(){
        restart = SKSpriteNode(imageNamed: "RestartBtn")
        bird.removeAllActions()
        restart!.setScale(0)
        restart!.zPosition = 6
        restart!.position = CGPoint(x: self.frame.midX, y: self.frame.height - ((self.frame.height - (self.frame.height / 6))/2))
        let action = SKAction.scale(to: 0.7, duration: 0.3)
        restart!.run(action, completion: {
            self.died = true
        })
        self.addChild(restart!)
    }
    
    
    func restartGame(){
        self.removeAllChildren()
        died = false
        self.score = 0
        gameStarted = false
        enumerateChildNodes(withName: "pipe", using: { (node:SKNode, _) -> Void in
            node.removeFromParent()
            
        })
        setUpBird()
        setUpGround()
        setupBarrier()
        scoreLabel.text = "0"
        self.run(SKAction.colorize(with: bkgColors[Int(arc4random_uniform(UInt32(bkgColors.count)))], colorBlendFactor: 1, duration: 3))
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if gameStarted && !died{
            enumerateChildNodes(withName: "background") { (node: SKNode, _) -> Void in
                node.position.x -= 0.5
                if node.position.x <= -((node as! SKSpriteNode).size.width){
                    node.position.x += (node as! SKSpriteNode).size.width * 2
                }
                
            }
            
            enumerateChildNodes(withName: "ground") { (node: SKNode, _) -> Void in
                node.position.x -= 1
                if node.position.x <= -((node as! SKSpriteNode).size.width){
                    node.position.x += (node as! SKSpriteNode).size.width * 2
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    
}

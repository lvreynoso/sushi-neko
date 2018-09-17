//
//  GameScene.swift
//  Sushi Neko
//
//  Created by Lucia Reynoso on 9/16/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit



enum GameState {
    case title, ready, playing, gameOver
}

enum Side {
    case left, right, none
}

class GameScene: SKScene {
    // initialize to title
    var state: GameState = .title
    var playButton: MSButtonNode!
    
    // game objects
    var sushiBasePiece: SushiPiece!
    var playerCharacter: PlayerCharacter!
    var sushiTower: [SushiPiece] = []
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet {
            // cap health
            if health > 1.0 { health = 1.0 }
            healthBar.xScale = health / 2
        }
    }
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var bgMusic: SKAudioNode = SKAudioNode(fileNamed: "nyanCat.mp3")
    var punchSFX: SKAudioNode = SKAudioNode(fileNamed: "sfxSwipe.caf")
    let punchSound: SKAction = SKAction.play()
    
    // build the sushi tower
    func addTowerPiece(side: Side) {
        // add a new piece to the sushi tower
        
        // copy original sushi piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // access last piece properties
        let lastPiece = sushiTower.last
        
        // add on top of the last piece, default to first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 110
        
        // increment Z to make sure it's on *top* of the last piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // set side
        newPiece.side = side
        
        // add sushi to scene
        addChild(newPiece)
        
        // add sushi piece to the tower
        sushiTower.append(newPiece)
    }
    
    // tower piece randomizer
    func addRandomPieces(total: Int) {
        // add random pieces to the sushi tower
        for _ in 1...total {
            
            // access the properties of the last piece
            let lastPiece = sushiTower.last!
            
            // let's not create impossible sushi structures
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                
                // RNG
                let rand = arc4random_uniform(100)
                
                if rand < 45 {
                    addTowerPiece(side: .right)
                } else if rand < 90 {
                    addTowerPiece(side: .left)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    // scene load
    override func didMove(to view: SKView) {
        // ui objects
        playButton = childNode(withName: "playButton") as! MSButtonNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        // setup play button handler
        playButton.selectedHandler = {
            self.state = .ready
            self.addChild(self.bgMusic)
        }
        
        // connect game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        sushiBasePiece.connectChopsticks()
        playerCharacter = childNode(withName: "playerCharacter") as! PlayerCharacter
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        
        // manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 20)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // check state
        if state == .gameOver || state == .title { return }
        if state == .ready { state = .playing }
        
        // get first touch
        let touch = touches.first!
        // get touch position
        let location = touch.location(in: self)
        // figure out which side of the screen the touch was on
        if location.x > size.width / 2 {
            playerCharacter.side = .right
            punchSFX.run(punchSound)
        } else {
            playerCharacter.side = .left
            punchSFX.run(punchSound)
        }
        
        if let firstPiece = sushiTower.first as SushiPiece? {
            // remove from sushi tower array
            firstPiece.flip(playerCharacter.side)
            sushiTower.removeFirst()
            
            if playerCharacter.side == firstPiece.side {
                gameOver()
                return
            }
            health += 0.1
            score += 1
            // add a new sushi piece to the top of the tower
            addRandomPieces(total: 1)
        }
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 110) + 445
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if state != .playing { return }
        
        health -= 0.01
        
        if health < 0 {
            gameOver()
        }
        
        moveTowerDown()
    }
    
    func gameOver() {
        state = .gameOver
        bgMusic.run(SKAction.stop())
        // paint it red
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        sushiBasePiece.run(turnRed)
        for piece in sushiTower {
            piece.run(turnRed)
        }
        playerCharacter.run(turnRed)
        
        // change play button selection handler
        playButton.selectedHandler = {
            // grab reference to the spritekit view
            let skView = self.view as SKView?
            // load game scene
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
                return
            }
            // ensure correct aspect mode
            scene.scaleMode = .aspectFill
            // restart game scene
            skView?.presentScene(scene)
        }
    }
    
}






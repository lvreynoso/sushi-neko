//
//  GameScene.swift
//  Sushi Neko
//
//  Created by Lucia Reynoso on 9/16/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // tracking enum so we know which side is which
    enum Side {
        case left, right, none
    }
    
    // game objects
    var sushiBasePiece: SushiPiece!
    var playerCharacter: PlayerCharacter!
    var sushiTower: [SushiPiece] = []
    
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
        newPiece.position.y = lastPosition.y + 55
        
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
        // connect game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        sushiBasePiece.connectChopsticks()
        playerCharacter = childNode(withName: "playerCharacter") as! PlayerCharacter
        
        // manually stack the start of the tower
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
        
    }
}

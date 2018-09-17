//
//  Character.swift
//  Sushi Neko
//
//  Created by Lucia Reynoso on 9/16/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit

class PlayerCharacter: SKSpriteNode {
    let punch: SKAction = SKAction.animate(with: [SKTexture(imageNamed: "character2.png"), SKTexture(imageNamed: "character3.png")], timePerFrame: 0.07, resize: false, restore: true)
    
    
    // character side
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 140
            } else {
                // flip the sprite by inverting x coords
                xScale = -1
                position.x = 504
            }
            run(punch)
            
            self.texture = SKTexture(imageNamed: "character1.png")
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

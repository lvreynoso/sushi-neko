//
//  Character.swift
//  Sushi Neko
//
//  Created by Lucia Reynoso on 9/16/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit

class PlayerCharacter: SKSpriteNode {
    
    // character side
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                // flip the sprite by inverting x coords
                xScale = -1
                position.x = 252
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

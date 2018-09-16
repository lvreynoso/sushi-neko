//
//  sushiPiece.swift
//  Sushi Neko
//
//  Created by Lucia Reynoso on 9/16/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    // chopsticks objects
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    // sushi type
    var side: Side = .none {
        didSet {
            switch side {
            case .left:
                leftChopstick.isHidden = false
            case .right:
                rightChopstick.isHidden = false
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            default:
                print("This should never happen.")
            }
        }
    }
    
    // required init function
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // required init coder function
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        // connect our child chopstick nodes
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        
        // set the default side
        side = .none
    }
}

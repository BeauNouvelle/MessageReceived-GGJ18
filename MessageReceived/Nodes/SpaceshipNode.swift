//
//  SpaceshipNode.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 27/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import UIKit
import SpriteKit

class SpaceshipNode: SKNode {
    
    override init() {
        super.init()
        let spaceshipNode = SKSpriteNode(imageNamed: "spaceship")
        addChild(spaceshipNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

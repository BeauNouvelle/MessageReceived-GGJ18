//
//  HUD.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 27/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    
    let distanceTravelledLabel = SKLabelNode(text: "0")
    
    override init() {
        super.init()
        
        zPosition = 20
        
        distanceTravelledLabel.position = CGPoint(x: 0, y: 0)
        distanceTravelledLabel.fontColor = .white
        distanceTravelledLabel.fontSize = 60
        addChild(distanceTravelledLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


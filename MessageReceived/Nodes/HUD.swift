//
//  HUD.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 27/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import Foundation
import SpriteKit

class ControlButtons: SKNode {
    
    var rightButtonTapped: (() -> Void)?
    var leftButtonTapped: (() -> Void)?
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        zPosition = 20
        
        let leftButton = SKSpriteNode(imageNamed: "leftButton")
        leftButton.position = CGPoint(x: 0, y: 0)
        leftButton.anchorPoint = .zero
        leftButton.name = "leftButton"
        addChild(leftButton)
        
        let rightButton = SKSpriteNode(imageNamed: "rightButton")
        rightButton.anchorPoint = .zero
        rightButton.name = "rightButton"
        rightButton.position = CGPoint(x: leftButton.size.width+10,y: 0)
        addChild(rightButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            if node.name == "leftButton" {
                leftButtonTapped?()
            } else if node.name == "rightButton" {
                rightButtonTapped?()
            }
        }
    }
    
}


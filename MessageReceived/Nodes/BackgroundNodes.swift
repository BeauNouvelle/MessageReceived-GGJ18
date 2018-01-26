//
//  BackgroundNode.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 27/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import Foundation
import SpriteKit

func backgroundNode(size: CGSize) -> SKSpriteNode {
    let backgroundNode = SKSpriteNode()
    backgroundNode.name = "background"
    backgroundNode.zPosition = -5
    
    let background1 = SKSpriteNode(imageNamed: "background")
    background1.position = CGPoint(x: 0, y: 0)
    background1.size = CGSize(width: size.width, height: size.height)
    backgroundNode.addChild(background1)
    
    let background2 = SKSpriteNode(imageNamed: "background")
    background2.zRotation = .pi
    background2.size = CGSize(width: size.width, height: size.height)
    background2.position = CGPoint(x: 0, y: background1.size.height)
    backgroundNode.addChild(background2)
    
    backgroundNode.size = CGSize(width: background1.size.width, height: background1.size.height + background2.size.height)
    return backgroundNode
}

func slowStars(size: CGSize) -> SKSpriteNode {
    let slowStarsNode = SKSpriteNode(imageNamed: "slowStars")
    slowStarsNode.name = "slowStars"
    slowStarsNode.zPosition = -4
    slowStarsNode.size = CGSize(width: size.width, height: size.height)
    return slowStarsNode
}

func mediumStars(size: CGSize) -> SKSpriteNode {
    let slowStarsNode = SKSpriteNode(imageNamed: "mediumStars")
    slowStarsNode.name = "mediumStars"
    slowStarsNode.zPosition = -3
    slowStarsNode.size = CGSize(width: size.width, height: size.height)
    return slowStarsNode
}

//func streakParticles() -> SKEmitterNode {
//
//}


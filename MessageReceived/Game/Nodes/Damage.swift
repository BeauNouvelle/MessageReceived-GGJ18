//
//  Damage.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 28/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import Foundation
import SpriteKit

func damage1() -> SKSpriteNode {
    let damageSprite = SKSpriteNode(imageNamed: "damage1")
    damageSprite.position = CGPoint(x: -20, y: 40)
    damageSprite.name = "damage"
    damageSprite.zPosition = 3
    return damageSprite
}

func damage2() -> SKSpriteNode {
    let damageSprite = SKSpriteNode(imageNamed: "damage2")
    damageSprite.position = CGPoint(x: 45, y: 70)
    damageSprite.name = "damage"
    damageSprite.zPosition = 3
    return damageSprite
}

func damage3() -> SKSpriteNode {
    let damageSprite = SKSpriteNode(imageNamed: "damage3")
    damageSprite.position = CGPoint(x: -40, y: -70)
    damageSprite.name = "damage"
    damageSprite.zPosition = 3
    return damageSprite
}

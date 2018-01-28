//
//  Asteroids.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 28/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import Foundation
import SpriteKit

func createAsteroid() -> SKSpriteNode {
    let imageNames = ["asteroid1", "asteroid2", "asteroid3", "asteroid4", "asteroid5"]
    let randomNumber = CGFloat.random(min: 0, max: CGFloat(imageNames.count)-1)
    let asteroid = SKSpriteNode(imageNamed: imageNames[Int(randomNumber)])
    
    asteroid.name = "asteroid"

    let asteroidPhysicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width/2)
    asteroidPhysicsBody.friction = 0
    asteroidPhysicsBody.angularVelocity = CGFloat.random(min: -10, max: 10)
    asteroidPhysicsBody.isDynamic = true
    asteroidPhysicsBody.allowsRotation = true
    asteroidPhysicsBody.categoryBitMask = PhysicsCategory.Asteroid
    asteroidPhysicsBody.collisionBitMask = PhysicsCategory.Spaceship | PhysicsCategory.Asteroid | PhysicsCategory.DeadZone
    asteroidPhysicsBody.contactTestBitMask = PhysicsCategory.Spaceship | PhysicsCategory.Asteroid | PhysicsCategory.DeadZone
    asteroidPhysicsBody.velocity = CGVector(dx: 0, dy: -500)
    asteroidPhysicsBody.usesPreciseCollisionDetection = true
    asteroidPhysicsBody.restitution = 1.0
    asteroid.physicsBody = asteroidPhysicsBody
    
    return asteroid
}


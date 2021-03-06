//
//  GameScene.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 26/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let playableRect: CGRect
    let cameraNode = SKCameraNode()
    var spaceshipNode = SKSpriteNode(imageNamed: "spaceship")
    let hud = HUD()
    
    let shipMovePointsPerSec: CGFloat = 450
    
    var touchDelay = 0.0
    var distanceTravelled = 0 {
        didSet {
            hud.distanceTravelledLabel.text = "\(distanceTravelled/10)AU"
        }
    }
    var shipLife = 91
    var velocity = CGPoint.zero
    
    let asteroidHitSound: SKAction = SKAction.playSoundFileNamed("asteroidHit", waitForCompletion: false)
    let rocketSound: SKAction = SKAction.playSoundFileNamed("rocket", waitForCompletion: true)
    let astronautSound: SKAction = SKAction.playSoundFileNamed("astronaut", waitForCompletion: true)
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 3/4
        let playableHeight = size.width / maxAspectRatio
        let playableWidth = (size.width * maxAspectRatio)
        playableRect = CGRect(x: 250, y: 50, width: playableWidth-100, height: playableHeight-100)
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width/2
        let y = cameraNode.position.y - size.height/22
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
        
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero

        setupBackground()
        setupSlowStars()
        setupMediumStars()
        setupStreakParticles()
        setupSpaceship()
        setupDeadZone()
        setupHUD()
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        // Rocket Sound
        run(SKAction.repeatForever(rocketSound))
        
        // spawn asteroid
        let spawnAsteroidAction = SKAction.run() { [weak self] in
            self?.spawnAsteroid()
        }
        let spawnAsteroidSequence = SKAction.sequence([spawnAsteroidAction, SKAction.wait(forDuration: 2.0, withRange: 2.0)])
        run(SKAction.repeatForever(spawnAsteroidSequence))

        // Spawn astronaut
        let spawnAstronautAction = SKAction.run { [weak self] in
            self?.spawnAstronaut()
        }
        let spawnAstronautSequence = SKAction.sequence([SKAction.wait(forDuration: 25, withRange: 10), spawnAstronautAction])
        run(SKAction.repeatForever(spawnAstronautSequence))
        
        // Spawn Whale
        let spawnWhale = SKAction.run { [weak self] in
            self?.spawnWhale()
        }
        let spawnWhaleSequence = SKAction.sequence([SKAction.wait(forDuration: 70, withRange: 10), spawnWhale])
        run(SKAction.repeatForever(spawnWhaleSequence))
        
        // Spawn Flower
        let spawnFlower = SKAction.run { [weak self] in
            self?.spawnFlower()
        }
        let spawnFlowerSequence = SKAction.sequence([SKAction.wait(forDuration: 65, withRange: 10), spawnFlower])
        run(SKAction.repeatForever(spawnFlowerSequence))
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func setupHUD() {
        hud.position = CGPoint(x: size.width/2, y: playableRect.height-50)
        addChild(hud)
    }
    
    func setupSpaceship() {
        spaceshipNode.zPosition = 1
        spaceshipNode.position = CGPoint(x: playableRect.midX, y: playableRect.minY+150)
        
        let spaceshipPhysicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spaceship"), size: spaceshipNode.size)
        spaceshipPhysicsBody.isDynamic = true
        spaceshipPhysicsBody.categoryBitMask = PhysicsCategory.Spaceship
        spaceshipPhysicsBody.collisionBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Whale | PhysicsCategory.Astronaut | PhysicsCategory.Flower
        spaceshipPhysicsBody.allowsRotation = false
        spaceshipPhysicsBody.usesPreciseCollisionDetection = true
        spaceshipPhysicsBody.mass = 100
        spaceshipPhysicsBody.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Astronaut | PhysicsCategory.Whale | PhysicsCategory.Flower

        spaceshipNode.physicsBody = spaceshipPhysicsBody
        
        let scaleUp = SKAction.scaleX(to: 0.98, y: 1.04, duration: 0.2)
        let scaleDown = SKAction.scaleX(to: 1.0, y: 1.0, duration: 0.2)
        let scaleLoop = SKAction.sequence([scaleUp, scaleDown])
        spaceshipNode.run(SKAction.repeatForever(scaleLoop))
        
        let boosterSprite = SKSpriteNode(imageNamed: "booster1")
        boosterSprite.position = CGPoint(x: 0, y: -230)
        boosterSprite.zPosition = 0
        spaceshipNode.addChild(boosterSprite)
        
        let textureAtlas = SKTextureAtlas(named: "Sprites")
        let frames = ["booster1", "booster2", "booster3"].map { textureAtlas.textureNamed($0) }
        let animate = SKAction.animate(with: frames, timePerFrame: 0.2)
        let forever = SKAction.repeatForever(animate)
        boosterSprite.run(forever)
        
        addChild(spaceshipNode)
    }
    
    func spawnAsteroid() {
        let asteroid = createAsteroid()
        asteroid.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX), y: size.height+asteroid.size.height/2)
        addChild(asteroid)
    }
    
    func spawnAstronaut() {
        let imageNames = ["astronaut1", "astronaut2"]
        let randomNumber = CGFloat.random(min: 0, max: CGFloat(imageNames.count)-1)
        
        let astronaut = SKSpriteNode(imageNamed: imageNames[Int(randomNumber)])
        astronaut.name = "astronaut"
        
        let astronautPhysicsBody = SKPhysicsBody(circleOfRadius: astronaut.size.width/2)
        astronautPhysicsBody.friction = 0
        astronautPhysicsBody.angularVelocity = CGFloat.random(min: -2, max: 2)
        astronautPhysicsBody.isDynamic = true
        astronautPhysicsBody.allowsRotation = true
        astronautPhysicsBody.velocity = CGVector(dx: 0, dy: -200)
        astronautPhysicsBody.usesPreciseCollisionDetection = true
        astronautPhysicsBody.restitution = 1.0
        astronautPhysicsBody.categoryBitMask = PhysicsCategory.Astronaut
        astronautPhysicsBody.collisionBitMask = PhysicsCategory.Spaceship | PhysicsCategory.DeadZone
        
        astronaut.physicsBody = astronautPhysicsBody
        astronaut.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX), y: size.height+astronaut.size.height/2)

        addChild(astronaut)
    }
    
    func spawnWhale() {
        let whale = SKSpriteNode(imageNamed: "whale")
        whale.name = "whale"
        
        let whalePhysicsBody = SKPhysicsBody(circleOfRadius: whale.size.width/2)
        whalePhysicsBody.friction = 0
        whalePhysicsBody.angularVelocity = CGFloat.random(min: -5, max: 5)
        whalePhysicsBody.isDynamic = true
        whalePhysicsBody.allowsRotation = true
        whalePhysicsBody.velocity = CGVector(dx: 0, dy: -300)
        whalePhysicsBody.usesPreciseCollisionDetection = true
        whalePhysicsBody.restitution = 1.0
        whalePhysicsBody.categoryBitMask = PhysicsCategory.Whale
        whalePhysicsBody.collisionBitMask = PhysicsCategory.Spaceship | PhysicsCategory.DeadZone
        
        whale.physicsBody = whalePhysicsBody
        whale.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX), y: size.height+whale.size.height/2)
        addChild(whale)
    }
    
    func spawnFlower() {
        let flower = SKSpriteNode(imageNamed: "flower")
        flower.name = "flower"
        
        let flowerPhysicsBody = SKPhysicsBody(circleOfRadius: flower.size.width/2)
        flowerPhysicsBody.friction = 0
        flowerPhysicsBody.angularVelocity = CGFloat.random(min: -3, max: 3)
        flowerPhysicsBody.isDynamic = true
        flowerPhysicsBody.allowsRotation = true
        flowerPhysicsBody.velocity = CGVector(dx: 0, dy: -100)
        flowerPhysicsBody.usesPreciseCollisionDetection = true
        flowerPhysicsBody.restitution = 1.0
        flowerPhysicsBody.categoryBitMask = PhysicsCategory.Flower
        flowerPhysicsBody.collisionBitMask = PhysicsCategory.Spaceship | PhysicsCategory.DeadZone
        
        flower.physicsBody = flowerPhysicsBody
        flower.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX), y: size.height+flower.size.height/2)
        addChild(flower)
    }
    
    func setupDeadZone() {
        let deadZone = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 2000, height: 100))
        deadZone.fillColor = .red
        deadZone.name = "deadZone"
        deadZone.position = CGPoint(x: 0, y: -100)
        
        let deadZonePhysicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2000, height: 100), center: CGPoint(x: size.width/2, y: -50))
        deadZonePhysicsBody.categoryBitMask = PhysicsCategory.DeadZone
        deadZonePhysicsBody.collisionBitMask = PhysicsCategory.Asteroid
        deadZonePhysicsBody.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.Astronaut | PhysicsCategory.Whale | PhysicsCategory.Flower
        deadZonePhysicsBody.isDynamic = true
        deadZonePhysicsBody.pinned = true
        deadZonePhysicsBody.allowsRotation = false
        deadZonePhysicsBody.usesPreciseCollisionDetection = true
        
        deadZone.physicsBody = deadZonePhysicsBody
        
        addChild(deadZone)
    }
    
    // MARK: - Background Setup
    func setupBackground() {
        for i in 0...1 {
            let background = backgroundNode(size: size)
            background.position = CGPoint(x: background.size.width/2, y: CGFloat(i)*background.size.height)
            addChild(background)
        }
    }
    
    func setupSlowStars() {
        for i in 0...1 {
            let stars = slowStars(size: size)
            stars.position = CGPoint(x: stars.size.width/2, y: CGFloat(i)*stars.size.height)
            addChild(stars)
        }
    }
    
    func setupMediumStars() {
        for i in 0...1 {
            let stars = mediumStars(size: size)
            stars.position = CGPoint(x: stars.size.width/2, y: CGFloat(i)*stars.size.height)
            addChild(stars)
        }
    }
    
    func setupStreakParticles() {
        guard let emitter = SKEmitterNode(fileNamed: "Streak.sks") else { return }
        emitter.position = CGPoint(x: size.width/2, y: size.height)
        addChild(emitter)
    }
    
    // MARK: - Background Movement
    func moveBackground() {
        enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.y + background.size.height < 0 {
                background.position = CGPoint(x: background.position.x, y: background.position.y + background.size.height*2)
            }
            background.position.y -= 0.3
        }
    }
    
    func moveSlowStars() {
        enumerateChildNodes(withName: "slowStars") { node, _ in
            let slowStars = node as! SKSpriteNode
            if slowStars.position.y + slowStars.size.height < 0 {
                slowStars.position = CGPoint(x: slowStars.position.x, y: slowStars.position.y + slowStars.size.height*2)
            }
            slowStars.position.y -= 0.5
        }
    }
    
    func moveMediumStars() {
        enumerateChildNodes(withName: "mediumStars") { node, _ in
            let mediumStars = node as! SKSpriteNode
            if mediumStars.position.y + mediumStars.size.height < 0 {
                mediumStars.position = CGPoint(x: mediumStars.position.x, y: mediumStars.position.y + mediumStars.size.height*2)
            }
            mediumStars.position.y -= 1.0
        }
    }
    
    // MARK: - Ship Bounds Check
    func boundsCheckSpaceship() {
        let bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
        let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
        
        if spaceshipNode.position.x <= bottomLeft.x {
            spaceshipNode.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if spaceshipNode.position.x >= topRight.x {
            spaceshipNode.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if spaceshipNode.position.y <= bottomLeft.y {
            spaceshipNode.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if spaceshipNode.position.y >= topRight.y {
            spaceshipNode.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    // MARK: - Sprite Move
    func moveShipToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - spaceshipNode.position.x, y: location.y - spaceshipNode.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * shipMovePointsPerSec, y: direction.y * shipMovePointsPerSec)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    // MARK: - Touches
    func sceneTouched(touchLocation:CGPoint) {
        drawSignal(at: touchLocation)
        let delayAction = SKAction.wait(forDuration: touchDelay)
        let moveBlock = SKAction.run { [weak self] in
            self?.shipRecievedMessage()
            self?.moveShipToward(location: touchLocation)
        }
        run(SKAction.sequence([delayAction, moveBlock]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    // MARK: - Update
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        move(sprite: spaceshipNode, velocity: velocity)
        
        moveBackground()
        moveSlowStars()
        moveMediumStars()
        boundsCheckSpaceship()
        
        distanceTravelled += 1
        touchDelay = Double(distanceTravelled) * 0.0001
    }
    
    // MARK: - Actions
    func destroyAsteroidAnimation(at position: CGPoint) {
        guard let emitter = SKEmitterNode(fileNamed: "AsteroidBreak.sks") else { return }
        emitter.position = position
        addChild(emitter)
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()])
        emitter.run(removeAction)
    }
    
    func shake(initialPosition: CGPoint, duration:Float, amplitudeX:Int = 12, amplitudeY:Int = 3) -> SKAction {
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.015
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPoint(x: newXPos,y: newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
    
    func shipRecievedMessage() {
        guard let pulse = SKEmitterNode(fileNamed: "MessageReceived.sks") else { return }
        pulse.position = CGPoint(x: -7, y: 170)
        pulse.name = "pulse"
        spaceshipNode.addChild(pulse)
        let removeAction = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
        pulse.run(removeAction)
    }
    
    func damageShip() {
        shipLife -= 30
        run(asteroidHitSound)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        if shipLife > 60 {
            spaceshipNode.addChild(damage1())
        } else if shipLife > 30 {
            spaceshipNode.addChild(damage3())
        } else if shipLife > 0 {
            spaceshipNode.addChild(damage2())
        }
        
        if shipLife < 0 {
            // play ship blow up animation.
            gameOver()
        }
    }
    
    // MARK: - Signal
    func drawSignal(at location: CGPoint) {
        let signalSprite = SKShapeNode(circleOfRadius: 10)
        signalSprite.position = location
        signalSprite.lineWidth = 1
        signalSprite.glowWidth = 1
        signalSprite.strokeColor = #colorLiteral(red: 0.2494468093, green: 0.7084226012, blue: 0.9994592071, alpha: 1)
        signalSprite.name = "signal"
        signalSprite.zPosition = 9
        addChild(signalSprite)
        
        let scaleAction = SKAction.scale(by: CGFloat(touchDelay*20), duration: touchDelay)
        let removeAction = SKAction.removeFromParent()
        let fadeAction = SKAction.fadeAlpha(to: 0, duration: touchDelay)
        let sequence = SKAction.sequence([SKAction.group([scaleAction,fadeAction]), removeAction])
        signalSprite.run(sequence)
    }
    
    // MARK: - Game state
    func gameOver() {
        restart()
    }
    
    func restart() {
        touchDelay = 0.0
        distanceTravelled = 0
        shipLife = 91
        spaceshipNode.enumerateChildNodes(withName: "damage") { (node, _) in
            node.removeFromParent()
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.DeadZone) && (contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.DeadZone) && (contact.bodyB.categoryBitMask == PhysicsCategory.Whale) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.DeadZone) && (contact.bodyB.categoryBitMask == PhysicsCategory.Flower) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.DeadZone) && (contact.bodyB.categoryBitMask == PhysicsCategory.Astronaut) {
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Spaceship) && (contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid) {
            guard let explosionLocation = contact.bodyB.node?.position else { return }
            destroyAsteroidAnimation(at: explosionLocation)
            contact.bodyB.node?.removeFromParent()
            cameraNode.run(shake(initialPosition: cameraNode.position, duration: 0.5, amplitudeX: 30, amplitudeY: 4))
            damageShip()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Asteroid) && (contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid) {
            guard let explosionLocation = contact.bodyB.node?.position else { return }
            destroyAsteroidAnimation(at: explosionLocation)
            contact.bodyB.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Spaceship) && (contact.bodyB.categoryBitMask == PhysicsCategory.Astronaut) {
            contact.bodyB.node?.run(astronautSound)
        }
        
//        if (contact.bodyA.categoryBitMask == PhysicsCategory.Spaceship) && (contact.bodyB.categoryBitMask == PhysicsCategory.Whale) {
//            contact.bodyB.node?.run(whaleSound)
//        }
        
    }
}

struct PhysicsCategory {
    static let None: UInt32 = 0x1 << 1
    static let Asteroid: UInt32 = 0x1 << 2
    static let Spaceship: UInt32 = 0x1 << 3
    static let DeadZone: UInt32 = 0x1 << 4
    static let Astronaut: UInt32 = 0x1 << 5
    static let Flower: UInt32 = 0x1 << 6
    static let Whale: UInt32 = 0x1 << 7
}

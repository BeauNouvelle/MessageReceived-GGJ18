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
    var spaceshipNode = SpaceshipNode()
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 3/4
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        print(playableRect)
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width/2 + (size.width - playableRect.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - playableRect.height)/2
        return CGRect(x: x, y: y, width: playableRect.width, height: playableRect.height)
    }
        
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        setupBackground()
        setupSlowStars()
        setupMediumStars()
        setupStreakParticles()
        setupSpaceship()
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        debugDrawPlayableArea()
        startGame()
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func setupSpaceship() {
        spaceshipNode.zPosition = 1
        spaceshipNode.position = CGPoint(x: size.width/2, y: 200)
        addChild(spaceshipNode)
    }
    
    func startGame() {
        // start debris
    }
    
    func cameraShake() {
        
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
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
        moveSlowStars()
        moveMediumStars()
    }
    
}

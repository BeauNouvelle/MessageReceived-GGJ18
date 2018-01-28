//
//  GameViewController.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 26/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        playThemeSound()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Music
    func playThemeSound() {
        if let path = Bundle.main.path(forResource: "music", ofType: "wav") {
            let music = URL(fileURLWithPath:path)
            
            player = try! AVAudioPlayer(contentsOf: music)
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.volume = 0.5
            player.play()
        }
    }
}

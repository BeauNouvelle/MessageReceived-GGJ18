//
//  Menu.swift
//  MessageReceived
//
//  Created by Beau Nouvelle on 27/1/18.
//  Copyright © 2018 Beau Nouvelle. All rights reserved.
//

import UIKit
import SpriteKit

class Menu: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        addChild(background)
        
        let launchButton = SKSpriteNode(imageNamed: "launch")
        addChild(launchButton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get launch button here.
    }
    
}

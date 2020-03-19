//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit

@objcMembers
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        let backGround = SKSpriteNode(imageNamed: "space.jpg")
        backGround.zPosition = -1
        addChild(backGround)
        
       
        
        if let particles = SKEmitterNode(fileNamed: "SpaceDust") {
            
            // Add this line of code to fill the space with space dust "10 seconds" before we launch. (So it would be filled as soon as we launch)
            particles.advanceSimulationTime(10)
             // Ipad has 1024 points therefore 512 is the right edge of the ipad
            particles.position.x = 512
            // Show on the screen
            addChild(particles)
            
        
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }

    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
    }
}


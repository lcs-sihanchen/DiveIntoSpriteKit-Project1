//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit
import CoreMotion

@objcMembers
class GameScene: SKScene {
    
    // Properties
    let motionManager = CMMotionManager()
    let player = SKSpriteNode(imageNamed: "player-rocket.png")
    
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
            
        
       
            player.position.x = 400
            addChild(player)
            // On top of the background and the spacedust
            player.zPosition = 1
            
        // Tilt the device to move
        // collecting accelerometer data
            motionManager.startAccelerometerUpdates()
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
        // Gathering data
        if let accelerometerData = motionManager.accelerometerData {
            
            // For the player to move 100 times faster than default
            let changeX = CGFloat(accelerometerData.acceleration.y) * 100
            let changeY = CGFloat(accelerometerData.acceleration.x) * 100
            
            // Update player position for each frame
            player.position.x = changeX
            player.position.y = changeY
            
        }
    }
}


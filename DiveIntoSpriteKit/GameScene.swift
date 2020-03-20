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
// contact delegate is a protocal that the code has to conform
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Properties
    let motionManager = CMMotionManager()
    let player = SKSpriteNode(imageNamed: "player-rocket.png")
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        let backGround = SKSpriteNode(imageNamed: "space.jpg")
        backGround.zPosition = -1
        addChild(backGround)
        
        // Gathering all the collision data
        physicsWorld.contactDelegate = self
        
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
            
            // Every 0.35 seconds deploy an asteroid
            // Target: the game scene
            // Trigger the function createEnemy()
            // No user info
            // Keep Repeating
            gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            
            
            // Add a physics body to the rocket
            player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
            
            // Player ready for collision
            player.physicsBody?.categoryBitMask = 1
            
           
            
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
            
            // Update player position for each frame by add and subtract change values
            player.position.x -= changeX
            player.position.y += changeY
            
        }
    }
    
    func createEnemy() {
        
        
        // Adding Asteroid sprite node
        let sprite = SKSpriteNode(imageNamed: "asteroid")
        
        // Want Asteroids to appear in random Y positions(a number between -350 to 350)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: -350...350))
        
        // Name the sprite
        sprite.name = "enemy"
        
        // zPosition is the same to the player
        sprite.zPosition = 1
        
        // Show the sprite on the scene
        addChild(sprite)
        
        // Let the asteroid have its physics property: Momentum, Slow down over time
        // Size: Original sprite size
        // Texture: the image, the outline?
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        // Move the asteroids using velocity tools
        // Don't want it to move up and down so "y" is 0
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        
        
        // Disable the friction function in sprite kit
        sprite.physicsBody?.linearDamping = 0
        
        // Asteroid ready for collision
        sprite.physicsBody?.contactTestBitMask = 1
        
        // Don't want asteroid collide with other asteroid
        sprite.physicsBody?.categoryBitMask = 0
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // These two commands include all the contacts
        guard let nodeA = contact.bodyA.node else {
            return
            
        }
        guard let nodeB = contact.bodyB.node else {
            return
            
        }
        
        // Special case when one of the nodes is player
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    // If player gets hit, rocket is removed from the screen
    func playerHit(_ node: SKNode) {
        player.removeFromParent()
    }

   
    
    
    
    
    
}


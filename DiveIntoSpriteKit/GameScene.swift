//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit
import CoreMotion

// To do list
// ADD More enemies
// add a restart button
// add different levels
// create bonus
// fire rockets

@objcMembers
// contact delegate is a protocal that the code has to conform
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Properties
    let motionManager = CMMotionManager()
    let player = SKSpriteNode(imageNamed: "player-rocket.png")
    var gameTimer: Timer?
    // create a score label
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
    
    // Score label will be updated when score property is set
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    var touchOnScreen = false
    var contactWithEnergy = false
    // Add background music node
    let music = SKAudioNode(fileNamed: "overworld.mp3")
    
    
    
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        let backGround = SKSpriteNode(imageNamed: "space.jpg")
        backGround.zPosition = -1
        addChild(backGround)
        
        // Gathering all the collision data
        physicsWorld.contactDelegate = self
        
        // Trigger initial text
        score = 0
        
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
            
            // Score label is above background, spacedust, rockets and asteroids
            scoreLabel.zPosition = 2
            
            // y position of the label
            scoreLabel.position.y = 300
            
            // Put this on the scene
            addChild(scoreLabel)
            
            // Activating the background music
            addChild(music)
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
        
        // Make sure it reads first touch
        guard let touch = touches.first else {
            return
        }
        // MARK: Incomplete
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        if tappedNodes.contains(player){
            touchOnScreen = true
        }
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
        // Invoke firingEnergy function
        firingEnergy()
        touchOnScreen = false
        contactWithEnergy = false
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
            
            // Update the score for each frame, stop adding when the game is over
            if player.parent != nil {
                score += 1
            }
            // Make sure the player is not out of the screen
            // Clamping - limit inside a range
            if player.position.x < -400 {
                player.position.x = -400
            } else if player.position.x > 400 {
                player.position.x = 400
            }
            
            if player.position.y < -300 {
                player.position.y = -300
            } else if player.position.y > 300 {
                player.position.y = 300
            }
            
            for node in children {
                // When the asteroids are off screen, remove them
                if node.position.x < -700 || node.position.x > 1400 {
                    node.removeFromParent()
                }
                
                
            }
            
            
            
            
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
        } else if nodeB == player {
            playerHit(nodeA)
            
        } else {
            contactWithEnergy = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        contactWithEnergy = false
    }
    func playerHit(_ node: SKNode) {
        
        if let particles = SKEmitterNode(fileNamed: "Explosion.sks") {
            
            // Explosion over the rocket itself
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
            
            
        }
        
        // If player gets hit, rocket is removed from the screen
        player.removeFromParent()
        
        // When player is hit, make an explosion sound
        let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
        
        // Run an action (play the sound)
        run(sound)
        
        // When player is hit, stop playing the music
        music.removeFromParent()
        
        // Game-over picture shown automatically in the middle
        let gameOver = SKSpriteNode(imageNamed: "gameOver-3")
        // zPosition 10 so it's above everything
        gameOver.zPosition = 10
        addChild(gameOver)
        
        // MARK:Maybe a button here
        // wait for two seconds then run some code(now + 2 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // create a new scene from GameScene.sks
            if let scene = GameScene(fileNamed: "GameScene") {
                // make it stretch to fill all available space
                scene.scaleMode = .aspectFill
                
                // present it immediately
                self.view?.presentScene(scene)
            }
        }
        
        
    }
    
    
    
    func firingEnergy() {
        
        
        let energy = SKSpriteNode(imageNamed: "energy")
        
        
        // zPosition is zero by default
        energy.zPosition = 0
        
        energy.position = CGPoint(x: player.position.x + 100, y: player.position.y)
        
        addChild(energy)
        
        energy.physicsBody = SKPhysicsBody(texture: energy.texture!, size: energy.size)
        
        energy.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        energy.physicsBody?.linearDamping = 0
        energy.physicsBody?.contactTestBitMask = 1
        
        
        
        for n in 0...200{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(n) * 0.01){
                
                if self.contactWithEnergy == true  {
                    energy.removeFromParent()
                    
                }
                
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}


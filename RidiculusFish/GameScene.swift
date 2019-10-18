//
//  GameScene.swift
//  RidiculusFish
//
//  Created by Himanshu Mehta on 2019-10-18.
//  Copyright © 2019 Himanshu Mehta. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var bushes: SKSpriteNode!
    var count:Int! = 0
    var play: SKSpriteNode!
    var hanger: SKSpriteNode!
    var flag: Bool = false
    var flagHanger: Bool = false
    
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        let moveAction1 = SKAction.moveBy(x: 0, y: 10, duration: 1)
         let moveAction2 = SKAction.moveBy(x: 0, y: -20, duration: 1)
        
        self.enumerateChildNodes(withName: "bush")
        {
            (node, stop) in
            self.bushes = node as! SKSpriteNode
            let waterAnimation = SKAction.sequence(
                       [moveAction1,moveAction2,moveAction1]
                   )
                  
                   let waterforever = SKAction.repeatForever(waterAnimation)
                   self.bushes.run(waterforever)
        }
        
        self.hanger = self.childNode(withName: "hanger") as! SKSpriteNode
        self.play = self.childNode(withName: "play") as! SKSpriteNode
        play.zPosition = 999
    }
    
    
    var fish:[SKSpriteNode] = []
       
       func spawnfish() {
           // Add a cat to a static location
//        let randomfish = ["fish1","fish2","fish3","fish4","fish5","fish6","fish7","fish8"]
        let randomFishIndex = Int(CGFloat.random(in: 1 ... 8))
        let cat:SKSpriteNode = SKSpriteNode(imageNamed: "fish\(randomFishIndex)")
           
           // generate a random x position
           let randomXPos = CGFloat.random(in: -100 ... 0)
           let randomYPos = CGFloat.random(in: 0 ... size.height/2-50)
           cat.position = CGPoint(x:randomXPos, y:randomYPos)
        print("fish\([randomFishIndex])")
           
           // add the cat to the screen
           addChild(cat)
           
           // add the cat to the array
           self.fish.append(cat)
           
       }
    
    
    override func update(_ currentTime: TimeInterval) {
        count = count + 1;
//        print(count)
        if(count % 200 == 0){
            spawnfish()
        }
        for node in fish {
            
            node.position.x += 1
//            print("positive")
//            print(node.position.x)
        }
        
//        MARK: speed of hanger
        if(flag == true){
            if(hanger.position.y>0){
            self.hanger.position.y -= 1
            }
        }
        
        for node in fish{
            if(hanger.frame.intersects(node.frame)){
                flagHanger = true
                flag = false
            }
            
        }
//        MARK: hanger moving up direction with fishes
        if (flagHanger == true) {
            for node in fish{
                if(hanger.frame.intersects(node.frame)){
                    node.position.x = hanger.position.x
                    node.position.y = hanger.position.y
                }
            }
            self.hanger.position.y += 1

        }
        
        
        
        
        
//        for nde in fish {
//            if (nde.position.x > size.width) {
//                nde.position.x = nde.position.x - 2
//                print("Negative")
//                print(nde.position.x)
//
//            }
//        }
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        // MARK: Middle of the screen
        let middleOfScreenWidth = self.size.width/2
        let middleOfScreenHeight = self.size.height/2
        if (mousePosition.x < middleOfScreenWidth && mousePosition.y < middleOfScreenHeight) {
            print("Move Left")
            hanger.position.x -= 15
        }
        else  if (mousePosition.x > middleOfScreenWidth && mousePosition.y < middleOfScreenHeight){
            print("Move right")
            hanger.position.x += 15
        }
        
        let mouseTouch = touches.first
               if(mouseTouch==nil){
                   return
               }
               
               let location = mouseTouch!.location(in: self)
               
               let nodeTouched = atPoint(location).name
               print("Player touched: \(nodeTouched)")
           
           
           if (nodeTouched == "play"){
           print("play button pressed")
            self.play.removeFromParent()
            flag = true
           }
        
        
        
    }
    
    
   
    
    
}

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
    var scoreLabel: Int! = 0
    var scoreNode: SKLabelNode!
    var play: SKSpriteNode!
    var hanger: SKSpriteNode!
    var flag: Bool = false
    var flagHanger: Bool = false
    var flagup: Bool = false
    var flagdown: Bool = false
    var cnt: Int = 0
    
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
        self.scoreNode = self.childNode(withName: "score") as! SKLabelNode
        scoreNode.text = "\(scoreLabel ?? 0)"
        scoreNode.zPosition = 999
    }
    
    
    var fish:[SKSpriteNode] = []
       // MARK: FISH Generation function
    func spawnfish() {
        // Add a fish to a static location
        //        let randomfish = ["fish1","fish2","fish3","fish4","fish5","fish6","fish7","fish8"]
        cnt = cnt + 1
        let randomFishIndex = Int(CGFloat.random(in: 1 ... 8))
        let fishs:SKSpriteNode = SKSpriteNode(imageNamed: "fish\(randomFishIndex)")
        
          cnt = cnt + 1
            fishs.name = "fishtest\(cnt)"
        print("fishtest\(cnt)")
        
//        fishs.name = "fishtest"
        // generate a random x position
        let randomXPos = CGFloat.random(in: -100 ... 0)
        let randomYPos = CGFloat.random(in: 0 ... size.height/2-50)
        fishs.position = CGPoint(x:randomXPos, y:randomYPos)
        print("fish\([randomFishIndex])")
        
        // add the cat to the screen
        addChild(fishs)
        
        // add the cat to the array
        self.fish.append(fishs)
        
    }
    
    var catchFish:[SKSpriteNode] = []
    // MARK: UPDATE Method
    override func update(_ currentTime: TimeInterval) {
        //MARK
        count = count + 1;
//        print(count)
        if(count % 200 == 0){
            spawnfish()
        }
        
        //MARK: moving the fishes in x direction
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
        //MARK: Hanger attaches fishes
        for node in fish{
            if(hanger.frame.intersects(node.frame)){
                if(hanger.position.y<size.height/2){
                    flagHanger = true
                    flag = false
                }
            }
            
        }
//        MARK: hanger moving up direction with fishes
        
        if (flagHanger == true) {
            for (index,node) in fish.enumerated() {
                if(hanger.frame.intersects(node.frame)){
                    node.position.x = hanger.position.x
                    node.position.y = hanger.position.y
                    self.catchFish.append(node)
                    print("\(node.texture)")
                    fish.remove(at: index)

                }
            }
            self.hanger.position.y += 1
            
            if (self.hanger.position.y > size.height/2 + 200) {
                flagup = true
                flagHanger = false
               
//                print("xxx")
            }
                for node in catchFish{
            //                if(hanger.frame.intersects(node.frame)){
                                node.position.x = hanger.position.x
                                node.position.y = hanger.position.y
            //                    self.catchFish.append(node)
            //                }
                        }

        }
        
        if(flagup == true){
            for node in catchFish{
//                if(){
                let speedx = CGFloat.random(in: -20 ... 20)
                let speed = CGFloat.random(in: 1 ... 2)
                    node.position.x += speedx
                    node.position.y += speed
//                    self.catchFish.append(node)
//                }
            }
        }
        
        for node in catchFish{
            let fishReturn = CGFloat.random(in: 100 ... 200)
            if(node.position.y > size.height ){
                flagup = false
                flagdown = true
            }
        }
        
        if(flagdown == true){
            for node in catchFish{
            node.position.y -= 1
//                print("\(node.position.y)")
            }
        }
        
    
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
        
        var nodeTouched = atPoint(location).name
       // print("Player touched: \(nodeTouched)")
        
        
        if (nodeTouched == "play"){
            print("play button pressed")
            self.play.removeFromParent()
            flag = true
        }
        //        let mouseXPosition = location.x
        //        let mouseYPosition = location.y
        //
        //        if (nodeTouched == "tree") {
        //            spawnOrange(x: mouseXPosition, y: mouseYPosition)
        //        }
        
        for (ind,node) in catchFish.enumerated()
        {
            
            
            var nodeTouched1 = atPoint(location).name
            print("Touch: \(nodeTouched1)")
            print("node frame: \(node.name)")
            
            for index in 1...cnt {
             if(nodeTouched1 == "fishtest\(index)" )
                {
                    if(hanger.position.y > size.height/2){
                       catchFish[ind].removeFromParent()
                        scoreLabel += 10;
                        scoreNode.text = "SCORE IS: " + "\(scoreLabel ?? 0)"
                        print("xxxx")
                        nodeTouched1 = ""
                        nodeTouched1 = atPoint(location).name
                        
                        print("n: \(nodeTouched1)")
                        
                    }
                }
            }
         
        }
        
        
    }
    
    
}

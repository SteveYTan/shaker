//
//  ViewController.swift
//  shaker
//
//  Created by Steve T on 8/17/15.
//  Copyright © 2015 Steve T. All rights reserved.
//


    import UIKit
    import CoreMotion
    import AVFoundation


    class ViewController: UIViewController {
        
        lazy var motionManager = CMMotionManager()
        var audioPlayer:AVAudioPlayer!
        var volume: Float = 0.0
        
        var people = Person.all()
        var totalCount = 0
        var currentTotal = 0;
        var count : Int = 0
        var turn = false
        var randomNum: Int = 10001230
        var lower : Int = 0
        var upper: Int = 999
        var index = 0
        var shuffled = [Person]()
    
        
        @IBOutlet weak var yourRestrictions: UILabel!
        
        @IBOutlet weak var randomTotalShakes: UILabel!
        
        @IBOutlet weak var shakeCount: UILabel!
        
        @IBOutlet weak var currentPlayer: UILabel!
        
        
        @IBOutlet weak var startButtonLabel: UIButton!
       
        @IBAction func startButton(sender: UIButton) {
//            audioPlayer.volume = 1.0
            if turn == false{
                
            turn = true
            count = 0;
            currentPlayer.textColor = UIColor.greenColor()
            
    
            lower = Int(arc4random_uniform(3) + 1)
            upper = Int(arc4random_uniform(6) + 9)
            
              
            }
            
            
        }
        func lose(){
            
            currentPlayer.textColor = UIColor.blackColor()
            restriction1.text = String(lower)
            restriction1.hidden = false
            resetLabel.hidden = false
            //make noise
            restriction3.text = String(upper)
            restriction3.hidden = false
            shakeCount.text = "You lose!"
            startButtonLabel.enabled = false
            
            //// sound ///////
        
            let audioFilePath = NSBundle.mainBundle().pathForResource("alarm", ofType: "mp3")
            //"alarm" is the name of the mp3 file
            
            if audioFilePath != nil {
                
                let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
                
                audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl, fileTypeHint: nil)
                audioPlayer.play()
                
            } else {
                print("audio file is not found")
            }

            ////////////////////
            
        }
        
        func reset(){
            startButtonLabel.enabled = true
            turn = false
            totalCount = Int(arc4random_uniform(30) + 30)
            count = 0
            currentTotal = 0
            randomTotalShakes.text = String(totalCount)
            shakeCount.text = "0";
            
            restriction1.hidden = true
            resetLabel.hidden = true
            restriction3.hidden = true
            
            //////start song ////////////////
            
            let audioFilePath1 = NSBundle.mainBundle().pathForResource("shakeitoff", ofType: "mp3")
            //"alarm" is the name of the mp3 file
            
            if audioFilePath1 != nil {
                
                let audioFileUrl1 = NSURL.fileURLWithPath(audioFilePath1!)
                
                audioPlayer = try! AVAudioPlayer(contentsOfURL: audioFileUrl1, fileTypeHint: nil)
                audioPlayer.play()
                
            } else {
                print("audio file is not found")
            }
            /////////////////////////////////
            
            
            yourRestrictions.hidden = true
            
            
            for var i = 0; i < 10000; i++ {
                
                var x = Int(arc4random_uniform(UInt32(shuffled.count)))
                var y = Int(arc4random_uniform(UInt32(shuffled.count)))
                
                var temp = shuffled[x]
                shuffled[x] = shuffled[y]
                shuffled[y] = temp
                
            }
            index = 0
            currentPlayer.text = shuffled[index].objective
     
        }
      
        
        @IBAction func endButton(sender: UIButton) {
            
            if (turn == true){
//                audioPlayer.volume = 0.0
                
                if count < (lower * 2) {
                    lose()
                }
                
                
                currentPlayer.textColor = UIColor.blackColor()
                turn = false
                index++
                
                if index == shuffled.count
                {
                    index = 0
                }
                
                currentPlayer.text = shuffled[index].objective
                
                count = 0
         
            }
       
        }
        
        @IBOutlet weak var restriction1: UILabel!
        
        @IBOutlet weak var restriction3: UILabel!
        
        @IBOutlet weak var resetLabel: UIButton!
        
        @IBAction func resetButton(sender: UIButton) {
            reset()
            
            
        }
 
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            restriction1.hidden = true
            resetLabel.hidden = true
            restriction3.hidden = true
            
            
            
            shuffled = people
            
            
            for var i = 0; i < 10000; i++ {
                
                var x = Int(arc4random_uniform(UInt32(shuffled.count)))
                var y = Int(arc4random_uniform(UInt32(shuffled.count)))
                
                var temp = shuffled[x]
                shuffled[x] = shuffled[y]
                shuffled[y] = temp
                
            }
            
            currentPlayer.text = shuffled[0].objective
            
            let players = shuffled.count
            
            
            
            
            totalCount = Int(arc4random_uniform(30) + UInt32(players) * 10)
            
            
            
            randomTotalShakes.text = String(totalCount)
            
            yourRestrictions.hidden = true
            
            
            
            if motionManager.accelerometerAvailable{
                let queue = NSOperationQueue()
                motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                    {data, error in
                        
                        if let data = data {
                            var high = false
                            var low = false
                            if(data.acceleration.y > 5 && !high) {
                                high = true
                            }
                            if(data.acceleration.y < -3 && high) {
                                high = false
                                
                                if self.turn == true{
                                self.currentTotal++
                                    self.count++
                                    
                                    
                                    
                                    if self.currentTotal > (self.totalCount * 2){
                                        self.turn = false
                                        self.lose()
                                    }
                                    
                                }
                                
                                
                            }
                            if(data.acceleration.y < -5 && !low) {
                                low = true
                            }
                            if(data.acceleration.y < 3 && low) {
                                low = false
                                
                                if self.turn == true{
                                self.currentTotal++
                                    self.count++
                                    
                                    if self.count > (self.upper * 2){
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.turn = false
                                            self.lose()
                                        })
                                        
                                        
                                    }
                                    
                                    
                                    if self.currentTotal > (self.totalCount * 2){
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.turn = false
                                            self.lose()
                                        })
                                    }
                                    
                                    
                                    
                                print("Current Count: " + String(self.currentTotal / 2))
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                     self.shakeCount.text = String(self.currentTotal / 2)
                                })
                               
                                }
                            }
                                
                                
                            }
                        }
                    
                )
            } else {
                print("Accelerometer is not available")
            }
            
        }
            
            

        }
        
        
        
    



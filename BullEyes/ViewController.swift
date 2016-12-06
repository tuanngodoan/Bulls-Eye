//
//  ViewController.swift
//  BullEyes
//
//  Created by Doan Tuan on 12/5/16.
//  Copyright © 2016 Doan Tuan. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation
class ViewController: UIViewController, AVAudioPlayerDelegate {

    var newGameAudio = AVAudioPlayer()
    var newRoundAudio = AVAudioPlayer()
    var badAudio = AVAudioPlayer()
    var pfAudio = AVAudioPlayer()
    var checkGood: Int = 1 // 1 perfect 0 fail
    var currentValue:Int!
    var targetValue:Int!
    var score = 0
    var round = 0
    
    
    @IBOutlet weak var slider:UISlider!
    @IBOutlet weak var taretLabel:UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set audio
        newGameAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "newgame", ofType: ".wav")!))
        newGameAudio.delegate = self
        
        newRoundAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "newRound", ofType: ".wav")!))
        newRoundAudio.delegate = self
        
        badAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "fail", ofType: ".wav")!))
        badAudio.delegate = self
        
        pfAudio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "perfect", ofType: ".wav")!))
        pfAudio.delegate = self
        
        
        //
        newGameAudio.play()
        
        startNewGame()
        setThubSlider()
    }

    @IBAction func startOver(_ sender: Any) {
        startNewGame()
        
        let transiton = CATransition()
        
        transiton.type = kCATransitionFade
        
        transiton.duration = 1
        
        transiton.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.add(transiton, forKey: nil)
    }
    
    func startNewGame(){
        score = 0
        round = 0
        startNewRound()
    }
    
    
    func startNewRound(){
        newRoundAudio.play()
       
        round = round + 1
        
        targetValue  = 1 + Int(arc4random_uniform(UInt32(100)))
            
        currentValue = 50
            
        slider.value = Float(currentValue)
        
        updateLabel()
        
        let transiton = CATransition()
        
        transiton.type = kCATransitionFade
        
        transiton.duration = 1
        
        transiton.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.add(transiton, forKey: nil)
    }
    func updateLabel(){
        taretLabel.text = String(describing: targetValue!)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
    
    
    func setThubSlider(){
        
        // normal
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal@2x")
        
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        // highligh
        
        let thumbImageHighLigh = UIImage(named: "SliderThumb-Highlighted@2x")
        
        slider.setThumbImage(thumbImageHighLigh, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft@2x"){
            
            let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
            
            slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
            
        }
        if let trackRightImage = UIImage(named: "SliderTrackRight@2x") {
            let trackRightResizable =
                trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        }
        
    }
    
    @IBAction func showAlert(){
        
        checkGood = 0
        let diffValue = Swift.abs(currentValue-targetValue)
        
        var point = 100 - diffValue
        
        
        // Cal point
        let title:String
        
        if diffValue == 0{
            title = "Perfect!"
            point = point + 100
            checkGood = 1
            
        }else if diffValue < 5{
            title = "You almost had it!"
            if diffValue == 1 {
                point = point + 50
            }
        }
        else if diffValue < 10{
            title = "Pretty Good!"
        }else {
            title = "Not even close...!"
        }
        
        // total score
        score = score + point
        
        let message = "Your point in round \(round) is: \(point) "
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Awesome", style: .default) { (finished) in
            //when close alert, new round begin
            self.startNewRound()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: {
            if self.checkGood == 1 {
                self.pfAudio.play()
            }else{
                self.badAudio.play()
            }
        } )
    }

    @IBAction func sliderMoved(slider :UISlider){
        currentValue = lround(Double(slider.value))
    }
    
}


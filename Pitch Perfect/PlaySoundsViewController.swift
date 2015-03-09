//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Luis Matute on 11/26/14.
//  Copyright (c) 2014 Luis Matute. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var error: NSError?
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSlow(sender: AnyObject) {
        audioPlayer.rate = 0.5
        play()
    }

    @IBAction func playFast(sender: AnyObject) {
        audioPlayer.rate = 1.5
        play()
    }
    
    @IBAction func playNormal(sender: AnyObject) {
        audioPlayer.rate = 1.0
        play()
    }
    
    @IBAction func stopPlayback(sender: AnyObject) {
        stopPlaying()
        println("Stopped")
    }
    
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    func play() {
        stopPlaying()
        audioPlayer.play()
        println("Playing")
    }
    
    func stopPlaying() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
}

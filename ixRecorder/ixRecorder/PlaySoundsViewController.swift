//
//  PlaySoundsViewController.swift
//  ixRecorder
//
//  Created by Brandon Taleisnik on 6/28/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var testVar: String!
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(testVar)
        setupAudio()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    @IBAction func playSoundButtons (_ sender: UIButton) {
        print("Play sound button")
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
    }
    
    
    @IBAction func fastPlayback(_ sender: Any) {
        
        do {
            let sound = try AVAudioPlayer(contentsOf: recordedAudioURL)
            audioPlayer = sound
            
            sound.enableRate = true
            sound.rate = Float(1.5)
            sound.play()
            
            
            let test = AVAudioUnitTimePitch()
            test.pitch = 1200
        } catch {
            print("Couldn't load or play recording")
        }
        
        
        
    }
    
    
    
    @IBAction func highPitchPlayback(_ sender: Any) {
        
        var recordingSession = AVAudioSession.sharedInstance()
        
        do {
            // Here recordingSession is just a shared instance of AVAudioSession
            
            try recordingSession.setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers, .defaultToSpeaker]) // There are several options here - choose what best suits your needs
            try recordingSession.setActive(true)
            
            // I suggest adding notifications here for route and configuration changes
        }
        catch {
            print("Session could not be activated")
        }
        
        let audioEngine = AVAudioEngine()
        
        let audioMixer = AVAudioMixerNode()
        let micMixer = AVAudioMixerNode()
        let reverb = AVAudioUnitReverb()
        let echo = AVAudioUnitDelay()
        let audioPlayerNode = AVAudioPlayerNode()
        let pitchMixer = AVAudioUnitTimePitch()
        
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(reverb)
        audioEngine.attach(echo)
        audioEngine.attach(audioMixer)
        audioEngine.attach(micMixer)
        audioEngine.attach(pitchMixer)
        
        audioEngine.connect(audioMixer, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.connect(echo, to: audioMixer, fromBus: 0, toBus: 0, format: nil)
        audioEngine.connect(reverb, to: echo, fromBus: 0, toBus: 0, format: nil)
        audioEngine.connect(micMixer, to: reverb, format: nil)
        audioEngine.connect(pitchMixer, to: micMixer, fromBus: 0, toBus: 0, format: nil)
        
        let playerConnectionPoints = [
            AVAudioConnectionPoint(node: audioEngine.mainMixerNode, bus: 0),
            AVAudioConnectionPoint(node: audioMixer, bus: 1)
        ]
        
        audioEngine.connect(audioPlayerNode, to: playerConnectionPoints, fromBus: 0, format: nil)
        
        
        
    }
    
    
    @IBAction func slowPlayback(_ sender: Any) {
        
        do {
            let sound = try AVAudioPlayer(contentsOf: recordedAudioURL)
            audioPlayer = sound
            
            sound.enableRate = true
            sound.rate = Float(0.7)
            sound.play()
        } catch {
            print("Couldn't load or play recording")
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

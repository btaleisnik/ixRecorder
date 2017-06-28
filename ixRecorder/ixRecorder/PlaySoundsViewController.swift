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
    
    var recordedAudioURL: URL!
    var testVar: String!
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(testVar)
        // Do any additional setup after loading the view.
        
        do {
            let sound = try AVAudioPlayer(contentsOf: recordedAudioURL)
            audioPlayer = sound
            sound.play()
        } catch {
            print("Couldn't load or play recording")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func fastPlayback(_ sender: Any) {
        
        do {
            let sound = try AVAudioPlayer(contentsOf: recordedAudioURL)
            audioPlayer = sound
            
            sound.enableRate = true
            sound.rate = Float(1.5)
            sound.play()
        } catch {
            print("Couldn't load or play recording")
        }
        
        
        
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

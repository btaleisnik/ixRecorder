//
//  RecordSoundsViewController.swift
//  ixRecorder
//
//  Created by Brandon Taleisnik on 6/26/17.
//  Copyright © 2017 Brandon Taleisnik. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var inProgressButton: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
        recordButton.isEnabled = true
        inProgressButton.isHidden = true
    }
    
    @IBAction func startRecording(sender: AnyObject) {
        print("Hello world")
        inProgressButton.isHidden = false
        stopButton.isHidden = false
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        
        //Record Sound
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedvoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // AVAudioSession is needed to record or play audio
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        

    }
    
    @IBAction func stopRecording(_ sender: Any) {
        //Save Recording
        audioRecorder.stop()
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        inProgressButton.isHidden = true
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    
    @IBAction func playRecording(_ sender: Any) {
        //Play recording
        
    }
    
    
    // Because of AVAudioRecorderDelegate protocol, we can define this function and it will know to use our implementation
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    
    override func prepare(for segue: UIStoryBoardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}


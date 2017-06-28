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

    var audioRecorder:AVAudioRecorder?
    var soundFileURL: URL?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var inProgressButton: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create filename
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime) + ".wav"
        
        
        //Create file path
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                     in: FileManager.SearchPathDomainMask.userDomainMask)
        soundFileURL = paths[0].appendingPathComponent(recordingName)
        
        // Initialize default settings
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        // Initialize the audio recorder with the filename and settings
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL!, settings: recordSettings)
            audioRecorder?.delegate = self
        } catch {
            print("Unable to initialize audioRecorder")
        }

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
        
        if audioRecorder?.isRecording == false {
            // Start recording
            audioRecorder?.record()
            
        }

    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        inProgressButton.isHidden = true

        // Stop recording
        audioRecorder?.stop()
        
        
    }
    
    
    // Because of AVAudioRecorderDelegate protocol, we can define this function and it will know to use our implementation
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    
        //REMOVE THESE SOON
        print(recorder.url.lastPathComponent)
        
        self.performSegue(withIdentifier: "stopRecording", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            playSoundsVC.recordedAudioURL = soundFileURL
            playSoundsVC.testVar = "Data successfully sent"
        }
    }
    
}


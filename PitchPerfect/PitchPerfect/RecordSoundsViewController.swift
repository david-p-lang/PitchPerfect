//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by David Lang on 4/18/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(isRecording: false)
    }
    
    // MARK: - Stop recording
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    // MARK: - Record Audio
    //Criteria - The app uses IBAction methods to record audio and playback sounds.
    @IBAction func recordAudio(_ sender: Any) {
         configureUI(isRecording: true)
        
        // Set path and File name
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // setup AVAudioSession with play and record and defaults play to speakers
        let session = AVAudioSession.sharedInstance()
        let category = AVAudioSession.Category.playAndRecord
        try! session.setCategory(category, options: .defaultToSpeaker)
        
        // configure and record with audioRecorder
        // Criteria - The first scene of the app uses AVAudioRecorder to record audio.
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // Programmatic trigger via performSegueWithIdentifier() in AVAudioRecorderDelegate
    // Criteria - The app uses the audioRecorderDidFinishRecording() method to determine when the audio has finished recording.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording not successful")
        }
    }
    
    // Pass the recorded audio url to the destination view controller
    // Criteria - The app programmatically triggers a segue from the first scene to the second.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recoredAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recoredAudioURL
        }
    }
    
    // Criteria - Labels and buttons are shown or hidden as appropriate.
    func configureUI(isRecording: Bool) {
        if isRecording {
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            recordingLabel.text = "Recording in progress"
        } else {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordingLabel.text = "Tap to Record"
        }
    }
}


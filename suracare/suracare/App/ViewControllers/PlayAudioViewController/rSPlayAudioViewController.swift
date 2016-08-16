//
//  rSPlayAudioViewController.swift
//  suracare
//
//  Created by hoi on 8/16/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreData

class Voice: NSObject {
    
    var date: NSDate
    var filename: String?
    var subject: String = ""
    var duration: NSNumber = 0.0
    override init() {
        self.date = NSDate()
        self.filename = "filename"
        self.subject = "subject"
        self.duration = 0.0
    }
}


class AudioSessionHelper {
    
    struct Constants {
        struct Notification {
            struct AudioObjectWillStart {
                static let Name = "KMAudioObjectWillStartNotification"
                struct UserInfo {
                    static let AudioObjectKey = "KMAudioObjectWillStartNotificationAudioObjectKey"
                }
            }
        }
    }
    
    class func postStartAudioNotificaion(AudioObject: NSObject) {
        let userInfo = [Constants.Notification.AudioObjectWillStart.UserInfo.AudioObjectKey: AudioObject]
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.AudioObjectWillStart.Name,
                                                                  object: nil,
                                                                  userInfo: userInfo)
    }
    
    class func setupSessionActive(active: Bool, catagory: String = AVAudioSessionCategoryPlayback) {
        let session = AVAudioSession.sharedInstance()
        if active {
            do {
                try session.setCategory(catagory)
            } catch {
                debugPrint("Could not set session category: \(error)")
            }
            
            do {
                try session.setActive(true)
            } catch {
                debugPrint("Could not activate session: \(error)")
            }
        } else {
            do {
                try session.setActive(false, withOptions: .NotifyOthersOnDeactivation)
            } catch {
                ("Could not deactivate session: \(error)")
            }
        }
    }
}




protocol rSPlayAudioViewControllerDelegate {
    func didFinishViewController(detailViewController: rSPlayAudioViewController, didSave: Bool)
}

class rSPlayAudioViewController: rSBaseViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    
    var voice: Voice = Voice()
    
    var recordingHasUpdates = false
    var overlayTransitioningDelegate: KMOverlayTransitioningDelegate?
    
    let tmpStoreURL = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent("tmpVoice.caf")
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    
    lazy var directoryURL: NSURL = {
        let doucumentURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let _directoryURL = doucumentURL.URLByAppendingPathComponent("Voice")
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(_directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assertionFailure("Error creating directory: \(error)")
        }
        return _directoryURL
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playback.playButton = self.playButton
        playback.progressSlider = self.progressSlider
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioObjectWillStart:", name: AudioSessionHelper.Constants.Notification.AudioObjectWillStart.Name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "proximityStateDidChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if playback.audioPlayer?.playing == true {
            playback.state = .Default(deactive: true)
        } else {
            playback.state = .Default(deactive: false)
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AudioSessionHelper.Constants.Notification.AudioObjectWillStart.Name, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceProximityStateDidChangeNotification, object: nil)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Record" {
            playback.state = .Default(deactive: false)
            
            let recordViewController = segue.destinationViewController as! rSRecordViewController
            recordViewController.configRecorderWithURL(tmpStoreURL, delegate: self)
            
            overlayTransitioningDelegate = KMOverlayTransitioningDelegate()
            transitioningDelegate = overlayTransitioningDelegate
            recordViewController.modalPresentationStyle = .Custom
            recordViewController.transitioningDelegate = overlayTransitioningDelegate
        }
    }
    
    
    
    @IBAction func playAudioButtonTapped(sender: AnyObject) {
        if let player = playback.audioPlayer {
            if player.playing {
                playback.state = .Pause(deactive: true)
            } else {
                playback.state = .Play
            }
        } else {
            let url: NSURL = {
                if self.recordingHasUpdates {
                    return self.tmpStoreURL
                } else {
                    return self.directoryURL.URLByAppendingPathComponent(self.voice.filename!)
                }
            }()
            do {
                try playback.audioPlayer = AVAudioPlayer(contentsOfURL: url)
                playback.audioPlayer!.delegate = self
                playback.audioPlayer!.prepareToPlay()
                playback.state = .Play
            } catch {
                let alertController = UIAlertController(title: nil, message: "The audio file seems to be corrupted. Do you want to retake?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Retake", style: .Destructive) { _ in
                    self.performSegueWithIdentifier("Record", sender: self)
                }
                alertController.addAction(OKAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    // MARK: - Playback Control
    
    class KMPlayback {
        var playButton: UIButton!
        var progressSlider: UISlider!
        var audioPlayer: AVAudioPlayer?
        var timer: NSTimer?
        
        var state: KMPlaybackState = .Default(deactive: false) {
            didSet {
                state.changePlaybackState(self)
            }
        }
        
        @objc func updateprogressSliderValue() {
            if let player = audioPlayer {
                progressSlider.value = Float(player.currentTime / player.duration)
            }
        }
    }
    
    enum KMPlaybackState {
        case Play
        case Pause(deactive: Bool)
        case Finish
        case Default(deactive: Bool)
        
        func changePlaybackState(playback: KMPlayback) {
            switch self {
            case .Play:
                if let player = playback.audioPlayer {
                    AudioSessionHelper.postStartAudioNotificaion(player)
                    playback.timer?.invalidate()
                    playback.timer = NSTimer(
                        timeInterval: 0.1,
                        target: playback,
                        selector: "updateprogressSliderValue",
                        userInfo: nil,
                        repeats: true)
                    NSRunLoop.currentRunLoop().addTimer(playback.timer!, forMode: NSRunLoopCommonModes)
                    AudioSessionHelper.setupSessionActive(true)
                    if !player.playing {
                        player.currentTime = NSTimeInterval(playback.progressSlider.value) * player.duration
                        player.play()
                    }
                    UIDevice.currentDevice().proximityMonitoringEnabled = true
                    playback.playButton.setImage(UIImage(named: "ic_pause"), forState: .Normal)
                    playback.updateprogressSliderValue()
                }
            case .Pause(let deactive):
                playback.timer?.invalidate()
                playback.timer = nil
                playback.audioPlayer?.pause()
                UIDevice.currentDevice().proximityMonitoringEnabled = false
                if deactive {
                    AudioSessionHelper.setupSessionActive(false)
                }
                playback.playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
                playback.updateprogressSliderValue()
            case .Finish:
                playback.timer?.invalidate()
                playback.timer = nil
                UIDevice.currentDevice().proximityMonitoringEnabled = false
                AudioSessionHelper.setupSessionActive(false)
                playback.playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
                playback.progressSlider.value = 1.0
            case .Default(let deactive):
                playback.timer?.invalidate()
                playback.timer = nil
                playback.audioPlayer = nil
                UIDevice.currentDevice().proximityMonitoringEnabled = false
                if deactive {
                    AudioSessionHelper.setupSessionActive(false)
                }
                playback.playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
                playback.progressSlider.value = 0.0
            }
        }
    }
    
    lazy var playback = KMPlayback()

    //  AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordingHasUpdates = true
            playback.playButton.hidden = false
            playback.progressSlider.hidden = false
            recordButton.setTitle("", forState: .Normal)
            
            let asset = AVURLAsset(URL: recorder.url, options: nil)
            let duration = asset.duration
            let durationInSeconds = Int(ceil(CMTimeGetSeconds(duration)))
            voice.duration = durationInSeconds
        }
    }
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        assertionFailure("Encode Error occurred! Error: \(error)")
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        playback.state = .Finish
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        assertionFailure("Decode Error occurred! Error: \(error)")
    }
    
    func handleInterruption(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let interruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as! UInt
            if interruptionType == AVAudioSessionInterruptionType.Began.rawValue {
                if playback.audioPlayer?.playing == true {
                    playback.state = .Pause(deactive: true)
                }
            }
        }
    }
    
    func audioObjectWillStart(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let audioObject: AnyObject = userInfo[AudioSessionHelper.Constants.Notification.AudioObjectWillStart.UserInfo.AudioObjectKey] {
                if playback.audioPlayer != audioObject as? AVAudioPlayer && playback.audioPlayer?.playing == true {
                    playback.state = .Pause(deactive: false)
                }
            }
        }
    }
    
    func proximityStateDidChange(notification: NSNotification) {
        if playback.audioPlayer?.playing == true {
            if UIDevice.currentDevice().proximityState {
                AudioSessionHelper.setupSessionActive(true, catagory: AVAudioSessionCategoryPlayAndRecord)
            } else {
                AudioSessionHelper.setupSessionActive(true)
            }
        }
    }
    

 

}

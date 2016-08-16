//
//  rSRecordViewController.swift
//  suracare
//
//  Created by hoi on 8/16/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit
import AVFoundation

class rSRecordViewController: rSBaseViewController {
    
    var audioRecorder: AVAudioRecorder?
    var meterTimer: NSTimer?
    let recordDuration = 10.0
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var voiceRecordHUD: KMVoiceRecordHUD!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        voiceRecordHUD.update(0.0)
        voiceRecordHUD.fillColor = UIColor.greenColor()
        durationLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func finishRecord(sender: AnyObject) {
        meterTimer?.invalidate()
        meterTimer = nil
        voiceRecordHUD.update(0.0)
        if audioRecorder?.currentTime > 0 {
            audioRecorder?.stop()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            audioRecorder = nil
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        AudioSessionHelper.setupSessionActive(false)
    }
    
    
    // MARK: Notification
    
    func handleInterruption(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let interruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as! UInt
            if interruptionType == AVAudioSessionInterruptionType.Began.rawValue {
                if audioRecorder?.recording == true {
                    audioRecorder?.pause()
                }
                meterTimer?.invalidate()
                meterTimer = nil
                voiceRecordHUD.update(0.0)
            } else if interruptionType == AVAudioSessionInterruptionType.Ended.rawValue {
                let alertController = UIAlertController(title: nil, message: "Do you want to continue the recording?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
                    self.finishRecord(self)
                }
                alertController.addAction(cancelAction)
                
                let resumeAction = UIAlertAction(title: "Resume", style: .Default) { _ in
                    self.delay(0.8) {
                        if let recorder = self.audioRecorder {
                            recorder.record()
                            self.updateRecorderCurrentTimeAndMeters()
                            self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                                                                     target: self,
                                                                                     selector: "updateRecorderCurrentTimeAndMeters",
                                                                                     userInfo: nil,
                                                                                     repeats: true)
                            
                        }
                    }
                }
                alertController.addAction(resumeAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Other
    
    func delay(time: NSTimeInterval, block: () -> Void) {
        let time =  dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func updateRecorderCurrentTimeAndMeters() {
        if let recorder = audioRecorder {
            let currentTime = Int(recorder.currentTime)
            let timeLeft = Int(recordDuration) - currentTime
            if timeLeft > 10 {
                durationLabel.text = "\(currentTime)″"
            } else {
                voiceRecordHUD.fillColor = UIColor.redColor()
                durationLabel.text = "\(timeLeft) seconds left"
                if timeLeft == 0 {
                    durationLabel.text = "Time is up"
                    finishRecord(self)
                }
            }
            
            if recorder.recording {
                recorder.updateMeters()
                let ALPHA = 0.05
                let peakPower = pow(10, (ALPHA * Double(recorder.peakPowerForChannel(0))))
                var rate: Double = 0.0
                if (peakPower <= 0.2) {
                    rate = 0.2
                } else if (peakPower > 0.9) {
                    rate = 1.0
                } else {
                    rate = peakPower
                }
                voiceRecordHUD.update(CGFloat(rate))
            }
        }
    }
    
    func configRecorderWithURL(url: NSURL, delegate: AVAudioRecorderDelegate) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        session.requestRecordPermission {granted in
            if granted {
                debugPrint("Recording permission has been granted")
                let recordSettings: [String : AnyObject]  = [
                    AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatLinearPCM),
                    AVSampleRateKey : 44100.0,
                    AVNumberOfChannelsKey : 2,
                    AVLinearPCMBitDepthKey : 16,
                    AVLinearPCMIsBigEndianKey : false,
                    AVLinearPCMIsFloatKey : false,
                ]
                self.audioRecorder = try? AVAudioRecorder(URL: url, settings: recordSettings)
                guard let recorder = self.audioRecorder else {
                    return
                }
                recorder.delegate = delegate
                recorder.meteringEnabled = true
                AudioSessionHelper.postStartAudioNotificaion(recorder)
                self.delay(0.8) {
                    AudioSessionHelper.setupSessionActive(true, catagory: AVAudioSessionCategoryRecord)
                    if recorder.prepareToRecord() {
                        recorder.recordForDuration(self.recordDuration)
                        debugPrint("Start recording")
                        
                        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
                        
                        self.updateRecorderCurrentTimeAndMeters()
                        self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                            target: self,
                            selector: "updateRecorderCurrentTimeAndMeters",
                            userInfo: nil,
                            repeats: true)
                    }
                }
            } else {
                debugPrint("Recording permission has been denied")
            }
        }
    }

}

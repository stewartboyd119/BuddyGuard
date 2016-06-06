//
//  alarm.swift
//  BuddyGuard
//
//  Created by Stewart Boyd on 5/30/16.
//  Copyright © 2016 Stewart Boyd. All rights reserved.
//

import Foundation
import AVFoundation

class Alarm{
    static let max_volume : Float = 1.0;
    static let min_volume : Float = 0.0;
    var time_delay = 0.0; //number of seconds until begin alarm
    var gradient = 0.0; //Number of seconds until max volume from start of alarm
    var file_url : NSURL?;
    let audio_player : AVAudioPlayer;
    var fader : Fader?;
    var delegate : AVAudioPlayerDelegate?;

    var sound_fpath : String?{
        get {
            return self.file_url?.absoluteString
        }
        set{
            self.file_url = NSURL.init(fileURLWithPath: newValue!);
        }
    }

    var volume : Float{
        get{
            return self.audio_player.volume;
        }
        set{
            self.audio_player.volume = Alarm.volume_range(newValue);
        }
    }
    
    

    init(fpath : String? = nil, volume : Float = 1.0, fader : Fader? = nil) throws {
        /*
         fpath - filepath pointing to a resource to be used as alarm
         volume - val between 0 and 1
        */

        if let _ = fpath {
            self.file_url = NSURL.init(fileURLWithPath: fpath!)
        }
        else{
            let fpath = NSBundle.mainBundle().pathForResource("test", ofType: "wav")!;
            self.file_url = NSURL.init(fileURLWithPath: fpath)
        }
        self.fader = fader
        audio_player = try AVAudioPlayer.init(contentsOfURL: self.file_url!);
        audio_player.volume = Alarm.volume_range(volume);
        audio_player.prepareToPlay()
    }

    static func volume_range(volume : Float) -> Float{
        if volume < Alarm.min_volume {
            return Alarm.min_volume
        }
        else if volume > Alarm.max_volume {
            return Alarm.max_volume
        }
        else {
            return volume
        }
    }

    func play( ) -> Bool?{
        let played = self.audio_player.play()
        //fader?.fade(fromVolume: fromVolume, toVolume: <#T##Double#>, duration: <#T##Double#>, velocity: <#T##Double#>, onFinished: <#T##((Bool) -> ())?##((Bool) -> ())?##(Bool) -> ()#>)
        return played
    }

    func stop() {
        self.audio_player.stop()
    }

    func stop_if_true(stop_bool : Bool){
        if stop_bool{
            self.stop();
        }
    }

    func play_with_fade(fader : Fader? = nil, duration: Double = Fader.defaultFadeDurationSeconds,
                        velocity: Double = Fader.defaultVelocity, onFinished: ((Bool)->())? = nil) {
        self.play()
        fader?.fade(duration, velocity: velocity, onFinished: onFinished)
    }
}


public class Fader: NSObject {

    static let defaultFadeDurationSeconds = 3.0
    static let defaultVelocity = 2.0
    let player: AVAudioPlayer
    private var timer: NSTimer?
    
    // The higher the number - the higher the quality of fade
    // and it will consume more CPU.
    var volumeAlterationsPerSecond = 30.0

    private var fadeDurationSeconds = Fader.defaultFadeDurationSeconds
    private var fadeVelocity = Fader.defaultVelocity
    private var totalSteps = 0.0;
    var fromVolume : Double = 0.0;
    var toVolume : Double = 0.0;
    private var currentStep = 0
    
    private var onFinished: ((Bool)->())? = nil
    
    init(player: AVAudioPlayer, fromVolume: Double = 0, toVolume: Double = 1) {
        self.player = player
        self.fromVolume = Fader.makeSureValueIsBetween0and1(fromVolume)
        self.toVolume = Fader.makeSureValueIsBetween0and1(toVolume)
        
    }
    
    deinit {
        callOnFinished(false)
        stop()
    }
    
    private var fadeIn: Bool {
        return fromVolume < toVolume
    }

    var shouldStopTimer: Bool {
        return Double(currentStep) > totalSteps
    }
    
    func fadeIn(duration: Double = Fader.defaultFadeDurationSeconds,
                velocity: Double = Fader.defaultVelocity, onFinished: ((Bool)->())? = nil) {
        
        fade(duration, velocity: velocity, onFinished: onFinished)
    }
    
    
    func fade(duration: Double = Fader.defaultFadeDurationSeconds,
                         velocity: Double = Fader.defaultVelocity, onFinished: ((Bool)->())? = nil) {

        self.fadeDurationSeconds = duration
        self.fadeVelocity = velocity
        self.totalSteps = fadeDurationSeconds * volumeAlterationsPerSecond
        
        callOnFinished(false)
        self.onFinished = onFinished
        
        player.volume = Float(self.fromVolume)

        //if already at volume to go to then return
        if self.fromVolume == self.toVolume {
            callOnFinished(true)
            return
        }
        
        startTimer()
    }
    
    // Stop fading. Does not stop the sound.
    func stop() {
        stopTimer()
    }
    
    private func callOnFinished(finished: Bool) {
        onFinished?(finished)
        onFinished = nil
    }
    
    private func startTimer() {
        stopTimer()
        currentStep = 0
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1 / volumeAlterationsPerSecond, target: self,
                                                       selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        if let currentTimer = timer {
            currentTimer.invalidate()
            timer = nil
        }
    }
    
    func timerFired(timer: NSTimer) {
        print("timerFired \(currentStep)");
        if shouldStopTimer {
            player.volume = Float(toVolume)
            stopTimer()
            callOnFinished(true)
            return
        }
        
        let currentTimeFrom0To1 = timeFrom0To1(
            currentStep, fadeDurationSeconds: fadeDurationSeconds, volumeAlterationsPerSecond: volumeAlterationsPerSecond)
        
        var volumeMultiplier: Double
        var newVolume: Double = 0

        volumeMultiplier = Fader.fadeInVolumeMultiplier(currentTimeFrom0To1, velocity: fadeVelocity)
            
        newVolume = fromVolume + (toVolume - fromVolume) * volumeMultiplier

        
        player.volume = Float(newVolume)
        
        currentStep += 1
    }

    
    public func timeFrom0To1(currentStep: Int, fadeDurationSeconds: Double,
                                   volumeAlterationsPerSecond: Double) -> Double {
        
        //let totalSteps = fadeDurationSeconds * volumeAlterationsPerSecond
        var result = Double(currentStep) / totalSteps
        result = Fader.makeSureValueIsBetween0and1(result)
        
        return result
    }
    
    // Graph: https://www.desmos.com/calculator/wnstesdf0h
    public class func fadeInVolumeMultiplier(timeFrom0To1: Double, velocity: Double) -> Double {
        let time = makeSureValueIsBetween0and1(timeFrom0To1)
        return pow(M_E, velocity * (time - 1)) * time
    }
    
    private class func makeSureValueIsBetween0and1(value: Double) -> Double {
        if value < 0 { return 0 }
        if value > 1 { return 1 }
        return value
    }
}
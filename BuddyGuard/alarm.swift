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
    
    let audio_player : AVAudioPlayer;

    init(fpath : String? = nil, volume : Float = 1.0) throws {
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

    func play() -> Bool?{
        print("begin playing");
        let played = self.audio_player.play()
        print("end call to play");
        return played
    }

    func play_with_grad() {
        self.play()
        sleep(1);
        self.volume = 0.5;
        sleep(1);
        self.volume = 0.1;
    }

}
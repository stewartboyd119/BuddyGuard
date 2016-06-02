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
    var time_delay = 0.0; //number of seconds until begin alarm
    var volume : Float; //from 0 to 1 indicating volume of sound (0 being silent 1 being max)
    var gradient = 0.0; //Number of seconds until max volume from start of alarm
    var soundFilePath : NSString;
    var fileURL : NSURL;
    var newPlayer : AVAudioPlayer?;

    init(volume : Float){
        self.volume = volume;
        soundFilePath = NSBundle.mainBundle().pathForResource("test", ofType: "wav")!;
        fileURL = NSURL.init(fileURLWithPath: soundFilePath as String);
        do{
            newPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL);
        }
        catch let error as NSError {
            print(error.localizedDescription);
        }
        newPlayer?.volume = self.volume;
        newPlayer?.prepareToPlay()
    }
    func play() -> Bool?{
        print("begin playing");
        let played = newPlayer?.play()
        print("end call to play");
        return played
    }

}
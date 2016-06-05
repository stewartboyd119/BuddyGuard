//
//  BuddyGuardTests.swift
//  BuddyGuardTests
//
//  Created by Stewart Boyd on 5/23/16.
//  Copyright © 2016 Stewart Boyd. All rights reserved.
//

import XCTest
@testable import BuddyGuard

class BuddyGuardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAlarm() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let alarm = try! Alarm(volume: 1.0);
        XCTAssertTrue(alarm.play()!, "play should return true");
    }

    func testAlarmWithBrokenFilePath(){
        do{
            //this should raise an exception
            let alarm = try Alarm(fpath: "fake_file_path", volume: 1.0)
            XCTFail();
        }
        catch let error as NSError {
            XCTAssertTrue(true);
        }
        
            //XCTAssertFalse(alarm.play()!, "play should fail because not an extant resource")
    }

    func testAlarmWithAbove1Vol(){
        let alarm = try! Alarm(volume : 3.0);
        XCTAssertEqual(alarm.volume, Alarm.max_volume);
    }

    func testAlarmBelow0Vol(){
        let alarm = try! Alarm(volume : -1.0);
        XCTAssertEqual(alarm.volume, Alarm.min_volume);
    }

    func testAlarmSetFpath(){
        let fpath = NSBundle.mainBundle().pathForResource("test", ofType: "mp3")
        let alarm = try! Alarm(fpath: fpath)
        XCTAssertEqual(alarm.sound_fpath, "file://" + fpath!)
        XCTAssertEqual(alarm.volume, 1.0);
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

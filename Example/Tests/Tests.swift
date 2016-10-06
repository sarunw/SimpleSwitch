import UIKit
import XCTest
import FBSnapshotTestCase
@testable import SimpleSwitch


/// Iphone 6 Plus 10.1
class Tests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        recordMode = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultOn() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        XCTAssertTrue(simpleSwitch.isOn)
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testOn() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = true
        
        XCTAssertTrue(simpleSwitch.isOn)
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testOff() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = false
        
        XCTAssertFalse(simpleSwitch.isOn)
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testDisable() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isEnabled = false
        
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testAdjustMinimumSpacing() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = true
        simpleSwitch.minimumThumbSpacing = 0
        
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testAdjustMinimumSpacing2() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = true
        simpleSwitch.minimumThumbSpacing = 10
        
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testThumbColor() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = true
        simpleSwitch.thumbTintColor = UIColor.red
        
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testOnTintColor() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = true
        simpleSwitch.onTintColor = UIColor.red
        
        FBSnapshotVerifyView(simpleSwitch)
    }
    
    func testOffTintColor() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        simpleSwitch.isOn = false
        simpleSwitch.offTintColor = UIColor.red
        
        FBSnapshotVerifyView(simpleSwitch)
    }

}

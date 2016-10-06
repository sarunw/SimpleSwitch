import UIKit
import XCTest
import FBSnapshotTestCase
@testable import SimpleSwitch


class Tests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOn() {
        // This is an example of a functional test case.
        let simpleSwitch = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
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
}

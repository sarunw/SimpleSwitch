//
//  LogicTests.swift
//  SimpleSwitch
//
//  Created by Sarun Wongpatcharapakorn on 11/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SimpleSwitch


class LogicTests: XCTestCase {
    
    var expectValueChanged: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func expectedValueChanged() {
        expectValueChanged = expectation(description: "Value Chnaged")
    }
    
    func testValueChangedEventNotFiredIfChangeProgrammatically() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let s = SimpleSwitch()
        s.addTarget(self, action: #selector(self.valueChanged(sender:)), for: .valueChanged)
        
        expectedValueChanged()
        expectValueChanged?.fulfill()
        
        s.setOn(false, animated: true)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func valueChanged(sender: AnyObject) {
        expectValueChanged?.fulfill()
    }
    
}

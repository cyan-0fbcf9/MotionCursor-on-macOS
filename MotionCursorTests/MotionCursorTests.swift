//
//  MotionCursorTests.swift
//  MotionCursorTests
//
//  Created by NH on 2020/08/25.
//  Copyright © 2020 NH. All rights reserved.
//

import XCTest
@testable import MotionCursor

class MotionCursorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMotionInfoのデコードテストAcc() throws {
        let testData = "{\"type\": \"\(MotionCursor.MOUSE_TYPE.NORMAL.rawValue)\", \"acc\": {\"x\": 20.0, \"y\": 32.1, \"z\":4.0}}".data(using: .utf8) ?? Data()
        XCTAssertNoThrow(try decodeMouseInfo(data: testData))
    }
    
    func testMotionInfoのデコードテストAtti() throws {
        let testData = "{\"type\": \"\(MotionCursor.MOUSE_TYPE.NORMAL.rawValue)\", \"atti\": {\"pitch\": 20.0, \"yaw\": 32.1, \"roll\":4.0}}".data(using: .utf8) ?? Data()
        XCTAssertNoThrow(try decodeMouseInfo(data: testData))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

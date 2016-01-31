//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import XCTest
@testable import Log

class LoggerTest: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testLogError()
    {
        var outString: String?
        let testedLogger: Logger = Logger(withLevel: .ERROR, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        let loggedObject: Int = 1
        outString = nil
        testedLogger.debug(loggedObject)
        let expectedOutput = "[MT]LoggerTest.swift#testLogError():32 - 1"

        XCTAssertEqual(outString, expectedOutput, "Logged integer")
    }

    func testGetDefaultLogger()
    {
        let logger1: Logger = Logger.Default
        let logger2: Logger = Logger.Default

        XCTAssertTrue(logger1 === logger2, "Both loggers")
    }
}

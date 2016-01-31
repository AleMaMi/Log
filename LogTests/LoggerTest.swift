//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import XCTest
@testable import Log
import Hamcrest

class LoggerTest: XCTestCase
{
    private var fileName: String!

    override func setUp()
    {
        super.setUp()

        self.fileName = NSURL(string: __FILE__)!.lastPathComponent
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testLogError()
    {
        let funcName: String = __FUNCTION__
        let expectedPrefix: String = "[MT]" + self.fileName + "#" + funcName + ":"

        var outString: String?
        let testedLogger: Logger = Logger(withLevel: .ERROR, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        let loggedObject: Int = 1
        outString = nil
        testedLogger.error(loggedObject)
        let expectedSuffix = "- 1"

        assertThat(outString, presentAnd(hasPrefix(expectedPrefix)))
        assertThat(outString!, hasSuffix(expectedSuffix))
    }

    func testGetDefaultLogger()
    {
        let logger1: Logger = Logger.Default
        let logger2: Logger = Logger.Default

        assertThat(logger1 === logger2)
    }
}

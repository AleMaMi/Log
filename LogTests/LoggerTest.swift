//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import XCTest
@testable import Log
import Hamcrest

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

    class ClassWithoutStringRepresentation
    {

    }

    class ClassWithDescription: CustomStringConvertible
    {
        var description: String
        {
            return "TEST-ONLY-CUSTOM-DESCRIPTION"
        }
    }

    class ClassWithDebugDescription: CustomDebugStringConvertible
    {
        var debugDescription: String
        {
            return "TEST-ONLY-CUSTOM-DEBUG-DESCRIPTION"
        }
    }

    class ClassWithBothDescription: CustomDebugStringConvertible, CustomStringConvertible
    {
        var debugDescription: String
        {
            return "TEST-CUSTOM-DEBUG-DESCRIPTION"
        }

        var description: String
        {
            return "TEST-CUSTOM-DESCRIPTION"
        }

    }

    private func prepareRegExp(expectedValue: String, funcName: String = __FUNCTION__) -> String
    {
        let fileName = NSURL(string: __FILE__)!.lastPathComponent!
        let prefix = "[ERR](MT)" + fileName + "#" + funcName + ":"
        let suffix = " - " + expectedValue

        let prefixEscaped = NSRegularExpression.escapedPatternForString(prefix)
        let suffixEscaped = NSRegularExpression.escapedPatternForString(suffix)

        return "^" + prefixEscaped + "\\d+" + suffixEscaped + "$"
    }

    func testLogErrorWithDifferentTypes()
    {
        var outString: String? = nil
        let testedLogger: Logger = Logger(withLevel: .ERROR, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        // Integer
        let loggedObjectInt: Int = 1
        testedLogger.error(loggedObjectInt)
        let expectedPatternInt = prepareRegExp(loggedObjectInt.description)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternInt)))

        // String
        let loggedObjectString: String = "logged object"
        testedLogger.error(loggedObjectString)
        let expectedPatternString = prepareRegExp(loggedObjectString)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternString)))

        // Object without description
        let loggedObjectNotDesc = ClassWithoutStringRepresentation()
        testedLogger.error(loggedObjectNotDesc)
        let expectedPatternNoDesc = prepareRegExp(NSStringFromClass(ClassWithoutStringRepresentation.self))
        assertThat(outString, presentAnd(matchesPattern(expectedPatternNoDesc)))
    }

    func testGetDefaultLogger()
    {
        let logger1: Logger = Logger.Default
        let logger2: Logger = Logger.Default

        assertThat(logger1 === logger2)
    }
}

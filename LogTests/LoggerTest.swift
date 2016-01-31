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

    struct Const
    {
        static let CUST_DESC_ONLY = "TEST-ONLY-CUSTOM-DESCRIPTION"
        static let CUST_DESC = "TEST-CUSTOM-DESCRIPTION"
        static let CUST_DEBUG_DESC_ONLY = "TEST-ONLY-CUSTOM-DEBUG-DESCRIPTION"
        static let CUST_DEBUG_DESC = "TEST-CUSTOM-DEBUG-DESCRIPTION"
        static let TESTING_STRING: String = "TESTING STRING"
        static let TESTING_INT: Int = 42
        static let TESTING_ARRAY: [String] = ["A1", "A2", "A3"]
    }

    class ClassWithoutStringRepresentation
    {

    }

    class ClassWithDescription: CustomStringConvertible
    {
        var description: String
        {
            return Const.CUST_DESC_ONLY
        }
    }

    class ClassWithDebugDescription: CustomDebugStringConvertible
    {
        var debugDescription: String
        {
            return Const.CUST_DEBUG_DESC_ONLY
        }
    }

    class ClassWithBothDescription: CustomDebugStringConvertible, CustomStringConvertible
    {
        var debugDescription: String
        {
            return Const.CUST_DEBUG_DESC
        }

        var description: String
        {
            return Const.CUST_DESC
        }

    }

    private func prepareRegExp(expectedValue: String, _ level: Level = .ERROR, funcName: String = __FUNCTION__) -> String
    {
        let fileName = NSURL(string: __FILE__)!.lastPathComponent!
        let lvlStr = levelToString(level)
        let prefix = "[\(lvlStr)](MT)" + fileName + "#" + funcName + ":"
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
        let loggedObjectInt: Int = Const.TESTING_INT
        outString = nil
        testedLogger.error(loggedObjectInt)
        let expectedPatternInt = prepareRegExp(Const.TESTING_INT.description)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternInt)))

        // String
        let loggedObjectString: String = Const.TESTING_STRING
        outString = nil
        testedLogger.error(loggedObjectString)
        let expectedPatternString = prepareRegExp(Const.TESTING_STRING)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternString)))

        // Object without description
        let loggedObjectNotDesc = ClassWithoutStringRepresentation()
        outString = nil
        testedLogger.error(loggedObjectNotDesc)
        let expectedPatternNoDesc = prepareRegExp(NSStringFromClass(ClassWithoutStringRepresentation.self))
        assertThat(outString, presentAnd(matchesPattern(expectedPatternNoDesc)))

        // Object with description only
        let loggedObjectDesc = ClassWithDescription()
        outString = nil
        testedLogger.error(loggedObjectDesc)
        let expectedPatternDesc = prepareRegExp(Const.CUST_DESC_ONLY)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternDesc)))

        // Object with debug description only
        let loggedObjectDebugDesc = ClassWithDebugDescription()
        outString = nil
        testedLogger.error(loggedObjectDebugDesc)
        let expectedPatternDebugDesc = prepareRegExp(Const.CUST_DEBUG_DESC_ONLY)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternDebugDesc)))

        // Object with both descriptions
        let loggedObjectBoth = ClassWithBothDescription()
        outString = nil
        testedLogger.error(loggedObjectBoth)
        let expectedPatternBoth = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternBoth)))

        // Collection
        let loggedObjectArray = Const.TESTING_ARRAY
        outString = nil
        testedLogger.error(loggedObjectArray)
        let expectedPatternArray = prepareRegExp(Const.TESTING_ARRAY.description)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternArray)))
    }

    func testLogDifferentLevelsForNone()
    {
        var outString: String? = nil

        let testedLogger = Logger(withLevel: .NONE, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        let loggedObject = ClassWithBothDescription()

        outString = nil
        testedLogger.log(.NONE, loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.error(loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.warning(loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.info(loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.debug(loggedObject)
        assertThat(outString, `is`(nilValue()))
    }

    func testLogDifferentLevelsForError()
    {
        var outString: String? = nil

        let testedLogger = Logger(withLevel: .ERROR, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        let loggedObject = ClassWithBothDescription()

        outString = nil
        testedLogger.log(.NONE, loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.error(loggedObject)
        let expectedPatternError = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternError)))

        outString = nil
        testedLogger.warning(loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.info(loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.debug(loggedObject)
        assertThat(outString, `is`(nilValue()))
    }

    func testLogDifferentLevelsForDebug()
    {
        var outString: String? = nil

        let testedLogger = Logger(withLevel: .DEBUG, verboseLevel: .DEBUG)
        {
            (os: String) in
            outString = os
        }

        let loggedObject = ClassWithBothDescription()

        outString = nil
        testedLogger.log(.NONE, loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.error(loggedObject)
        let expectedPatternError = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternError)))

        outString = nil
        testedLogger.warning(loggedObject)
        let expectedPatternWarning = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternWarning)))

        outString = nil
        testedLogger.info(loggedObject)
        let expectedPatternInfo = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternInfo)))

        outString = nil
        testedLogger.debug(loggedObject)
        let expectedPatternDebug = prepareRegExp(Const.CUST_DEBUG_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternDebug)))
    }

    func testLogDifferentLevelsForDebugLoweredVerbosityTreshold()
    {
        var outString: String? = nil

        let testedLogger = Logger(withLevel: .DEBUG, verboseLevel: .INFO)
        {
            (os: String) in
            outString = os
        }

        let loggedObject = ClassWithBothDescription()

        outString = nil
        testedLogger.log(.NONE, loggedObject)
        assertThat(outString, `is`(nilValue()))

        outString = nil
        testedLogger.error(loggedObject)
        let expectedPatternError = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternError)))

        outString = nil
        testedLogger.warning(loggedObject)
        let expectedPatternWarning = prepareRegExp(Const.CUST_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternWarning)))

        outString = nil
        testedLogger.info(loggedObject)
        let expectedPatternInfo = prepareRegExp(Const.CUST_DEBUG_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternInfo)))

        outString = nil
        testedLogger.debug(loggedObject)
        let expectedPatternDebug = prepareRegExp(Const.CUST_DEBUG_DESC)
        assertThat(outString, presentAnd(matchesPattern(expectedPatternDebug)))
    }

    func testGetDefaultLogger()
    {
        let logger1: Logger = Logger.Default
        let logger2: Logger = Logger.Default

        assertThat(logger1 === logger2)
    }
}

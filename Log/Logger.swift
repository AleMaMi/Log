//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import Foundation

public class Logger
{
    private static let NO_FILE: String = "no_file"
    private static let THREAD_MAIN: String = "MT"
    private static let THREAD_OTHER: String = "OT"

    public private(set) static var Default: Logger =
    {
        return Logger()
    }()

    private var outputTreshold: Level
    private var verboseTreshold: Level
    private var printer: (String) -> Void

    public init(withLevel level: Level, verboseLevel: Level, printer: (String)->Void)
    {
        self.outputTreshold = level
        self.verboseTreshold = verboseLevel
        self.printer = printer
    }

    private convenience init()
    {
        self.init(withLevel: .ERROR, verboseLevel: .DEBUG)
        {
            (outString: String) in NSLog(outString)
        }
    }

    func log<T>(level: Level, @autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        if level.rawValue > Level.NONE.rawValue && level.rawValue <= self.outputTreshold.rawValue
        {
            guard let value: T = object() else {return}
            let stringToPrint: String

            // If verbosity, debugDescription has priority over description
            if let v = value as? CustomDebugStringConvertible where level.rawValue >= self.verboseTreshold.rawValue
            {
                stringToPrint = v.debugDescription
            }
            // regular description is preffered
            else if let v = value as? CustomStringConvertible
            {
                stringToPrint = v.description
            }
            // String implements CustomDebuStringConvertible; TODO: do we want qutotaion marks there? If yes, remove String
            else if let v = value as? String
            {
                stringToPrint = v
            }
            // if there is only debugDesctiption, just use it
            else if let v = value as? CustomDebugStringConvertible
            {
                stringToPrint = v.debugDescription
            }
            else if let c = T.self as? AnyClass
            {
                stringToPrint = NSStringFromClass(c)
            }
            // Perhaps never happen
            else
            {
                return
            }

            let shortFileName: String = NSURL(string: file)?.lastPathComponent ?? Logger.NO_FILE
            let thread: String = NSThread.isMainThread() ? Logger.THREAD_MAIN : Logger.THREAD_OTHER
            let prefix = levelToString(level)

            let outputString = "[\(prefix)](\(thread))\(shortFileName)#\(function):\(line) - \(stringToPrint)"

            printer(outputString)
        }
    }

    public func error<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.ERROR, object, file, function, line)
    }

    public func warning<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.WARNING, object, file, function, line)
    }

    public func info<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.INFO, object, file, function, line)
    }

    public func debug<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.DEBUG, object, file, function, line)
    }
}

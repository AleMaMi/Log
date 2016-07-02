//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import Foundation

/**
 * Simple logging utility. Any instance of this class can be used to manage logging.
 * For now the configurable levels of output are set during initialization, cannot be
 * changed during run-time.
 */
public class Logger
{
    private static let NO_FILE: String = "no_file"
    private static let THREAD_MAIN: String = "MT"
    private static let THREAD_OTHER: String = "OT"

    /**
     * Pre-defined Logger instance as singleton, can be shared areound whole appliation.
     * Has default settings: level is ERROR, verboseLevel is DEBUG and output is NSLog()
     */
    public private(set) static var Default: Logger =
    {
        return Logger()
    }()

    private var outputThreshold: Level
    private var verboseThreshold: Level
    private var printer: (String) -> Void

    /**
     * Creates an instance of Logger with required levels
     *
     * - parameter level: defines threshold for debug output; no output above this threshold;
     * if it is Level.NONE, no output is produced
     *
     * - parameter verboseLevel: define threshold for debugDescription output
     *
     * - parameter printer: closure used to send output string outside - to real logger
     */
    public init(withLevel level: Level, verboseLevel: Level, printer: (String)->Void)
    {
        self.outputThreshold = level
        self.verboseThreshold = verboseLevel
        self.printer = printer
    }

    private convenience init()
    {
        self.init(withLevel: .error, verboseLevel: .debug) {outString in NSLog("%@", outString)}
    }

    func log<T>(_ level: Level, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(level, nil, object, file, function, line)
    }

    func log<T>(_ level: Level, _ message: String?, @autoclosure _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        if level.rawValue > Level.none.rawValue && level.rawValue <= self.outputThreshold.rawValue
        {
            guard let value: T = object() else {return}
            let stringToPrint: String

            // If verbosity, debugDescription has priority over description
            if let v = value as? CustomDebugStringConvertible
            where self.verboseThreshold.rawValue > Level.none.rawValue
                    && level.rawValue >= self.verboseThreshold.rawValue
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

            let shortFileName: String = URL(string: file)?.lastPathComponent ?? Logger.NO_FILE
            let thread: String = Thread.isMainThread() ? Logger.THREAD_MAIN : Logger.THREAD_OTHER
            let prefix = levelToString(level)

            let outputString: String
            let dbgMessage = message != nil ? (message! + ": ") : ""

            if self.verboseThreshold.rawValue > Level.none.rawValue
            {
                outputString = "[\(prefix)] (\(thread)) \(dbgMessage)\(stringToPrint) - \(shortFileName):\(line)"
            }
            else
            {
                outputString = "[\(prefix)] \(dbgMessage)\(stringToPrint)"
            }

            printer(outputString)
        }
    }

    /**
     * Log object with ERROR level
     *
     * - parameter object: object what will be logged, if required level is ERROR or more
     */
    public func error<T>( _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.error, object, file, function, line)
    }

    /**
     * Log object with ERROR level
     *
     * - parameter message: message shown before object
     * - parameter object: object what will be logged, if required level is ERROR or more
     */
    public func error<T>(_ message: String, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.error, message, object, file, function, line)
    }

    /**
     * Log object with WARNING level
     *
     * - parameter object: object what will be logged, if required level is WARNING or more
     */
    public func warning<T>( _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.warning, object, file, function, line)
    }

    /**
     * Log object with WARNING level
     *
     * - parameter message: message shown before object
     * - parameter object: object what will be logged, if required level is WARNING or more
     */
    public func warning<T>(_ message: String, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.warning, message, object, file, function, line)
    }

    /**
     * Log object with INFO level
     *
     * - parameter object: object what will be logged, if required level is INFO or more
     */
    public func info<T>( _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.info, object, file, function, line)
    }

    /**
     * Log object with INFO level
     *
     * - parameter message: message shown before object
     * - parameter object: object what will be logged, if required level is INFO or more
     */
    public func info<T>(_ message: String, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.info, message, object, file, function, line)
    }

    /**
     * Log object with DEBUG level
     *
     * - parameter object: object what will be logged, if required level is DEBUG or more
     */
    public func debug<T>( _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.debug, object, file, function, line)
    }

    /**
     * Log object with DEBUG level
     *
     * - parameter message: message shown before object
     * - parameter object: object what will be logged, if required level is DEBUG or more
     */
    public func debug<T>(_ message: String, _ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line)
    {
        log(.debug, message, object, file, function, line)
    }
}

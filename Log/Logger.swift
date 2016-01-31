//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import Foundation

public class Logger
{
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

    private func logLevelPrefix(level: Level) -> String
    {
        let prefix: String

        switch level
        {
            case .DEBUG:
                prefix = "DBG"

            case .INFO:
                prefix = "INF"

            case .WARNING:
                prefix = "WRN"

            case .ERROR:
                prefix = "ERR"

            default:
                prefix = "NON"
        }

        return prefix
    }

    func log<T>(level: Level, @autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        if level.rawValue > Level.NONE.rawValue && level.rawValue >= self.outputTreshold.rawValue
        {
            guard let value: T = object() else {return}
            let stringToPrint: String

            if let v = value as? CustomDebugStringConvertible where level.rawValue >= self.verboseTreshold.rawValue
            {
                stringToPrint = v.debugDescription
            }
            else if let v = value as? CustomStringConvertible
            {
                stringToPrint = v.description
            }
            else if let v = value as? String
            {
                stringToPrint = v
            }
            else if let c = T.self as? AnyClass
            {
                stringToPrint = NSStringFromClass(c)
            }
            else
            {
                return
            }

            let shortFileName: String = NSURL(string: file)?.lastPathComponent ?? "no_file"
            let thread: String = NSThread.isMainThread() ? "MT" : "OT"
            let prefix = logLevelPrefix(level)

            let outputString = "[\(prefix)](\(thread))\(shortFileName)#\(function):\(line) - \(stringToPrint)"

            printer(outputString)
        }
    }

    public func error<T>(@autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.ERROR, object, file, function, line)
    }

    public func warning<T>(@autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.WARNING, object, file, function, line)
    }

    public func info<T>(@autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.INFO, object, file, function, line)
    }

    public func debug<T>(@autoclosure _ object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__)
    {
        log(.DEBUG, object, file, function, line)
    }
}

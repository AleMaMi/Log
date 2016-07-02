//
// Created by Aleš M. Michálek on 31.01.16.
// Copyright (c) 2016 Deuterium-Ice. All rights reserved.
//

import Foundation

/**
 * Determine level of output with obvious values
 */
public enum Level: Int
{
    case none       = 0     // This level has no output at all, can be used to disable all outputs
    case error      = 1
    case warning    = 2
    case info       = 3
    case debug      = 4
}

/**
 * Helps to convert level enum into short string, usually used as
 * prefix of the logged output
 */
public func levelToString(_ level: Level) -> String
{
    let prefix: String

    switch level
    {
        case .debug:
            prefix = "DBG"

        case .info:
            prefix = "INF"

        case .warning:
            prefix = "WRN"

        case .error:
            prefix = "ERR"

        default:
            prefix = "NON"
    }

    return prefix
}

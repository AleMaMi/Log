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
    case NONE       = 0     // This level has no output at all, can be used to disable all outputs
    case ERROR      = 1
    case WARNING    = 2
    case INFO       = 3
    case DEBUG      = 4
}

/**
 * Helps to convert level enum into short string, usually used as
 * prefix of the logged output
 */
public func levelToString(level: Level) -> String
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

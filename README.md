# Log #

Simple logging facility as framework to use during iOS development

### Simple start ###

Main utility is Logger class. To use it, you have to create instance. 

```swift
let myLogger = Logger(withLevel: .ERROR, verboseLevel: .DEBUG) {
 (outputString: String) in NSLog(outputString)
}
```

When you have an instance of logger, you can use it

```swift
myLogger.error(objectToLog)
```

For your convenience, there is alredy prepared logger with usual setup.
```swift
Logger.Default.info(objectToLog)
```

### Level and verbose level ###

The `level` parameter defines threshold to limit output. If the logged level is above this
configured level threshold, the output is not produced, logger just do nothing.

The `verboseLevel` parameter defines threshold to produce more verbose output. At this moment
the only difference is the `debugDescription` is used prior to `description` if possible. Otherwise
the regular `description` is used, if present.

The `printer` closure parameter allow to define how the output string should be shown. This
could be used to redirect output to any stream, logger facility etc.

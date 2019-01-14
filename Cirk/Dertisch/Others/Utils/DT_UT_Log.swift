//
//  DT_UT_Logs.swift
//  Dertisch
//
//  Created by Richard Willis on 14/10/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// adds filename, time, and code line to print functions
public func lo(_ args: Any?... , file: String = #file, function: String = #function, line: Int = #line) {
	_lo(args, file: file, function: function, line: line)
}

// loops through an object, printing all of its keys and associated values
public func lobject(_ object: [String: Any], file: String = #file, function: String = #function, line: Int = #line) {
	for (key, value) in object {
		_lo([key, ":", value], file: file, function: function, line: line)
	}
}

// differing levels of log (see Consts logLevel and logModes)
public func loInfo(_ args: Any... , file: String = #file, function: String = #function, line: Int = #line) {
	guard Logs.logModes.index(of: Logs.logLevel.info) != nil else { return }
	_lo(args, file: file, function: function, line: line)
}

public func loFeedback(_ args: Any... , file: String = #file, function: String = #function, line: Int = #line) {
	guard Logs.logModes.index(of: Logs.logLevel.feedback) != nil else { return }
	_lo(args, file: file, function: function, line: line)
}

public func loWarning(_ args: Any... , file: String = #file, function: String = #function, line: Int = #line) {
	guard Logs.logModes.index(of: Logs.logLevel.warning) != nil else { return }
	_lo(args, file: file, function: function, line: line)
}

public func loError(_ args: Any... , file: String = #file, function: String = #function, line: Int = #line) {
	guard Logs.logModes.index(of: Logs.logLevel.error) != nil else { return }
	_lo(args, file: file, function: function, line: line)
}



//internal func flagNonImplementation(file: String = #file, function: String = #function) {
//	lo("\(function) not implemented for \(getShortFileName(from: file))")
//}



fileprivate func getShortFileName(from file: String) -> String {
	guard  let lastSlash = StringUtils.getLastIndexOf(subString: "/", inString: file) as Int?,
		let lastDot = StringUtils.getLastIndexOf(subString: ".", inString: file) as Int?,
		let fileName = StringUtils.getSubStringOf(string: file, between: lastSlash + 1, and: lastDot),
		let shortFileName = StringUtils.set(length: 16, ofText: fileName)
		else { return "unknown file" }
	return shortFileName
}



fileprivate func _lo(_ args: [Any?], file: String, function: String, line: Int) {
	let
	printableArgs = args.count > 0 ? args : ["\(function) ()"],
	fileName = getShortFileName(from: file)
	if  let shortenedLine = StringUtils.set(length: 4, ofText: String(line)),
		let shortenedInterval = StringUtils.set(
			length: 5,
			ofText: String(Time.getInterval(format: Time.intervalFormats.withoutHoursAndMinutes))) {
		_log(printableArgs, location: "\(fileName) \(shortenedLine) \(shortenedInterval)")
	} else {
		_log(printableArgs)
	}
}

fileprivate func _log(_ args: [Any?], location: String? = nil) {
	var mutableArgs = args
	// occasionally args is just a one-value array that contains the real args
	if  args.count == 1, let args = args[0] as? [Any] { mutableArgs = args }
	// turn args into single message string
	guard mutableArgs.count > 0 else { return }
	var message = Chars.emptyString
	_ = mutableArgs.map { element in
		if let messageSuffix = StringUtils.serialise(value: _serialise(arg: element)) {
			message = "\(message)  \(messageSuffix)"
		}
	}
	
	// hack: ^ lets us filter out all the nasty debug the XCode team have currently left in, hopefully just temporarily
	let
	prefix = "^",
	output = location == nil ? message : "\(location!) \(message)"
	print("\(prefix)\(output)")
}

fileprivate func _serialise(arg: Any?) -> String {
	return arg != nil ? "\(arg!)" : "nil"
}

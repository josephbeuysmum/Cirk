//
//  Time.swift
//  Dertisch
//
//  Created by Richard Willis on 19/04/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public class Time {
	public enum intervalFormats {
		case full, withoutHours, withoutMilliseconds, withoutHoursAndMilliseconds, withoutHoursAndMinutes
	}
	
	fileprivate static var startTime: Date?
	
	// returns a timestamp based upon the intervalFormats case passed 
	// (assumes full case if none passed)
	public static func getInterval(format: intervalFormats = .full) -> String {
		let rawInterval = _getRawInterval()
		let interval = rawInterval != nil ? Int(rawInterval!) : 0
		
		switch format {
		case .withoutHours:
			return String(
				format: "%0.2d:%0.2d.%0.2d",
				_getMinutesBy(interval: interval),
				_getSecondsBy(interval: interval),
				_getMillisecondsBy(rawInterval: rawInterval))
			
		case .withoutMilliseconds:
			return String(
				format: "%0.2d:%0.2d:%0.2d",
				_getHoursBy(interval: interval),
				_getMinutesBy(interval: interval),
				_getSecondsBy(interval: interval))
			
		case .withoutHoursAndMinutes:
			return String(
				format: "%0.2d:%0.2d",
				_getSecondsBy(interval: interval),
				_getMillisecondsBy(rawInterval: rawInterval))
			
		case .withoutHoursAndMilliseconds:
			return String(
				format: "%0.2d:%0.2d",
				_getMinutesBy(interval: interval),
				_getSecondsBy(interval: interval))
			
		// included to catch case .full
		default:
			return String(
				format: "%0.2d:%0.2d:%0.2d.%0.2d",
				_getHoursBy(interval: interval),
				_getMinutesBy(interval: interval),
				_getSecondsBy(interval: interval),
				_getMillisecondsBy(rawInterval: rawInterval))
		}
	}
	
	public static func getDateComponents(from date: Date) -> DateComponents? {
		let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
		let flags = NSCalendar.Unit.init(rawValue: UInt.max)
		return (gregorian as NSCalendar).components(flags, from: date)
	}
	
	// startTime acts as "zero hour" so setting it to nil basically restarts the clock
	public static func resetInterval() {
		startTime = nil
	}
	
	public static func startInterval() {
		startTime = Date()
	}

	
	
	// hours and milliseconds have accessor functions because they aren't used in all cases
	fileprivate static func _getHoursBy(interval: Int) -> Int { return interval / 3600 }
	
	fileprivate static func _getMillisecondsBy(rawInterval: TimeInterval?) -> Int {
		return rawInterval != nil ? Int((rawInterval!.truncatingRemainder(dividingBy: 1)) * 1000) : 0
	}
	
	fileprivate static func _getMinutesBy(interval: Int) -> Int { return (interval / 60) % 60 }
	
	fileprivate static func _getSecondsBy(interval: Int) -> Int { return interval % 60 }
	
	
	// raw interval has its own accessor function as it *might* need to restart the startTime clock
	fileprivate static func _getRawInterval() -> TimeInterval? {
		
		return startTime != nil ? Date().timeIntervalSince(startTime!) : nil
	}
}

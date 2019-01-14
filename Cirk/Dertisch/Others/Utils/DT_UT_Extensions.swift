//
//  DT_UT_Extensions.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

// taken from Dmitry Isaev at https://stackoverflow.com/questions/21789770/determine-mime-type-from-nsdata#32765708
extension Data {
	enum mimeTypes: String {
		case AVI, BMP, GIF, JPG, MP3, OCT, OGG, PDF, PNG, /*RAR,*/ RTF, TAR, TIFF, /*TXT,*/ VND, /*WAV,*/ XML, ZIP
	}
	
	var mimeType: Data.mimeTypes {
		var c: UInt8 = 0
		copyBytes(to: &c, count: 1)
		return Data.mimeTypeSignatures[c] ?? mimeTypes.OCT
	}
	
	
	
	// todo check these are correct, distinguish between clashing MIMEs like 0x52
	// see: https://en.wikipedia.org/wiki/List_of_file_signatures
	private static let mimeTypeSignatures: [UInt8: Data.mimeTypes] = [
		0x1F: Data.mimeTypes.TAR,
		0x25: Data.mimeTypes.PDF,
		0x3C: Data.mimeTypes.XML,
		0x46: Data.mimeTypes.BMP,
		//		0x46: Data.mimeTypes.TXT,
		0x47: Data.mimeTypes.GIF,
		0x49: Data.mimeTypes.MP3,
		//		0x49: Data.mimeTypes.TIFF,
		0x4D: Data.mimeTypes.TIFF,
		0x4F: Data.mimeTypes.OGG,
		0x50: Data.mimeTypes.ZIP,
		//		0x52: Data.mimeTypes.RAR,
		//		0x52: Data.mimeTypes.WAV,
		0x75: Data.mimeTypes.TAR,
		0x7B: Data.mimeTypes.RTF,
		0x89: Data.mimeTypes.PNG,
		0xD0: Data.mimeTypes.VND,
		0xFF: Data.mimeTypes.JPG
	]
}

// Date extensions make accessing properties easier
public extension Date {
	public func years(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
	}
	
	public func months(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
	}
	
	public func weeks(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
	}
	
	public func days(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
	}
	
	public func hours(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
	}
	
	public func minutes(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
	}
	
	public func seconds(from date: Date) -> Int {
		return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
	}
	
	public func offset(from date: Date) -> String {
		if years(from: date) > 0 { return "\(years(from: date))y"}
		if months(from: date) > 0 { return "\(months(from: date))M" }
		if weeks(from: date) > 0 { return "\(weeks(from: date))w" }
		if days(from: date) > 0 { return "\(days(from: date))d" }
		if hours(from: date) > 0 { return "\(hours(from: date))h" }
		if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
		if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
		return Chars.emptyString
	}
}



public extension NSLayoutConstraint {
	// useAndActivate allows us to forget about the hell that is translatesAutoresizingMaskIntoConstraints
	public class func useAndActivate (constraints: [NSLayoutConstraint]) {
		for constraint in constraints {
			if let view = constraint.firstItem as? UIView {
				view.translatesAutoresizingMaskIntoConstraints = false
			}
		}
		activate(constraints)
	}
}



public extension NSObject {
	// helps to identify classes by letting the wind out of their names
	public var instanceDescriptor: String? {
		guard let value = NSStringFromClass(type(of: self)).components(separatedBy: ".").last else { return nil }
		return value
	}
}



public extension String {
	// lots of ways of identifying and measuring emojis in Strings
	// from: stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
	public var containsEmojis: Bool { return !unicodeScalars.filter{ $0.isEmoji }.isEmpty }
	
	// from: stackoverflow.com/questions/25138339/nsrange-to-rangestring-index#26517690
	public func getRange (from nsRange: NSRange) -> Range< String.Index >? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
			let from = from16.samePosition(in: self),
			let to = to16.samePosition(in: self)
			else { return nil }
		return from ..< to
	}
}



public extension UIColor {
	// allows creating colors from simple hex strings
	public convenience init? (hex: String) {
		let permittedChars = "0123456789ABCDEF"
		// todo this could be better
		for char in hex.uppercased() {
			if permittedChars.index(of: char) == nil {
				return nil
			}
		}
		let adjustedHex: String?
		switch hex.count {
		case 6:		adjustedHex = "\(hex)FF"
		case 8:		adjustedHex = "\(hex)"
		default:	adjustedHex = nil
		}
		guard adjustedHex != nil else {
			return nil
		}
		let red, green, blue, alpha: CGFloat
		if hex.hasPrefix("#") {
			let start = hex.index(hex.startIndex, offsetBy: 1)
			let hexColor = String(hex.suffix(from: start))
			if hexColor.count == 8 {
				let order = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				if order.scanHexInt64(&hexNumber) {
					red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					alpha = CGFloat(hexNumber & 0x000000ff) / 255
					self.init(red: red, green: green, blue: blue, alpha: alpha)
					return
				}
			}
		}
		return nil
	}
}



public extension UILabel {
	// simply makes UILabels sizeToFit()-able
	public func makeWrappable () {
		numberOfLines = 0
		lineBreakMode = .byWordWrapping
	}
}



public extension UnicodeScalar {
	// tell us whethere the scalar in question is an emoji or not, but examining it's value against known emoji ranges
	// from: stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
	public var isEmoji: Bool {
		switch value {
		case 0x3030, 0x00AE, 0x00A9, // Special Characters
		0x1D000 ... 0x1F77F, // Emoticons
		0x2100 ... 0x27BF, // Misc symbols and Dingbats
		0xFE00 ... 0xFE0F, // Variation Selectors
		0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
					return true
		default: 	return false
		}
	}
}

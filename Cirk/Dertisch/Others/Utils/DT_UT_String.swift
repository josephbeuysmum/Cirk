//
//  DT_UT_String.swift
//  Dertisch
//
//  Created by Richard Willis on 15/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class StringUtils {
	// returns the first index of the given substring, or nil if it cannot be found
	public static func getIndexOf ( subString: String, inString string: String, startingAt startIndex: Int? = 0 ) -> Int? {
		let
		count = string.count,
		shortenedRange = string.index( string.startIndex, offsetBy: startIndex! ) ..< string.index( string.startIndex, offsetBy: count ),
		shortenedValue = String( string.suffix( from: shortenedRange.lowerBound ) ),
		range = shortenedValue.range( of: subString )
		return range != nil ?
			shortenedValue.distance( from: shortenedValue.startIndex, to: range!.lowerBound ) + startIndex! :
			nil
	}
	
	// returns a Range from the String, or nil where "start" and "end" are invalid indices
	public static func getIndexRangeOf (
		string: String,
		between startIndex: Int,
		and endIndex: Int ) -> Range < String.Index >? {
		let range = _getRangeFrom( string: string, between: startIndex, and: endIndex )
		return range != nil ? string.getRange( from: range! ) : nil
	}
	
	// returns the indices of the given one-char String, or nil if none can be found
	public static func getIndicesOf ( subString: String, inString string: String ) -> [ Int ]? {
		var
		subStringIndex = StringUtils.getIndexOf( subString: subString, inString: string, startingAt: 0 ),
		indices: [ Int ] = []
		while subStringIndex != nil {
			indices.append( subStringIndex! )
			subStringIndex = StringUtils.getIndexOf(
				subString: subString,
				inString: string,
				startingAt: subStringIndex! + 1 )
		}
		return indices.count > 0 ? indices : nil
	}
	
	// returns the last index of the given substring, or nil if it cannot be found
	public static func getLastIndexOf ( subString: String, inString string: String ) -> Int? {
		var
		indexOf = getIndexOf( subString: subString, inString: string ),
		lastIndexOf: Int?
		while indexOf != nil {
			lastIndexOf = indexOf
			indexOf = getIndexOf( subString: subString, inString: string, startingAt: indexOf! + 1 )
		}
		return lastIndexOf
	}
	
	
	// returns a subString from the given string, or nil where "start" and "end" are invalid indices
	public static func getSubStringOf ( string: String, between startIndex: Int, and endIndex: Int ) -> String? {
		return string.containsEmojis ?
			_getSubStringByScalarsFrom( string: string, between: startIndex, and: endIndex ) :
			_getSubStringOf( string: string, between: startIndex, and: endIndex )
	}
	
	public static func serialise ( array: [ Any ]?, withSeparator separator: String? = " " ) -> String? {
		guard array != nil else { return nil }
//		let countValues = values.count
		var result = Chars.emptyString
		// serialise first value
		if array!.count > 0 { result = "\( array![ 0 ] )" }
		// loop through rest serialising then adding them
		_ = array!.map { element in result = "\( result )\( String( describing: separator ) )\( element )" }
		return result
	}
	
	public static func serialise ( value: Any? ) -> String? {
		guard let value = value else { return nil }
		// only arrays need special treatment...
		let values = value as? [ Any ]
		return values != nil ? serialise( array: values ) : "\( value )"
	}
	
	public static func set ( length newLength: Int, ofText string: String ) -> String? {
		var adjustedString: String? = string
		switch true {
		// if the new length is shorter, just shorten it...
		case adjustedString!.count > newLength:
			adjustedString = getSubStringOf( string: string, between: 0, and: newLength )
		// ...otherwise keep adding a space to the end until the new length is reached
		case adjustedString!.count < newLength:
			let space = Chars.space
			while adjustedString!.count < newLength { adjustedString = "\( adjustedString! )\( space )" }
		default: ()
		}
		return adjustedString
	}
	
	fileprivate static func _getRangeFrom ( string: String, between startIndex: Int, and endIndex: Int ) -> NSRange? {
		// only return a range if the passed indices are valid
		return startIndex < endIndex && startIndex > -1 && endIndex <= string.count ?
			NSMakeRange( startIndex, endIndex - startIndex ) :
			nil
	}
	
	fileprivate static func _getSubStringOf ( string: String, between startIndex: Int, and endIndex: Int ) -> String? {
		// only return a range if the passed indices are valid
		guard let range = getIndexRangeOf( string: string, between: startIndex, and: endIndex ) else { return nil }
		return String( string[ range ] )
	}
	
	// this method of getting substrings ensures that emojis are treated as individual chars
	fileprivate static func _getSubStringByScalarsFrom (
		string: String,
		between startIndex: Int,
		and endIndex: Int ) -> String {
		// runs through scalars scalar-by-scalar building the phrase
		var
		index = 0,
		subStringByScalars = Chars.emptyString
		for scalar in string.unicodeScalars {
			// keep skipping scalars until we get to the desired start index,
			// then progressively add each char until we reach the end of the phrase
			if index >= startIndex { subStringByScalars = "\( subStringByScalars )\( String( scalar ) )" }
			if index == endIndex { break }
			index += 1
		}
		return subStringByScalars
	}
}

//
//  DT_ET_CoreData.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum DTCDTypes { case bool, double, int, string }

//extension DTCDTypes: Equatable {
//	public static func == (lhs: DTCDTypes, rhs: DTCDTypes) -> Bool {
//		switch (lhs, rhs) {
//		case (.string, .string), (.int, .int), (.bool, .bool):		return true
//		default:													return false
//		}
//	}
//}



public struct DTCDKey {
	public let
	key: String,
	type: DTCDTypes
	
	public init (_ key: String, _ type: DTCDTypes) {
		self.key = key
		self.type = type
	}
}



public struct DTCDAttribute {
	public let
	key: String,
	value: DTStorableDataType
	
	public init (_ key: String, _ value: DTStorableDataType) {
		self.key = key
		self.value = value
	}
}


public struct DTCDEntity: DTCDEntityProtocol {
	fileprivate typealias TypesCollection = [String: DTCDTypes]
	
	public var attributes: [String: DTStorableDataType] { return attributes_ }
	public var name: String { return name_ }
	
	fileprivate let
	name_: String,
	types_: TypesCollection
	
	fileprivate var attributes_: [String: DTStorableDataType]
	
	init () { fatalError("init() has not been implemented") }
	
	public init (_ name: String, keys: [DTCDKey]) {
		name_ = name
		attributes_ = [:]
		var types: TypesCollection = [:]
		keys.forEach { key in
			types[key.key] = key.type
		}
		types_ = types
	}
	
	mutating public func add(_ attribute: DTStorableDataType, by key: String) -> Bool {
		guard
			let type = types_[key],
			self.assessValidity(of: attribute, by: type)
			else { return false }
		attributes_[key] = attribute
//		lo(key, attribute, type)
		return true
	}
	
fileprivate func assessValidity(of attribute: DTStorableDataType, by type: DTCDTypes) -> Bool {
		switch type {
		case DTCDTypes.bool:	return attribute is Bool
		case DTCDTypes.double:	return attribute is Double
		case DTCDTypes.int:		return attribute is Int || attribute is Int16 || attribute is Int32 || attribute is Int64
		case DTCDTypes.string:	return attribute is String
		}
	}
}

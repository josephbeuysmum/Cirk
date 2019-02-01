//
//  FreezerSections.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum FreezerTypes { case bool, double, int, string }

//extension FreezerTypes: Equatable {
//	public static func == (lhs: FreezerTypes, rhs: FreezerTypes) -> Bool {
//		switch (lhs, rhs) {
//		case (.string, .string), (.int, .int), (.bool, .bool):		return true
//		default:													return false
//		}
//	}
//}



public struct FreezerKey {
	public let
	key: String,
	type: FreezerTypes
	
	public init (_ key: String, _ type: FreezerTypes) {
		self.key = key
		self.type = type
	}
}



public struct FreezerAttribute {
	public let
	key: String,
	value: StorableDataType
	
	public init (_ key: String, _ value: StorableDataType) {
		self.key = key
		self.value = value
	}
}


public struct FreezerEntity: FreezerEntityProtocol {
	fileprivate typealias TypesCollection = [String: FreezerTypes]
	
	public var attributes: [String: StorableDataType] { return attributes_ }
	public var name: String { return name_ }
	
	fileprivate let
	name_: String,
	types_: TypesCollection
	
	fileprivate var attributes_: [String: StorableDataType]
	
	init () { fatalError("init() has not been implemented") }
	
	public init (_ name: String, keys: [FreezerKey]) {
		name_ = name
		attributes_ = [:]
		var types: TypesCollection = [:]
		keys.forEach { key in
			types[key.key] = key.type
		}
		types_ = types
	}
	
	mutating public func add(_ attribute: StorableDataType, by key: String) -> Bool {
		guard
			let type = types_[key],
			self.assessValidity(of: attribute, by: type)
			else { return false }
		attributes_[key] = attribute
		return true
	}
	
fileprivate func assessValidity(of attribute: StorableDataType, by type: FreezerTypes) -> Bool {
		switch type {
		case FreezerTypes.bool:	return attribute is Bool
		case FreezerTypes.double:	return attribute is Double
		case FreezerTypes.int:		return attribute is Int || attribute is Int16 || attribute is Int32 || attribute is Int64
		case FreezerTypes.string:	return attribute is String
		}
	}
}

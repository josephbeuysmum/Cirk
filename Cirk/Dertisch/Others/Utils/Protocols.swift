//
//  Protocols.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol CigaretteBreakProtocol {
	mutating func beginBreak()
	mutating func endBreak()
}

extension CigaretteBreakProtocol {
	public func beginBreak() {}
	public func endBreak() {}
}

public protocol DescribableProtocol {
	var description: String { get }
}

public protocol BeginShiftProtocol {
	func beginShift()
}

// todo end in a better way, with weak vars etc
public protocol EndShiftProtocol {
	mutating func endShift()
}

public protocol GiveOrderProtocol {
	mutating func give(_ order: CustomerOrder)
}

public protocol KitchenResource: BeginShiftProtocol, EndShiftProtocol {
	init(_ resources: [String: KitchenResource]?)
}

extension KitchenResource {
	static public var staticId: String { return String(describing: self) }
	public func beginShift() {}
	public func endShift() {}
}

public protocol StaffMember: CigaretteBreakProtocol {}

public protocol FreezerEntityProtocol {
	var attributes: [String: StorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [FreezerKey])
	mutating func add(_ attribute: StorableDataType, by key: String) -> Bool
}

public protocol StorableDataType {}

public protocol SwitchesRelationshipProtocol: class {}

extension Bool: StorableDataType {}
extension Double: StorableDataType {}
extension Float: StorableDataType {}
extension Int: StorableDataType {}
extension String: StorableDataType {}

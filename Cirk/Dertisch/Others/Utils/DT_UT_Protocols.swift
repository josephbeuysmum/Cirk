//
//  DT_UT_Protocols.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol CigaretteBreakProtocol {
	mutating func startBreak ()
	mutating func endBreak ()
}

public protocol DescribableProtocol {
	var description: String { get }
}

// todo endShift in a better way, with weak vars etc
public protocol EndShiftProtocol {
	mutating func endShift ()
}

public protocol GiveOrderProtocol {
	mutating func give(_ order: Order)
}

public protocol StartShiftProtocol {
	func startShift()
}

public protocol FreezerEntityProtocol {
	var attributes: [String: StorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [FreezerKey])
	mutating func add(_ attribute: StorableDataType, by key: String) -> Bool
}

public protocol StorableDataType {}

extension Bool: StorableDataType {}
extension Double: StorableDataType {}
extension Float: StorableDataType {}
extension Int: StorableDataType {}
extension String: StorableDataType {}

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

// tood we're here. staffmember is not the right place for var id: String because then sous chefs require it, which they don't need. maybe then we don't need staffmember but can shift StartShiftProtocol, EndShiftProtocol back into kitchenmember and restaurant member, then *somehow* ensure that only head chefs, waiters, and customers get var id: string. also var id: String *might* be better as some sort of specific struct?
public protocol StaffMember: StartShiftProtocol, EndShiftProtocol {
	var id: String { get }
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

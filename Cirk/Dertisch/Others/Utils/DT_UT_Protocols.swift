//
//  DT_PT_Utils.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTCigaretteBreakProtocol {
	mutating func startBreak ()
	mutating func endBreak ()
}

public protocol DTDescribableProtocol {
	var description: String { get }
}

// todo endShift in a better way, with weak vars etc
public protocol DTEndShiftProtocol {
	mutating func endShift ()
}

public protocol DTGiveOrderProtocol {
	mutating func give(_ order: DTOrder)
}

// todo: the presenter Model presenting a viewController: bad code smell
public protocol DTPresentCustomerProtocol {
	func serve(_ customerId: String, animated: Bool)
}

public protocol DTSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T)
}

public protocol DTStartShiftProtocol {
	func startShift()
}



// todo the places where protocols and their extensions live is becoming increasingly messy, refactor into some sensible system
public extension DTSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T) {
		let reflection = Mirror(reflecting: delegate)
		for (_, child) in reflection.children.enumerated() {
			if child.value is Self {
				fatalError("DTSingleInstanceProtocol delegates can only possess one instance of <T>.self")
			}
		}
	}
}

public protocol DTCDEntityProtocol {
	var attributes: [String: DTStorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [DTCDKey])
	mutating func add(_ attribute: DTStorableDataType, by key: String) -> Bool
}

public protocol DTStorableDataType {}

extension Bool: DTStorableDataType {}
extension Double: DTStorableDataType {}
extension Float: DTStorableDataType {}
extension Int: DTStorableDataType {}
extension String: DTStorableDataType {}

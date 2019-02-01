//
//  SwitchesRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct SwitchesRelationship {
	let
	customerID: String,
	animated: Bool,
	customer: Customer?,
	waiter: Waiter?,
	headChef: HeadChef?
//
//	mutating func endShift() {
//		customer?.presentCheck()
//		waiter?.endShift()
//		headChef?.endShift()
//		customer = nil
//		waiter = nil
//		headChef = nil
//	}
}

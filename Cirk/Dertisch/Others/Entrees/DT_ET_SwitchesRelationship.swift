//
//  DT_ET_SwitchesRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct SwitchesRelationship: EndShiftProtocol {
	var
	customerID: String,
	customer: Customer,
	waiter: Waiter?,
	headChef: HeadChef?,
	animated: Bool

	mutating func endShift() {
		customer.finishMeal()
		waiter?.endShift()
		headChef?.endShift()
//		customer = nil
		waiter = nil
		headChef = nil
	}
}

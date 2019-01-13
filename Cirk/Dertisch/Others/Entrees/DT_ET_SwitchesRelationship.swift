//
//  DT_ET_switchBundle.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

internal struct DTSwitchesRelationship: DTEndShiftProtocol {
	var
	customerID: String,
	customer: DTCustomer?,
	waiter: DTWaiter?,
	headChef: DTHeadChef?,
	animated: Bool

	mutating func endShift() {
		customer?.finishMeal()
		waiter?.endShift()
		headChef?.endShift()
		customer = nil
		waiter = nil
		headChef = nil
	}
}

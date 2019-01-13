//
//  DT_ET_switchRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct DTInternalSwitchRelationship {
	let
	customerType: DTCustomerProtocol.Type,
	waiterType: DTWaiter.Type?,
	headChefType: DTHeadChef.Type?,
	kitchenStaffTypes: [DTKitchenMember.Type]?
}


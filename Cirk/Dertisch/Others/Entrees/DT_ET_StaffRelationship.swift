//
//  DT_ET_InternalSwitchRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct InternalSwitchRelationship {
	let
	customerType: CustomerProtocol.Type,
	waiterType: Waiter.Type?,
	headChefType: HeadChef.Type?,
	kitchenStaffTypes: [KitchenMember.Type]?
}


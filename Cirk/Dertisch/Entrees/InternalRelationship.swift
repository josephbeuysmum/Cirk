//
//  InternalRelationship.swift
//  Dertisch
//
//  Created by Richard Willis on 13/03/2018.
//

// todo a bunch more files can be made internal, no?
internal struct InternalRelationship {
	let
	customerType: Customer.Type,
	waiterType: Waiter.Type?,
	headChefType: HeadChef.Type?,
	kitchenResourceTypes: [KitchenResource.Type]?
}


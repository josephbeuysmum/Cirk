//
//  HeadChef.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol HeadChefForSousChef {
	mutating func give(prep: InternalOrder)
}

public protocol HeadChefForWaiter: GiveOrderProtocol {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForSousChef, BeginShiftProtocol, EndShiftProtocol, StaffMember, SwitchesRelationshipProtocol {
	init(maitreD: MaitreD, waiter: WaiterForHeadChef?, resources: [String: KitchenResource]?)
}

public extension HeadChef {
	public func beginBreak() {}
	public func beginShift() {}
	public func endBreak() {}
	public func endShift() {}
	public func give(_ order: CustomerOrder) {}
}

public extension HeadChefForSousChef {
	public func give(prep: InternalOrder) {
		let fulfilledOrder = FulfilledOrder(prep.ticket, dishes: prep.dishes as? Dishionarizer)
		lo(fulfilledOrder)
		Rota().waiterForHeadChef(self as? SwitchesRelationshipProtocol)?.serve(main: fulfilledOrder)
	}
}

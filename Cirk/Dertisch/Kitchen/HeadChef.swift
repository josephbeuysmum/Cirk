//
//  HeadChef.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol HeadChefForSousChef {
	func give(prep: InternalOrder)
}

public protocol HeadChefForMaitreD: BeginShiftable, EndShiftable {}

public protocol HeadChefForWaiter: GiveOrderable {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForSousChef, HeadChefForMaitreD, StaffMember, StaffRelatable {
	init(maitreD: MaitreD, waiter: WaiterForHeadChef?, resources: [String: KitchenResource]?)
}

public extension HeadChef {
	public func beginBreak() {}
	public func endBreak() {}
	public func give(_ order: CustomerOrder) {}
}

public extension HeadChefForMaitreD {
	public func beginShift() {}
	public func endShift() {}
}

public extension HeadChefForSousChef {
	public func give(prep: InternalOrder) {
		let fulfilledOrder = FulfilledOrder(prep.ticket, dishes: prep.dishes as? Dishionarizer)
		Rota().waiterForHeadChef(self as? StaffRelatable)?.serve(main: fulfilledOrder)
	}
}

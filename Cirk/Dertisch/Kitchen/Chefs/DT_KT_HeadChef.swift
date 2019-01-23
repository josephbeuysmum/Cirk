//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol HeadChefForKitchenMember {
	mutating func give(dishes: FulfilledOrder)
}

public protocol HeadChefForWaiter: GiveOrderProtocol {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForKitchenMember, StartShiftProtocol, EndShiftProtocol, CigaretteBreakProtocol {
	init(_ sousChefs: [String: KitchenMember]?)
	var waiter: WaiterForHeadChef? { get set }
}

public extension HeadChef {
	public func endBreak() {}
	public func endShift() {}
	public mutating func give(_ order: Order) {}
	public func startBreak() {}
	public func startShift() {}
}

public extension HeadChefForKitchenMember {
	public func give(dishes: FulfilledOrder) {
		guard var waiter = Rota().getColleague(WaiterForHeadChef.self, from: Mirror(reflecting: self)) else { return }
		waiter.serve(main: dishes)
	}
}

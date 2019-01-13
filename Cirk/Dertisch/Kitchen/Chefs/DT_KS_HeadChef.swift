//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol DTHeadChefForKitchenMember {
	mutating func give(dishes: DTOrderFromKitchen)
}

public protocol DTHeadChefForWaiter: DTGiveOrderProtocol {}

public protocol DTHeadChef: DTHeadChefForWaiter, DTHeadChefForKitchenMember, DTStartShiftProtocol, DTEndShiftProtocol, DTCigaretteBreakProtocol {
	init(_ sousChefs: [String: DTKitchenMember]?)
	var waiter: DTWaiterForHeadChef? { get set }
}

public extension DTHeadChef {
	public func endBreak() {}
	public func endShift() {}
	public mutating func give(_ order: DTOrder) {}
	public func startBreak() {}
	public func startShift() {}
}

public extension DTHeadChefForKitchenMember {
	public func give(dishes: DTOrderFromKitchen) {
		guard var waiter = DTReflector().getFirst(DTWaiterForHeadChef.self, from: Mirror(reflecting: self)) else { return }
		waiter.hand(main: dishes)
	}
}

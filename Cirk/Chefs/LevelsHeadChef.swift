//
//  LevelsHeadChef.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class LevelsHeadChef: HeadChef {
	private var
	maitreD: MaitreD?,
	sousChef: CirkSousChef?,
	waiter: WaiterForHeadChef?
	
	required init(maitreD: MaitreD, waiter: WaiterForHeadChef?, resources: [String: KitchenResource]?) {
		self.maitreD = maitreD
		self.sousChef = resources?[CirkSousChef.staticId] as? CirkSousChef
		self.waiter = waiter
//		lo("BONJOUR  ", self)
	}
	
//	deinit { lo("AU REVOIR", self) }
}

extension LevelsHeadChef: HeadChefForMaitreD {
	func beginShift() {
		guard let allLevels = sousChef?.allLevels else { return }
		waiter?.serve(entrees: FulfilledOrder(Tickets.allLevels, dishes: allLevels))
	}
	
	func endShift() {
		// todo can we genericise sousChef?.headChef = nil somehow? maybe nillify all sousChef headChefs at screen change time?
		sousChef?.headChef = nil
		waiter = nil
		maitreD = nil
	}
}

extension LevelsHeadChef: HeadChefForWaiter {
	func give(_ order: CustomerOrder) {
		guard
			order.ticket == Tickets.setLevel,
			let index = order.content as? Int
			else { return }
		sousChef?.selectLevel(by: index)
	}
}

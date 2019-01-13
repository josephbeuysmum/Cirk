//
//  LevelsHeadChef.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class LevelsHeadChef: DTHeadChef {
	var waiter: DTWaiterForHeadChef?
	
	fileprivate var sousChef: CirkSousChef?
	
	required init(_ sousChefs: [String: DTKitchenMember]?) {
//		lo("bonjour levels head chef")
		sousChef = sousChefs?[CirkSousChef.staticId] as? CirkSousChef
	}
	
//	deinit { lo("au revoir levels head chef") }
}

extension LevelsHeadChef: DTEndShiftProtocol {
	func endShift() {
		// todo can we genericise sousChef?.headChef = nil somehow? maybe nillify all sousChef headChefs at screen change time?
		sousChef?.headChef = nil
		waiter = nil
	}
}

extension LevelsHeadChef: DTHeadChefForWaiter {
	func give(_ order: DTOrder) {
		guard
			order.ticket == Tickets.setLevel,
			let index = order.content as? Int
			else { return }
		sousChef?.selectLevel(by: index)
	}
}

extension LevelsHeadChef: DTStartShiftProtocol {
	func startShift() {
		guard let allLevels = sousChef?.allLevels else { return }
		waiter?.serve(entrees: DTOrderFromKitchen(Tickets.allLevels, allLevels))
	}
}

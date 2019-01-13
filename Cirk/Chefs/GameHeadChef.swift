//
//  GameHeadChef.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GameHeadChef: DTHeadChef {
	var waiter: DTWaiterForHeadChef?
	
	fileprivate var sousChef: CirkSousChef?
	
	required init(_ sousChefs: [String: DTKitchenMember]?) {
//		lo("bonjour game head chef")
		sousChef = sousChefs?[CirkSousChef.staticId] as? CirkSousChef
		sousChef?.headChef = self
	}
	
//	deinit { lo("au revoir game head chef") }
	
	private func setLevel() {
		var level: Level?
		if let selectedLevel = sousChef?.selectedLevel {
			level = selectedLevel
		} else if let highestUnlockedLevel = sousChef?.highestUnlockedLevel {
			level = highestUnlockedLevel
		}
		guard let unwrappedLevel = level else { return }
		waiter?.serve(entrees: DTOrderFromKitchen(Tickets.openingLevel, unwrappedLevel))
	}
}

extension GameHeadChef: DTCigaretteBreakProtocol {
	func endBreak() {
		sousChef?.headChef = self
		setLevel()
	}
	
	func startBreak() {
		sousChef?.headChef = nil
	}
}

extension GameHeadChef: DTEndShiftProtocol {
	func endShift() {
		sousChef?.headChef = nil
		waiter = nil
	}
}

extension GameHeadChef: DTStartShiftProtocol {
	func startShift() {
		setLevel()
	}
}

extension GameHeadChef: DTHeadChefForWaiter {
	func give(_ order: DTOrder) {
		switch order.ticket {
		case Tickets.personalBest:
			sousChef?.set(personalBest: order.content as? PBMetrics)
		case Tickets.setLevel:
			guard
				let index = order.content as? Int,
				let level = sousChef?.getLevel(by: index)
				else { return }
			waiter?.hand(main: DTOrderFromKitchen(order.ticket, level))
		case Tickets.unlock:
			sousChef?.unlockLevel(by: order.content as? Int)
		default: ()
		}
	}
}

//
//  GameHeadChef.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GameHeadChef: HeadChef {
	var waiter: WaiterForHeadChef?
	
	fileprivate var sousChef: CirkSousChef?
	
	required init(_ sousChefs: [String: KitchenMember]?) {
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
		waiter?.serve(entrees: FulfilledOrder(Tickets.openingLevel, unwrappedLevel))
	}
}

extension GameHeadChef: CigaretteBreakProtocol {
	func endBreak() {
		sousChef?.headChef = self
		setLevel()
	}
	
	func startBreak() {
		sousChef?.headChef = nil
	}
}

extension GameHeadChef: EndShiftProtocol {
	func endShift() {
		sousChef?.headChef = nil
		waiter = nil
	}
}

extension GameHeadChef: StartShiftProtocol {
	func startShift() {
		setLevel()
	}
}

extension GameHeadChef: HeadChefForWaiter {
	func give(_ order: Order) {
		switch order.ticket {
		case Tickets.personalBest:
			sousChef?.set(personalBest: order.content as? PBMetrics)
		case Tickets.setLevel:
			guard
				let index = order.content as? Int,
				let level = sousChef?.getLevel(by: index)
				else { return }
			waiter?.hand(main: FulfilledOrder(order.ticket, level))
		case Tickets.unlock:
			sousChef?.unlockLevel(by: order.content as? Int)
		default: ()
		}
	}
}

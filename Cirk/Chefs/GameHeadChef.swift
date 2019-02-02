//
//  GameHeadChef.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GameHeadChef: HeadChef {
	private var
	maitreD: MaitreD?,
	sousChef: CirkSousChef?,
	waiter: WaiterForHeadChef?
	
	required init(maitreD: MaitreD, waiter: WaiterForHeadChef?, resources: [String: KitchenResource]?) {
//		lo("BONJOUR  ", self)
		self.maitreD = maitreD
		sousChef = resources?[CirkSousChef.staticId] as? CirkSousChef
		self.waiter = waiter
		sousChef?.headChef = self
	}
	
//	deinit { lo("AU REVOIR", self) }
	
	private func setLevel() {
		var level: Level?
		if let selectedLevel = sousChef?.selectedLevel {
			level = selectedLevel
		} else if let highestUnlockedLevel = sousChef?.highestUnlockedLevel {
			level = highestUnlockedLevel
		}
		guard let unwrappedLevel = level else { return }
		waiter?.serve(entrees: FulfilledOrder(Tickets.openingLevel, dishes: unwrappedLevel))
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
		maitreD = nil
	}
}

extension GameHeadChef: BeginShiftProtocol {
	func beginShift() {
		setLevel()
	}
}

extension GameHeadChef: HeadChefForWaiter {
	func give(_ order: CustomerOrder) {
		lo(order.ticket)
		switch order.ticket {
		case Tickets.personalBest:
			sousChef?.personalBest(order.content as? PBMetrics)
		case Tickets.setLevel:
			guard
				let index = order.content as? Int,
				let level = sousChef?.getLevel(by: index)
				else { return }
			waiter?.serve(main: FulfilledOrder(order.ticket, dishes: level))
		case Tickets.unlock:
			sousChef?.unlockLevel(by: order.content as? Int)
		default: ()
		}
	}
}

//
//  GameWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import AVFoundation
//import Dertisch

// todo all this is basically GeneralWaiter with a bespoke [Game]Carte added, so if we make the carte generic too then we can do away with this class/code
class GameWaiter: Waiter {
	private let maitreD: MaitreD
	
	private var
	customer: CustomerForWaiter!,
	headChef: HeadChefForWaiter!,
	carte_: CarteForCustomer?

	required init(maitreD: MaitreD) {
		self.maitreD = maitreD
//		lo("BONJOUR  ", self)
	}
	
//	deinit { lo("AU REVOIR", self) }
}

extension GameWaiter: EndShiftable {
	func endShift() {
		customer = nil
		headChef = nil
	}
}

extension GameWaiter: WaiterForCustomer {
	var carte: CarteForCustomer? {
		return carte_
	}
}

extension GameWaiter: WaiterForMaitreD {
	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?) {
		self.customer = customer
		self.headChef = headChef
	}
}

extension GameWaiter: WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {
		setCarte(with: main)
	}
	
	func fillCarte(with entrees: FulfilledOrder) {
		setCarte(with: entrees)
	}
	
	private func setCarte(with order: FulfilledOrder) {
		guard let dishes = order.dishes else { return }
		carte_ = Carte(dishes)
	}
}

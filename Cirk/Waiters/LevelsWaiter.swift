//
//  LevelsWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class LevelsWaiter: Waiter {
	// tood reinstate weak vars
//	fileprivate weak var customer: CustomerForWaiter!

	private let maitreD: MaitreD
	
	private var
	headChef: HeadChefForWaiter?,
	carte_: CarteForCustomer?,
	customer: CustomerForWaiter?

	required init(maitreD: MaitreD) {
		self.maitreD = maitreD
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

// todo we've managed to make Customer nillify itself via a weak ref., let's do the same for the head chef etc.
extension LevelsWaiter: EndShiftProtocol {
	func endShift() {
		customer = nil
		headChef = nil
	}
}

extension LevelsWaiter: WaiterForCustomer {
	var carte: CarteForCustomer? {
		return carte_
	}
}

extension LevelsWaiter: WaiterForMaitreD {
	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?) {
		self.customer = customer
		self.headChef = headChef
	}
}

extension LevelsWaiter: WaiterForWaiter {
	func fillCarte(with entrees: FulfilledOrder) {
		guard let dishes = entrees.dishes else { return }
		carte_ = Carte(dishes)
	}
}

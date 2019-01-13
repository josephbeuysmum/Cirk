//
//  GameWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import AVFoundation
//import Dertisch

// todo all this is basically GeneralWaiter with a bespoke [Game]Carte added, so if we make the carte generic too [with a subscript? [and casting accessors a la JsonThingy?]] then we can do away with this class/code
class GameWaiter: DTWaiter {
	fileprivate var
	customer: DTCustomerForWaiter!,
	headChef: DTHeadChefForWaiter!,
	carte_: DTCarteForCustomer?

	required init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?) {
//		lo("bonjour game waiter")
		self.customer = customer
		self.headChef = headChef
	}
	
//	deinit { lo("au revoir game waiter") }
}

extension GameWaiter: DTEndShiftProtocol {
	func endShift() {
		customer = nil
		headChef = nil
	}
}

extension GameWaiter: DTWaiterForCustomer {
	var carte: DTCarteForCustomer? {
		return carte_
	}
}

extension GameWaiter: DTWaiterForWaiter {
	func fillCarte(with entrees: DTOrderFromKitchen) {
		guard let dishes = entrees.dishes else { return }
		carte_ = DTCarte(dishes)
	}
}

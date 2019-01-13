//
//  LevelsWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import Foundation

class LevelsWaiter: DTWaiter {
	fileprivate weak var
	customer: DTCustomerForWaiter!
	
	fileprivate var
	headChef: DTHeadChefForWaiter!,
	carte_: DTCarteForCustomer?

	required init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?) {
//		lo("bonjour levels waiter")
		self.customer = customer
		self.headChef = headChef
	}
	
//	deinit { lo("au revoir levels waiter") }
}

// todo we've managed to make DTCustomer nillify itself via a weak ref., let's do the same for the head chef etc.
extension LevelsWaiter: DTEndShiftProtocol {
	func endShift() {
		headChef = nil
	}
}

extension LevelsWaiter: DTWaiterForCustomer {
	var carte: DTCarteForCustomer? {
		return carte_
	}
}

extension LevelsWaiter: DTWaiterForWaiter {
	func fillCarte(with entrees: DTOrderFromKitchen) {
		guard let dishes = entrees.dishes else { return }
		carte_ = DTCarte(dishes)
	}
}

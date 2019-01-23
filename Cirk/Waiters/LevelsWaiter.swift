//
//  LevelsWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import Foundation

class LevelsWaiter: Waiter {
	fileprivate weak var
	customer: CustomerForWaiter!
	
	fileprivate let maitreD: MaitreD
	
	fileprivate var
	headChef: HeadChefForWaiter!,
	carte_: CarteForCustomer?

	required init(maitreD: MaitreD, customer: CustomerForWaiter, headChef: HeadChefForWaiter?) {
//		lo("bonjour levels waiter")
		self.maitreD = maitreD
		self.customer = customer
		self.headChef = headChef
	}
	
//	deinit { lo("au revoir levels waiter") }
}

// todo we've managed to make Customer nillify itself via a weak ref., let's do the same for the head chef etc.
extension LevelsWaiter: EndShiftProtocol {
	func endShift() {
		headChef = nil
	}
}

extension LevelsWaiter: WaiterForCustomer {
	var carte: CarteForCustomer? {
		return carte_
	}
}

extension LevelsWaiter: WaiterForWaiter {
	func fillCarte(with entrees: FulfilledOrder) {
		guard let dishes = entrees.dishes else { return }
		carte_ = Carte(dishes)
	}
}

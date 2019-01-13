//
//  DT_WT_Simple.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

class GeneralWaiter: DTWaiter {
	var carte: DTCarteForCustomer? { return nil }
	
	fileprivate var
	customer: DTCustomerForWaiter?,
	headChef: DTHeadChefForWaiter?
	
	required init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter? = nil) {
		//lo("bonjour general waiter")
		self.customer = customer
		self.headChef = headChef
	}
	
//	deinit { lo("au revoir general waiter") }
	
	public func endShift() {
		customer = nil
		headChef = nil
	}
	
	public func startShift() {}
}

extension GeneralWaiter: DTWaiterForHeadChef {
	public func serve(entrees: DTOrderFromKitchen) {}
}

extension GeneralWaiter: DTWaiterForWaiter {
	func fillCarte(with entrees: DTOrderFromKitchen) {}
	func serve(dishes: DTOrderFromKitchen) {}
}

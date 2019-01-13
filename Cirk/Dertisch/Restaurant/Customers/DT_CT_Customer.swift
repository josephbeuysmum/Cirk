//
//  DT_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol DTCustomerForWaiter: class {
	func approach()
//	func firstDishServed()
//	func placeOrder()
//	func peruseMenu()
	func present(dish dishId: String)
//	func returnMenuToWaiter(_ chosenDishId: String?)
}

public protocol DTCustomerForSommelier {
	func regionChosen()
}

public protocol DTCustomerProtocol: DTCustomerForWaiter, DTCustomerForSommelier {
	func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier)
}

open class DTCustomer: UIViewController {
	// these can only be overridden if they are here as opposed to the extension below
	open func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier) {}
	open func finishMeal() {}
	open func firstDishServed() {}
	open func returnMenuToWaiter(_ chosenDishId: String?) {}
	open func peruseMenu() {}
	open func placeOrder() {}
	open func present(dish dishId: String) {}
	open func regionChosen() {}

	override final public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		firstDishServed()
	}
	
	override final public func viewDidLoad() {
		super.viewDidLoad()
		if let labels = DTReflector().getAll(UILabel.self, from: Mirror(reflecting: self)) {
			for label in labels {
				label.text = nil
			}
		}
		checkReadinessToOrder()
	}
	
	private final func checkReadinessToOrder() {
		guard
			isViewLoaded,
			let waiter = DTReflector().getFirst(DTWaiterForCustomer.self, from: Mirror(reflecting: self)),
			waiter.onShift
			else { return }
		placeOrder()
		regionChosen()
	}
}

extension DTCustomer: DTCustomerProtocol {
	public final func approach() {
		checkReadinessToOrder()
	}
}

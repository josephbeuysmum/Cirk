//
//  DT_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol CustomerForWaiter: class {
	func approach()
//	func firstDishServed()
//	func placeOrder()
//	func peruseMenu()
	func present(dish dishId: String)
//	func returnMenuToWaiter(_ chosenDishId: String?)
}

public protocol CustomerForSommelier {
	func regionChosen()
}

public protocol CustomerProtocol: CustomerForWaiter, CustomerForSommelier {
	func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier)
}

open class Customer: UIViewController {
	// these can only be overridden if they are here as opposed to the extension below
	open func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) {}
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
		if let labels = Rota().getAll(UILabel.self, from: Mirror(reflecting: self)) {
			for label in labels {
				label.text = nil
			}
		}
		checkReadinessToOrder()
	}
	
	private final func checkReadinessToOrder() {
		guard
			isViewLoaded,
			let waiter = Rota().getColleague(WaiterForCustomer.self, from: Mirror(reflecting: self)),
			waiter.onShift
			else { return }
		placeOrder()
		regionChosen()
	}
}

extension Customer: CustomerProtocol {
	public final func approach() {
		checkReadinessToOrder()
	}
}

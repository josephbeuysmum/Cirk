//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol CustomerForCustomer {
	func layTable()
	func showToTable()
}

public protocol CustomerForMaitreD: class {
	var restaurantTable: RestaurantTable? { get }
	func peruseMenu()
	func returnMenuToWaiter(_ order: CustomerOrder?)
	func menuReturnedToWaiter(_ order: CustomerOrder?)
}

public protocol CustomerForSommelier {
	func regionChosen()
}

public protocol CustomerForRestaurantTable {
	func tableAssigned()
	func isSeated()
}

public protocol CustomerForWaiter: class {
	func approach()
	func present(dish dishId: String)
	func presentCheck()
}

public protocol Customer: CustomerForCustomer, CustomerForMaitreD, CustomerForSommelier, CustomerForRestaurantTable, CustomerForWaiter, StaffRelatable {
	init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?)
}



public extension CustomerForCustomer {
	public func layTable() {}
	public func showToTable() {}
}

public extension CustomerForMaitreD {
	public func peruseMenu() {}
	public func returnMenuToWaiter(_ order: CustomerOrder? = nil) {}
	public func menuReturnedToWaiter(_ order: CustomerOrder? = nil) {}
}

public extension CustomerForRestaurantTable {
	public func tableAssigned() {
		(self as? CustomerForCustomer)?.showToTable()
		(self as? CustomerForSommelier)?.regionChosen()
	}
	
	public func isSeated() {
		(self as? CustomerForCustomer)?.layTable()
	}
}

public extension CustomerForSommelier {
	public func regionChosen() {}
}

public extension CustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
	public func presentCheck() {}
}

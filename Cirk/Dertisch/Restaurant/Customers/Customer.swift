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
	func returnMenuToWaiter(_ chosenDishId: String?)
}

public protocol CustomerForSommelier {
	func regionChosen()
}

public protocol CustomerForRestaurantTable {
	func tableIsLaid()
	func seat()
}

public protocol CustomerForWaiter: class {
	func approach()
	func present(dish dishId: String)
	func presentCheck()
}

public protocol Customer: CustomerForCustomer, CustomerForMaitreD, CustomerForSommelier, CustomerForRestaurantTable, CustomerForWaiter, SwitchesRelationshipProtocol {
	init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?)
}



public extension CustomerForCustomer {
	public func layTable() {}
	public func showToTable() {}
}

public extension CustomerForMaitreD {
	public func peruseMenu() {}
	public func returnMenuToWaiter(_ chosenDishId: String?) {}
}

public extension CustomerForRestaurantTable {
	public func seat() {
		(self as? CustomerForCustomer)?.layTable()
	}
	
	public func tableIsLaid() {
		(self as? CustomerForCustomer)?.showToTable()
		(self as? CustomerForSommelier)?.regionChosen()
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

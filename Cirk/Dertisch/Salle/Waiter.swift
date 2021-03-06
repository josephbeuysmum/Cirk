//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol Dish {}
public protocol SimpleDish: Dish {}
public protocol ComplexDish: Dish {}

extension Array: SimpleDish {}
extension Bool: SimpleDish {}
extension Double: SimpleDish {}
extension Float: SimpleDish {}
extension Int: SimpleDish {}
extension String: SimpleDish {}

public typealias Dishionary = [String: SimpleDish]

public struct Dishes: ComplexDish {
	private var dishes = Dishionary()
	
	init(_ dishes: Dishionary) {
		self.dishes = dishes
	}
}

extension Dishes: Collection {
	public typealias Index = Dishionary.Index
	public typealias Element = Dishionary.Element
	
	public var startIndex: Index { return dishes.startIndex }
	public var endIndex: Index { return dishes.endIndex }
	
	public subscript(index: Index) -> Iterator.Element {
		get { return dishes[index] }
	}
	
	public subscript(key: String) -> SimpleDish? {
		get { return dishes[key] }
	}
	
	public func index(after i: Index) -> Index {
		return dishes.index(after: i)
	}
}

public protocol Dishionarizer {
	var dishionary: Dishionary? { get }
}

fileprivate func dishionize(_ value: Any) -> Dishionary? {
	var dishionary = Dishionary()
	dishionize_(value, in: &dishionary)
	return dishionary.count > 0 ? dishionary : nil
}

fileprivate func dishionize_(_ value: Any, in dishionary: inout Dishionary, with prefix: String? = nil) {
	let mirror = Mirror(reflecting: value)
	var arrayCount = 0
	_ = mirror.children.compactMap {
		let
		label = $0.label ?? "\(arrayCount)",
		compositeLabel = prefix == nil ? label : "\(prefix!).\(label)",
		countChildren = Mirror(reflecting: $0.value).children.count
		if countChildren > 0 {
			if let array = $0.value as? Array<Any> {
				dishionary["\(compositeLabel).count"] = array.count
			}
			dishionize_($0.value, in: &dishionary, with: compositeLabel)
		} else if let value = $0.value as? SimpleDish {
			dishionary[compositeLabel] = value
		}
		arrayCount += 1
	}
}

extension Dishionarizer {
	// todo make dishionary once and once only
	var dishionary: Dishionary? {
		return dishionize(self)
	}
}





public protocol CarteForCustomer {}

// todo reinstate carte.stock()? And see if we can somehow make it generic?
public protocol CarteForWaiter {
//	func stock(with order: FulfilledOrder)
	func empty()
}

public protocol CarteProtocol: CarteForCustomer, CarteForWaiter {
//	init(_ entrees: Dishes?)
}

public extension CarteForWaiter {
//	func stock(with order: FulfilledOrder) {}
	func empty() {}
}

public extension CarteForCustomer {
	func des<T>(_ id: String) -> T? {
		guard let dishes = (self as? Carte)?.dishes_ else { return nil }
		let tempValue: Any?
		if let mandatoryValue = dishes[id] {
			tempValue = mandatoryValue
		} else if let optionalValue = dishes["\(id).some"] {
			tempValue = optionalValue
		} else {
			tempValue = nil
		}
		guard tempValue != nil else { return nil }
		let value = tempValue!
		if let result = value as? T {
			return result
		} else {
			// todo add CGFloat etc. here
			let tType = type(of: T.self)
			switch true {
			case tType == String.Type.self:
				return "\(value)" as? T
			case tType == Int.Type.self:
				if value is Float { return Int(round(Double(value as! Float))) as? T }
				if value is Double { return Float(value as! Double) as? T }
			case tType == Float.Type.self:
				if value is Int { return Float(value as! Int) as? T }
				if value is Double { return Float(value as! Double) as? T }
			case tType == Double.Type.self:
				if value is Int { return Double(value as! Int) as? T }
				if value is Float { return Double(value as! Float) as? T }
			case tType == Bool.Type.self:
				if value is Int { return ((value as! Int) == 1) as? T }
				if value is String { return ((value as! String) == "1") as? T }
				if value is Double { return ((value as! Double) == 1.0) as? T }
				if value is Float { return ((value as! Float) == 1.0) as? T }
			default: ()
			}
		}
		return nil
	}
	
	// todo we are currently using these to get array, when really they should be accessible through des<T>()
	func entrees<T>() -> T? {
		return (self as? Carte)?.entrees_ as? T
	}
}

// tood GC class or struct?
public struct Carte: CarteProtocol {
	// todo do these need trailing underscores?
	fileprivate let entrees_: Dishionarizer
	fileprivate var dishes_: Dishes?
	
	public init(_ entrees: Dishionarizer) {
		self.entrees_ = entrees
		guard let dishionary = entrees.dishionary else { return }
		self.dishes_ = Dishes(dishionary)
	}
}








public protocol WaiterForCustomer: GiveOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte()
//	var onShift: Bool { get }
}

//public protocol WaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol WaiterForHeadChef {
	func serve(entrees: FulfilledOrder)
	func serve(main: FulfilledOrder)
}

public protocol WaiterForMaitreD {
	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?)
}

public protocol WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder)
	func fillCarte(with entrees: FulfilledOrder)
}

public protocol Waiter: WaiterForCustomer, WaiterForHeadChef, WaiterForMaitreD, WaiterForWaiter, StaffMember, BeginShiftable, EndShiftable, StaffRelatable {
	init(maitreD: MaitreD)
}



public extension Waiter {
	public func beginShift() {
		Rota().customerForWaiter(self)?.approach()
	}
	
	public func beginBreak() {}
	public func endBreak() {}
	public func endShift() {}
}

public extension WaiterForCustomer {
	func emptyCarte() {}
	
	public func give(_ order: CustomerOrder) {
		guard let headChef = Rota().headChefForWaiter(self as? StaffRelatable) else { return }
		headChef.give(order)
	}
}

public extension WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {}
	func fillCarte(with entrees: FulfilledOrder) {}
}

public extension WaiterForHeadChef {
	// todo the waiter calls a serve function on itself from a serve function: is this necessary?
	public func serve(main: FulfilledOrder) {
		guard
			let waiter = self as? WaiterForWaiter,
			let selfAsStaffRelationship = self as? StaffRelatable,
			let customer = Rota().customerForWaiter(selfAsStaffRelationship)
			else { return }
		Rota().hasCarte(selfAsStaffRelationship) ? waiter.addToCarte(main) : waiter.fillCarte(with: main)
		DispatchQueue.main.async {
			customer.present(dish: main.ticket)
		}
	}
	
	public func serve(entrees: FulfilledOrder) {
		guard
			let waiter = self as? WaiterForWaiter,
			let customer = Rota().customerForWaiter(self as? StaffRelatable)
			else { return }
		waiter.fillCarte(with: entrees)
		customer.present(dish: entrees.ticket)
	}
}

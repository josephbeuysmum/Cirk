//
//  DT_RS_Waiter.swift
//  Cirk
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol DTDish {}
public protocol DTSimpleDish: DTDish {}
public protocol DTComplexDish: DTDish {}

extension Array: DTSimpleDish {}
extension Bool: DTSimpleDish {}
extension Double: DTSimpleDish {}
extension Float: DTSimpleDish {}
extension Int: DTSimpleDish {}
extension String: DTSimpleDish {}

public typealias DTDishionary = [String: DTSimpleDish]

public struct DTDishes: DTComplexDish {
	
	private var dishes = DTDishionary()
	
	init(_ dishes: DTDishionary) {
		self.dishes = dishes
	}
}

extension DTDishes: Collection {
	public typealias Index = DTDishionary.Index
	public typealias Element = DTDishionary.Element
	
	public var startIndex: Index { return dishes.startIndex }
	public var endIndex: Index { return dishes.endIndex }
	
	public subscript(index: Index) -> Iterator.Element {
		get { return dishes[index] }
	}
	
	public subscript(key: String) -> DTSimpleDish? {
		get { return dishes[key] }
	}
	
	public func index(after i: Index) -> Index {
		return dishes.index(after: i)
	}
}

public protocol DTDishionarizer {
	var dishionary: DTDishionary? { get }
}

fileprivate func dishionize(_ value: Any) -> DTDishionary? {
	var dishionary = DTDishionary()
	dishionize_(value, in: &dishionary)
	return dishionary.count > 0 ? dishionary : nil
}

fileprivate func dishionize_(_ value: Any, in dishionary: inout DTDishionary, with prefix: String? = nil) {
	let mirror = Mirror(reflecting: value)
	var arrayCount = 0
	_ = mirror.children.compactMap {
//		lo(prefix, $0.label, type(of: $0.value))
		let
		label = $0.label ?? "\(arrayCount)",
		compositeLabel = prefix == nil ? label : "\(prefix!).\(label)",
		countChildren = Mirror(reflecting: $0.value).children.count
		if countChildren > 0 {
			if let array = $0.value as? Array<Any> {
				dishionary["\(compositeLabel).count"] = array.count
			}
			dishionize_($0.value, in: &dishionary, with: compositeLabel)
		} else if let value = $0.value as? DTSimpleDish {
			dishionary[compositeLabel] = value
		}
		arrayCount += 1
	}
}

extension DTDishionarizer {
	// todo make dishionary once and once only
	var dishionary: DTDishionary? {
//		lo("dish..............", self)
//		if let dishion = DTReflector().getFirst(DTDishionary.self, from: Mirror(reflecting: self)) {
//			lo("dishion exists")
//			return dishion
//		} else {
//			lo("dishion needs creating")
			return dishionize(self)
//		}
	}
}





public protocol DTCarteForCustomer {}

// todo reinstate carte.stock()? And see if we can somehow make it generic?
public protocol DTCarteForWaiter {
//	func stock(with order: DTOrderFromKitchen)
	func empty()
}

public protocol DTCarteProtocol: DTCarteForCustomer, DTCarteForWaiter {
//	init(_ entrees: DTDishes?)
}

public extension DTCarteForWaiter {
//	func stock(with order: DTOrderFromKitchen) { lo() }
	func empty() {}
}

public extension DTCarteForCustomer {
	func des<T>(_ id: String) -> T? {
		guard let dishes = (self as? DTCarte)?.dishes_ else { return nil }
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
		return (self as? DTCarte)?.entrees_ as? T
	}
}

public struct DTCarte: DTCarteProtocol {
	fileprivate let entrees_: DTDishionarizer
	fileprivate var dishes_: DTDishes?
	
	public init(_ entrees: DTDishionarizer) {
		self.entrees_ = entrees
		guard let dishionary = entrees.dishionary else { return }
		self.dishes_ = DTDishes(dishionary)
//		lo(dishionary)
	}
}








public protocol DTWaiterForCustomer: DTGiveOrderProtocol {
	var carte: DTCarteForCustomer? { get }
	var onShift: Bool { get }
}

//public protocol DTWaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol DTWaiterForHeadChef {//: DTServeCustomerProtocol {
	mutating func serve(entrees: DTOrderFromKitchen)
	mutating func hand(main: DTOrderFromKitchen)
}

public protocol DTWaiterForWaiter {
	mutating func fillCarte(with entrees: DTOrderFromKitchen)
	mutating func serve(dishes: DTOrderFromKitchen)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTWaiterForWaiter, DTStartShiftProtocol, DTEndShiftProtocol, DTCigaretteBreakProtocol {
	init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?)
}



public extension DTWaiter {
	public func endBreak() {}
	public func endShift() {}
	public func startBreak() {}
	public func startShift() {}
}

public extension DTWaiterForCustomer {
	public var onShift: Bool {
		return type(of: self) == GeneralWaiter.self || carte != nil
		// && DTReflector().getFirst(DTHeadChefForWaiter.self, from: Mirror(reflecting: self)) != nil
	}
	
	public func give(_ order: DTOrder) {
//		lo()
		// todo replace the "get firsts" with some sort of generic ID
		guard var headChef = DTReflector().getFirst(DTHeadChefForWaiter.self, from: Mirror(reflecting: self)) else { return }
		headChef.give(order)
	}
}

public extension DTWaiterForWaiter {
	func fillCarte(with entrees: DTOrderFromKitchen) {}
	func serve(dishes: DTOrderFromKitchen) {
		let mirror = Mirror(reflecting: self)
//		guard let carte = DTReflector().getFirst(DTCarte.self, from: mirror) else { return }
//		carte.stock(with: dishes)
//		guard var waiter = self as? DTWaiterForWaiter else { return  }
		fillCarte(with: dishes)
		guard let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: mirror) else { return }
		// if we don't use dispatch queue we will cause a simultaneous-mutating-access error in the carte
		DispatchQueue.main.async {
			customer.present(dish: dishes.ticket)
		}
	}
}

public extension DTWaiterForHeadChef {
	public func hand(main: DTOrderFromKitchen) {
		guard var waiter = self as? DTWaiterForWaiter else { return }
		waiter.serve(dishes: main)
	}
	
	public func serve(entrees: DTOrderFromKitchen) {
		guard
			let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: Mirror(reflecting: self)),
			var waiter = self as? DTWaiterForWaiter
			else { return }
//		if let carte = DTReflector().getFirst(DTCarteForWaiter.self, from: Mirror(reflecting: self)) {
//			carte.stock(with: entrees)
//		} else {
			waiter.fillCarte(with: entrees)
//		}
		customer.approach()
	}
}

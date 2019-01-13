//
//  DT_PX_LocalAccess.swift
//  Dertisch
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol DTTemporaryValuesProtocol: DTKitchenMember {
	func getValue(by key: String, andAnnul: Bool?) -> DTStorableDataType?
	func set(_ value: DTStorableDataType, by key: String)
	func annulValue(by key: String)
	func removeValues ()
}

public class DTTemporaryValues {
	public var headChef: DTHeadChefForKitchenMember?
	
	fileprivate var values: Dictionary<String, DTStorableDataType>
	
	required public init(_ kitchenStaff: [String: DTKitchenMember]? = nil) {
		values = [:]
	}
}

extension DTTemporaryValues: DTTemporaryValuesProtocol {
	public func getValue(by key: String, andAnnul: Bool? = false) -> DTStorableDataType? {
		guard let value = values[key] else { return nil }
		if andAnnul! { annulValue(by: key) }
		return value
	}
	
	// todo use DTStorableDataType protocol (or something damned similar) to make value more flexible than just String
	public func set(_ value: DTStorableDataType, by key: String) {
		values[key] = value
	}
	
	public func annulValue(by key: String) {
		guard values[key] != nil else { return }
		values.removeValue(forKey: key)
	}
	
	public func removeValues() {
		for (key, _) in values { _ = annulValue(by: key) }
	}
	
//	public func deleteValue ( by key: String ) {
//		storage.removeObject( forKey: key )
//	}
//	
//	//	public func deleteValues ( key: String ) {}
//	
//	public func retrieveValue ( by key: String ) -> String? {
//		return storage.string( forKey: key )
//	}
//	
//	// store ("set") the given property
//	public func store ( value: String, by key: String, and caller: DTCaller? = nil ) {
//		guard let dishes = wornCloset.getSignals( by: key_.teeth ) else { return }
//		let signalKey = DTOrder.valueStored
//		DTMisc.set( dishes: dishes, withKey: signalKey, andCaller: caller )
//		storage.setValue( value, forKey: key )
//		storage.synchronize()
//		dishes.transmitSignalFor( key: signalKey )
//	}

}

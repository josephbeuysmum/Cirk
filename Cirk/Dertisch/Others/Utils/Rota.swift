//
//  Rota.swift
//  Dertisch
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

internal struct Rota {
	func all<T>(_ type: T.Type, from mirror: Mirror) -> [T]? {
		return instances(of: type, from: mirror, getAll: true)
	}
	
	func hasCarte(_ staffMember: SwitchesRelationshipProtocol?) -> Bool {
		return getWaiter(staffMember)?.carte != nil
	}
	
	func customerForWaiter(_ staffMember: SwitchesRelationshipProtocol?) -> CustomerForWaiter? {
		return getCustomer(staffMember)
	}
	
	func headChefForWaiter(_ staffMember: SwitchesRelationshipProtocol?) -> HeadChefForWaiter? {
		return getHeadChef(staffMember)
	}
	
	func waiterForCustomer(_ staffMember: SwitchesRelationshipProtocol?) -> WaiterForCustomer? {
		return getWaiter(staffMember)
	}
	
	func waiterForHeadChef(_ staffMember: SwitchesRelationshipProtocol?) -> WaiterForHeadChef? {
		return getWaiter(staffMember)
	}
	
	func waiterForWaiter(_ staffMember: SwitchesRelationshipProtocol?) -> WaiterForWaiter? {
		return getWaiter(staffMember)
	}
	
	private func getCustomer(_ staffMember: SwitchesRelationshipProtocol?) -> Customer? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(staffMember)?.customer(for: staffMember)
	}
	
	private func getHeadChef(_ staffMember: SwitchesRelationshipProtocol?) -> HeadChef? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(staffMember)?.headChef(for: staffMember)
	}
	
	private func getMaitreD(_ staffMember: SwitchesRelationshipProtocol) -> MaitreD? {
		let mirror = Mirror(reflecting: staffMember)
		guard let maitreDs = instances(of: MaitreD.self, from: mirror, getAll: true) else { return nil }
		return maitreDs.count == 1 ? maitreDs[0] : nil
	}
	
	private func getWaiter(_ staffMember: SwitchesRelationshipProtocol?) -> Waiter? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(staffMember)?.waiter(for: staffMember)
	}
	
	// kudos to everyone involved in this stack overflow thread:
	// stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
	private func instances<T>(of type: T.Type, from mirror: Mirror, getAll: Bool) -> [T]? {
		var values: [T] = []
		for (_, child) in mirror.children.enumerated() {
			let mirror = Mirror(reflecting: child.value)
			let value: Any
			if 	mirror.displayStyle == .optional,
				let first = mirror.children.first {
				value = first.value
			} else {
				value = child.value
			}
			if let t = value as? T {
				values.append(t)
				if !getAll { return values }
			}
		}
		return values.count > 0 ? values : nil
	}
}

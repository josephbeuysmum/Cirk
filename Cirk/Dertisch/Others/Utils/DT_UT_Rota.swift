//
//  DT_UT_Rota.swift
//  Dertisch
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

internal struct Rota {
	func customer(for staffMember: SwitchesRelationshipProtocol?) -> Customer? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(for: staffMember)?.customer(for: staffMember)
	}
	
	func headChef(for staffMember: SwitchesRelationshipProtocol?) -> HeadChef? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(for: staffMember)?.headChef(for: staffMember)
	}
	
	func waiter(for staffMember: SwitchesRelationshipProtocol?) -> Waiter? {
		guard let staffMember = staffMember else { return nil }
		return getMaitreD(for: staffMember)?.waiter(for: staffMember)
	}
	
	func getAllColleagues<T>(_ type: T.Type, from mirror: Mirror) -> [T]? {
		return instances(of: type, from: mirror, getAll: true)
	}

//	func getColleague<T>(_ type: T.Type, of staffMember: SwitchesRelationshipProtocol) -> T? {
//		let mirror = Mirror(reflecting: staffMember)
//		guard
//			let maitreD = instances(of: MaitreD.self, from: mirror, getAll: false)?[0],
//			let colleague = instances(of: type, from: mirror, getAll: false)?[0],
//			let switchColleague = colleague as? SwitchesRelationshipProtocol
//			else { return nil }
//		return maitreD.areColleagues(staffMember, switchColleague) ? colleague : nil
//	}
	
	private func getMaitreD(for staffMember: SwitchesRelationshipProtocol) -> MaitreD? {
		let mirror = Mirror(reflecting: staffMember)
		guard let maitreDs = instances(of: MaitreD.self, from: mirror, getAll: true) else { return nil }
		return maitreDs.count == 1 ? maitreDs[0] : nil
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

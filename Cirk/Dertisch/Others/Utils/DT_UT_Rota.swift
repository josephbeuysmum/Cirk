//
//  DT_UT_Rota.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

struct Rota {
	func getAllColleagues<T>(_ type: T.Type, from mirror: Mirror) -> [T]? {
		return instances(of: type, from: mirror, getAll: true)
	}
	
	func getColleague<T>(_ type: T.Type, of staffMember: SwitchesRelationshipProtocol) -> T? {
		let mirror = Mirror(reflecting: staffMember)
		guard
			let maitreD = getMaitreD(from: mirror),
			let colleague = instances(of: type, from: mirror, getAll: false)?[0],
			let switchColleague = colleague as? SwitchesRelationshipProtocol
			else { return nil }
		return maitreD.areColleagues(staffMember, switchColleague) ? colleague : nil
	}
	
	
	
	private func getMaitreD(from mirror: Mirror) -> MaitreD? {
		return instances(of: MaitreD.self, from: mirror, getAll: false)?[0]
	}
	
	// kudos to everyone involved in this stack overflow thread:
	// stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
	private func instances<T>(of type: T.Type, from mirror: Mirror, getAll: Bool) -> [T]? {
		var values: [T] = []
		for (_, child) in mirror.children.enumerated() {
			let mirror = Mirror(reflecting: child.value)
			let value: Any
			if  mirror.displayStyle == .optional,
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

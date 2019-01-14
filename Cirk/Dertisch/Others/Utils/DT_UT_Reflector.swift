//
//  DT_ET_FirstInstance.swift
//  Cirk
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// kudos to everyone involved in this stack overflow thread:
// stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
struct Reflector {
	func getAll<T>(_ type: T.Type, from mirror: Mirror) -> [T]? {
		return instances(of: type, from: mirror, getAll: true)
	}
	
	func getFirst<T>(_ type: T.Type, from mirror: Mirror) -> T? {
		return instances(of: type, from: mirror, getAll: false)?[0]
	}
	
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
//			lo(value)
			if let t = value as? T {
				values.append(t)
				if !getAll { return values }
			}
		}
		return values.count > 1 ? values : nil
	}
}

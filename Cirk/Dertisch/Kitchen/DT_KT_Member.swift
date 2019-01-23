//
//  DT_PT_VP_ModelClass.swift
//  Dertisch
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol KitchenMember: StaffMember {
	init(_ kitchenStaff: [String: KitchenMember]?)
	var headChef: HeadChefForKitchenMember? { get set }
}

public extension KitchenMember {
//	public var instanceDescriptor: String { return String(describing: self) }
	static public var staticId: String { return String(describing: self) }
	public mutating func endShift() {}
	public func startShift() {}
}

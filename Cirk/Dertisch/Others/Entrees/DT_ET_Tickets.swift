//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo better generic word for dishes and dishes than "passable"
//public typealias DTOrderFromKitchen = DTPassable
public typealias DTOrder = DTPassable
public typealias DTTicket = String

public protocol DTPassableProtocol {
	var ticket: DTTicket { get }
	var content: Any? { get }
}

//public protocol DTOrderFromKitchenProtocol {}

public struct DTPassable: DTPassableProtocol {
	public let
	ticket: DTTicket,
	content: Any?
	
	public init(_ ticket: DTTicket, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct DTOrderFromKitchen {//}: DTOrderFromKitchenProtocol {
	var ticket: DTTicket { return passable.ticket }
	var dishes: DTDishionarizer? { return passable.content as? DTDishionarizer }
	
	private let passable: DTPassable
	
	public init(_ id: DTTicket, _ content: DTDishionarizer?) {
		passable = DTPassable(id, content)
	}
}


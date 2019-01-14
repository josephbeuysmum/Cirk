//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public typealias Ticket = String

public struct Order {
	public let
	ticket: Ticket,
	content: Any?

	public init(_ ticket: Ticket, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct FulfilledOrder {
	public let
	ticket: Ticket,
	dishes: Dishionarizer?,
	multipleDishes: [String: Dishionarizer]?

	public init(_ ticket: Ticket, _ dishes: Dishionarizer?) {
		self.ticket = ticket
		self.dishes = dishes
		self.multipleDishes = nil
	}

	public init(_ ticket: Ticket, _ multipleDishes: [String: Dishionarizer]?) {
		self.ticket = ticket
		self.multipleDishes = multipleDishes
		self.dishes = nil
	}
}

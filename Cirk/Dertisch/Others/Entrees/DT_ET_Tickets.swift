//
//  DT_ET_Order.swift
//  Cirk
//
//  Created by Richard Willis on 23/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//public typealias Ticket = String

public struct Order {
	public let
	ticket: String,
	content: Any?

	public init(_ ticket: String, _ content: Any?) {
		self.ticket = ticket
		self.content = content
	}
}

public struct FulfilledOrder {
	public let
	ticket: String,
	dishes: Dishionarizer?
	
	public init(_ ticket: String, dishes: Dishionarizer? = nil) {
		self.ticket = ticket
		self.dishes = dishes
	}
}

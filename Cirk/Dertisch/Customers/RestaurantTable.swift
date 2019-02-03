//
//  RestaurantTable.swift
//  Cirk
//
//  Created by Richard Willis on 01/02/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class RestaurantTable: UIViewController {
	var customer: CustomerForRestaurantTable?
	
	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		customer?.isSeated()
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		customer?.tableAssigned()
	}
	
	override public func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		customer = nil
	}
}

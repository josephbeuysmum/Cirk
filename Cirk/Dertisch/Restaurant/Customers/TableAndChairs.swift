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
		customer?.seat()
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		customer?.tableIsLaid()
	}
}

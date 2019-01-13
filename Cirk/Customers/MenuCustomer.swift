//
//  MenuCustomer.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

class MenuCustomer: DTCustomer {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var dismissButton: UIButton!
	
	override func placeOrder() {
		tableView.delegate = self
		tableView.dataSource = self as? UITableViewDataSource
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 64
	}
}

extension MenuCustomer: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 48
	}
}

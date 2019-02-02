//
//  LevelsCustomer.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

class LevelsCustomer: NSObject, Customer {
	private let
	maitreD: MaitreD,
	sommelier: Sommelier!
	
	private var
	viewController: LevelsViewController?,
	waiter: WaiterForCustomer?
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.maitreD = maitreD
		self.viewController = restaurantTable as? LevelsViewController
		self.waiter = waiter
		self.sommelier = sommelier
		super.init()
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension LevelsCustomer {
	@objc private func dismissButtonTarget() {
		maitreD.removeMenu()
	}
}

extension LevelsCustomer: CustomerForWaiter {
	func presentCheck() {
		waiter = nil
		viewController = nil
	}
}

extension LevelsCustomer: CustomerForMaitreD {
	var restaurantTable: RestaurantTable? { return viewController }
}

extension LevelsCustomer: CustomerForCustomer {
	func showToTable() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.tableView.delegate = self
		restaurantTable.tableView.dataSource = self
		restaurantTable.tableView.rowHeight = UITableView.automaticDimension
		restaurantTable.tableView.estimatedRowHeight = 64
		restaurantTable.tableView.register(UINib(nibName: Views.levelsCell, bundle: nil), forCellReuseIdentifier: Views.levelsCell)
		restaurantTable.dismissButton.setTitle(sommelier[SommelierKeys.close]!, for: .normal)
		restaurantTable.dismissButton.addTarget(self, action: #selector(dismissButtonTarget), for: .touchUpInside)
	}
}
	

extension LevelsCustomer: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let entrees: LevelCollection = waiter?.carte?.entrees() else { return 0 }
		return entrees.levels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
//			let carte = carte,
			let cell = tableView.dequeueReusableCell(withIdentifier: Views.levelsCell) as? LevelsCustomerItem,
			let levels: LevelCollection = waiter?.carte?.entrees()
			else { return UITableViewCell() }
		cell.serve(with: levels.levels[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard
			let tableHeader = tableView.dequeueReusableCell(withIdentifier: Views.levelsCell) as? LevelsCustomerItem
			else { return nil }
		tableHeader.serve(with: LevelsTableHeader(
			title: sommelier[SommelierKeys.title]!,
			level: sommelier[SommelierKeys.level]!,
			target: sommelier[SommelierKeys.target]!,
			personalBest: sommelier[SommelierKeys.personalBest]!))
		return tableHeader
	}
}

extension LevelsCustomer: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = indexPath.row
		waiter?.give(CustomerOrder(Tickets.setLevel, row))
		maitreD.removeMenu("\(row)")
	}
}

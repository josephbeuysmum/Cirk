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
	var restaurantTable: RestaurantTable? { return viewController }
	
	private let
	maitreD: MaitreD,
	sommelier: Sommelier!,
	viewController: LevelsViewController?
	
	private var waiter: WaiterForCustomer?
	//	deinit { lo("au revoir levels menu") }
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.maitreD = maitreD
		self.viewController = restaurantTable as? LevelsViewController
		self.waiter = waiter
		self.sommelier = sommelier
	}

	func presentCheck() {
		waiter = nil
	}
	
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
	
	
	
	@objc private func dismissButtonTarget() {
		maitreD.removeMenu()
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

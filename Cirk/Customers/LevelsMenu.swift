//
//  LevelsMenu.swift
//  Cirk
//
//  Created by Richard Willis on 26/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

class LevelsMenu: MenuCustomer {
//	private var carte: LevelsCarte? { return waiter.carte as? LevelsCarte }
	
	private var
	maitreD: MaitreD!, 
	sommelier: Sommelier!,
	waiter: WaiterForCustomer?
	
//	deinit { lo("au revoir levels menu") }
	
	override func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) {
		self.waiter = waiter
		self.maitreD = maitreD
		self.sommelier = sommelier
	}
	
	override func finishMeal() {
		waiter = nil
	}
	
	override func placeOrder() {
		super.placeOrder()
		tableView.register(UINib(nibName: Views.levelsCell, bundle: nil), forCellReuseIdentifier: Views.levelsCell)
		dismissButton.setTitle(sommelier[SommelierKeys.close]!, for: .normal)
		dismissButton.addTarget(self, action: #selector(dismissButtonTarget), for: .touchUpInside)
	}
	
	
	
	@objc private func dismissButtonTarget() {
		maitreD.removeMenu()
	}
}



extension LevelsMenu: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let entrees: LevelCollection = waiter?.carte?.entrees() else { return 0 }
		return entrees.levels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
//			let carte = carte,
			let cell = tableView.dequeueReusableCell(withIdentifier: Views.levelsCell) as? LevelsMenuItem,
			let levels: LevelCollection = waiter?.carte?.entrees()
			else { return UITableViewCell() }
		cell.serve(with: levels.levels[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard
			let tableHeader = tableView.dequeueReusableCell(withIdentifier: Views.levelsCell) as? LevelsMenuItem
			else { return nil }
		tableHeader.serve(with: LevelsTableHeader(
			level: sommelier[SommelierKeys.level]!,
			target: sommelier[SommelierKeys.target]!,
			personalBest: sommelier[SommelierKeys.personalBest]!))
		return tableHeader
	}
}

extension LevelsMenu {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let row = indexPath.row
		waiter?.give(Order(Tickets.setLevel, row))
		maitreD.removeMenu("\(row)")
	}
}

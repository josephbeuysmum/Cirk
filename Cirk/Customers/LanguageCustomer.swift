//
//  LanguageCustomer.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

class LanguageCustomer: NSObject, Customer {
	var restaurantTable: RestaurantTable? { return viewController }
	
	private let
	maitreD: MaitreD,
	sommelier: Sommelier!,
	viewController: LanguageViewController?

	private var waiter: WaiterForCustomer?
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.viewController = restaurantTable as? LanguageViewController
		self.maitreD = maitreD
		self.waiter = waiter
		self.sommelier = sommelier
		super.init()
//		lo("BONJOUR  ", self)
	}
	
//	deinit { lo("AU REVOIR", self) }
	
	func presentCheck() {
		waiter = nil
	}
	
	func showToTable() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.tableView.delegate = self
		restaurantTable.tableView.dataSource = self
		restaurantTable.tableView.rowHeight = UITableView.automaticDimension
		restaurantTable.tableView.estimatedRowHeight = 64
		restaurantTable.tableView.register(UINib(nibName: Views.languageCell, bundle: nil), forCellReuseIdentifier: Views.languageCell)
		restaurantTable.dismissButton.setTitle(sommelier[SommelierKeys.close]!, for: .normal)
		restaurantTable.dismissButton.addTarget(self, action: #selector(dismissButtonTarget), for: .touchUpInside)
	}
	
	
	
	@objc func dismissButtonTarget() {
		maitreD.removeMenu()
	}
	
	private func getCarteName(by indexPath: IndexPath) -> String {
		return "names.\(indexPath.row).name"
	}
}



extension LanguageCustomer: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let entrees: LanguageCellEntrees = waiter?.carte?.entrees() else { return 0 }
		return entrees.names.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let languageId: String = waiter?.carte?.des(getCarteName(by: indexPath)),
			let language = sommelier[languageId.uppercased()],
			let cell = viewController?.tableView.dequeueReusableCell(withIdentifier: Views.languageCell) as? LanguageCustomerItem
			else { return UITableViewCell() }
		cell.serve(with: LanguageEntre(name: language, flag: languageId))
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard
			let language = sommelier[SommelierKeys.language],
			let tableHeader = viewController?.tableView.dequeueReusableCell(withIdentifier: Views.languageCell) as? LanguageCustomerItem
			else { return nil }
		tableHeader.serve(with: LanguageEntre(name: language, flag: nil))
		return tableHeader
	}
}

extension LanguageCustomer: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let languageId: String = waiter?.carte?.des(getCarteName(by: indexPath)) else { return }
		switch languageId {
		case Languages.english.rawValue:	sommelier.region = .england
		case Languages.french.rawValue:		sommelier.region = .france
		default: ()
		}
		maitreD.removeMenu()
	}
}

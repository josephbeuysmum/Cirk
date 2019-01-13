//
//  LanguageMenu.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

class LanguageMenu: MenuCustomer {
	private var
	maitreD: DTMaitreD!,
	sommelier: DTSommelier!,
	waiter: DTWaiterForCustomer!
	
	//	deinit { lo("au revoir language menu") }
	
	override func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier) {
		self.waiter = waiter
		self.maitreD = maitreD
		self.sommelier = sommelier
	}
	
	override func finishMeal() {
		waiter = nil
	}
	
	override func placeOrder() {
		super.placeOrder()
		tableView.register(UINib(nibName: Views.languageCell, bundle: nil), forCellReuseIdentifier: Views.languageCell)
		dismissButton.setTitle(sommelier[Sommelier.close]!, for: .normal)
		dismissButton.addTarget(self, action: #selector(dismissButtonTarget), for: .touchUpInside)
	}
	
	
	
	@objc func dismissButtonTarget() {
		maitreD.removeMenu()
	}
	
	private func getCarteName(by indexPath: IndexPath) -> String {
		return "names.\(indexPath.row).name"
	}
}



extension LanguageMenu: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let entrees: LanguageCellEntrees = waiter.carte?.entrees() else { return 0 }
		return entrees.names.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let languageId: String = waiter.carte?.des(getCarteName(by: indexPath)),
			let language = sommelier?[languageId.uppercased()],
			let cell = tableView.dequeueReusableCell(withIdentifier: Views.languageCell) as? LanguageMenuItem
			else { return UITableViewCell() }
		cell.serve(with: LanguageEntre(name: language, flag: languageId))
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard
			let language = sommelier?[Sommelier.language],
			let tableHeader = tableView.dequeueReusableCell(withIdentifier: Views.languageCell) as? LanguageMenuItem
			else { return nil }
		tableHeader.serve(with: LanguageEntre(name: language, flag: nil))
		return tableHeader
	}
}

extension LanguageMenu {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let languageId: String = waiter.carte?.des(getCarteName(by: indexPath)) else { return }
		switch languageId {
		case Languages.english.rawValue:	sommelier?.region = .england
		case Languages.french.rawValue:		sommelier?.region = .france
		default: ()
		}
		maitreD.removeMenu()
	}
}

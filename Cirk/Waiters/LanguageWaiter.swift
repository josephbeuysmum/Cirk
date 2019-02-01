//
//  LanguageWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import Foundation

class LanguageWaiter: Waiter {
	func fillCarte(with entrees: FulfilledOrder) {}
	
	fileprivate let maitreD: MaitreD
	
	fileprivate weak var
	customer: CustomerForWaiter!
	
	fileprivate var
	carte_: CarteForCustomer?
	
	required init(maitreD: MaitreD) {
//		lo("bonjour language waiter")
		self.maitreD = maitreD
		
		var languageNames: [LanguageCellEntre] = []
		Languages.allCases.forEach {
			languageNames.append(LanguageCellEntre(name: $0.rawValue))
		}
		carte_ = Carte(LanguageCellEntrees(names: languageNames))
	}
	
//	deinit { lo("au revoir language waiter") }
}

extension LanguageWaiter: WaiterForCustomer {
	var carte: CarteForCustomer? { return carte_ }
}

extension LanguageWaiter: WaiterForMaitreD {
	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?) {
		self.customer = customer
	}
}

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
	private let maitreD: MaitreD
	
	private var
	carte_: CarteForCustomer?,
	customer: CustomerForWaiter?

	required init(maitreD: MaitreD) {
		self.maitreD = maitreD
		lo("BONJOUR  ", self)

		var languageNames: [LanguageCellEntre] = []
		Languages.allCases.forEach {
			languageNames.append(LanguageCellEntre(name: $0.rawValue))
		}
		carte_ = Carte(LanguageCellEntrees(names: languageNames))
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension LanguageWaiter: WaiterForCustomer {
	var carte: CarteForCustomer? { return carte_ }
}

extension LanguageWaiter: WaiterForMaitreD {
	func introduce(_ customer: CustomerForWaiter, and headChef: HeadChefForWaiter?) {
		self.customer = customer
	}
}

extension LanguageWaiter: EndShiftProtocol {
	func endShift() {
		customer = nil
	}
}

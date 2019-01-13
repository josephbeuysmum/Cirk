//
//  LanguageWaiter.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import Foundation

class LanguageWaiter: DTWaiter {
	fileprivate weak var
	customer: DTCustomerForWaiter!
	
	fileprivate var
	carte_: DTCarteForCustomer?
	
	required init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?) {
		lo("bonjour language waiter")
		self.customer = customer
		
		var languageNames: [LanguageCellEntre] = []
		Languages.allCases.forEach {
			languageNames.append(LanguageCellEntre(name: $0.rawValue))
		}
		carte_ = DTCarte(LanguageCellEntrees(names: languageNames))
	}
	
	deinit { lo("au revoir language waiter") }
}

extension LanguageWaiter: DTWaiterForCustomer {
	var carte: DTCarteForCustomer? { return carte_ }
}

//
//  DTRoutingExtension.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

//extension DTCarteForCustomer {
//	var circles: [CircleJson]? {
//		let value: [CircleJson]? = self.des("circles")
//		return value
//	}
//}

extension DTMaitreD: DTMaitreDExtension {
	public func registerStaff(with key: String) {
		register(DTCoreData.self, with: key)
		register(DTBundledJson.self, with: key)
		register(CirkSousChef.self, with: key, injecting: [DTCoreData.self, DTBundledJson.self])
		introduce(
			Views.introCustomer,
			 as: IntroCustomer.self,
			 with: key)
		introduce(
			Views.gameCustomer,
			as: GameCustomer.self,
			with: key,
			waiter: GameWaiter.self,
			chef: GameHeadChef.self,
			kitchenStaff: [CirkSousChef.self])
		introduce(
			Views.languageMenu,
			as: LanguageMenu.self,
			with: key,
			waiter: LanguageWaiter.self)
		introduce(
			Views.levelsMenu,
			as: LevelsMenu.self,
			with: key,
			waiter: LevelsWaiter.self,
			chef: LevelsHeadChef.self,
			kitchenStaff: [CirkSousChef.self])
	}
}

//
//  DTRoutingExtension.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch

//extension CarteForCustomer {
//	var circles: [CircleJson]? {
//		let value: [CircleJson]? = self.des("circles")
//		return value
//	}
//}

extension MaitreD: MaitreDExtension {
	public func registerStaff(with key: String) {
		register(Freezer.self, with: key)
		register(Larder.self, with: key)
		register(CirkSousChef.self, with: key, injecting: [Freezer.self, Larder.self])
		introduce(
			Views.intro,
			 as: IntroCustomer.self,
			 with: key)
		introduce(
			Views.game,
			as: GameCustomer.self,
			with: key,
			waiter: GameWaiter.self,
			chef: GameHeadChef.self,
			kitchenResources: [CirkSousChef.self])
		introduce(
			Views.language,
			as: LanguageCustomer.self,
			with: key,
			waiter: LanguageWaiter.self)
		introduce(
			Views.levels,
			as: LevelsCustomer.self,
			with: key,
			waiter: LevelsWaiter.self,
			chef: LevelsHeadChef.self,
			kitchenResources: [CirkSousChef.self])
	}
}

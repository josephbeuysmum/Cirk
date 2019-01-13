//
//  LanguageEntre.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

struct LanguageEntre {
	let name: String, flag: String?
}

struct LanguageCellEntrees: DTDishionarizer {
	let names: [LanguageCellEntre]
}

struct LanguageCellEntre: DTDishionarizer {
	let name: String
}

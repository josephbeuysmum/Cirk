//
//  LevelJson.swift
//  Cirk
//
//  Created by Richard Willis on 05/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//protocol Indexical {
//	var index: Int { get }
//}

struct Level: DTDishionarizer { //, Indexical {
	let
	index: Int,
	mode: Int,
	json: LevelJson,
	personalBest: Float?,
	nextLevelUnlocked: Bool
}

struct LevelCollection: DTDishionarizer { //, Indexical {
	let levels: [Level]
}

struct LevelsJson: Decodable {
	let levels: [LevelJson]
}

struct LevelJson: Decodable { //, Indexical {
	let
	index: Int,
	circles: [CircleJson],
	unlockTime: Int
}

struct CircleJson: Decodable {
	let
	x: Float,
	y: Float,
	radius: Float,
	time: Float
}

struct LevelsTableHeader {
	let
	level: String,
	target: String,
	personalBest: String
}

//struct LanguageTableHeader {
//	let language: String, flag: String
//}

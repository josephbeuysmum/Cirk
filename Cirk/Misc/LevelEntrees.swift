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

struct Level: Dishionarizer { //, Indexical {
	let
	index: Int,
	mode: Int,
	json: LevelJson,
	nextLevelUnlocked: Bool,
	countLevels: Int,
	personalBest: Float?
}

struct LevelCollection: Dishionarizer { //, Indexical {
	let levels: [Level]
}

struct LevelCount: Dishionarizer {
	let countLevels: Int
}

struct LevelsJson: Decodable {
	let levels: [LevelJson]
}

struct LevelJson: Decodable, Hashable {
	var hashValue: Int { return 0 }
	let
	circles: [CircleJson],
	unlockTime: Int
	var index: Int?

	static func == (lhs: LevelJson, rhs: LevelJson) -> Bool {
		return lhs.index == rhs.index
	}
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

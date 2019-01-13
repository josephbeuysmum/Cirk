//
//  Consts.swift
//  Cirk
//
//  Created by Richard Willis on 07/06/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

// todo remove UIKit dependency and CGFloats
fileprivate let level = "Level"

struct Colors {
	static let
	crimson = CircleColors(red: 0.8, green: 0, blue: 0),
	black = CircleColors(red: 0, green: 0, blue: 0),
	lightGray = CircleColors(red: 0.8, green: 0.8, blue: 0.8),
	umber = CircleColors(red: 0.95, green: 0.4, blue: 0),
	teal = CircleColors(red: 0.2, green: 1, blue: 0.8),
	alpha = CGFloat(0.6)
}

enum Effects: String {
	case
	ballbearing = "ballbearingLoop",
	beep = "beepShort",
	//	circleIn = "win",
	//	circleOut = "lose",
	punch = "punch",
	start = "beepLong",
	schwoosh = "shwoosh",
	ticking = "tickTock",
	whoosh = "bambooWhoosh",
	wind = "electronicRunning"
}

struct Images {
	static let
	arrow = "arrow",
	ball = "ball",
	locked = "locked",
	unlocked = "unlocked",
	wood = "wood"
}

enum Languages: String, CaseIterable {
	case english, french
}

struct Metrics {
	static let
	animationDuration = 1.0,
	ballbearingMP3Length = 1.7,
	ballbearingVolumeDivider = CGFloat(16),
	ballHeightDivider = 7.0,
	ballSizeDiagram = 8,
	closeMarginOfError = Float(3),
	circleStrokeDivider = 120,
	frameTime = Float(0.02),
	screenSmallest = 320,
	screenLargest = 1024,
	screenMedian = (screenSmallest + screenLargest) / 2,
	shadowDivider = 80,
//	timeTextMarginDivider = 44,
	timeViewSize = 32
}

enum Modes: Int {
	case
	tabletop = 0,
	glassFromBelow = 1
}

struct Sommelier {
	static let
	almost = "ALMOST",
	cancel = "CANCEL",
	changeLevel = "CHANGE_LEVEL",
	cirks = "CIRKS",
	close = "CLOSE",
	english = "ENGLISH",
	french = "FRENCH",
	gameDescription = "GAME_DESC",
	go = "GO",
	improvePersonalBest = "IMPROVE_PERSONAL_BEST",
	language = "LANGUAGE",
	level = "LEVEL",
	levelUnlocked = "LEVEL_UNLOCKED",
	levelNotUnlocked = "LEVEL_NOT_UNLOCKED",
	matchedPB = "MATCHED_PB",
	newPB = "NEW_PB",
	personalBest = "PERSONAL_BEST",
	play = "PLAY",
	playAgain = "PLAY_AGAIN",
	playNextLevel = "PLAY_NEXT_LEVEL",
	target = "TARGET",
	total = "TOTAL",
	unlockTime = "UNLOCK_TIME"
//		levelMastered = "LEVEL_MASTERED",
//		bestTime = "BEST_TIME",
}

struct Storage {
	static let
	selectedLevel = "\(DTCCommonPhrases.Selected)\(level)"
}

struct Tickets {
	private static let ns = "Tickets."
	static let
	allLevels = "\(ns)allLevels",
	openingLevel = "\(ns)openingLevel",
	personalBest = "\(ns)personalBest",
	setLevel = "\(ns)setLevel",
	unlock = "\(ns)unlock"
}

struct Views {
	private static let
	language_ = "Language",
	levels_ = "Levels"
	
	static let
	gameCustomer = "Game\(DTCCommonPhrases.Customer)",
	introCustomer = "Intro\(DTCCommonPhrases.Customer)",
	languageCell = "\(language_)\(DTCCommonPhrases.Cell)",
	languageMenu = "\(language_)\(DTCCommonPhrases.Menu)",
	levelsCell = "\(levels_)\(DTCCommonPhrases.Cell)",
	levelsMenu = "\(levels_)\(DTCCommonPhrases.Menu)"
}


//struct UnusedConsts {
//	fileprivate static let
//	level_ = "Level",
//	levels_ = "Levels"

//	static let
//	levelSelected = "\(level_)\(DTCCommonPhrases.Selected)",
//	levelChosen = "\(level_)Chosen",
//	levelsAdded = "\(levels_)\(DTCCommonPhrases.Added)",
//	levelUpdated = "\(levels_)\(DTCCommonPhrases.Updated)",
//	ballTimerTicked = "BallTimerTicked",
//	newPersonalBest = "NewPersonalBest",
//	selectedLevel = "\(DTCCommonPhrases.Selected)\(level_)"

//	frameTime = Float(0.02),
//	alpha = CGFloat(0.8)

//	init() { fatalError("Consts should not be inited") }
//}

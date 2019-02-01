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

struct CarteKeys {
	private static let ns = "json."
	static let
	ballX = "\(ns)ballX",
	ballY = "\(ns)ballY",
	circleTime = "\(ns)circles.0.time",
	countCircles = "\(ns)circles.count",
	countLevels = "countLevels",
	jsonIndex = "\(ns)index",
	jsonTitle = "\(ns)title",
	jsonUnlock = "\(ns)unlockTime",
	nextLevelUnlocked = "nextLevelUnlocked",
	personalBest = "personalBest"
}

struct Colors {
	static let
	crimson = CircleColors(red: 0.8, green: 0, blue: 0),
	black = CircleColors(red: 0, green: 0, blue: 0),
	lightGray = CircleColors(red: 0.8, green: 0.8, blue: 0.8),
	brown = CircleColors(red: 0.6, green: 0.4, blue: 0.1),
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

struct ImageNames {
	static let
	arrow = "arrow",
	ball = "ball",
	locked = "locked",
	surface = "wood",
	unlocked = "unlocked"
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
	timeLabelMargin = 8,
	timeViewSize = 32
}

enum Modes: Int {
	case
	tabletop = 0,
	glassFromBelow = 1
}

struct SommelierKeys {
	static let
	almost = "ALMOST",
	cancel = "CANCEL",
	changeLevel = "CHANGE_LEVEL",
	cirks = "CIRKS",
	close = "CLOSE",
	english = "ENGLISH",
	french = "FRENCH",
	gameDescription = "GAME_DESCRIPTION",
	go = "GO",
	improvePersonalBest = "IMPROVE_PERSONAL_BEST",
	language = "LANGUAGE",
	lastLevelCopy = "LAST_LEVEL_COPY",
	lastLevelUnlocked = "LAST_LEVEL_UNLOCKED",
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
	title = "TITLE",
	total = "TOTAL",
	unlockTime = "UNLOCK_TIME"
//		levelMastered = "LEVEL_MASTERED",
//		bestTime = "BEST_TIME",
}

struct Storage {
	static let
	selectedLevel = "\(CommonPhrases.Selected)\(level)"
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
	game = "Game",
	intro = "Intro",
	language = "\(language_)",
	languageCell = "\(language_)\(CommonPhrases.Cell)",
	levels = "\(levels_)",
	levelsCell = "\(levels_)\(CommonPhrases.Cell)"
}


//struct UnusedConsts {
//	fileprivate static let
//	level_ = "Level",
//	levels_ = "Levels"

//	static let
//	levelSelected = "\(level_)\(CommonPhrases.Selected)",
//	levelChosen = "\(level_)Chosen",
//	levelsAdded = "\(levels_)\(CommonPhrases.Added)",
//	levelUpdated = "\(levels_)\(CommonPhrases.Updated)",
//	ballTimerTicked = "BallTimerTicked",
//	newPersonalBest = "NewPersonalBest",
//	selectedLevel = "\(CommonPhrases.Selected)\(level_)"

//	frameTime = Float(0.02),
//	alpha = CGFloat(0.8)

//	init() { fatalError("Consts should not be inited") }
//}

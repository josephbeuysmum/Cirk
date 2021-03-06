//
//  CirkSousChef.swift
//  Cirk
//
//  Created by Richard Willis on 12/06/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData
//import Dertisch

class CirkSousChef {
	var
	mode: Modes,
	headChef: HeadChefForSousChef?
	
	// todo uppercase these
	private let
	levelKey: String,
	indexKey: String,
	modeKey: String,
	personalBestKey: String,
	freezer: Freezer?,
	bundledJson: Larder?
	
	private var
	levels: [Level],
	levelsJson: LevelsJson?,
	selectedLevelIndex: Int?
	
	required init(_ kitchenStaff: [String: KitchenResource]?) {
		freezer = kitchenStaff?[Freezer.staticId] as? Freezer
		bundledJson = kitchenStaff?[Larder.staticId] as? Larder
		levelKey = "DTCDLevel"
		indexKey = "index"
		personalBestKey = CarteKeys.personalBest
		modeKey = "mode"
		levels = []
		mode = Modes.tabletop
	}
}

extension CirkSousChef {
	var allLevels: LevelCollection? {
		guard
			let countJson = levelsJson?.levels.count,
			let highestUnlockedLevel = self.highestUnlockedLevel
			else { return nil }
		let
		highestUnlockedLevelIndex = highestUnlockedLevel.index,
		levelsUnlockedUpTo = !highestUnlockedLevel.nextLevelUnlocked ? highestUnlockedLevelIndex : highestUnlockedLevelIndex + 1,
		countLevels = self.levels.count
		var
		levels: [Level] = [],
		level: Level
		for i in 0..<countJson {
			if  i >= countLevels,
				let json = levelsJson?.levels[i] {
				level = Level(
					index: i,
					mode: Modes.tabletop.rawValue,
					json: json,
					nextLevelUnlocked: i < levelsUnlockedUpTo, countLevels: 0,
					personalBest: nil)
			} else {
				level = self.levels[i]
			}
			levels.append(level)
		}
		return levels.count > 0 ? LevelCollection(levels: levels) : nil
	}
	
	var countLevel: LevelCount {
		return LevelCount(countLevels: levels.count)
	}
	
	var highestUnlockedLevel: Level? {
		guard
			levelsJson != nil,
			levels.count > 0,
			let firstLevel = get(level: 0)
			else { return nil }
		let highestLevel = levels.reduce(firstLevel, { $0.index > $1.index ? $0 : $1 })
		return highestLevel
	}
	
	var selectedLevel: Level? {
		guard let index = selectedLevelIndex else { return nil }
		return getLevel(by: index)
	}
	
	
	
	
	
	func endShift() {}
	
	func getLevel(by index: Int) -> Level? {
		guard let level = get(level: index) else { return nil }
		return level
	}
	
	func selectLevel(by index: Int) {
		let countJson = levelsJson?.levels.count
		selectedLevelIndex = countJson != nil && index > -1 && index < countJson! ? index : nil
	}
	
	func personalBest(_ value: PBMetrics?) {
		guard let pb = value else { return }
		freezer?.update(
			levelKey,
			to: FreezerAttribute(personalBestKey, pb.value),
			by: "index == \(pb.levelIndex)") { [weak self] managedObjects in
				guard
					let strongSelf = self,
					let strongManagedObjects = managedObjects
					else { return }
				strongSelf.setLevels(strongManagedObjects)
				guard let level = strongSelf.getLevel(by: pb.levelIndex) else { return }
				strongSelf.headChef?.give(prep: InternalOrder(Tickets.personalBest, dishes: level))
		}
	}
	
	func beginShift() {
		guard let rawLevelsJson = bundledJson?.decode(json: "levels", into: LevelsJson.self) else { return }
		var preparedLevels: [LevelJson] = []
		let levelsCount = rawLevelsJson.levels.count
		for i in 0..<levelsCount {
			var level = rawLevelsJson.levels[i]
			level.index = i
			preparedLevels.append(level)
		}
		self.levelsJson = LevelsJson(levels: preparedLevels)
		freezer?.dataModelName = "CirkData"
		freezer?.retrieve(levelKey) { [weak self] managedObjects in
			guard let strongSelf = self else { return }
			if let strongManagedObjects = managedObjects {
				strongSelf.setLevels(strongManagedObjects)
			} else {
				strongSelf.store(level: 0)
			}
		}
	}
	
	func unlockLevel(by index: Int?) {
		guard let levelIndex = index else { return }
		self.store(level: levelIndex)
	}
	

	
	private func get(level index: Int) -> Level? {
		let filteredLevels = levels.filter { $0.index == index }
		guard filteredLevels.count == 1 else { return nil }
		return filteredLevels[0]
	}
	
	private func getLevelArrayIndex(by levelIndex: Int) -> Int? {
		// todo? change this to less brute force approach: maybe filter{} down to single Level then index(of) it?
		for i in 0..<levels.count {
			if levels[i].index == levelIndex {
				return i
			}
		}
		return nil
	}
	
	private func setLevels(_ levels: [NSManagedObject]?) {
		guard
			let strongLevels = levels as? [DTCDLevel],
			let countLevels = levelsJson?.levels.count
			else { return }
		for level in strongLevels {
			let levelIndex = Int(level.index)
			if let levelJson = levelsJson?.levels[levelIndex] {
				let
				nextLevelUnlocked = level.personalBest > 0 && level.personalBest <= Double(levelJson.unlockTime),
				level = Level(
					index: levelIndex,
					mode: Int(level.mode),
					json: levelJson,
					nextLevelUnlocked: nextLevelUnlocked,
					countLevels: countLevels,
					personalBest: Float(level.personalBest))
				if let levelIndex = getLevelArrayIndex(by: level.index) {
					self.levels.replaceSubrange(levelIndex...levelIndex, with: [level])
				} else {
					self.levels.append(level)
				}
			}
		}
	}
	
	// todo: mode does nothing for now, but is foreseen as a way to make an upside-down version of the game later on
	private func store(level index: Int) {
		var levelEntity = FreezerEntity(
			levelKey,
			keys: [
				FreezerKey(indexKey, FreezerTypes.int),
				FreezerKey(modeKey, FreezerTypes.int),
				FreezerKey(personalBestKey, FreezerTypes.double)
			])
		guard
			levelEntity.add(index, by: indexKey),
			levelEntity.add(mode.rawValue, by: modeKey),
			levelEntity.add(-1.0, by: personalBestKey)
			else { return }
		freezer?.store(levelEntity) { [weak self] objects in
			self?.setLevels(objects)
		}
	}
}

extension CirkSousChef: KitchenResource {}

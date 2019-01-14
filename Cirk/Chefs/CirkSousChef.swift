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
	headChef: HeadChefForKitchenMember?
	
	// todo uppercase these
	private let
	levelKey: String,
	indexKey: String,
	modeKey: String,
	personalBestKey: String,
	coreData: Freezer?,
	bundledJson: BundledJson?
	
	private var
	levels: [Level],
	levelsJson: LevelsJson?,
	selectedLevelIndex: Int?
	
	required init(_ kitchenStaff: [String: KitchenMember]?) {
		coreData = kitchenStaff?[Freezer.staticId] as? Freezer
		bundledJson = kitchenStaff?[BundledJson.staticId] as? BundledJson
		levelKey = "DTCDLevel"
		indexKey = "index"
		personalBestKey = "personalBest"
		modeKey = "mode"
		levels = []
		mode = Modes.tabletop
	}
}

extension CirkSousChef {//}: CirkSousChefProtocol {
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
				let json = getLevelJson(by: i) {
				level = Level(
					index: i,
					mode: Modes.tabletop.rawValue,
					json: json,
					nextLevelUnlocked: i < levelsUnlockedUpTo,
					personalBest: nil)
			} else {
				level = self.levels[i]
			}
//			lo("ALLEVS", level.index, getLevelArrayIndex(by: level.index), level.personalBest, level.nextLevelUnlocked)
			levels.append(level)
		}
		return levels.count > 0 ? LevelCollection(levels: levels) : nil
	}
	
	var highestUnlockedLevel: Level? {
		guard
			levelsJson != nil,
			levels.count > 0,
			let firstLevel = get(level: 0)
			else { return nil }
		let highestLevel = levels.reduce(firstLevel, { $0.index > $1.index ? $0 : $1 })
//		highestLevel.nextLevelUnlocked = false
		return highestLevel
	}
	
	var selectedLevel: Level? {
		guard let index = selectedLevelIndex else { return nil }
		return getLevel(by: index)
	}
	
	
	
	
	
	func endShift() {
		// todo remove this temporary deletion
		coreData?.delete(levelKey) { [weak self] _ in
			lo("deleted")
			self?.levels.removeAll()
		}
	}
	
	func getLevel(by index: Int) -> Level? {
		guard let level = get(level: index) else { return nil }
		return level
	}
	
	func selectLevel(by index: Int) {
		let countJson = levelsJson?.levels.count
		selectedLevelIndex = countJson != nil && index > -1 && index < countJson! ? index : nil
//		lo("selected index:", selectedLevelIndex)
	}
	
	func set(personalBest: PBMetrics?) {
		guard let pb = personalBest else { return }
		coreData?.update(
			levelKey,
			to: FreezerAttribute(personalBestKey, pb.value),
			by: "index == \(pb.levelIndex)") { [weak self] managedObjects in
				guard
					let strongSelf = self,
					let safeManagedObjects = managedObjects
					else { return }
//				lo( strongSelf.getLevel(by: pb.levelIndex)?.index, strongSelf.getLevel(by: pb.levelIndex)?.personalBest, strongSelf.getLevel(by: pb.levelIndex)?.nextLevelUnlocked )
				strongSelf.set(levels: safeManagedObjects)
				guard let level = strongSelf.getLevel(by: pb.levelIndex) else { return }
//				lo(level.index, level.personalBest, level.nextLevelUnlocked)
//				lo(strongSelf.headChef)
				strongSelf.headChef?.give(dishes: FulfilledOrder(Tickets.personalBest, level))
		}
	}
	
	func startShift() {
		guard let levelsJson = bundledJson?.decode(json: "levels", into: LevelsJson.self) else {
			// todo replace this
			fatalError("NO LEVELS JSON")
		}
		self.levelsJson = levelsJson
		coreData?.dataModelName = "CirkData"
//		endShift(); return;
		coreData?.retrieve(levelKey) { [weak self] managedObjects in
			guard let strongSelf = self else { return }
			if let safeManagedObjects = managedObjects {
				strongSelf.set(levels: safeManagedObjects)
			} else {
				if let lowestLevel = strongSelf.levelsJson?.levels.reduce(LevelJson(index: 100, circles: [], unlockTime: 0), { $0.index < $1.index ? $0 : $1 }) {
					strongSelf.store(level: lowestLevel.index)
				}
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
//		let level = filteredLevels[0]
//		, nextLevel = levels.filter { $0.index == index + 1 }
//		level.nextLevelUnlocked = nextLevel.count > 0
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
	
	private func getLevelJson(by index: Int) -> LevelJson? {
		guard let levelsJson = (levelsJson?.levels.filter { $0.index == index }) else { return nil }
		return levelsJson.count == 1 ? levelsJson[0] : nil
	}

	private func set(levels: [NSManagedObject]?) {
		guard let safeLevels = levels as? [DTCDLevel] else {
			return }
		for safeLevel in safeLevels {
			let index = Int(safeLevel.index)
//			lo(index)
			if let levelJson = getLevelJson(by: index) {
				let
				nextLevelUnlocked = safeLevel.personalBest > 0 && safeLevel.personalBest <= Double(levelJson.unlockTime),
				level = Level(
					index: index,
					mode: Int(safeLevel.mode),
					json: levelJson,
					nextLevelUnlocked: nextLevelUnlocked,
					personalBest: Float(safeLevel.personalBest))
//				lo("UPDATE", index, getLevelArrayIndex(by: index), safeLevel.personalBest, level.nextLevelUnlocked)
				if let levelIndex = getLevelArrayIndex(by: index) {
					self.levels.replaceSubrange(levelIndex...levelIndex, with: [level])
				} else {
					self.levels.append(level)
				}
			}
		}
//		logLevels()
	}
	
//	private func logLevels () {
//		for i in 0..<levels.count {
//			lo(i, levels[i].index, levels[i].mode, levels[i].nextLevelUnlocked, levels[i].personalBest)
//		}
//	}
	
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
//		lo("CREATE", index, -1.0)
		coreData?.store(levelEntity) { [weak self] objects in
			self?.set(levels: objects)
		}
	}
}

extension CirkSousChef: KitchenMember {}

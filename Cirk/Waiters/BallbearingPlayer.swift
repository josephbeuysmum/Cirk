//
//  GameCarte.swift
//  Cirk
//
//  Created by Richard Willis on 14/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import AVFoundation
//import Foundation
//
//class GameCarte: NSObject, DTCarte {
//	fileprivate var
//	level: Level?
//
//	required init<T>(_ entrees: T) {
////		lo("bonjour game carte")
//		level = entrees as? Level
//	}
//	
////	deinit { lo("au revoir game carte") }
//}
//
//	var circles: [CircleJson]? { return level?.json.circles }
//	var levelIndex: Int? { return level?.index }
//	var personalBest: Float? { return level?.personalBest }
//	var nextLevelUnlocked: Bool? { return level?.nextLevelUnlocked }
//	var unlockTime: Float? {
//		let unlockInt = level?.json.unlockTime
//		return unlockInt != nil ? Float(unlockInt!) : nil
//	}


class BallbearingPlayer: NSObject {
	fileprivate var
	audioIsOn: Bool,
	level: Level?,
	effectPlayer: AVAudioPlayer?,
	ballbearingPlayer: AVAudioPlayer?
	
	override init() {
		audioIsOn = false
		super.init()
	}
	
	func play(sound effect: Effects, loops: Bool) {
		effectPlayer = self.play(effect, 1.0, loops)
	}
	
	func set(audioOn: Bool) {
		guard audioOn != audioIsOn else { return }
		audioIsOn = audioOn
		if audioIsOn {
			do {
				try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
				try AVAudioSession.sharedInstance().setActive(true)
			} catch {
				audioIsOn = false
			}
		} else {
			stopSoundEffect()
			stopBallbearingSound()
			do {
				try AVAudioSession.sharedInstance().setActive(false)
			} catch {}
		}
	}
	
	func set(ballbearingVolume volume: Float) {
		ballbearingPlayer?.volume = volume
	}
	
	func startBallbearingSound() {
		ballbearingPlayer = self.play(Effects.ballbearing, 0.0, true)
	}
	
	func stopBallbearingSound() {
		ballbearingPlayer?.stop()
		ballbearingPlayer = nil
	}

	func stopSoundEffect() {
		effectPlayer?.stop()
		effectPlayer = nil
	}
	
	private func play(_ sound: Effects, _ volume: Float, _ loops: Bool) -> AVAudioPlayer? {
		guard
			audioIsOn,
			let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3")
			else { return nil }
		do {
			let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
			player.volume = volume
			player.numberOfLoops = loops ? -1 : 0
			player.play()
			return player
		} catch let error {
			lo(error.localizedDescription)
		}
		return nil
	}
}

extension BallbearingPlayer: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		player.stop()
		if player === effectPlayer {
			effectPlayer = nil
		} else {
			ballbearingPlayer = nil
		}
	}
}

//extension GameCarte: DTCarteForWaiter {
//	func empty() {
//		stopSoundEffect()
//		stopBallbearingSound()
//	}
//
//	func stock(with order: DTOrderFromKitchen) {
//		guard let updatedLevel = order.dishes as? Level else { return }
//		level = updatedLevel
//	}
//}

//
//  ViewController.swift
//  Cirk
//
//  Created by Richard Willis on 15/05/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreMotion
//import Dertisch
import UIKit

fileprivate typealias AlertDetails = (header: String, actions: [UIAlertAction], message: String?)
fileprivate typealias AnimDetails = (text: String, effect: Effects)

class GameCustomer: Customer {
	var restaurantTable: RestaurantTable?  { return viewController }

	private var ballSize: Double {
		return round(Double((Int(screenBounds.height) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)
	}
	
	private let
	ballbearingPlayer: BallbearingPlayer,
	maitreD: MaitreD,
	sommelier: Sommelier!,
	viewController: GameRestaurantTable?

	private var
	countBallbearing: Int,
	orientations: UIInterfaceOrientationMask,
	currentCircle: CAShapeLayer,
	
	ball: UIImageView!,
	ballX: CGFloat!,
	ballY: CGFloat!,
	circleIndex: Int!,
	cirk: UIImageView!,
	countdownLabel: UILabel!,
	gameTime: Float!,
	motionManager: CMMotionManager!,
	screenBounds: CGRect!,
	timeInsideCircle: Float!,
	timeLabel: UILabel!,

	alertDetails: AlertDetails?,
	animationDetails: [AnimDetails]?,
	arrow: UIImageView?,
	nextCircle: CAShapeLayer?,
	timer: Timer?,
	waiter: WaiterForCustomer?

	var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		get { return orientations }
		set { orientations = newValue }
	}
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.maitreD = maitreD
		self.viewController = restaurantTable as? GameRestaurantTable
		self.waiter = waiter
		self.sommelier = sommelier
		motionManager = CMMotionManager()
		currentCircle = CAShapeLayer()
		ballbearingPlayer = BallbearingPlayer()
		orientations = []
		countBallbearing = 0
//		lo("BONJOUR  ", self)
	}
	
//	deinit { lo("AU REVOIR", self) }
}
	
extension GameCustomer {
	private func analyseResult() {
		guard
			let carte = waiter?.carte,
			let unlockTime: Float = carte.des(CarteKeys.jsonUnlock),
			let levelIndex: Int = carte.des(CarteKeys.jsonIndex),
			let nextLevelAlreadyUnlocked: Bool = carte.des(CarteKeys.nextLevelUnlocked),
			let countLevels: Int = carte.des(CarteKeys.countLevels),
			let restaurantTable = viewController
			else { return }
		var
		personalBest: Float = carte.des(CarteKeys.personalBest) ?? 0,
		hasPersonalBest = personalBest > 0,
		actions: [UIAlertAction],
		message: String?
		let
		roundedGameTime = roundFloat(gameTime),
		unlocked = !nextLevelAlreadyUnlocked && roundedGameTime <= unlockTime,
		newPersonalBest = !hasPersonalBest || roundedGameTime < personalBest,
		lastLevelComplete = (levelIndex + 1 == countLevels) && unlocked,
		levelWasAlreadyUnlocked = personalBest > 0 && personalBest <= unlockTime,
		almostUnlocked = roundedGameTime < unlockTime + Metrics.closeMarginOfError,
		textColor: CircleColors,
		title: String
		
		restaurantTable.restartButton.isEnabled = false
		restaurantTable.levelsButton.isEnabled = false
		timeLabel.textColor = getColor(by: Colors.crimson)
		timeLabel.text = "0.0"
		restaurantTable.timeValueLabel.text = "\(roundedGameTime)"
		invalidateTimer()
		
		if newPersonalBest {
			personalBest = roundedGameTime
		}
		
		switch true {
		case lastLevelComplete:
			textColor = levelWasAlreadyUnlocked && personalBest >= roundedGameTime ? Colors.black : Colors.teal
			actions = [
				getReplayAction(with: SommelierKeys.improvePersonalBest),
				getChooseLevelAction()]
			if levelWasAlreadyUnlocked {
				title = getUnlockedLevelAlertTitle(hasPersonalBest, almostUnlocked, newPersonalBest, roundedGameTime, personalBest)
				message = levelWasAlreadyUnlocked ? nil : sommelier[SommelierKeys.lastLevelCopy]
			} else {
				title = sommelier[SommelierKeys.lastLevelUnlocked]!
				message = levelWasAlreadyUnlocked ? nil : sommelier[SommelierKeys.lastLevelCopy]
			}
			
		case nextLevelAlreadyUnlocked:
			textColor = newPersonalBest ? Colors.teal : Colors.black
			actions = [
				getReplayAction(with: SommelierKeys.improvePersonalBest),
				getChooseLevelAction(),
				getNextLevelAction()]
			title = getUnlockedLevelAlertTitle(hasPersonalBest, almostUnlocked, newPersonalBest, roundedGameTime, personalBest)
			
		default:
			if unlocked {
				textColor = Colors.teal
				actions = [
					getNextLevelAction(),
					getReplayAction(with: SommelierKeys.improvePersonalBest)]
				title = sommelier[SommelierKeys.levelUnlocked]!
				waiter?.give(CustomerOrder(Tickets.unlock, levelIndex + 1))
			} else {
				textColor = Colors.black
				let titleKey = almostUnlocked ? SommelierKeys.almost : SommelierKeys.playAgain
				actions = [getReplayAction(with: titleKey)]
				title = sommelier[SommelierKeys.levelNotUnlocked]!
			}
			if levelIndex > 0 {
				actions.append(getChooseLevelAction())
			}
		}
		actions.append(getCancelAction())
		alertDetails = AlertDetails(header: title, actions: actions, message: message)
		animate(
			getAnimDetails(
				title,
				success: unlocked || (nextLevelAlreadyUnlocked && newPersonalBest)),
			color: getColor(by: textColor))
		restaurantTable.personalBestValueLabel.text = "\(roundFloat(personalBest))"
		if newPersonalBest {
			waiter?.give(CustomerOrder(
				Tickets.personalBest,
				PBMetrics(value: personalBest, levelIndex: levelIndex)))
		}
		ballbearingPlayer.stopBallbearingSound()
	}
	
	private func animate(_ texts: [AnimDetails], color textColor: UIColor) {
		guard animationDetails == nil, texts.count > 0 else { return }
		animationDetails = texts
		arrow?.removeFromSuperview()
		arrow = nil
		countdownLabel.layer.removeAllAnimations()
		countdownLabel.textColor = textColor
		animateNextText()
	}
	
	private func textAnimationComplete() {
		animationDetails = nil
		if alertDetails == nil {
			startBallRolling()
		} else {
			ballbearingPlayer.set(audioOn: false)
			maitreD.alert(actions: alertDetails!.actions, title: alertDetails!.header, message: alertDetails!.message)
			alertDetails = nil
		}
	}
	
	private func textAnimationSectionComplete() {
		let countTexts = animationDetails?.count ?? 0
		countTexts > 0 ? animateNextText() : textAnimationComplete()
	}
	
	private func animateNextText() {
		let
		strongSelf = self,
		nextAnimDetail = animationDetails!.removeFirst()
		countdownLabel.text = nextAnimDetail.text
		countdownLabel.sizeToFit()
		countdownLabel.frame = CGRect(
			x: (screenBounds.width - countdownLabel.bounds.width) / 2,
			y: (screenBounds.height - countdownLabel.bounds.height) / 2,
			width: countdownLabel.bounds.width,
			height: countdownLabel.bounds.height)
		countdownLabel.alpha = 1
		countdownLabel.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
		UIView.animate(
			withDuration: Metrics.animationDuration,
			animations: {
				strongSelf.countdownLabel.alpha = 0
				strongSelf.countdownLabel.transform = CGAffineTransform(scaleX: 1, y: 1) } ) { success in
					guard success else { return }
					strongSelf.textAnimationSectionComplete()
		}
		countdownLabel.isHidden = false
		ballbearingPlayer.play(sound: nextAnimDetail.effect, loops: false)
	}
	
	private func drawCircles() {
		guard
			let level: Level = waiter?.carte?.entrees(),
			let restaurantTable = viewController
			else { return }
		ball.removeFromSuperview()
		countdownLabel.removeFromSuperview()
		let
		circles = level.json.circles,
		circleData = circles[circleIndex],
		cirkCenterPoint = getCenterPoint(by: circleData, and: screenBounds),
		screenHeightRatio = Int(screenBounds.height) / 320,
		timeLabelHeight = Metrics.timeViewSize * screenHeightRatio,
		timeLabelWidth = timeLabelHeight * 2,
		nextCircleIndex = circleIndex + 1,
		ballSizeInt = Int(ballSize),
		strokeWidth = screenBounds.height / CGFloat(Metrics.circleStrokeDivider),
		radius = getRadius(by: circleData.radius, and: ballSizeInt)
		drawCircle(
			with: currentCircle,
			from: circleData,
			onto: restaurantTable.view.layer,
			within: screenBounds,
			colored: getColor(by: Colors.teal).cgColor,
			withStrokeOf: strokeWidth,
			andRadius: radius)
		timeLabel.textAlignment = .center
		var timeLabelX: Int
		let
		timeLabelY: Int,
		timeLabelHeightFloat = CGFloat(timeLabelHeight),
		potentialLeftX = Int(cirkCenterPoint.x) - (timeLabelWidth / 2),
		potentialRightX = Int(screenBounds.width) - timeLabelWidth
		switch true {
		case potentialLeftX < 0: 				timeLabelX = 0
		case potentialLeftX > potentialRightX:	timeLabelX = potentialRightX
		default: 								timeLabelX = potentialLeftX
		}
		if cirkCenterPoint.y + radius + timeLabelHeightFloat < restaurantTable.timeKeyLabel.frame.origin.y {
			// room for text label beneath cirk
			timeLabelY = Int(cirkCenterPoint.y + radius)
		} else if cirkCenterPoint.y - radius - timeLabelHeightFloat > restaurantTable.targetKeyLabel.frame.origin.y + restaurantTable.targetKeyLabel.frame.height {
			// room for text label above cirk
			timeLabelY = Int(cirkCenterPoint.y - radius) - timeLabelHeight
		} else {
			// room for text label only to either left or right
			timeLabelY = Int(cirkCenterPoint.y) - (timeLabelHeight / 2)
			if cirkCenterPoint.x > (screenBounds.width / 2) {
				// left
				timeLabelX = Int(cirkCenterPoint.x - radius) - timeLabelWidth - Metrics.timeLabelMargin
				timeLabel.textAlignment = .right
			} else {
				// right
				timeLabelX = Int(cirkCenterPoint.x + radius) + Metrics.timeLabelMargin
				timeLabel.textAlignment = .left
			}
		}
		timeLabel.frame = CGRect(x: timeLabelX, y: timeLabelY, width: timeLabelWidth, height: timeLabelHeight)

		restaurantTable.view.addSubview(timeLabel)
		restaurantTable.view.layer.addSublayer(currentCircle)

		if nextCircleIndex < circles.count {
			let nextCircleData = circles[nextCircleIndex]
			if nextCircle == nil { nextCircle = CAShapeLayer() }
			drawCircle(
				with: nextCircle!,
				from: nextCircleData,
				onto: restaurantTable.view.layer,
				within: screenBounds,
				colored: getColor(by: Colors.teal, and: 0.25).cgColor,
				withStrokeOf: strokeWidth,
				andRadius: getRadius(by: nextCircleData.radius, and: ballSizeInt))
			restaurantTable.view.layer.addSublayer(nextCircle!)
		}
		restaurantTable.view.addSubview(ball)
		restaurantTable.view.addSubview(countdownLabel)
	}
	
	private func getAnimDetails(_ title: String, success: Bool) -> [AnimDetails] {
		var details: [AnimDetails] = []
		let
		texts = title.uppercased().components(separatedBy: " "),
		countTexts = texts.count,
		lastSound = success ? Effects.wind : Effects.punch,
		otherSound = success ? Effects.schwoosh : Effects.whoosh
		for i in 0..<countTexts {
			let sound = (i + 1) < countTexts ? otherSound : lastSound
			details.append((texts[i], sound))
		}
		return details
	}

	private func getColor(by circleColors: CircleColors, and alpha: CGFloat? = 0.8) -> UIColor {
		return UIColor(red: circleColors.red, green: circleColors.green, blue: circleColors.blue, alpha: alpha!)
	}
	
	private func getCancelAction() -> UIAlertAction {
		return UIAlertAction(title: sommelier[SommelierKeys.cancel], style: .cancel) { [weak self] _ in
			self?.maitreD.usherOutCurrentCustomer()
		}
	}
	
	private func getChooseLevelAction() -> UIAlertAction {
		return UIAlertAction(title: sommelier[SommelierKeys.changeLevel], style: .default) { [weak self] _ in
			self?.maitreD.present(popoverMenu: Views.levels)
		}
	}
	
	private func getNextLevelAction() -> UIAlertAction {
		return UIAlertAction(title: sommelier[SommelierKeys.playNextLevel], style: .default) { [weak self] _ in
			guard
				let strongSelf = self,
				let levelIndex: Int = strongSelf.waiter?.carte?.des(CarteKeys.jsonIndex)
				else { return }
			strongSelf.waiter?.give(CustomerOrder(Tickets.setLevel, levelIndex + 1))
		}
	}
	
	private func getReplayAction(with title: String) -> UIAlertAction {
		return UIAlertAction(title: sommelier[title], style: .default) { [weak self] _ in
			self?.layTable()
		}
	}
	
	private func getUnlockedLevelAlertTitle(
		_ hasPersonalBest: Bool,
		_ almostUnlocked: Bool,
		_ newPersonalBest: Bool,
		_ roundedGameTime: Float,
		_ personalBest: Float) -> String {
		switch true {
		case newPersonalBest:										return sommelier[SommelierKeys.newPB]!
		case hasPersonalBest && roundedGameTime == personalBest:	return sommelier[SommelierKeys.matchedPB]!
		case almostUnlocked:										return sommelier[SommelierKeys.almost]!
		default:													return sommelier[SommelierKeys.playAgain]!
		}
	}
	
	private func initilizeLevel() {
		guard
			let carte = waiter?.carte,
			let unlockTime: Float = carte.des(CarteKeys.jsonUnlock),
			let personalBest: Float = carte.des(CarteKeys.personalBest),
			let levelIndex: Int = carte.des(CarteKeys.jsonIndex),
			let countCircles: String = carte.des(CarteKeys.countCircles),
			let firstCircleTime: String = carte.des(CarteKeys.circleTime),
			let countLevels: Int = carte.des(CarteKeys.countLevels),
			let restaurantTable = viewController
			else { return }
		currentCircle.removeFromSuperlayer()
		nextCircle?.removeFromSuperlayer()
		
		ballX = 0
		ballY = 0
		timeInsideCircle = 0
		circleIndex = 0
		
		ballbearingPlayer.set(audioOn: true)
		restaurantTable.personalBestValueLabel.text = personalBest < 0 ? "..." : "\(roundFloat(personalBest))"
		restaurantTable.timeValueLabel.text = "0.0"
		restaurantTable.cirksValueLabel.text = countCircles
		restaurantTable.levelValueLabel.text = "\(levelIndex + 1)/\(countLevels)"
		restaurantTable.targetValueLabel.text = "\(unlockTime)"
		timeLabel.textColor = getColor(by: Colors.black)
		timeLabel.text = firstCircleTime
		
		let title: String? = carte.des(CarteKeys.jsonTitle)
		restaurantTable.titleLabel.text = title
		
		let
		ballStartX: Float = carte.des(CarteKeys.ballX) ?? 0.5,
		ballStartY: Float = carte.des(CarteKeys.ballY) ?? 0.5,
		ballSizeGame = CGFloat(ballSize)
		
		ball.frame = CGRect(
			x: (screenBounds.width - 0) * CGFloat(ballStartX) - (ballSizeGame / 2),
			y: (screenBounds.height - 0) * CGFloat(ballStartY) - (ballSizeGame / 2),
			width: ballSizeGame,
			height: ballSizeGame)
		
		drawCircles()
		animate(
			[("3", Effects.beep), ("2", Effects.beep), ("1", Effects.beep), (sommelier[SommelierKeys.go]!, Effects.start)],
			color: getColor(by: Colors.crimson))
		
		restaurantTable.restartButton.isEnabled = true
		restaurantTable.levelsButton.isEnabled = true
	}
	
	private func invalidateTimer() {
		timer?.invalidate()
		timer = nil
	}

	@IBAction private func levelsButtonTarget(_ sender: AnyObject) {
		stopLevel()
		maitreD.present(popoverMenu: Views.levels)
	}
	
	@IBAction private func restartButtonTarget(_ sender: AnyObject) {
		stopLevel()
		initilizeLevel()
	}
	
	private func roundFloat(_ value: Float) -> Float {
		return (round(value * 10) / 10)
	}
	
	private func startBallRolling() {
		guard
			let level: Level = waiter?.carte?.entrees(),
			let restaurantTable = viewController
			else { return }
		let circles = level.json.circles
		var
		circleData = circles[circleIndex],
		countCircles = circles.count,
		cirkCenterPoint = getCenterPoint(by: circleData, and: screenBounds),
		screenCenterPoint = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2),
		wasInsideCirk = false,
		levelOver = false
		let
		momentumDivider = CGFloat(2),
		ballSizeInt = Int(ballSize),
		ballSizeCGFloat = CGFloat(ballSize),
		halfBallSize = ballSizeCGFloat / 2,
		frameTime = Metrics.frameTime,
		strokeWidth = screenBounds.height / CGFloat(Metrics.circleStrokeDivider),
		shadowWidth = screenBounds.height / CGFloat(Metrics.shadowDivider),
		onScreenPythag = sqrt((screenCenterPoint.x * screenCenterPoint.x) + (screenCenterPoint.y * screenCenterPoint.y)),
		ballbearingVolumeDivider = Metrics.ballbearingVolumeDivider
		var insideCirkPythag = getRadius(by: circleData.radius, and: ballSizeInt) - ((ballSizeCGFloat + strokeWidth) / 2) + shadowWidth

		gameTime = 0
		ballbearingPlayer.startBallbearingSound()
		motionManager.startAccelerometerUpdates()
		
		self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(frameTime), repeats: true) { [weak self] _ in
			guard
				let strongSelf = self,
				let accelerometerData = strongSelf.motionManager.accelerometerData
				else { return }
			strongSelf.ballX = strongSelf.ballX + (CGFloat(accelerometerData.acceleration.y * -1) / momentumDivider)
			strongSelf.ballY = strongSelf.ballY + (CGFloat(accelerometerData.acceleration.x * -1) / momentumDivider)
			let
			ballFrame = strongSelf.ball.frame.origin,
			oldBallX = ballFrame.x,
			oldBallY = ballFrame.y,
			ballX = oldBallX + strongSelf.ballX,
			ballY = oldBallY + strongSelf.ballY,
			ballPoint = CGPoint(x: ballX + halfBallSize, y: ballY + halfBallSize),
			xCirkDist = cirkCenterPoint.x - ballPoint.x,
			yCirkDist = cirkCenterPoint.y - ballPoint.y,
			xScreenDist = screenCenterPoint.x - ballPoint.x,
			yScreenDist = screenCenterPoint.y - ballPoint.y,
			cirkPythag = sqrt((xCirkDist * xCirkDist) + (yCirkDist * yCirkDist)),
			screenPythag = sqrt((xScreenDist * xScreenDist) + (yScreenDist * yScreenDist)),
			isInsideCirk = cirkPythag < insideCirkPythag,
			isOffScreen = screenPythag > onScreenPythag,
			hasLeftCircle = !isInsideCirk && isInsideCirk != wasInsideCirk
			
			strongSelf.ball.frame = CGRect(x: ballX, y: ballY, width: ballSizeCGFloat, height: ballSizeCGFloat)

			let
			xDiff = oldBallX > ballX ? oldBallX - ballX : ballX - oldBallX,
			yDiff = oldBallY > ballY ? oldBallY - ballY : ballY - oldBallY
			strongSelf.ballbearingPlayer.set(ballbearingVolume: Float((xDiff + yDiff) / ballbearingVolumeDivider))
			
			if hasLeftCircle {
				strongSelf.ballbearingPlayer.stopSoundEffect()
				strongSelf.timeInsideCircle = 0
				strongSelf.timeLabel.textColor = strongSelf.getColor(by: Colors.black)
				strongSelf.timeLabel.text = "\(circleData.time)"
			}

			strongSelf.gameTime = strongSelf.gameTime + frameTime
			let roundedGameTime = strongSelf.roundFloat(strongSelf.gameTime)
			restaurantTable.timeValueLabel.text = "\(roundedGameTime)"

			if isInsideCirk {
				if !wasInsideCirk {
					strongSelf.ballbearingPlayer.play(sound: Effects.ticking, loops: true)
					strongSelf.timeLabel.textColor = strongSelf.getColor(by: Colors.crimson)
				}
				strongSelf.timeInsideCircle = strongSelf.timeInsideCircle + frameTime
				
				let
				roundedTimeInsideCircle = strongSelf.roundFloat(strongSelf.timeInsideCircle),
				viewTime = strongSelf.roundFloat(circleData.time - roundedTimeInsideCircle)
				
				if viewTime <= 0 {
					let incrementedCircleIndex = strongSelf.circleIndex + 1
					if incrementedCircleIndex < countCircles {
						strongSelf.circleIndex = incrementedCircleIndex
						strongSelf.timeInsideCircle = 0
						circleData = circles[strongSelf.circleIndex]
						insideCirkPythag = strongSelf.getRadius(
							by: circleData.radius,
							and: ballSizeInt) - ((ballSizeCGFloat + strokeWidth) / 2) + shadowWidth
						cirkCenterPoint = strongSelf.getCenterPoint(by: circleData, and: strongSelf.screenBounds)
						strongSelf.timeLabel.text = "\(circles[strongSelf.circleIndex].time)"
						restaurantTable.cirksValueLabel.text = "\(countCircles - strongSelf.circleIndex)"
						strongSelf.drawCircles()
					} else {
						levelOver = true
						strongSelf.analyseResult()
					}
				} else {
					strongSelf.timeLabel.text = "\(viewTime)"
				}
			}
			
			if isOffScreen && !levelOver {
				if strongSelf.arrow == nil {
					strongSelf.arrow = UIImageView(image: UIImage(named: ImageNames.arrow))
					let
					arrowWidth = strongSelf.screenBounds.height / 4,
					arrowHeight = arrowWidth / 3.764705882352941
					strongSelf.arrow!.frame = CGRect(
						x: screenCenterPoint.x - (arrowWidth / 2),
						y: screenCenterPoint.y - (arrowHeight / 2),
						width: arrowWidth,
						height: arrowHeight)
					restaurantTable.view.addSubview(strongSelf.arrow!)
				}
				strongSelf.arrow!.transform = CGAffineTransform(rotationAngle: (atan2(
					ballX - screenCenterPoint.x + halfBallSize,
					ballY - screenCenterPoint.y + halfBallSize) * -1) + (CGFloat.pi / 2))
			} else if strongSelf.arrow != nil {
				strongSelf.arrow!.removeFromSuperview()
				strongSelf.arrow = nil
			}
			
			wasInsideCirk = isInsideCirk
		}
	}
	
	private func stopLevel() {
		animationDetails = nil
		countdownLabel.layer.removeAllAnimations()
		ballbearingPlayer.stopSoundEffect()
		ballbearingPlayer.stopBallbearingSound()
		invalidateTimer()
	}
}

extension GameCustomer: CircleRenderable {}

extension GameCustomer: CustomerForCustomer {
	func layTable() {
		initilizeLevel()
	}
	
	func showToTable() {
		guard
			let restaurantTable = viewController,
			screenBounds == nil
			else { return }
		let
		tempScreenBounds = UIScreen.main.bounds,
		widthIsLargest = tempScreenBounds.width > tempScreenBounds.height
		screenBounds = widthIsLargest ?
			CGRect(x: 0, y: 0, width: tempScreenBounds.width, height: tempScreenBounds.height) :
			CGRect(x: 0, y: 0, width: tempScreenBounds.height, height: tempScreenBounds.width)
		let
		black = getColor(by: Colors.black),
		teal = getColor(by: Colors.teal),
		timeTextSize = screenBounds.height < 415 ? 28 : 52
		
		supportedInterfaceOrientations = .landscapeRight
		timeLabel = UILabel()
		timeLabel.font = UIFont(name: "EraserDust", size: CGFloat(timeTextSize))
		timeLabel.textAlignment = .center
		timeLabel.textColor = black
		restaurantTable.levelKeyLabel.textColor = black
		restaurantTable.targetKeyLabel.textColor = black
		restaurantTable.cirksKeyLabel.textColor = black
		restaurantTable.timeKeyLabel.textColor = black
		restaurantTable.personalBestKeyLabel.textColor = black
		restaurantTable.levelValueLabel.textColor = black
		restaurantTable.cirksValueLabel.textColor = black
		restaurantTable.targetValueLabel.textColor = black
		restaurantTable.timeValueLabel.textColor = black
		restaurantTable.personalBestValueLabel.textColor = teal
		restaurantTable.titleLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.9)
		restaurantTable.titleLabel.textColor = getColor(by: Colors.brown, and: 0.4)
		
		ball = UIImageView(image: UIImage(named: ImageNames.ball))
		
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 168)
		countdownLabel = label
		restaurantTable.backgroundImage.contentMode = .scaleAspectFill
		restaurantTable.backgroundImage.image = UIImage(named: ImageNames.surface)
		
		restaurantTable.restartButton.addTarget(self, action: #selector(restartButtonTarget(_:)), for: .touchUpInside)
		restaurantTable.levelsButton.addTarget(self, action: #selector(levelsButtonTarget(_:)), for: .touchUpInside)
	}
}

extension GameCustomer: CustomerForMaitreD {
	func menuReturnedToWaiter(_ order: CustomerOrder? = nil) {
		switch order?.ticket {
		case nil:					maitreD.usherOutCurrentCustomer()
		case Tickets.setLevel:		waiter?.give(order!)
		default: ()
		}
	}
}

extension GameCustomer: CustomerForSommelier {
	func regionChosen() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.levelKeyLabel.text = "\(sommelier[SommelierKeys.level]!):"
		restaurantTable.targetKeyLabel.text = "\(sommelier[SommelierKeys.unlockTime]!):"
		restaurantTable.cirksKeyLabel.text = "\(sommelier[SommelierKeys.cirks]!):"
		restaurantTable.timeKeyLabel.text = "\(sommelier[SommelierKeys.total]!):"
		restaurantTable.personalBestKeyLabel.text = "\(sommelier[SommelierKeys.personalBest]!):"
	}
}

extension GameCustomer: CustomerForWaiter {
	func presentCheck() {
		invalidateTimer()
		waiter = nil
	}
	
	func present(dish dishId: String) {
		if dishId == Tickets.setLevel {
			initilizeLevel()
		}
	}
}


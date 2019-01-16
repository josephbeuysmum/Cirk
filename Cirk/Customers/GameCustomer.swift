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

fileprivate typealias AlertDetails = (header: String, actions: [UIAlertAction])
fileprivate typealias AnimDetails = (text: String, effect: Effects)

class GameCustomer: Customer {
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var levelKeyLabel: UILabel!
	@IBOutlet weak var levelValueLabel: UILabel!
	@IBOutlet weak var targetKeyLabel: UILabel!
	@IBOutlet weak var targetValueLabel: UILabel!
	@IBOutlet weak var cirksKeyLabel: UILabel!
	@IBOutlet weak var cirksValueLabel: UILabel!
	@IBOutlet weak var timeKeyLabel: UILabel!
	@IBOutlet weak var timeValueLabel: UILabel!
	@IBOutlet weak var personalBestKeyLabel: UILabel!
	@IBOutlet weak var personalBestValueLabel: UILabel!
	@IBOutlet weak var levelsButton: UIButton!
	@IBOutlet weak var restartButton: UIButton!

	private var ballSize: Double {
		return round(Double((Int(screenBounds.height) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)
	}
	
	private let
	textAnimationComplete: String,
	ballbearingPlayer: BallbearingPlayer
	
	private var
	currentCircle: CAShapeLayer,
	orientations: UIInterfaceOrientationMask,
	countBallbearing: Int,
	ballX: CGFloat!,
	ballY: CGFloat!,
	circleIndex: Int!,
	screenBounds: CGRect!,
	timeInsideCircle: Float!,
	gameTime: Float!,
	maitreD: MaitreD!,
	waiter: WaiterForCustomer!,
	sommelier: Sommelier!,
	motionManager: CMMotionManager!,
	ball: UIImageView!,
	cirk: UIImageView!,
	countdownLabel: UILabel!,
	timeLabel: UILabel!,
	animationDetails: [AnimDetails]?,
	nextCircle: CAShapeLayer?,
	alertDetails: AlertDetails?,
	timer: Timer?,
	arrow: UIImageView?

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		get { return orientations }
		set { orientations = newValue }
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
//		lo("bonjour game customer")
		motionManager = CMMotionManager()
		currentCircle = CAShapeLayer()
		ballbearingPlayer = BallbearingPlayer()
		textAnimationComplete = "textAnimationComplete"
		orientations = []
		countBallbearing = 0
		super.init(coder: aDecoder)
	}
	
//	deinit { lo("au revoir game customer") }
	
	override func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) {
		self.waiter = waiter
		self.maitreD = maitreD
		self.sommelier = sommelier
	}
	
	override func finishMeal() {
		timer?.invalidate()
		waiter = nil
		timer = nil
	}
	
	override func firstDishServed() {
		initilizeLevel()
	}
	
	override func placeOrder() {
		guard screenBounds == nil else { return }
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
		levelKeyLabel.textColor = black
		targetKeyLabel.textColor = black
		cirksKeyLabel.textColor = black
		timeKeyLabel.textColor = black
		personalBestKeyLabel.textColor = black
		levelValueLabel.textColor = black
		cirksValueLabel.textColor = black
		targetValueLabel.textColor = black
		timeValueLabel.textColor = black
		personalBestValueLabel.textColor = teal
		
		ball = UIImageView(image: UIImage(named: ImageNames.ball))
		
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 168)
		countdownLabel = label
		backgroundImage.contentMode = .scaleAspectFill
		backgroundImage.image = UIImage(named: ImageNames.surface)
		
		restartButton.addTarget(self, action: #selector(restartButtonTarget), for: .touchUpInside)
		levelsButton.addTarget(self, action: #selector(levelsButtonTarget), for: .touchUpInside)
	}
	
	override func present(dish dishId: String) {
//		lo(dishId)
		if dishId == Tickets.setLevel {
			initilizeLevel()
		}
	}
	
	override func regionChosen() {
		levelKeyLabel.text = "\(sommelier[SommelierKeys.level]!):"
		targetKeyLabel.text = "\(sommelier[SommelierKeys.unlockTime]!):"
		cirksKeyLabel.text = "\(sommelier[SommelierKeys.cirks]!):"
		timeKeyLabel.text = "\(sommelier[SommelierKeys.total]!):"
		personalBestKeyLabel.text = "\(sommelier[SommelierKeys.personalBest]!):"
	}
	
	
	
	
	
	private func animate(_ texts: [AnimDetails], color textColor: UIColor) {
		guard animationDetails == nil else { return }
		animationDetails = texts
		countdownLabel.layer.removeAllAnimations()
		countdownLabel.textColor = textColor
		animateNextText()
	}
	
	private func animateNextText() {
		let
		strongSelf = self,
		countTexts = animationDetails?.count ?? 0,
		hasAlert = alertDetails != nil
		if  countTexts > 0,
				let nextAnimDetail = animationDetails?.removeFirst() {
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
						strongSelf.animateNextText()
			}
			countdownLabel.isHidden = false
			ballbearingPlayer.play(sound: nextAnimDetail.effect, loops: false)
		} else {
			animationDetails = nil
			if hasAlert {
				ballbearingPlayer.set(audioOn: false)
				maitreD.alert(actions: alertDetails!.actions, title: alertDetails!.header)
				alertDetails = nil
			} else {
				startBallRolling()
			}
		}
	}
	
	/*
	tood jobboes:
	melanie for bugtesting
	improve copy texts
	last level options
	french translations
	test UI with melanie
	level design
	allow left hand portrait too? 
	*/
	private func drawCircles() {
		guard let level: Level = waiter.carte?.entrees() else { return }
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
			onto: view.layer,
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
		case potentialLeftX < 0: 								timeLabelX = 0
		case potentialLeftX > potentialRightX:	timeLabelX = potentialRightX
		default: 																timeLabelX = potentialLeftX
		}
		if cirkCenterPoint.y + radius + timeLabelHeightFloat < timeKeyLabel.frame.origin.y {
			// room for text label beneath cirk
			timeLabelY = Int(cirkCenterPoint.y + radius)
		} else if cirkCenterPoint.y - radius - timeLabelHeightFloat > targetKeyLabel.frame.origin.y + targetKeyLabel.frame.height {
			// room for text label above cirk
			timeLabelY = Int(cirkCenterPoint.y - radius) - timeLabelHeight
		} else {
			// room for text label only to either left or right
			timeLabelY = Int(cirkCenterPoint.y) - (timeLabelHeight / 2)
			if cirkCenterPoint.x > (screenBounds.width / 2) {
				// left
				timeLabelX = Int(cirkCenterPoint.x - radius) - timeLabelWidth
				timeLabel.textAlignment = .right
			} else {
				// right
				timeLabelX = Int(cirkCenterPoint.x + radius)
				timeLabel.textAlignment = .left
			}
		}
		timeLabel.frame = CGRect(x: timeLabelX, y: timeLabelY, width: timeLabelWidth, height: timeLabelHeight)

		view.addSubview(timeLabel)
		view.layer.addSublayer(currentCircle)

		if nextCircleIndex < circles.count {
			let nextCircleData = circles[nextCircleIndex]
			if nextCircle == nil { nextCircle = CAShapeLayer() }
			drawCircle(
				with: nextCircle!,
				from: nextCircleData,
				onto: view.layer,
				within: screenBounds,
				colored: getColor(by: Colors.teal, and: 0.4).cgColor,
				withStrokeOf: 4,
				andRadius: getRadius(by: nextCircleData.radius, and: ballSizeInt))
			view.layer.addSublayer(nextCircle!)
		}
		view.addSubview(ball)
		view.addSubview(countdownLabel)
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
			self?.maitreD.present(popoverMenu: Views.levelsMenu)
		}
	}
	
	private func getNextLevelAction() -> UIAlertAction {
		return UIAlertAction(title: sommelier[SommelierKeys.playNextLevel], style: .default) { [weak self] _ in
			guard
				let strongSelf = self,
				let levelIndex: Int = strongSelf.waiter.carte?.des(CarteKeys.jsonIndex)
				else { return }
			strongSelf.waiter.give(Order(Tickets.setLevel, levelIndex + 1))
		}
	}
	
	private func getReplayAction(with title: String) -> UIAlertAction {
		return UIAlertAction(title: sommelier[title], style: .default) { [weak self] _ in
			self?.firstDishServed()
		}
	}
	
	private func initilizeLevel() {
		guard
			let carte = waiter.carte,
			let unlockTime: Float = carte.des(CarteKeys.jsonUnlock),
			let personalBest: Float = carte.des(CarteKeys.personalBest),
			let levelIndex: Int = carte.des(CarteKeys.jsonIndex),
			let countCircles: String = carte.des(CarteKeys.countCircles),
			let firstCircleTime: String = carte.des(CarteKeys.circleTime)
			else { return }
//		lo(levelIndex)
		currentCircle.removeFromSuperlayer()
		nextCircle?.removeFromSuperlayer()
		arrow?.removeFromSuperview()
		arrow = nil
		
		ballX = 0
		ballY = 0
		timeInsideCircle = 0
		circleIndex = 0
		
		let
		levelNumber = "\(levelIndex + 1)",
		countLevels: Int? = carte.des(CarteKeys.countLevels)
		
		ballbearingPlayer.set(audioOn: true)
		personalBestValueLabel.text = personalBest < 0 ? "..." : "\(roundFloat(personalBest))"
		timeValueLabel.text = "0.0"
		cirksValueLabel.text = countCircles
		levelValueLabel.text = countLevels != nil ? "\(levelNumber)/\(countLevels!)" : levelNumber
		targetValueLabel.text = "\(unlockTime)"
		timeLabel.textColor = getColor(by: Colors.black)
		timeLabel.text = firstCircleTime
		
		let ballSizeGame = CGFloat(ballSize)
		ball.frame = CGRect(
			x: (screenBounds.width - ballSizeGame) / 2,
			y: (screenBounds.height - ballSizeGame) / 2,
			width: ballSizeGame,
			height: ballSizeGame)
		
		drawCircles()
		animate(
			[("3", Effects.beep), ("2", Effects.beep), ("1", Effects.beep), (sommelier[SommelierKeys.go]!, Effects.start)],
			color: getColor(by: Colors.crimson))
	}

	@objc private func levelsButtonTarget() {
		stopLevel()
		maitreD.present(popoverMenu: Views.levelsMenu)
	}
	
	@objc private func restartButtonTarget() {
		stopLevel()
		initilizeLevel()
	}
	
	private func roundFloat(_ value: Float) -> Float {
		return (round(value * 10) / 10)
	}

	private func startBallRolling() {
		guard
			let carte = waiter.carte,
			let level: Level = carte.entrees(),
			let unlockTime: Float = carte.des(CarteKeys.jsonUnlock),
			let levelIndex: Int = carte.des(CarteKeys.jsonIndex),
			let nextAlreadyLevelUnlocked: Bool = carte.des(CarteKeys.nextLevelUnlocked)
			else { return }
		let circles = level.json.circles
		var
		circleData = circles[circleIndex],
		countCircles = circles.count,
		personalBest: Float = carte.des(CarteKeys.personalBest) ?? 0,
		cirkCenterPoint = getCenterPoint(by: circleData, and: screenBounds),
		screenCenterPoint = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2),
		hasPersonalBest = personalBest > 0,
		wasInsideCirk = false
		let
		isFirstLevel = levelIndex < 1,
		momentumDivider = CGFloat(2),
		ballSizeInt = Int(ballSize),
		ballSizeCGFloat = CGFloat(ballSize),
		halfBallSize = ballSizeCGFloat / 2,
		frameTime = Metrics.frameTime,
		strokeWidth = screenBounds.height / CGFloat(Metrics.circleStrokeDivider),
		shadowWidth = screenBounds.height / CGFloat(Metrics.shadowDivider),
		insideCirkPythag = getRadius(by: circleData.radius, and: ballSizeInt) - ((ballSizeCGFloat + strokeWidth) / 2) + shadowWidth,
		onScreenPythag = sqrt((screenCenterPoint.x * screenCenterPoint.x) + (screenCenterPoint.y * screenCenterPoint.y)),
		ballbearingVolumeDivider = Metrics.ballbearingVolumeDivider,
		black = getColor(by: Colors.black),
		crimson = getColor(by: Colors.crimson)
		
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
				strongSelf.timeLabel.textColor = black
				strongSelf.timeLabel.text = "\(circleData.time)"
			}

			strongSelf.gameTime = strongSelf.gameTime + frameTime
			let roundedGameTime = strongSelf.roundFloat(strongSelf.gameTime)
			strongSelf.timeValueLabel.text = "\(roundedGameTime)"

			if isInsideCirk {
				if !wasInsideCirk {
					strongSelf.ballbearingPlayer.play(sound: Effects.ticking, loops: true)
					strongSelf.timeLabel.textColor = crimson
				}
				strongSelf.timeInsideCircle = strongSelf.timeInsideCircle + frameTime
				let
				roundedTimeInsideCircle = strongSelf.roundFloat(strongSelf.timeInsideCircle),
				viewTime = strongSelf.roundFloat(circleData.time - roundedTimeInsideCircle)
				if viewTime <= 0 {
					let incrementedCircleIndex = strongSelf.circleIndex + 1
					if incrementedCircleIndex == countCircles {
						strongSelf.timeLabel.textColor = crimson
						strongSelf.timeLabel.text = "0.0"
						strongSelf.timeValueLabel.text = "\(roundedGameTime)"
						strongSelf.timer?.invalidate()
						strongSelf.timer = nil
						let
						newPersonalBest = !hasPersonalBest || roundedGameTime < personalBest,
						almostUnlocked = roundedGameTime < unlockTime + Metrics.closeMarginOfError,
						unlocked = !nextAlreadyLevelUnlocked && roundedGameTime <= unlockTime,
						textColor: CircleColors,
						title: String
						var actions: [UIAlertAction]
						
						if newPersonalBest {
							personalBest = roundedGameTime
						}
						
						if nextAlreadyLevelUnlocked {
							textColor = newPersonalBest ? Colors.teal : Colors.black
							actions = [
								strongSelf.getReplayAction(with: SommelierKeys.improvePersonalBest),
								strongSelf.getChooseLevelAction(),
								strongSelf.getNextLevelAction()]
							switch true {
							case newPersonalBest:																				title = strongSelf.sommelier[SommelierKeys.newPB]!
							case hasPersonalBest && roundedGameTime == personalBest:		title = strongSelf.sommelier[SommelierKeys.matchedPB]!
							case almostUnlocked:																				title = strongSelf.sommelier[SommelierKeys.almost]!
							default:																										title = strongSelf.sommelier[SommelierKeys.playAgain]!
							}
						} else {
							if unlocked {
								textColor = Colors.teal
								actions = [
									strongSelf.getNextLevelAction(),
									strongSelf.getReplayAction(with: SommelierKeys.improvePersonalBest)]
								title = strongSelf.sommelier[SommelierKeys.levelUnlocked]!
								strongSelf.waiter.give(Order(Tickets.unlock, levelIndex + 1))
							} else {
								textColor = Colors.black
								let titleKey = almostUnlocked ? SommelierKeys.almost : SommelierKeys.playAgain
								actions = [strongSelf.getReplayAction(with: titleKey)]
								title = strongSelf.sommelier[SommelierKeys.levelNotUnlocked]!
							}
							if !isFirstLevel { actions.append(strongSelf.getChooseLevelAction()) }
						}
						
						actions.append(strongSelf.getCancelAction())
						strongSelf.alertDetails = AlertDetails(header: title, actions: actions)
						strongSelf.animate(
							strongSelf.getAnimDetails(
								title,
								success: unlocked || (nextAlreadyLevelUnlocked && newPersonalBest)),
							color: strongSelf.getColor(by: textColor))
						strongSelf.personalBestValueLabel.text = "\(strongSelf.roundFloat(personalBest))"
						if newPersonalBest {
							strongSelf.waiter.give(Order(
								Tickets.personalBest,
								PBMetrics(value: personalBest, levelIndex: levelIndex)))
						}
						strongSelf.ballbearingPlayer.stopBallbearingSound()
					} else {
						strongSelf.circleIndex = incrementedCircleIndex
						strongSelf.timeInsideCircle = 0
						circleData = circles[strongSelf.circleIndex]
						cirkCenterPoint = strongSelf.getCenterPoint(by: circleData, and: strongSelf.screenBounds)
						strongSelf.timeLabel.text = "\(circles[strongSelf.circleIndex].time)"
						strongSelf.cirksValueLabel.text = "\(countCircles - strongSelf.circleIndex)"
						strongSelf.drawCircles()
					}
				} else {
					strongSelf.timeLabel.text = "\(viewTime)"
				}
			}
			
			if isOffScreen {
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
					strongSelf.view.addSubview(strongSelf.arrow!)
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
		timer?.invalidate()
		timer = nil
	}
}

extension GameCustomer: CircleRendererProtocol {}

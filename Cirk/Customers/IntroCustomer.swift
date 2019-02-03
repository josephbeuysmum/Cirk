//
//  IntroCustomer.swift
//  Cirk
//
//  Created by Richard Willis on 05/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo once we replace refs to Dertisch, we can remove all these supporting refs to UIKit etc
//import Dertisch
import UIKit

class IntroCustomer: Customer {
	private let
	maitreD: MaitreD,
	sommelier: Sommelier?

	private var
	viewController: IntroRestaurantTable?,
	waiter: WaiterForCustomer?,
	ball: UIImageView?,
	shapeLayer: CAShapeLayer?
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.maitreD = maitreD
		self.viewController = restaurantTable as? IntroRestaurantTable
		self.waiter = waiter
		self.sommelier = sommelier!
//		lo("BONJOUR  ", self)
	}
	
//	deinit { lo("AU REVOIR", self) }
}

extension IntroCustomer {
	@objc private func languageButtonTarget() {
		maitreD.present(popoverMenu: Views.language)
	}
	
	@objc private func levelsButtonTarget() {
		maitreD.present(popoverMenu: Views.levels)
	}
	
	@objc private func playButtonTarget() {
		maitreD.seat(Views.game)
	}
}

extension IntroCustomer: CustomerForWaiter {
	func presentCheck() {
		if let restaurantTable = viewController {
			restaurantTable.languageButton.removeTarget(self, action: #selector(languageButtonTarget), for: .touchUpInside)
			restaurantTable.levelsButton.removeTarget(self, action: #selector(levelsButtonTarget), for: .touchUpInside)
			restaurantTable.playButton.removeTarget(self, action: #selector(playButtonTarget), for: .touchUpInside)
		}
		shapeLayer?.path = nil
		waiter = nil
		viewController = nil
	}
}

extension IntroCustomer: CustomerForCustomer {
	func showToTable() {
		guard let restaurantTable = viewController else { return }
		let
		screenBounds = restaurantTable.view.bounds,
		screenHeight = screenBounds.height < screenBounds.width ? screenBounds.height : screenBounds.width,
		circX = CGFloat(screenHeight / 4),
		circY = CGFloat(screenHeight / 3),
		ballSize = CGFloat(round(Double((Int(screenHeight) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)),
		halfBallSize = ballSize / 2
		
		restaurantTable.backgroundImage.contentMode = .scaleAspectFill
		restaurantTable.backgroundImage.image = UIImage(named: ImageNames.surface)
		restaurantTable.titleLabel.text = "Cirk"
		restaurantTable.descriptionLabel.makeWrappable()
		
		ball = UIImageView(frame: CGRect(x: circX - halfBallSize,y: circY - halfBallSize, width: ballSize, height: ballSize))
		ball!.image = UIImage(named: ImageNames.ball)
		restaurantTable.view.addSubview(ball!)
	}
}

extension IntroCustomer: CustomerForMaitreD {
	var restaurantTable: RestaurantTable? { return viewController }
	
	func menuReturnedToWaiter(_ chosenDishId: String?) {
		guard chosenDishId != nil else { return }
		maitreD.seat(Views.game)
	}
}

extension IntroCustomer: CustomerForRestaurantTable {
	func isSeated() {
		guard let restaurantTable = viewController else { return }
		
		restaurantTable.languageButton.addTarget(self, action: #selector(languageButtonTarget), for: .touchUpInside)
		restaurantTable.levelsButton.addTarget(self, action: #selector(levelsButtonTarget), for: .touchUpInside)
		restaurantTable.playButton.addTarget(self, action: #selector(playButtonTarget), for: .touchUpInside)
		
		let
		screenBounds = restaurantTable.view.bounds,
		screenHeight = screenBounds.height < screenBounds.width ? screenBounds.height : screenBounds.width,
		circX = CGFloat(screenHeight / 4),
		circY = CGFloat(screenHeight / 3),
		strokeWidth = screenHeight / CGFloat(Metrics.circleStrokeDivider),
		ballSize = CGFloat(round(Double((Int(screenHeight) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)),
		halfBallSize = ballSize / 2,
		teal = Colors.teal
		
		var count = 5
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.5), repeats: true) { [weak self] timer in
			guard let strongSelf = self else { return }
			let
			sLayer = strongSelf.shapeLayer ?? CAShapeLayer(),
			radius = halfBallSize + CGFloat((4 - (count % 5)) * 3)
			sLayer.path = UIBezierPath(
				arcCenter: CGPoint(x: circX, y: circY),
				radius: radius,
				startAngle: CGFloat(0),
				endAngle:CGFloat(Double.pi * 2),
				clockwise: true).cgPath
			sLayer.strokeColor =  UIColor(
				red: teal.red,
				green: teal.green,
				blue: teal.blue,
				alpha: Colors.alpha).cgColor
			sLayer.fillColor = UIColor.clear.cgColor
			sLayer.lineWidth = strokeWidth
			restaurantTable.view.layer.addSublayer(sLayer)
			strongSelf.shapeLayer = sLayer
			count += 1
		}
	}
}

extension IntroCustomer: CustomerForSommelier {
	func regionChosen() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.descriptionLabel.text = sommelier?[SommelierKeys.gameDescription]
		restaurantTable.playButton.setTitle(sommelier?[SommelierKeys.play], for: .normal)
	}
}

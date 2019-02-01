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
	var restaurantTable: RestaurantTable? { return viewController }
	
	private let
	maitreD: MaitreD,
	sommelier: Sommelier!,
	viewController: IntroViewController?
	
	private var
	waiter: WaiterForCustomer?,
	ball: UIImageView?,
	shapeLayer: CAShapeLayer?
	
	required init(maitreD: MaitreD, restaurantTable: RestaurantTable, waiter: WaiterForCustomer, sommelier: Sommelier?) {
		self.maitreD = maitreD
		self.viewController = restaurantTable as? IntroViewController
		self.waiter = waiter
		self.sommelier = sommelier!
	}
	
	func presentCheck() {
		waiter = nil
	}
	
	func showToTable() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.languageButton.addTarget(self, action: #selector(languageButtonTarget), for: .touchUpInside)
		restaurantTable.levelsButton.addTarget(self, action: #selector(levelsButtonTarget), for: .touchUpInside)
		let
		screenBounds = restaurantTable.view.bounds,
		screenHeight = screenBounds.height < screenBounds.width ? screenBounds.height : screenBounds.width,
		circX = CGFloat(screenHeight / 4),
		circY = CGFloat(screenHeight / 3),
		strokeWidth = screenHeight / CGFloat(Metrics.circleStrokeDivider),
		ballSize = CGFloat(round(Double((Int(screenHeight) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)),
		halfBallSize = ballSize / 2,
		teal = Colors.teal
		restaurantTable.backgroundImage.contentMode = .scaleAspectFill
		restaurantTable.backgroundImage.image = UIImage(named: ImageNames.surface)
		restaurantTable.titleLabel.text = "Cirk"
		restaurantTable.descriptionLabel.makeWrappable()
		
		ball = UIImageView(frame: CGRect(x: circX - halfBallSize,y: circY - halfBallSize, width: ballSize, height: ballSize))
		ball!.image = UIImage(named: ImageNames.ball)
		restaurantTable.view.addSubview(ball!)
		
		restaurantTable.playButton.addTarget(self, action: #selector(playButtonTarget), for: .touchUpInside)
		
		var count = 5
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.5), repeats: true) { [weak self] timer in
			guard let strongSelf = self else { return }
			let shapeLayer: CAShapeLayer
			if let formerShapeLayer = strongSelf.shapeLayer {
				for sublayer in formerShapeLayer.sublayers ?? [] {
					sublayer.removeFromSuperlayer()
				}
				shapeLayer = formerShapeLayer
			} else {
				shapeLayer = CAShapeLayer()
			}
			let
//			screenBounds = UIScreen.main.bounds,
			radius = halfBallSize + CGFloat((4 - (count % 5)) * 3)
			shapeLayer.path = UIBezierPath(
				arcCenter: CGPoint(x: circX, y: circY),
				radius: radius,
				startAngle: CGFloat(0),
				endAngle:CGFloat(Double.pi * 2),
				clockwise: true).cgPath
			shapeLayer.strokeColor =  UIColor(
				red: teal.red,
				green: teal.green,
				blue: teal.blue,
				alpha: Colors.alpha).cgColor
			shapeLayer.fillColor = UIColor.clear.cgColor
			shapeLayer.lineWidth = strokeWidth
			restaurantTable.view.layer.addSublayer(shapeLayer)
			strongSelf.shapeLayer = shapeLayer
			count += 1
		}
	}
	
	func regionChosen() {
		guard let restaurantTable = viewController else { return }
		restaurantTable.descriptionLabel.text = sommelier?[SommelierKeys.gameDescription]
		restaurantTable.playButton.setTitle(sommelier?[SommelierKeys.play], for: .normal)
	}
	
	func returnMenuToWaiter(_ chosenDishId: String?) {
		guard chosenDishId != nil else { return }
		maitreD.seat(Views.game)
	}
	
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

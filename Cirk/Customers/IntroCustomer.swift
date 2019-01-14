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
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var levelsButton: UIButton!
	@IBOutlet weak var languageButton: UIButton!
	
	private var
	ball: UIImageView?,
	maitreD: MaitreD?,
	sommelier: Sommelier?,
	waiter: WaiterForCustomer?,
	shape_layer: CAShapeLayer?
	
//	private var timer: Timer?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
//		lo("bonjour intro customer")
	}
	
//	deinit { lo("au revoir intro customer") }
	
	override func assign(_ waiter: WaiterForCustomer, maitreD: MaitreD, and sommelier: Sommelier) {
		self.waiter = waiter
		self.maitreD = maitreD
		self.sommelier = sommelier
	}
	
	override func finishMeal() {
		waiter = nil
	}
	
	override func present(dish dishId: String) {
		lo(dishId)
	}
	
	override func placeOrder() {
//		lo()
		languageButton.addTarget(self, action: #selector(languageButtonTarget), for: .touchUpInside)
		levelsButton.addTarget(self, action: #selector(levelsButtonTarget), for: .touchUpInside)
		let
		screenBounds = view.bounds,
		screenHeight = screenBounds.height < screenBounds.width ? screenBounds.height : screenBounds.width,
		circX = CGFloat(screenHeight / 4),
		circY = CGFloat(screenHeight / 3),
		strokeWidth = screenHeight / CGFloat(Metrics.circleStrokeDivider),
		ballSize = CGFloat(round(Double((Int(screenHeight) + Metrics.screenMedian) / 2) / Metrics.ballHeightDivider)),
		halfBallSize = ballSize / 2,
		teal = Colors.teal
		backgroundImage.image = UIImage(named: ImageNames.wood)
		titleLabel.text = "Cirk"
		descriptionLabel.makeWrappable()
//		descriptionLabel.text = sommelier?[SommelierKeys.gameDescription]
		
		ball = UIImageView(frame: CGRect(x: circX - halfBallSize,y: circY - halfBallSize, width: ballSize, height: ballSize))
		ball!.image = UIImage(named: ImageNames.ball)
		view.addSubview(ball!)
		
//		playButton.setTitle(sommelier?[SommelierKeys.play], for: .normal)
		playButton.addTarget(self, action: #selector(playButtonTarget), for: .touchUpInside)
//		cancelButton.addTarget(self, action: #selector(cancelButtonTarget), for: .touchUpInside)
		
		var count = 5
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.5), repeats: true) { [weak self] timer in
			guard let strongSelf = self else { return }
			let shapeLayer: CAShapeLayer
			if let formerShapeLayer = strongSelf.shape_layer {
				for sublayer in formerShapeLayer.sublayers ?? [] {
					sublayer.removeFromSuperlayer()
				}
				shapeLayer = formerShapeLayer
			} else {
				shapeLayer = CAShapeLayer()
			}
			let
			screenBounds = UIScreen.main.bounds,
			circleSize = screenBounds.width > screenBounds.height ? screenBounds.width : screenBounds.height,
			radius = (circleSize / 200) * CGFloat(((5 - count) % 5) + 20)
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
			strongSelf.view.layer.addSublayer(shapeLayer)
			strongSelf.shape_layer = shapeLayer
			count += 1
		}
	}
	
	override func regionChosen() {
		descriptionLabel.text = sommelier?[SommelierKeys.gameDescription]
		playButton.setTitle(sommelier?[SommelierKeys.play], for: .normal)
	}
	
	override func returnMenuToWaiter(_ chosenDishId: String?) {
		guard chosenDishId != nil else { return }
		maitreD?.seatNext(Views.gameCustomer)
	}
	
	
	
	
	
	@objc private func languageButtonTarget() {
		maitreD?.present(popoverMenu: Views.languageMenu)
	}
	
	@objc private func levelsButtonTarget() {
		maitreD?.present(popoverMenu: Views.levelsMenu)
	}
	
	@objc private func playButtonTarget() {
		maitreD?.seatNext(Views.gameCustomer)
	}
}

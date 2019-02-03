//
//  LevelsCustomerItem.swift
//  Cirk
//
//  Created by Richard Willis on 27/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

//extension LevelsCustomerItem {
//	var level: Level? { return level_ }
//}

class LevelsCustomerItem: RestaurantTableViewCell, CircleRenderable {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var levelLabel: UILabel!
	@IBOutlet weak var targetLabel: UILabel!
	@IBOutlet weak var personalBestLabel: UILabel!
	@IBOutlet weak var diagramImage: UIImageView!
	
//	fileprivate var level_: Level?
	
	override func serve<T>(with data: T?) {
		if  let level = data as? Level {
			populate(with: level)
		} else if let header = data as? LevelsTableHeader {
			populate(with: header)
		}
	}
	
	private func populate(with header: LevelsTableHeader) {
		titleLabel.text = nil
		levelLabel.text = header.level
		targetLabel.text = header.target
		personalBestLabel.text = header.personalBest
		let img = UIImageView(image: UIImage(named: ImageNames.surface))
		img.contentMode = .scaleAspectFill
		backgroundView = img
	}
	
	private func populate(with level: Level) {
		let
		isUnlocked = level.index == 0 || level.personalBest != nil,
		black = Colors.black,
		gray = Colors.lightGray,
		crimson = Colors.crimson,
		circleColor = isUnlocked ? Colors.teal : Colors.crimson,
		alpha: CGFloat = isUnlocked ? 1 : 0.8,
		textColor = UIColor(red: black.red, green: black.green, blue: black.blue, alpha: alpha),
		imageName = isUnlocked ? ImageNames.unlocked : ImageNames.locked,
		countCircles = level.json.circles.count,
		countCirclesDouble = Double(countCircles)
		levelLabel.textColor = textColor
		targetLabel.textColor = textColor
		personalBestLabel.textColor = isUnlocked ?
			textColor :
			UIColor(red: crimson.red, green: crimson.green, blue: crimson.blue, alpha: alpha)
		titleLabel.text = "\(level.json.title)"
		levelLabel.text = "\(level.index + 1)"
		targetLabel.text = "\(level.json.unlockTime)"
		if isUnlocked {
			personalBestLabel.text = isUnlocked && level.personalBest! > 0 ? "\(level.personalBest!)" : "..."
		} else {
			personalBestLabel.text = "X"
		}
		diagramImage.image = UIImage(named: imageName)
		backgroundColor = isUnlocked ? UIColor.white : UIColor(red: gray.red, green: gray.green, blue: gray.blue, alpha: Colors.alpha)
		for i in 0..<countCircles {
			let
			iDouble = Double(i),
			circleData = level.json.circles[i]
			drawCircle(
				with: CAShapeLayer(),
				from: circleData,
				onto: diagramImage.layer,
				within: diagramImage.frame,
				colored: UIColor(
					red: circleColor.red,
					green: circleColor.green,
					blue: circleColor.blue,
					alpha: CGFloat(1 - (iDouble / countCirclesDouble))).cgColor,
				withStrokeOf: 1,
				andRadius: getRadius(by: circleData.radius, and: Metrics.ballSizeDiagram))
		}
		if !isUnlocked {
			isUserInteractionEnabled = false
		}
		selectionStyle = .none;
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		diagramImage.layer.cornerRadius = 4
		diagramImage.layer.masksToBounds = true
	}
	
	override func prepareForReuse() {
		guard let subLayers = diagramImage.layer.sublayers else { return }
		for subLayer in subLayers {
			subLayer.removeFromSuperlayer()
		}
	}
}

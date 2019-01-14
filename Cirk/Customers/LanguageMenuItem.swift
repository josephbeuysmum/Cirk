//
//  LanguageMenuItem.swift
//  Cirk
//
//  Created by Richard Willis on 21/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

class LanguageMenuItem: RestaurantTableViewCell {
	@IBOutlet weak var languageLabel: UILabel!
	@IBOutlet weak var flagImage: UIImageView!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		flagImage.layer.cornerRadius = 4
		flagImage.layer.masksToBounds = true
	}
	
	override func serve<T>(with data: T?) {
		guard let language = data as? LanguageEntre else { return }
		languageLabel.text = language.name
		if let flag = language.flag {
			flagImage.image = UIImage(named: flag)
		} else {
			let img = UIImageView(image: UIImage(named: ImageNames.wood))
			img.contentMode = .scaleAspectFill
			backgroundView = img
		}
	}
}


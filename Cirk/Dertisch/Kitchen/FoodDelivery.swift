//
//  FoodDelivery.swift
//  Dertisch
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import Foundation

public protocol FoodDeliverable: Ingredients {
//	func call(_ url: String, from resource: SousChefForIngredients, method: Methods?) -> Bool
}

public class FoodDelivery {
	private var resources: [String: KitchenResource]
	
	enum Methods: String { case GET, POST, DELETE }
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		self.resources = [:]
	}
}

extension FoodDelivery: FoodDeliverable {
	func call(_ url: String, from resource: KitchenResource, method: Methods, flagged flag: String? = nil) -> Bool {
		lo()
		guard let validUrl = URL(string: url) else { return false }
		resources[url] = resource
		var request = URLRequest(url: validUrl)
		request.httpMethod = method.rawValue
		_ = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			guard error == nil else {
				lo("ERROR NEEDS HANDLING")
				return
			}
			guard let strongSelf = self else {
				lo("SELF MISSING NEEDS HANDLING")
				return
			}
			let
			resource = strongSelf.resources[url],
			rawIngredients = data != nil ?
				RawIngredients(success: true, url: url, data: data!, flag: flag) :
				RawIngredients(success: false, url: url, data: nil, flag: flag)
			strongSelf.resources.removeValue(forKey: url)
			
			if let sousChef = resource as? SousChefForIngredients {
				sousChef.cook(rawIngredients)
			} else if let complexIngredients = resource as? IngredientsForIngredients {
				complexIngredients.blend(rawIngredients)
			}
		}.resume()
		return true
	}
}

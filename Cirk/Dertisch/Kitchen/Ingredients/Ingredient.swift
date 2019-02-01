//
//  Ingredients.swift
//  Dertisch
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol IngredientsForIngredients {
	func blend(_ rawIngredients: RawIngredients)
}

public protocol Ingredients: IngredientsForIngredients, KitchenResource {}

extension IngredientsForIngredients {
	public func blend(_ rawIngredients: RawIngredients) {}
}

extension Ingredients {
	public var sousChef: SousChefForIngredients? {
		get { return nil }
		set {}
	}
}

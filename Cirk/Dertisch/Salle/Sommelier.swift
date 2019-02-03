//
//  Sommelier.swift
//  Dertisch
//
//  Created by Richard Willis on 08/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum Regions: String {
	case
	england = "en",
	france = "fr"
}

public protocol SommelierProtocol {
//	var region: Regions { get set }
//	init(larder: Larder)
//	func set(_ customer: CustomerForSommelier?)
//	subscript(name: String) -> String? { get }
}

public final class Sommelier {
	public var region: Regions {
		get { return region_ }
		// todo what should happen after the region gets re-set?
		set {
			guard region_ != newValue else { return }
//			lo(customer)
			region_ = newValue
//			customer?.regionChosen()
		}
	}
	
	fileprivate let wines: [String: Wine]?
	
	fileprivate var
	region_: Regions
//	, customer: CustomerForSommelier?
	
	public required init(larder: Larder) {
		region_ = .england
		if let unbottledWines = larder.decode(json: "text", into: Wines.self) {
			var bottledWines: [String: Wine] = [:]
			for var unbottledWine in unbottledWines.copy {
				if let name = unbottledWine.key {
					unbottledWine.key = nil
					bottledWines[name] = unbottledWine
				}
			}
			wines = bottledWines
		} else {
			wines = nil
		}
	}
	
//	public func assign(_ customer: CustomerForSommelier?) {
//		lo("assign", customer)
//		self.customer = customer
//	}
}

extension Sommelier: SommelierProtocol {
	public subscript(name: String) -> String? {
		guard let wine = wines?[name] else { return nil }
		if wine.isGlobal {
			return wine.all
		} else {
			switch region.rawValue {
			case Regions.england.rawValue:	return wine.en
			case Regions.france.rawValue:		return wine.fr
			default:													return nil
			}
		}
	}
}

internal struct Wines: Decodable {
	let copy: [Wine]
}

internal struct Wine: Decodable {
	var isGlobal: Bool { return all != nil }
	var key: String?
	let
	en: String?,
	fr: String?,
	all: String?
}

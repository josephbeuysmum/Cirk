//
//  DT_WT_Sommelier.swift
//  Cirk
//
//  Created by Richard Willis on 08/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public enum DTRegions: String {
	case
	england = "en",
	france = "fr"
}

public protocol DTSommelierProtocol {
	var region: DTRegions { get set }
	init(bundledJson: DTBundledJson)
	func set(_ customer: DTCustomerForSommelier?)
	subscript(name: String) -> String? { get }
}

extension DTSommelier: DTSommelierProtocol {
	public subscript(name: String) -> String? {
		guard let wine = wines?[name] else { return nil }
		if wine.isGlobal {
			return wine.all
		} else {
			switch region.rawValue {
			case DTRegions.england.rawValue:	return wine.en
			case DTRegions.france.rawValue:		return wine.fr
			default:							return nil
			}
		}
	}
}

public final class DTSommelier {
	public var region: DTRegions {
		get { return region_ }
		// todo what should happen after the region gets re-set?
		set {
			guard region_ != newValue else { return }
			region_ = newValue
			customer?.regionChosen()
		}
	}
	
	fileprivate let wines: [String: DTWine]?
	
	fileprivate var
	region_: DTRegions,
	customer: DTCustomerForSommelier?
	
	public required init(bundledJson: DTBundledJson) {
		region_ = .england
		if let unbottledWines = bundledJson.decode(json: "text", into: DTWines.self) {
			var bottledWines: [String: DTWine] = [:]
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
	
	public func set(_ customer: DTCustomerForSommelier?) {
		self.customer = customer
	}
}

internal struct DTWines: Decodable {
	let copy: [DTWine]
}

internal struct DTWine: Decodable {
	var isGlobal: Bool { return all != nil }
	var key: String?
	let
	en: String?,
	fr: String?,
	all: String?
}

//
//  Larder.swift
//  Dertisch
//
//  Created by Richard Willis on 03/07/2018.
//

import Foundation

public protocol LarderProtocol: Ingredients {
//	var settings: JsonSettings? { get }
//	func decode<T>(json fileName: String, into type: T.Type) -> T? where T : Decodable
}

public class Larder {
	fileprivate var
	settings_: JsonSettings?
	
	required public init(_ resources: [String: KitchenResource]? = nil) {
		parseSettings()
	}
	
	deinit {}
}

fileprivate struct PrivateSetting: Decodable {
	let key: String
	let value: String
}

extension Larder: LarderProtocol {
	public var settings: JsonSettings? { return settings_ }
	
	public func decode<T>(json fileName: String, into type: T.Type) -> T? where T : Decodable {
		guard
			// todo add sub-directories to jsonPath
			let jsonPath = Bundle.main.path(forResource: fileName, ofType: "json"),
			let jsonData = (NSData(contentsOfFile: jsonPath)) as Data?
			else { return nil }
		do {
			let json = try JSONDecoder().decode(type.self, from: jsonData)
			return json
			// todo complete error catching
		} catch DecodingError.dataCorrupted(let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.keyNotFound(_, let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.typeMismatch(_, let context) {
			handle(decodingError: context)
			return nil
		} catch DecodingError.valueNotFound(_, let context){
			handle(decodingError: context)
			return nil
		} catch {
			return nil
		}
	}
	
	fileprivate func handle(decodingError context: DecodingError.Context) {
		print("^", context.debugDescription)
	}
	
	fileprivate func parseSettings() {
		guard let decodedSettings = decode(json: PrivateSettings.CodingKeys.data.rawValue, into: PrivateSettings.self) else { return }
		var settings: Dictionary<String, String> = [:]
		for setting in decodedSettings.data {
			guard settings[setting.key] == nil else { fatalError("DUPLICATED SETTING") }
			settings[setting.key] = setting.value
		}
		settings_ = JsonSettings(settings: settings)
	}
}

public struct JsonSettings {
	let settings: Dictionary<String, String>
	
	public subscript(key: String) -> String? {
		get { return settings[key] }
	}
}

fileprivate struct PrivateSettings: Decodable {
	let data: [PrivateSetting]
	
	enum CodingKeys: String, CodingKey {
		case data = "settings"
	}
}

//
//  DT_SV_API.swift
//  Dertisch
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

public protocol DTUrlSessionProtocol: DTKitchenMember {
	func call (
		url: String,
		method: DTUrlSession.methods,
		parameters: Dictionary< String, String >?,
		callback: ( ( String, Any? ) -> Void )? )
}

public class DTUrlSession {
	public var headChef: DTHeadChefForKitchenMember?
	
	fileprivate var ongoing_calls: [ String ]
	
	required public init(_ kitchenStaff: [String: DTKitchenMember]? = nil) {
		ongoing_calls = []
	}
	
	deinit {}
}

extension DTUrlSession: DTUrlSessionProtocol {
	public enum methods: String { case GET, POST, DELETE }
	
	public func call (
		url: String,
		method: DTUrlSession.methods,
		parameters: Dictionary< String, String >? = nil,
		callback: ( ( String, Any? ) -> Void )? = nil ) {
		guard
			ongoing_calls.index( of: url ) == nil,
			let validUrl = URL( string: url )
			else { return }
		ongoing_calls.append( url )
//		if order != nil && callback != nil {
//			dishes_.takeSingle(order: url, orderer: order!, callback: callback! )
//		}
		var request = URLRequest( url: validUrl )
		request.httpMethod = method.rawValue
		// todo serialise json for POSTs here?
		
		_ = URLSession.shared.dataTask( with: request ) { [weak self] data, response, error in
			guard let strongSelf = self else { return }
			guard error == nil else {
				lo( "todo ERROR to be handled here", url )
				return
			}
			guard data != nil else {
				lo( "todo /NO DATA to be handled here" )
				return
			}
			// todo reintroduce stopwatch so hanging calls can be cancelled?
			if let callIndex = strongSelf.ongoing_calls.index( of: url ) {
				strongSelf.ongoing_calls.remove( at: callIndex )
			}
			do {
				switch data!.mimeType {
				case Data.mimeTypes.RTF:		try strongSelf.cast( richText: data!, with: url )
				case Data.mimeTypes.BMP,
					 Data.mimeTypes.GIF,
					 Data.mimeTypes.JPG,
					 Data.mimeTypes.PNG:		try strongSelf.cast( image: data!, with: url )
				default: ()						// todo process other mime types here as and when required...
				}
			} catch {
//				strongSelf.transmit( success: false, with: url )
			}
			}.resume()
	}
	
	
	
	// unadulterated transmission because DTImages deals with post-processing
	fileprivate func cast ( image data: Data, with url: String ) throws {
//		transmit( success: true, with: url, and: data )
	}
	
	fileprivate func cast ( richText data: Data, with url: String ) throws {
//		do {
//			guard let json = try JSONSerialization.jsonObject( with: data, options: [] ) as? [ String: Any ] else { return }
//			//			let success = json[ DTKey.success ] is Bool ? json[ DTKey.success ] as? Bool : nil
//			let castArray: [ Dictionary< String, Any > ]
//			if let rawData = json[ "data" ] {
//				castArray = ( rawData is NSArray ? ( rawData as! NSArray ) as? [ Dictionary< String, AnyObject > ] : nil )!
//			} else {
//				castArray = [ json ]
//			}
//			transmit( success: true, with: url, and: castArray[ 0 ] )
//		} catch {
//			transmit( success: false, with: url )
//		}
	}
	
	
	
//	fileprivate func transmit ( success: Bool, with url: String, and data: Any? = nil ) {
//		dishes_.make(order: url, with: DTRawIngredient(success: success, url: url, data: data))
//	}
}

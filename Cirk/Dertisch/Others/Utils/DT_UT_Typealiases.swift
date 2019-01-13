//
//  DT_PT_Proxies.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData
//import UIKit

public typealias DTBasicClosure = () -> Void
public typealias DTCDClosure = ([NSManagedObject]?) -> Void
public typealias DTCDDeletionClosure = (Bool) -> Void
public typealias DTOrderClosure = (String, Any?) -> Void

//public protocol DTCoreDataProtocol: DTKitchenMember {
//	var dataModelName: String? { get set }
//	func delete(entityName: String, _ callback: @escaping DTCDDeletionClosure)
//	func delete(entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping DTCDDeletionClosure)
//	func retrieve(_ entityName: String, by predicate: String?, _ callback: @escaping DTCDClosure)
//	func store(_ entity: DTCDEntity, _ callback: @escaping DTCDClosure)
//	func update(_ entityName: String, to attribute: DTCDAttribute, by predicate: String?, _ callback: @escaping DTCDClosure)
//}

//public protocol DTTemporaryValuesProtocol: DTKitchenMember {
//	func getValue(by key: String, andAnnul: Bool?) -> DTStorableDataType?
//	func set(_ value: DTStorableDataType, by key: String)
//	func annulValue(by key: String)
//	func removeValues ()
//}

//public protocol DTImagesProtocol: DTKitchenMember {
//	func getImage(by url: String, callback: ((String, Any?) -> Void)?) -> UIImage?
//	func loadImage(by url: String)
//}

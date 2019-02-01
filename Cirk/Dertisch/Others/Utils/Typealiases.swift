//
//  Typealiases.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData

public typealias FreezerClosure = ([NSManagedObject]?) -> Void
public typealias FreezerDeletionClosure = (Bool) -> Void

//public protocol FreezerProtocol: KitchenResource {
//	var dataModelName: String? { get set }
//	func delete(entityName: String, _ callback: @escaping FreezerDeletionClosure)
//	func delete(entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping FreezerDeletionClosure)
//	func retrieve(_ entityName: String, by predicate: String?, _ callback: @escaping FreezerClosure)
//	func store(_ entity: FreezerEntity, _ callback: @escaping FreezerClosure)
//	func update(_ entityName: String, to attribute: FreezerAttribute, by predicate: String?, _ callback: @escaping FreezerClosure)
//}

//public protocolTemporaryValuesProtocol: KitchenResource {
//	func getValue(by key: String, andAnnul: Bool?) -> StorableDataType?
//	func set(_ value: StorableDataType, by key: String)
//	func annulValue(by key: String)
//	func removeValues ()
//}

//public protocol ImagesProtocol: KitchenResource {
//	func getImage(by url: String, callback: ((String, Any?) -> Void)?) -> UIImage?
//	func load(by url: String)
//}

//
//  DT_IG_Freezer.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData

public protocol FreezerProtocol: KitchenMember {
	var dataModelName: String? { get set }
	func delete(_ entityName: String, _ callback: @escaping FreezerDeletionClosure)
	func delete(_ entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping FreezerDeletionClosure)
	func retrieve(_ entityName: String, by predicate: String?, _ callback: @escaping FreezerClosure)
	func store(_ entity: FreezerEntity, _ callback: @escaping FreezerClosure)
	func update(_ entityName: String, to attribute: FreezerAttribute, by predicate: String?, _ callback: @escaping FreezerClosure)
}

public class Freezer {
	public var headChef: HeadChefForKitchenMember?
	
	lazy var persistentContainer: NSPersistentContainer? = {
		guard let dmn = dataModelName else {
			loWarning("Freezer dataModelName is nil")
			return nil
		}
		let container = NSPersistentContainer(name: dmn)
		container.loadPersistentStores { _, error in
			guard error == nil else { fatalError(" Core Data error: \(error!)") }
		}
		return container
	}()
	
	fileprivate var data_model_name: String?
	
	required public init(_ kitchenStaff: [String: KitchenMember]? = nil) {}
	
	deinit {}
}

extension Freezer: FreezerProtocol {
	public var dataModelName: String? {
		get { return data_model_name }
		set {
			guard data_model_name == nil else { fatalError("Currently Freezer dataModelName can only be set once") }
			data_model_name = newValue
		}
	}
	
	public func delete(_ entityName: String, _ callback: @escaping FreezerDeletionClosure) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let
		request = NSFetchRequest< NSFetchRequestResult >(entityName: entityName),
		deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		do {
			try privateContext.execute(deleteRequest)
			DispatchQueue.main.async { callback(true) }
		} catch {
			DispatchQueue.main.async { callback(false) }
		}
	}
	
	public func delete(_ entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping FreezerDeletionClosure) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let
		request = NSFetchRequest< NSFetchRequestResult >(entityName: entityName),
		asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asyncResult in
			guard let managedObjects = asyncResult.finalResult as? [NSManagedObject] else { return }
			managedObjects.forEach { managedObject in
				if condition(managedObject) {
					privateContext.delete(managedObject)
				}
			}
			do { try privateContext.save()
			} catch {
				DispatchQueue.main.async { callback(false) }
				return
			}
		}
		do {
			try privateContext.execute( asyncRequest )
			DispatchQueue.main.async { callback(true) }
		} catch {
			DispatchQueue.main.async { callback(false) }
		}
	}
	
	public func retrieve(_ entityName: String, by predicate: String? = nil, _ callback: @escaping FreezerClosure) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		if let predicate = predicate {
			fetchRequest.predicate = NSPredicate(format: predicate)
		}
		let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asyncFetchResult in
			guard let result = asyncFetchResult.finalResult as? [NSManagedObject] else { return }
			DispatchQueue.main.async {
				// create queue-safe array on the main thread
				var safeManagedObjects = [NSManagedObject]()
				for managedObject in result {
					let safeManagedObject = privateContext.object(with: managedObject.objectID)
					safeManagedObjects.append(safeManagedObject)
				}
				callback(safeManagedObjects.count > 0 ? safeManagedObjects : nil)
			}
		}
		// this is where a fail sometimes happens
		do { try privateContext.execute(asyncFetchRequest)
		} catch let error {
			loWarning("NSAsynchronousFetchRequest error: \(error)")
		}
	}
	
	public func store(_ entity: FreezerEntity, _ callback: @escaping FreezerClosure) {
		persistentContainer?.performBackgroundTask { privateContext in
			let managedEntity = NSEntityDescription.insertNewObject(forEntityName: entity.name, into: privateContext)
			// todo this string interpolations causes runtime errors (when storing string values is known, there may be others). I will have to replace it with that byzantine predicate syntax stuff. ugh
			var
			predicate = "",
			predicateSection: String
			for (key, value) in entity.attributes {
				predicateSection = "\(key) == \(value)"
				predicate = predicate.count > 0 ? "\(predicate) && \(predicateSection)" : predicateSection
//				lo(value, key)
				managedEntity.setValue(value, forKey: key)
			}
//			lo("predicate:", predicate)
			do {
				try privateContext.save()
				DispatchQueue.main.async {
					self.retrieve(entity.name, by: predicate) { managedObjects in
						callback(managedObjects)
					}
				}
			} catch {
				fatalError("Failure to save context: \(error)")
			}
		}
	}
	
	public func update(_ entityName: String, to attribute: FreezerAttribute, by predicate: String? = nil, _ callback: @escaping FreezerClosure) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		privateContext.perform {
			let updateRequest = NSBatchUpdateRequest(entityName: entityName)
			updateRequest.propertiesToUpdate = [attribute.key: attribute.value]
			updateRequest.resultType = .updatedObjectIDsResultType
			if let scopedPredicate = predicate {
				updateRequest.predicate = NSPredicate(format: scopedPredicate)
			}
			do {
				let result = try privateContext.execute(updateRequest) as? NSBatchUpdateResult
				DispatchQueue.main.async {
					guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
					var objects = [NSManagedObject]()
					objectIDs.forEach { objectID in
						let object = privateContext.object(with: objectID)
						privateContext.refresh(object, mergeChanges: false)
						objects.append(object)
					}
					callback(objects)
				}
			} catch {
				fatalError( "request error: \(error)")
			}
		}
	}
}

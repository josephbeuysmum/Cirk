//
//  MaitreD.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//
// todo "All rights reserved" needs changing to MIT licence somehow

import UIKit



public protocol MaitreDExtension {
	func registerStaff(with key: String)
}

public protocol MaitreDRegistrar {
	func register(
		_ modelClassType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]?)
	func introduce(
		_ customerId: String,
		as customerType: Customer.Type,
		with key: String,
		waiter waiterType: Waiter.Type?,
		chef headChefType: HeadChef.Type?,
		kitchenResources: [KitchenResource.Type]?)
}

public protocol MaitreDProtocol: MaitreDRegistrar {
//	var menuId: String? { get }
//	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertController.Style?)
//	func closeRestaurant()
//	func createNibFrom(name nibName: String, for owner: Customer) -> UIView?
//	func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String?)
//	func present(popoverMenu menuId: String, inside rect: CGRect?, from storyboard: String?)
//	// todo is there a better solution to getting popover results to the underlying VC than passing chosenDishId?
//	func removeMenu(_ chosenDishId: String?)
//	func seat(_ customerId: String, via transitionStyle: UIModalTransitionStyle?, from storyboard: String?)
//	func usherOutCurrentCustomer()
}



fileprivate typealias CustomerTicket = (restaurantTable: RestaurantTable, id: String, animated: Bool)

public class MaitreD {
	private let
	key: String,
	sommelier: Sommelier
	
	private var
	resources: Dictionary<String, KitchenResource>,
	switchesRelationships: Dictionary<String, InternalSwitchRelationship>,
	window: UIWindow!,
	backgroundCustomers: [CustomerTicket],
	currentRelationships: SwitchesRelationship?,
	menuRelationships: SwitchesRelationship?
	
	required public init() {
		key = NSUUID().uuidString
		resources = [:]
		switchesRelationships = [:]
		backgroundCustomers = []
		let larder = Larder()
		resources[Larder.staticId] = larder
		sommelier = Sommelier(larder: larder)
	}
}



extension MaitreD: MaitreDProtocol {
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = currentRelationships?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.restaurantTable?.present(alert, animated: true)
	}
	
	public func createNibFrom(name nibName: String, for owner: Customer) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		guard self.window == nil else { return }
		Time.startInterval()
		registerStaff(with: key)
		guard
			let rootRelationships = createRelationships(customerId: customerId, animated: false, storyboard: storyboard),
			let rootRestaurantTable = rootRelationships.customer?.restaurantTable
			else { return }
		currentRelationships = rootRelationships
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootRestaurantTable
		sommelier.assign(currentRelationships!.customer)
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: Customer.Type,
		with key: String,
		waiter waiterType: Waiter.Type? = nil,
		chef headChefType: HeadChef.Type? = nil,
		kitchenResources: [KitchenResource.Type]? = nil) {
		guard
			switchesRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchesRelationships[customerId] = InternalSwitchRelationship(
			customerType: customerType,
			waiterType: waiterType,
			headChefType: headChefType,
			kitchenResourceTypes: kitchenResources)
	}
	
	public func present(popoverMenu menuId: String, inside rect: CGRect? = nil, from storyboard: String? = nil) {
		guard
			menuRelationships == nil,
			let currentCustomer = currentRelationships?.customer,
			let nextMenuRelationships = createRelationships(customerId: menuId, animated: true, storyboard: storyboard),
			let menuTableAndChair = nextMenuRelationships.customer?.restaurantTable
			else { return }
		menuRelationships = nextMenuRelationships
		
		currentCustomer.peruseMenu()
		currentRelationships?.waiter?.beginBreak()
		currentRelationships?.headChef?.beginBreak()
		
		menuRelationships!.customer?.restaurantTable?.modalPresentationStyle = .popover
		currentCustomer.restaurantTable?.present(menuTableAndChair, animated: true)
		menuRelationships!.customer?.restaurantTable?.popoverPresentationController?.sourceView = currentCustomer.restaurantTable?.view
		if let safeRect = rect {
			menuRelationships!.customer?.restaurantTable?.popoverPresentationController?.sourceRect = safeRect
		}
		
		sommelier.assign(menuRelationships!.customer)
		menuRelationships!.waiter?.beginShift()
		menuRelationships!.headChef?.beginShift()
	}
	
	// todo when registering Images: ingredients we should automatically do UrlSession too
	public func register(
		_ resourceType: KitchenResource.Type,
		with key: String,
		injecting dependencyTypes: [KitchenResource.Type]? = nil) {
		guard key == self.key else { return }
		let
		resourceDependencies = getResources(from: dependencyTypes),
		resource = resourceType.init(resourceDependencies)
		self.resources[resourceType.staticId] = resource
		resource.beginShift()
	}
	
	public func removeMenu(_ chosenDishId: String? = nil) {
		guard menuRelationships != nil else { return }
		menuRelationships!.customer?.restaurantTable?.dismiss(animated: true) //{}
		endShift(for: menuRelationships)
		menuRelationships = nil
		currentRelationships?.headChef?.endBreak()
		currentRelationships?.waiter?.endBreak()
		currentRelationships?.customer?.returnMenuToWaiter(chosenDishId)
	}
	
	public func seat(
		_ customerId: String,
		via transitionStyle: UIModalTransitionStyle? = nil,
		from storyboard: String? = nil) {
		let animated = transitionStyle != nil
		guard
			let currentCustomer = currentRelationships?.customer,
			let nextCurrentRelationships = createRelationships(
				customerId: customerId,
				animated: animated,
				storyboard: storyboard),
			let nextCustomer = nextCurrentRelationships.customer,
			let currentRestaurantTable = currentCustomer.restaurantTable,
			let nextRestaurantTable = nextCustomer.restaurantTable
			else { return }
		let ticket = CustomerTicket(restaurantTable: currentRestaurantTable, id: currentRelationships!.customerID, animated: animated)
		backgroundCustomers.append(ticket)
		endShift(for: currentRelationships)
		
		if animated {
			nextCurrentRelationships.customer?.restaurantTable?.modalTransitionStyle = transitionStyle!
		}
		
		currentRelationships = nextCurrentRelationships
		currentRestaurantTable.present(nextRestaurantTable, animated: animated)
		sommelier.assign(currentCustomer)
		currentRelationships!.waiter?.beginShift()
		currentRelationships!.headChef?.beginShift()
	}
	
	public func usherOutCurrentCustomer() {
		guard currentRelationships != nil else { return }
		currentRelationships!.customer?.restaurantTable?.dismiss(animated: currentRelationships!.animated) { [unowned self] in
			self.endShift(for: self.currentRelationships)
			guard let formerCustomer = self.backgroundCustomers.popLast() else { return }
			guard let formerRelationships = self.createRelationships(ticket: formerCustomer) else { return }
			self.currentRelationships = formerRelationships
			self.sommelier.assign(self.currentRelationships!.customer)
			self.currentRelationships!.waiter?.beginShift()
			self.currentRelationships!.headChef?.beginShift()
		}
	}
	
	
	
	
	
	internal func customer(for staffMember: SwitchesRelationshipProtocol) -> Customer? {
		switch true {
		case staffMember === currentRelationships?.waiter:		return currentRelationships!.customer
		case staffMember === menuRelationships?.waiter:			return menuRelationships!.customer
		default: 												return nil
		}
	}
	
	internal func headChef(for staffMember: SwitchesRelationshipProtocol) -> HeadChef? {
		switch true {
		case staffMember === currentRelationships?.waiter:		return currentRelationships!.headChef
		case staffMember === menuRelationships?.waiter:			return menuRelationships!.headChef
		default: 												return nil
		}
	}
	
	// todo? change to conditional conformance (I wish I had made this more explicit, now I'm not sure what "change to conditional conformance" means in this context)
	internal func waiter(for staffMember: SwitchesRelationshipProtocol) -> Waiter? {
		switch true {
		case staffMember === currentRelationships?.headChef,
			 staffMember === currentRelationships?.customer,
			 staffMember === currentRelationships?.waiter:		return currentRelationships!.waiter
		case staffMember === menuRelationships?.headChef,
			 staffMember === menuRelationships?.customer,
			 staffMember === menuRelationships?.waiter:			return menuRelationships!.waiter
		default: 												return nil
		}
	}
	
	
	
	
	
	private func createRelationships(ticket: CustomerTicket) -> SwitchesRelationship? {
		guard let switchesRelationship = switchesRelationships[ticket.id] else { return nil }
		let waiter = switchesRelationship.waiterType != nil ?
			switchesRelationship.waiterType!.init(maitreD: self) :
			GeneralWaiter(maitreD: self)
		let headChef = switchesRelationship.headChefType != nil ?
			switchesRelationship.headChefType!.init(
				waiter: waiter,
				resources: getResources(from: switchesRelationship.kitchenResourceTypes)) :
			nil
		let customer = switchesRelationship.customerType.init(
			maitreD: self,
			restaurantTable: ticket.restaurantTable,
			waiter: waiter,
			sommelier: sommelier)
		customer.restaurantTable?.customer = customer
		waiter.introduce(customer, and: headChef)
		return SwitchesRelationship(
			customerID: ticket.id,
			animated: ticket.animated,
			customer: customer,
			waiter: waiter,
			headChef: headChef)
	}
	
	private func createRelationships(customerId: String, animated: Bool, storyboard: String? = nil) -> SwitchesRelationship? {
		guard switchesRelationships[customerId] != nil else { return nil }
		let restaurantTableId = "\(customerId)\(CommonPhrases.View)\(CommonPhrases.Controller)"
		guard let restaurantTable = UIStoryboard(
			name: storyboard ?? "Main",
			bundle: nil).instantiateViewController(withIdentifier: restaurantTableId) as? RestaurantTable else { return nil }
		let ticket = CustomerTicket(restaurantTable: restaurantTable, id: customerId, animated: animated)
		return createRelationships(ticket: ticket)
	}
	
	private func getResources(from dependencyTypes: [KitchenResource.Type]?) -> [String: KitchenResource]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var resources: [String: KitchenResource] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = self.resources[dependencyId] {
				resources[dependencyId] = dependencyClass
			}
		}
		return resources
	}
	
	private func endShift(for switchesRelationship: SwitchesRelationship?) {
		guard switchesRelationship != nil else { return }
		switchesRelationship!.customer?.presentCheck()
		switchesRelationship!.waiter?.endShift()
		switchesRelationship!.headChef?.endShift()
	}
	
	private func searchFor(
		_ colleagueA: SwitchesRelationshipProtocol,
		and colleagueB: SwitchesRelationshipProtocol,
		in switchesRelationship: SwitchesRelationship?) -> Bool {
		guard let switches = switchesRelationship else { return false }
//		lo(colleagueA === switches.customer, colleagueA === switches.waiter, colleagueA === switches.headChef, colleagueB === switches.customer, colleagueB === switches.waiter, colleagueB === switches.headChef)
		return  (colleagueA === switches.customer || colleagueA === switches.waiter || colleagueA === switches.headChef) &&
				(colleagueB === switches.customer || colleagueB === switches.waiter || colleagueB === switches.headChef)
	}
}

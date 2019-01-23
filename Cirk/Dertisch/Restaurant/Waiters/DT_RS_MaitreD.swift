//
//  DT_SV_Routing.swift
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
		_ modelClassType: KitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [KitchenMember.Type]?)
	func introduce(
		_ customerId: String,
		as customerType: CustomerProtocol.Type,
		with key: String,
		waiter waiterType: Waiter.Type?,
		chef headChefType: HeadChef.Type?,
		kitchenStaff kitchenStaffTypes: [KitchenMember.Type]?)
}

public protocol MaitreDProtocol: MaitreDRegistrar {
//	var menuId: String? { get }
	func alert(actions: [UIAlertAction], title: String?, message: String?, style: UIAlertController.Style?)
	func closeRestaurant()
	func createNibFrom(name nibName: String, for owner: Customer) -> UIView?
//	func create(_ customerId: String, from storyboard: String?) -> Customer?
//	func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping ((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String?) -> UIAlertController
	func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String?)
	func present(popoverMenu menuId: String, inside rect: CGRect?, from storyboard: String?)
	// todo is there a better solution to getting popover results to the underlying VC than passing chosenDishId?
	func removeMenu(_ chosenDishId: String?)
	func seatNext(_ customerId: String, via transitionStyle: UIModalTransitionStyle?, from storyboard: String?)
	func usherOutCurrentCustomer()
}



fileprivate typealias CustomerTicket = (customer: Customer, id: String)

public class MaitreD {
	private let
	key: String,
	sommelier: Sommelier
	
	private var
	kitchenStaff: Dictionary<String, KitchenMember>,
	switchesRelationships: Dictionary<String, InternalSwitchRelationship>,
	window: UIWindow!,
	formerCustomers: [CustomerTicket],
//	rootSwitches: SwitchesRelationship?,
	currentSwitches: SwitchesRelationship?,
	menuSwitches: SwitchesRelationship?
	
	required public init() {
		key = NSUUID().uuidString
		kitchenStaff = [:]
		switchesRelationships = [:]
		formerCustomers = []
		let bundledJson = BundledJson()
		kitchenStaff[BundledJson.staticId] = bundledJson
		sommelier = Sommelier(bundledJson: bundledJson)
	}
}



extension MaitreD: MaitreDProtocol {
//	public var menuId: String? {
//		return menuSwitches?.customerID
//	}
	
	public func alert(
		actions: [UIAlertAction],
		title: String? = nil,
		message: String? = nil,
		style: UIAlertController.Style? = .alert) {
		guard let customer = currentSwitches?.customer else { return }
		let
		alert = UIAlertController(title: title, message: message, preferredStyle: style!),
		countActions = actions.count
		for i in 0..<countActions {
			alert.addAction(actions[i])
		}
		customer.present(alert, animated: true)
	}
	
	public func closeRestaurant() {
		currentSwitches?.endShift()
		menuSwitches?.endShift()
		//		exit(1)
	}
	
	public func createNibFrom(name nibName: String, for owner: Customer) -> UIView? {
		guard let viewArray = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil) else { return nil }
		return viewArray[0] as? UIView
	}
	
	internal func blah () {
		lo()
	}
	
//	public func create(_ customerId: String, from storyboard: String? = nil) -> Customer? {
//		return createBundleFrom(customerId, and: storyboard)?.customer
//	}
	
//	public func createAlertWith(
//		title: String,
//		message: String,
//		buttonLabel: String,
//		handler: @escaping((UIAlertAction) -> Void),
//		plusExtraButtonLabel extraButtonLabel: String? = nil) -> UIAlertController {
//		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//		// copy
//		alert.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default, handler: handler))
//		if extraButtonLabel != nil {
//			alert.addAction(UIAlertAction(title: extraButtonLabel!, style: UIAlertActionStyle.default, handler: nil))
//		}
//		return alert
//	}
	
	public func greet(firstCustomer customerId: String, through window: UIWindow, from storyboard: String? = nil) {
		// todo should this be a fatal error?
		guard self.window == nil else { return }
		Time.startInterval()
		registerStaff(with: key)
		// todo some sort of feedback for silent returns?
		guard
			let rootSwitches = createBundle(from: customerId, and: storyboard),
			let rootCustomer = rootSwitches.customer
			else { return }
		self.window = window
		self.window.makeKeyAndVisible()
		self.window.rootViewController = rootCustomer
		currentSwitches = rootSwitches
		formerCustomers.append((rootCustomer, customerId))
		sommelier.set(currentSwitches?.customer)
	}
	
	public func introduce(
		_ customerId: String,
		as customerType: CustomerProtocol.Type,
		with key: String,
		waiter waiterType: Waiter.Type? = nil,
		chef headChefType: HeadChef.Type? = nil,
		kitchenStaff kitchenStaffTypes: [KitchenMember.Type]? = nil) {
		guard
			switchesRelationships[customerId] == nil,
			key == self.key
			else { return }
		switchesRelationships[customerId] = InternalSwitchRelationship(
			customerType: customerType,
			waiterType: waiterType,
			headChefType: headChefType,
			kitchenStaffTypes: kitchenStaffTypes)
	}
	
	public func present(
		popoverMenu menuId: String,
		inside rect: CGRect? = nil,
		from storyboard: String? = nil) {
		guard
			menuSwitches == nil,
			let currentCustomer = currentSwitches?.customer,
			let switchBundle = createBundle(from: menuId, and: storyboard),
			let menu = switchBundle.customer
			else { return }
		currentSwitches?.headChef?.startBreak()
		currentSwitches?.waiter?.startBreak()
		currentCustomer.peruseMenu()
		menu.modalPresentationStyle = .popover
		currentCustomer.present(menu, animated: true)
//		{
//			lo()
////			self.dishes_.make(order: Order.popoverAdded)
//		}
		menu.popoverPresentationController?.sourceView = currentCustomer.view
		if let safeRect = rect {
			menu.popoverPresentationController?.sourceRect = safeRect
		}
		menuSwitches = switchBundle
	}
	
	public func register(
		_ kitchenStaffType: KitchenMember.Type,
		with key: String,
		injecting dependencyTypes: [KitchenMember.Type]? = nil) {
		guard key == self.key else { return }
		let kitchenClasses = getKitchenStaff(from: dependencyTypes)
		let kitchenStaffMember = kitchenStaffType.init(kitchenClasses)
		self.kitchenStaff[kitchenStaffType.staticId] = kitchenStaffMember
		kitchenStaffMember.startShift()
	}
	
	public func removeMenu(_ chosenDishId: String? = nil) {
		guard var strongMenuSwitches = menuSwitches else { return }
		strongMenuSwitches.customer?.dismiss(animated: true)
//		{ lo("removeMenu complete") }
		strongMenuSwitches.endShift()
		menuSwitches = nil
		currentSwitches?.headChef?.endBreak()
		currentSwitches?.waiter?.endBreak()
		currentSwitches?.customer?.returnMenuToWaiter(chosenDishId)
	}
	
	// todo will we reinstate something like this in future?
//	public func seat(
//		_ customerId: String,
//		via transitionType: CATransitionType? = nil,
//		and transitionSubtype: CATransitionSubtype? = nil,
//		from storyboard: String? = nil) {
//		guard
//			let switchBundle = createBundle(from: customerId, and: storyboard),
//			let customer = switchBundle.customer
//			else { return }
//		if let transitionType = transitionType {
//			let transition = CATransition()
//			transition.duration = 0.25
//			transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//			transition.type = transitionType
//			transition.subtype = transitionSubtype ?? .fromRight
//			window.layer.add(transition, forKey: nil)
//		}
//		window.rootViewController = customer
//		currentSwitches?.endShift()
//		currentSwitches = switchBundle
//	}
	
	public func seatNext(
		_ customerId: String,
		via transitionStyle: UIModalTransitionStyle? = nil,
		from storyboard: String? = nil) {
		guard
			let currentCustomer = currentSwitches?.customer,
			var switchBundle = createBundle(from: customerId, and: storyboard),
			let nextCustomer = switchBundle.customer
			else { return }
		let animated = transitionStyle != nil
		if animated {
			nextCustomer.modalTransitionStyle = transitionStyle!
		}
		currentCustomer.present(nextCustomer, animated: animated)
		currentSwitches?.endShift()
		switchBundle.animated = animated
		currentSwitches = switchBundle
		sommelier.set(currentCustomer)
	}
	
	public func usherOutCurrentCustomer() {
		guard currentSwitches != nil else { return }
		currentSwitches!.customer?.dismiss(animated: currentSwitches!.animated) { [unowned self] in
			self.currentSwitches!.endShift()
			guard let formerCustomer = self.formerCustomers.popLast() else { return }
			self.currentSwitches = self.createBundle(from: formerCustomer)
		}
	}
	
	
	
	
	
	private func createBundle(from ticket: CustomerTicket) -> SwitchesRelationship? {
		guard let switchesRelationship = switchesRelationships[ticket.id] else { return nil }
		let kitchenStaff = getKitchenStaff(from: switchesRelationship.kitchenStaffTypes)
		var headChef = switchesRelationship.headChefType != nil ? switchesRelationship.headChefType!.init(kitchenStaff) : nil
		let waiter = switchesRelationship.waiterType != nil ?
			switchesRelationship.waiterType!.init(customer: ticket.customer,  headChef: headChef) :
			GeneralWaiter(customer: ticket.customer, headChef: headChef)
		headChef?.waiter = waiter
		ticket.customer.assign(waiter, maitreD: self, and: sommelier)
		waiter.startShift()
		headChef?.startShift()
		return SwitchesRelationship(
			customerID: ticket.id,
			customer: ticket.customer,
			waiter: waiter,
			headChef: headChef,
			animated: false)
	}
	
	private func createBundle(from customerId: String, and storyboard: String? = nil) -> SwitchesRelationship? {
		guard
			switchesRelationships[customerId] != nil,
			let customer = UIStoryboard(
				name: storyboard ?? "Main",
				bundle: nil).instantiateViewController(withIdentifier: customerId) as? Customer
			else { return nil }
		return createBundle(from: (customer: customer, id: customerId))
	}
	
	private func getKitchenStaff(from dependencyTypes: [KitchenMember.Type]?) -> [String: KitchenMember]? {
		guard dependencyTypes?.count ?? -1 > 0 else { return nil }
		var kitchenStaff: [String: KitchenMember] = [:]
		for dependencyType in dependencyTypes! {
			let dependencyId = dependencyType.staticId
			if let dependencyClass = self.kitchenStaff[dependencyId] {
				kitchenStaff[dependencyId] = dependencyClass
			}
		}
		return kitchenStaff
	}
}

//
//  AppDelegate.swift
//  Cirk
//
//  Created by Richard Willis on 07/06/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//import Dertisch
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var maitreD: MaitreD!
	var window: UIWindow?

	func application (
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		maitreD = MaitreD()
		maitreD.greet(firstCustomer: Views.intro, through: window!)
		return true
	}
}

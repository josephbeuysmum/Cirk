//
//  Consts.swift
//  UsThree
//
//  Created by Richard Willis on 28/01/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

// todo get rid of this
public struct Chars {
	public static let
	ampersand =					"&",
	asterisk =					"*",
	at =						"@",
	backSlash =					"\\",
	caret =						"^",
	closedCurlyBracket =		"}",
	closedParenthesis =			")",
	closedSquareBracket =		"]",
	colon =						":",
	comma =						",",
	dollarSign =				"$",
	dot =						".",
	doubleQuote =				"\"",
	ellipsis =					"…",
	emptyString =				"",
	equals =					"=",
	exclamationMark =			"!",
	graveAccent =				"`",
	greaterThan =				">",
	hash =						"#",
	hyphen =					"-",
	lessThan =					"<",
	lineBreak =					"\n",
	minus =						hyphen,
	openCurlyBracket =			"{",
	openParenthesis =			"(",
	openSquareBracket =			"[",
	percent =					"%",
	plus =						"+",
	plusMinus =					"±",
	//	point =						dot,
	poundSign =					"£",
	questionMark =				"?",
	sectionSign =				"§",
	semicolon =					";",
	singleQuote =				"'",
	slash =						"/",
	space =						" ",
	tilda =						"~",
	underscore =				"_",
	verticalBar =				"|"
}

public struct CommonPhrases {
	public static let
	Activated = "Activated",
	Added = "Added",
	Cell = "Cell",
	Controller = "Controller",
	Customer = "Customer",
	Deleted = "Deleted",
	Loaded = "Loaded",
	Menu = "Menu",
	Popover = "Popover",
	Removed = "Removed",
	Retrieved = "Retrieved",
	Search = "Search",
	Selected = "Selected",
	Set = "Set",
	Stored = "Stored",
	Updated = "Updated",
	View = "View"
	
	//	Account = "Account",
	//	Accounts = "\( Account )s",
	//	Back = "Back",
	//	Changed = "Changed",
	//	Complete = "Complete",
	//	CoreData = "CoreData",
	//	Count = "Count",
	//	Dialog = "Dialog",
	//	Down = "Down",
	//	Error = "Error",
	//	ID = "ID",
	//	Image = "Image",
	//	Index = "Index",
	//	Initialised = "Initialised",
	//	Interactor = "Interactor",
	//	Login = "Login",
	//	Page = "Page",
	//	Ping = "Ping",
	//	Waiter = "Waiter",
	//	SousChef = "SousChef",
	//	Reloaded = "Reloaded",
	//	Released = "Released",
	//	Resolved = "Resolved",
	//	Routing = "Routing",
	//	Service = "Service",
	//	Signal = "Signal",
	//	Start = "Start",
	//	Started = "\( Start )ed",
	//	Up = "Up",
	//	Url = "Url"
}

public struct Flags {
	public static let
	imageLoad = "imageLoad"
}

public struct Logs {
	public struct logLevel {
		static let
		output = 0,
		info = 1,
		feedback = 2,
		warning = 3,
		error = 4
	}
	
	public static let logModes = [logLevel.output, logLevel.info, logLevel.warning]//, logLevel.feedback]
}

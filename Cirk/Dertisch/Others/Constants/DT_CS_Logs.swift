//
//  DT_UT_Log.swift
//  Dertisch
//
//  Created by Richard Willis on 03/06/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

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

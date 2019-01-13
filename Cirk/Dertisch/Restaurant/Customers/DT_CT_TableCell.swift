//
//  DT_TableCell.swift
//  Dertisch
//
//  Created by Richard Willis on 27/07/2018.
//

import UIKit

public protocol DTTableViewCellProtocol: class {}//, DTServeCustomerProtocol {}

open class DTTableViewCell: UITableViewCell, DTTableViewCellProtocol {
	// todo make this a serve(entrees)
	open func serve<T>(with data: T?) {}
}

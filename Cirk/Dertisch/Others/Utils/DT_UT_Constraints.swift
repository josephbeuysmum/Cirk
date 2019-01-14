//
//  DT_UT_Constraints.swift
//  Dertisch
//
//  Created by Richard Willis on 25/07/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

//import UIKit
//
//// NSLayoutConstraint is a pain in the ass. These functions make it easier
//public class DTConstraints {
//	
//	public static func getBottomEdgeConstraintFor ( view: UIView, of gap: Int ) -> NSLayoutConstraint {
//		return _getEdgeConstraintFor( view: view, toAttribute: .bottom, of: gap )
//	}
//
//	public static func getLeadingEdgeConstraintFor ( view: UIView, of gap: Int ) -> NSLayoutConstraint {
//		return _getEdgeConstraintFor( view: view, toAttribute: .leading, of: gap )
//	}
//
//	public static func getTopEdgeConstraintFor ( view: UIView, of gap: Int ) -> NSLayoutConstraint {
//		return _getEdgeConstraintFor( view: view, toAttribute: .top, of: gap )
//	}
//
//	public static func getTrailingEdgeConstraintFor ( view: UIView, of gap: Int ) -> NSLayoutConstraint {
//		return _getEdgeConstraintFor( view: view, toAttribute: .trailing, of: gap )
//	}
//	
//	public static func getConstraintBetween (
//		viewToTheTop topView: UIView,
//		andViewToTheBottom bottomView: UIView,
//		Of gap: Int ) -> NSLayoutConstraint {
//		return NSLayoutConstraint(
//			item: bottomView,
//			attribute: .top,
//			relatedBy: .equal,
//			toItem: topView,
//			attribute: .bottom,
//			multiplier: 1,
//			constant: CGFloat( gap )
//		)
//	}
//
//	public static func getConstraintBetween (
//		viewOnTheLeft leftView: UIView,
//		andViewOnTheRight rightView: UIView,
//		Of gap: Int ) -> NSLayoutConstraint {
//		return NSLayoutConstraint(
//			item: rightView,
//			attribute: .leading,
//			relatedBy: .equal,
//			toItem: leftView,
//			attribute: .trailing,
//			multiplier: 1,
//			constant: CGFloat( gap )
//		)
//	}
//
//	public static func getEqualHeightConstraintFor (
//		thisView firstView: UIView,
//		andThisView secondView: UIView ) -> NSLayoutConstraint {
//		return _getEqualDimensionConstraintFor( thisView: firstView, andThisView: secondView, of: .height )
//	}
//
//	public static func getEqualWidthConstraintFor (
//		thisView firstView: UIView,
//		andThisView secondView: UIView ) -> NSLayoutConstraint {
//		return _getEqualDimensionConstraintFor( thisView: firstView, andThisView: secondView, of: .width )
//	}
//
//	public static func getHeightConstraintFor ( view: UIView, of height: Int ) -> NSLayoutConstraint {
//		return _getSizeConstraintFor( view: view, toAttribute: .height, of: height )
//	}
//
//	public static func getWidthConstraintFor ( view: UIView, of width: Int ) -> NSLayoutConstraint {
//		return _getSizeConstraintFor( view: view, toAttribute: .width, of: width )
//	}
//	
//	
//
//	static fileprivate func _getEdgeConstraintFor (
//		view: UIView,
//		toAttribute attribute: NSLayoutConstraint.Attribute,
//		of gap: Int ) -> NSLayoutConstraint {
//		return NSLayoutConstraint(
//			item: view,
//			attribute: attribute,
//			relatedBy: .equal,
//			toItem: view.superview,
//			attribute: attribute,
//			multiplier: 1,
//			constant: CGFloat( gap ) )
//	}
//
//
//
//	static fileprivate func _getEqualDimensionConstraintFor (
//		thisView firstView: UIView,
//		andThisView secondView: UIView,
//		of dimension: NSLayoutConstraint.Attribute ) -> NSLayoutConstraint {
//		return NSLayoutConstraint(
//			item: firstView,
//			attribute: dimension,
//			relatedBy: .equal,
//			toItem: secondView,
//			attribute: dimension,
//			multiplier: 1,
//			constant: 0 )
//	}
//
//	static fileprivate func _getSizeConstraintFor (
//		view: UIView,
//		toAttribute attribute: NSLayoutConstraint.Attribute,
//		of gap: Int ) -> NSLayoutConstraint {
//		return NSLayoutConstraint(
//			item: view,
//			attribute: attribute,
//			relatedBy: .equal,
//			toItem: nil,
//			attribute: .notAnAttribute,
//			multiplier: 1.0,
//			constant: CGFloat( gap )
//		)
//	}
//}

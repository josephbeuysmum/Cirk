//
//  CircleRenderer.swift
//  Cirk
//
//  Created by Richard Willis on 30/07/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension CircleRendererProtocol {
	func drawCircle(
		with circle: CAShapeLayer,
		from circleData: CircleJson,
		onto layer: CALayer,
		within bounds: CGRect,
		colored color: CGColor,
		withStrokeOf lineWidth: CGFloat,
		andRadius radius: CGFloat) {
		circle.path = UIBezierPath(
			arcCenter: getCenterPoint(by: circleData, and: bounds),
			radius: radius,
			startAngle: CGFloat(0),
			endAngle:CGFloat(Double.pi * 2),
			clockwise: true).cgPath
		circle.strokeColor = color
		circle.fillColor = UIColor.clear.cgColor
		circle.lineWidth = lineWidth
		layer.addSublayer(circle)
	}
	
	func getCenterPoint(by circleData: CircleJson, and bounds: CGRect) -> CGPoint {
		return CGPoint(x: CGFloat(circleData.x) * bounds.width, y: CGFloat(circleData.y) * bounds.height)
	}
	
	func getRadius(by rawRadius: Float, and ballSize: Int) -> CGFloat {
		return (CGFloat(rawRadius) * 0.4) * CGFloat(ballSize)
	}
}

protocol CircleRendererProtocol {}

struct CircleColors {
	let red: CGFloat, green: CGFloat, blue: CGFloat
}

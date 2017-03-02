//
//  DrawRectangleToHideTransitions.swift
//  Vowel Space Travel
//
//  Created by Wessel Stoop on 16/09/16.
//  Copyright © 2016 Radboud University. All rights reserved.
//

import Foundation
import UIKit

func drawRectangleToHideTransitions(view : UIView)
{
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: 0, y: 0))
    path.addLineToPoint(CGPoint(x: 0, y: 1000))
    path.addLineToPoint(CGPoint(x: 1000, y: 0))
    path.closePath()
    UIColor.redColor().set()
    path.lineWidth = 1
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.CGPath
    shapeLayer.fillColor = kBackgroundColor.CGColor
    
    let scale = CATransform3DMakeScale(100,100,1)
    let translate = CATransform3DMakeTranslation(0, 0, 0)
    shapeLayer.transform = CATransform3DConcat(scale, translate)
    
    view.layer.addSublayer(shapeLayer)
}

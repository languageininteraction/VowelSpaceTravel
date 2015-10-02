//
//  DownloadBarView.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 21/08/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class DownloadBarView : UIView
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame : CGRect)
    {
        super.init(frame : frame)
        self.updatePercentage(0)
    }

    func drawFilledInPath(path : UIBezierPath, color : UIColor)
    {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = color.CGColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func updatePercentage(percentage : CGFloat)
    {
        let topLeft : CGPoint = CGPoint(x: self.frame.minX, y: self.frame.maxY-percentage*self.frame.height)
        let topRight : CGPoint = CGPoint(x: self.frame.maxX, y:  self.frame.maxY-percentage*self.frame.height)
        let bottomLeft : CGPoint = CGPoint(x: self.frame.minX, y:self.frame.maxY)
        let bottomRight : CGPoint = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        
        let myBezier = UIBezierPath()
        
        myBezier.moveToPoint(topLeft)
        myBezier.addLineToPoint(topRight)
        myBezier.addLineToPoint(bottomRight)
        myBezier.addLineToPoint(bottomLeft)
        
        self.drawFilledInPath(myBezier, color: UIColor(hue: 0.7, saturation: 1, brightness: 0.65, alpha: 1))
        
    }
}
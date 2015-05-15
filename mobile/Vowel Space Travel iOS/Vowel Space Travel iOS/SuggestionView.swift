//
//  SuggestionView.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 15/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class SuggestionView : UIView {
    
    var fillColor = UIColor.grayColor()
    var strokeColor = UIColor.blackColor()
    var lineWidth = CGFloat(0)
    var text : String = "Test"
    var textColor = UIColor.whiteColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)

        //Draw rounded rect
        let triangleSize : CGFloat = self.bounds.height * 0.2
        let rectHeigth : CGFloat = self.bounds.height - triangleSize
        
        var rectPath = UIBezierPath(roundedRect: CGRect(x: self.bounds.minX,y: self.bounds.minY,width: self.bounds.width,height: rectHeigth), cornerRadius: CGFloat(10)).CGPath
        
        var rect = CAShapeLayer()
        rect.path = rectPath
        rect.fillColor = self.fillColor.CGColor
        rect.strokeColor = self.strokeColor.CGColor
        rect.lineWidth = self.lineWidth
        self.layer.addSublayer(rect)
        
        //Draw triangle
        let triangleLeft = self.bounds.minX + self.bounds.width / 10
        
        var trianglePath = UIBezierPath()
        
        trianglePath.moveToPoint(CGPointMake(triangleLeft,rectHeigth))
        trianglePath.addLineToPoint(CGPointMake(triangleLeft+triangleSize,rectHeigth))
        trianglePath.addLineToPoint(CGPointMake(triangleLeft+triangleSize/2,self.bounds.maxY))
        
        trianglePath.closePath()
        
        var triangle = CAShapeLayer()
        triangle.path = trianglePath.CGPath
        triangle.fillColor = self.fillColor.CGColor
        self.layer.addSublayer(triangle)
        
        //Draw the text
        var suggestionText = UILabel(frame: self.bounds)
        suggestionText.textAlignment = NSTextAlignment.Center
        suggestionText.textColor = self.textColor
        suggestionText.text = text
        
        //Resize the label and recenter it
        suggestionText.sizeToFit()
        suggestionText.center = CGPoint(x: self.bounds.maxX - self.bounds.width/2,y: rectHeigth/2)
        
        self.addSubview(suggestionText)
        
    }
}

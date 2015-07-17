//
//  PlanetView.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 17/07/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class PlanetView : UIView
{

    let planetSize : CGFloat = 50
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame : frame)

        self.drawBasePlanet(CGPoint(x: 40,y: 40), color: UIColor.purpleColor())
        self.drawPlanetShadow()
        
    }
    
    func drawBasePlanet(center: CGPoint, color : UIColor)
    {
        var path : UIBezierPath = createCircularPath(center, size: self.planetSize)
        drawFilledInPath(path, color: color,position:CGPoint(x:0,y:0),scale: 1)
    }
    
    func drawPlanetShadow()
    {
        
        //Path converted from Inkscape SVG
        var myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 180, y:1))
        myBezier.addCurveToPoint(CGPoint(x: 157, y: 166),
            controlPoint1: CGPoint(x: 180, y:1),
            controlPoint2: CGPoint(x: 245, y:86))
        myBezier.addCurveToPoint(CGPoint(x: 0, y: 152),
            controlPoint1: CGPoint(x: 129, y:192),
            controlPoint2: CGPoint(x: 54, y:205))
        myBezier.addCurveToPoint(CGPoint(x: 180, y: 0),
            controlPoint1: CGPoint(x: 0, y:152),
            controlPoint2: CGPoint(x: 174, y:151))
    
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2),position: CGPoint(x: 3,y: 10),scale: 0.43)
    }
    
    func createCircularPath(center : CGPoint,size : CGFloat) -> UIBezierPath
    {
        return UIBezierPath(arcCenter: center,radius: size,startAngle: CGFloat(0),endAngle: CGFloat(100),clockwise: true)
    }
    
    func drawFilledInPath(path : UIBezierPath, color : UIColor, position : CGPoint, scale : CGFloat)
    {
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = color.CGColor

        var scale = CATransform3DMakeScale(scale,scale,1)
        var translate = CATransform3DMakeTranslation(position.x, position.y, 0)
        shapeLayer.transform = CATransform3DConcat(scale, translate)
        
        self.layer.addSublayer(shapeLayer)
    }
}
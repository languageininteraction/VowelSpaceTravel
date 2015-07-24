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
        self.drawRing(1)
        
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
    
    func drawRing(opacity : CGFloat)
    {
        var myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 11.37935, y:2.30567))
        myBezier.addCurveToPoint(CGPoint(x: 11.20793, y: 3.25206),
            controlPoint1: CGPoint(x: 11.34815, y:2.64942),
            controlPoint2: CGPoint(x: 11.30165, y:2.81456))
        myBezier.addCurveToPoint(CGPoint(x: 13.14359, y: 4.69622),
            controlPoint1: CGPoint(x: 11.92668, y:3.47081),
            controlPoint2: CGPoint(x: 13.0467, y:3.76722))
        myBezier.addCurveToPoint(CGPoint(x: 1.12982, y: 1.35171),
            controlPoint1: CGPoint(x: 5.65431, y:4.04441),
            controlPoint2: CGPoint(x: 1.08563, y:1.66107))
        myBezier.addCurveToPoint(CGPoint(x: 3.57306, y: 1.4584),
            controlPoint1: CGPoint(x: 1.17402, y:0.99816),
            controlPoint2: CGPoint(x: 2.79181, y:1.30211))
        myBezier.addCurveToPoint(CGPoint(x: 3.88464, y: 0.7513),
            controlPoint1: CGPoint(x: 3.69806, y:1.05215),
            controlPoint2: CGPoint(x: 3.88464, y:0.7513))
        myBezier.addCurveToPoint(CGPoint(x: 0.26072, y: 0.97227),
            controlPoint1: CGPoint(x: 3.13464, y:0.59505),
            controlPoint2: CGPoint(x: 0.52589, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.4375, y: 2.07712),
            controlPoint1: CGPoint(x: 0.10447, y:1.47227),
            controlPoint2: CGPoint(x: 0.0, y:1.54587))
        myBezier.addCurveToPoint(CGPoint(x: 13.07703, y: 5.56846),
            controlPoint1: CGPoint(x: 3.92884, y:4.5078),
            controlPoint2: CGPoint(x: 11.30926, y:5.48007))
        myBezier.addCurveToPoint(CGPoint(x: 13.31225, y: 3.25206),
            controlPoint1: CGPoint(x: 15.02157, y:5.34749),
            controlPoint2: CGPoint(x: 14.18725, y:4.03331))
        myBezier.addCurveToPoint(CGPoint(x: 11.37935, y: 2.30567),
            controlPoint1: CGPoint(x: 12.69353, y:2.81012),
            controlPoint2: CGPoint(x: 12.00435, y:2.49317))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: UIColor.redColor(),position: CGPoint(x: -56,y: 15),scale: 12.8)
        
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
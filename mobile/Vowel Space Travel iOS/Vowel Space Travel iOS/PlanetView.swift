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
    let shadowColor : UIColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.1)
    var hue : CGFloat = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame : frame)

        self.hue = 0.4
        
        self.drawBasePlanet(CGPoint(x: 40,y: 40))
        self.drawCraters()
        
        self.drawPlanetShadow()
        self.drawRing(1)
        
    }
    
    func drawBasePlanet(center: CGPoint)
    {
        var path : UIBezierPath = createCircularPath(center, size: self.planetSize)
        drawFilledInPath(path, color: UIColor(hue: self.hue, saturation: 0.32, brightness: 0.78, alpha: 1),position:CGPoint(x:0,y:0),scale: 1)
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
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 3,y: 10),scale: 0.43)
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
        drawFilledInPath(myBezier, color: UIColor(hue: self.hue, saturation: 0.6, brightness: 0.58, alpha: opacity),position: CGPoint(x: -56,y: 15),scale: 12.8)
        
        myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 3.52517, y:0.86872))
        myBezier.addCurveToPoint(CGPoint(x: 3.72405, y: 0.49307),
            controlPoint1: CGPoint(x: 3.52517, y:0.86872),
            controlPoint2: CGPoint(x: 3.6303, y:0.74307))
        myBezier.addCurveToPoint(CGPoint(x: 0.41235, y: 0.71877),
            controlPoint1: CGPoint(x: 2.86226, y:0.18371),
            controlPoint2: CGPoint(x: 0.72485, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 10.53477, y: 4.54647),
            controlPoint1: CGPoint(x: 0.0, y:2.04816),
            controlPoint2: CGPoint(x: 9.15222, y:4.26297))
        myBezier.addCurveToPoint(CGPoint(x: 13.68983, y: 4.23916),
            controlPoint1: CGPoint(x: 12.32647, y:4.77327),
            controlPoint2: CGPoint(x: 13.60144, y:5.06145))
        myBezier.addCurveToPoint(CGPoint(x: 11.15894, y: 2.27269),
            controlPoint1: CGPoint(x: 13.65883, y:3.25078),
            controlPoint2: CGPoint(x: 12.20696, y:2.40392))
        myBezier.addCurveToPoint(CGPoint(x: 11.16794, y: 2.81864),
            controlPoint1: CGPoint(x: 11.09644, y:2.55394),
            controlPoint2: CGPoint(x: 11.32419, y:2.50614))
        myBezier.addCurveToPoint(CGPoint(x: 13.11655, y: 4.14695),
            controlPoint1: CGPoint(x: 11.16794, y:2.81864),
            controlPoint2: CGPoint(x: 13.14669, y:3.53961))
        myBezier.addCurveToPoint(CGPoint(x: 1.12912, y: 0.88436),
            controlPoint1: CGPoint(x: 11.28249, y:4.39002),
            controlPoint2: CGPoint(x: 3.56662, y:2.58748))
        myBezier.addCurveToPoint(CGPoint(x: 3.52503, y: 0.86876),
            controlPoint1: CGPoint(x: 1.41638, y:0.61919),
            controlPoint2: CGPoint(x: 3.30628, y:0.99376))
        myBezier.addCurveToPoint(CGPoint(x: 3.52517, y: 0.86872),
            controlPoint1: CGPoint(x: 4.15003, y:0.77506),
            controlPoint2: CGPoint(x: 3.52517, y:0.86872))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2*opacity),position: CGPoint(x: -55,y: 20),scale: 12.8)
        
    }
    
    func drawCraters()
    {
        
        var myBezier = self.createCircularPath(CGPoint(x: 0,y: 0), size: 10)

        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 32,y: 37),scale: 1)

        myBezier = self.createCircularPath(CGPoint(x: 0,y: 0), size: 6)
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 50,y: 60),scale: 1)
        
        myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 0.34581, y:0.64149))
        myBezier.addCurveToPoint(CGPoint(x: 0.00799999999998, y: 0.55249),
            controlPoint1: CGPoint(x: 0.15672, y:0.70319),
            controlPoint2: CGPoint(x: 0.01024, y:0.66419))
        myBezier.addCurveToPoint(CGPoint(x: 0.29607, y: 0.17703),
            controlPoint1: CGPoint(x: 0.0, y:0.44884),
            controlPoint2: CGPoint(x: 0.12247, y:0.28967))
        myBezier.addCurveToPoint(CGPoint(x: 0.79968, y: 0.0449299999999),
            controlPoint1: CGPoint(x: 0.47506, y:0.05724),
            controlPoint2: CGPoint(x: 0.69303, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.77618, y: 0.36386),
            controlPoint1: CGPoint(x: 0.9117, y:0.0852299999999),
            controlPoint2: CGPoint(x: 0.90137, y:0.22322))
        myBezier.addCurveToPoint(CGPoint(x: 0.34578, y: 0.64148),
            controlPoint1: CGPoint(x: 0.6742, y:0.48185),
            controlPoint2: CGPoint(x: 0.50182, y:0.59336))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 8,y: 15),scale: 18)

        myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 0.34581, y:0.64149))
        myBezier.addCurveToPoint(CGPoint(x: 0.00799999999998, y: 0.55249),
            controlPoint1: CGPoint(x: 0.15672, y:0.70319),
            controlPoint2: CGPoint(x: 0.01024, y:0.66419))
        myBezier.addCurveToPoint(CGPoint(x: 0.29607, y: 0.17703),
            controlPoint1: CGPoint(x: 0.0, y:0.44884),
            controlPoint2: CGPoint(x: 0.12247, y:0.28967))
        myBezier.addCurveToPoint(CGPoint(x: 0.79968, y: 0.0449299999999),
            controlPoint1: CGPoint(x: 0.47506, y:0.05724),
            controlPoint2: CGPoint(x: 0.69303, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.77618, y: 0.36386),
            controlPoint1: CGPoint(x: 0.9117, y:0.0852299999999),
            controlPoint2: CGPoint(x: 0.90137, y:0.22322))
        myBezier.addCurveToPoint(CGPoint(x: 0.34578, y: 0.64148),
            controlPoint1: CGPoint(x: 0.6742, y:0.48185),
            controlPoint2: CGPoint(x: 0.50182, y:0.59336))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 60,y: 65),scale: 20)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 1.21951, y:0.49615))
        myBezier.addCurveToPoint(CGPoint(x: 0.97507, y: 0.65548),
            controlPoint1: CGPoint(x: 1.17541, y:0.58995),
            controlPoint2: CGPoint(x: 1.06939, y:0.63148))
        myBezier.addCurveToPoint(CGPoint(x: 0.37511, y: 0.60458),
            controlPoint1: CGPoint(x: 0.77603, y:0.70048),
            controlPoint2: CGPoint(x: 0.5653, y:0.67438))
        myBezier.addCurveToPoint(CGPoint(x: 0.0387, y: 0.35249),
            controlPoint1: CGPoint(x: 0.24409, y:0.55348),
            controlPoint2: CGPoint(x: 0.10803, y:0.48064))
        myBezier.addCurveToPoint(CGPoint(x: 0.0713, y: 0.13528),
            controlPoint1: CGPoint(x: 0.0, y:0.28269),
            controlPoint2: CGPoint(x: 0.0139, y:0.19066))
        myBezier.addCurveToPoint(CGPoint(x: 0.40215, y: 0.0126),
            controlPoint1: CGPoint(x: 0.1577, y:0.04918),
            controlPoint2: CGPoint(x: 0.28482, y:0.0228099999999))
        myBezier.addCurveToPoint(CGPoint(x: 1.03137, y: 0.15647),
            controlPoint1: CGPoint(x: 0.61938, y:0.0),
            controlPoint2: CGPoint(x: 0.84298, y:0.0456))
        myBezier.addCurveToPoint(CGPoint(x: 1.23387, y: 0.4023),
            controlPoint1: CGPoint(x: 1.12167, y:0.21297),
            controlPoint2: CGPoint(x: 1.21442, y:0.29195))
        myBezier.addCurveToPoint(CGPoint(x: 1.21957, y: 0.4962),
            controlPoint1: CGPoint(x: 1.23887, y:0.4341),
            controlPoint2: CGPoint(x: 1.2339, y:0.4674))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 30,y: 0),scale: 26)

        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 1.21951, y:0.49615))
        myBezier.addCurveToPoint(CGPoint(x: 0.97507, y: 0.65548),
            controlPoint1: CGPoint(x: 1.17541, y:0.58995),
            controlPoint2: CGPoint(x: 1.06939, y:0.63148))
        myBezier.addCurveToPoint(CGPoint(x: 0.37511, y: 0.60458),
            controlPoint1: CGPoint(x: 0.77603, y:0.70048),
            controlPoint2: CGPoint(x: 0.5653, y:0.67438))
        myBezier.addCurveToPoint(CGPoint(x: 0.0387, y: 0.35249),
            controlPoint1: CGPoint(x: 0.24409, y:0.55348),
            controlPoint2: CGPoint(x: 0.10803, y:0.48064))
        myBezier.addCurveToPoint(CGPoint(x: 0.0713, y: 0.13528),
            controlPoint1: CGPoint(x: 0.0, y:0.28269),
            controlPoint2: CGPoint(x: 0.0139, y:0.19066))
        myBezier.addCurveToPoint(CGPoint(x: 0.40215, y: 0.0126),
            controlPoint1: CGPoint(x: 0.1577, y:0.04918),
            controlPoint2: CGPoint(x: 0.28482, y:0.0228099999999))
        myBezier.addCurveToPoint(CGPoint(x: 1.03137, y: 0.15647),
            controlPoint1: CGPoint(x: 0.61938, y:0.0),
            controlPoint2: CGPoint(x: 0.84298, y:0.0456))
        myBezier.addCurveToPoint(CGPoint(x: 1.23387, y: 0.4023),
            controlPoint1: CGPoint(x: 1.12167, y:0.21297),
            controlPoint2: CGPoint(x: 1.21442, y:0.29195))
        myBezier.addCurveToPoint(CGPoint(x: 1.21957, y: 0.4962),
            controlPoint1: CGPoint(x: 1.23887, y:0.4341),
            controlPoint2: CGPoint(x: 1.2339, y:0.4674))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 30,y: 74),scale: 16)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 0.92123, y:0.37473))
        myBezier.addCurveToPoint(CGPoint(x: 0.99553, y: 1.076),
            controlPoint1: CGPoint(x: 1.05358, y:0.59288),
            controlPoint2: CGPoint(x: 1.08364, y:0.88192))
        myBezier.addCurveToPoint(CGPoint(x: 0.51585, y: 1.2926),
            controlPoint1: CGPoint(x: 0.91113, y:1.27394),
            controlPoint2: CGPoint(x: 0.71346, y:1.36372))
        myBezier.addCurveToPoint(CGPoint(x: 0.0716, y: 0.76613),
            controlPoint1: CGPoint(x: 0.32011, y:1.2286),
            controlPoint2: CGPoint(x: 0.13786, y:1.01206))
        myBezier.addCurveToPoint(CGPoint(x: 0.20201, y: 0.12871),
            controlPoint1: CGPoint(x: 0.0, y:0.51641),
            controlPoint2: CGPoint(x: 0.0534, y:0.25231))
        myBezier.addCurveToPoint(CGPoint(x: 0.75148, y: 0.17161),
            controlPoint1: CGPoint(x: 0.34567, y:0.0),
            controlPoint2: CGPoint(x: 0.57237, y:0.0184099999999))
        myBezier.addCurveToPoint(CGPoint(x: 0.92125, y: 0.37471),
            controlPoint1: CGPoint(x: 0.81628, y:0.22581),
            controlPoint2: CGPoint(x: 0.87446, y:0.29563))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 60,y: 30),scale: 18)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 0.51735, y:0.37491))
        myBezier.addCurveToPoint(CGPoint(x: 0.41594, y: 0.82695),
            controlPoint1: CGPoint(x: 0.54705, y:0.55444),
            controlPoint2: CGPoint(x: 0.50425, y:0.74569))
        myBezier.addCurveToPoint(CGPoint(x: 0.13383, y: 0.77095),
            controlPoint1: CGPoint(x: 0.33354, y:0.90785),
            controlPoint2: CGPoint(x: 0.21678, y:0.88555))
        myBezier.addCurveToPoint(CGPoint(x: 0.03043, y: 0.27254),
            controlPoint1: CGPoint(x: 0.04363, y:0.65355),
            controlPoint2: CGPoint(x: 0.0, y:0.44143))
        myBezier.addCurveToPoint(CGPoint(x: 0.24722, y: 0.00470000000007),
            controlPoint1: CGPoint(x: 0.05653, y:0.11076),
            controlPoint2: CGPoint(x: 0.14659, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.50425, y: 0.31009),
            controlPoint1: CGPoint(x: 0.35286, y:0.00486000000012),
            controlPoint2: CGPoint(x: 0.46192, y:0.13445))
        myBezier.addCurveToPoint(CGPoint(x: 0.51735, y: 0.37489),
            controlPoint1: CGPoint(x: 0.50925, y:0.33129),
            controlPoint2: CGPoint(x: 0.51425, y:0.35299))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 5,y: 45),scale: 28)
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
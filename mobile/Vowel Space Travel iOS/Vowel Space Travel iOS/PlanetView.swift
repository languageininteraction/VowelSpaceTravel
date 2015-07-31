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
    let generalDownScaleRatio : CGFloat = 0.3
    
    let planetSize : CGFloat = 50
    let shadowColor : UIColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.1)
    var planetColor : UIColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 1)
    var hue : CGFloat = 0
    
    var exampleWord : String = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, exampleWord : String, hue : CGFloat, ringOpacity : CGFloat)
    {
        super.init(frame : frame)
        
        self.exampleWord = exampleWord
        self.hue = hue
        self.planetColor = UIColor(hue: self.hue, saturation: 0.32, brightness: 0.78, alpha: 1)
        
        self.drawExternalCraters()
        self.drawBasePlanet(CGPoint(x: 40,y: 40))
        //self.drawInternalCraters()
        
        self.drawOcean()
        
        self.drawPlanetShadow()
        
        self.drawClouds(1);
        self.drawRing(ringOpacity)
        
        //This was made before I knew how large it would be... instead of changing all numbers, I scale down the whole thing
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.generalDownScaleRatio, self.generalDownScaleRatio);
        
        self.drawExampleWord()
        
    }
    
    func drawBasePlanet(center: CGPoint)
    {
        var path : UIBezierPath = createCircularPath(center, size: self.planetSize)
        drawFilledInPath(path, color: self.planetColor,position:CGPoint(x:0,y:0),scale: 1)
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

    func drawExternalCraters()
    {
        var myBezier : UIBezierPath
        
        //External craters
        myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 0.21115, y:9.99999997475e-06))
        myBezier.addCurveToPoint(CGPoint(x: 0.0352, y: 0.34939),
            controlPoint1: CGPoint(x: 0.18625, y:0.12865),
            controlPoint2: CGPoint(x: 0.13875, y:0.26308))
        myBezier.addCurveToPoint(CGPoint(x: 0.0362, y: 0.38019),
            controlPoint1: CGPoint(x: 0.00839999999999, y:0.36479),
            controlPoint2: CGPoint(x: 0.0, y:0.37389))
        myBezier.addCurveToPoint(CGPoint(x: 0.66227, y: 0.92572),
            controlPoint1: CGPoint(x: 0.30238, y:0.47839),
            controlPoint2: CGPoint(x: 0.51715, y:0.68572))
        myBezier.addCurveToPoint(CGPoint(x: 0.72907, y: 0.88162),
            controlPoint1: CGPoint(x: 0.67817, y:0.96792),
            controlPoint2: CGPoint(x: 0.69967, y:0.88682))
        myBezier.addCurveToPoint(CGPoint(x: 1.04244, y: 0.79052),
            controlPoint1: CGPoint(x: 0.82007, y:0.81802),
            controlPoint2: CGPoint(x: 0.93376, y:0.79842))
        myBezier.addCurveToPoint(CGPoint(x: 0.21086, y: 0.0),
            controlPoint1: CGPoint(x: 0.76525, y:0.52701),
            controlPoint2: CGPoint(x: 0.48805, y:0.26351))
        
        drawFilledInPath(myBezier, color: self.planetColor,position: CGPoint(x: -10,y: 60),scale: 18)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 0.6259, y:0.0863000000001))
        myBezier.addCurveToPoint(CGPoint(x: 0.34666, y: 0.028),
            controlPoint1: CGPoint(x: 0.5308, y:0.0858800000001),
            controlPoint2: CGPoint(x: 0.43053, y:0.0763000000001))
        myBezier.addCurveToPoint(CGPoint(x: 0.31886, y: 0.029),
            controlPoint1: CGPoint(x: 0.33216, y:0.019),
            controlPoint2: CGPoint(x: 0.31726, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.0624, y: 0.41152),
            controlPoint1: CGPoint(x: 0.28736, y:0.18413),
            controlPoint2: CGPoint(x: 0.18172, y:0.31288))
        myBezier.addCurveToPoint(CGPoint(x: 0.000300000000038, y: 0.46292),
            controlPoint1: CGPoint(x: 0.0472, y:0.42912),
            controlPoint2: CGPoint(x: 0.0, y:0.45102))
        myBezier.addCurveToPoint(CGPoint(x: 0.15337, y: 0.63069),
            controlPoint1: CGPoint(x: 0.0774, y:0.48602),
            controlPoint2: CGPoint(x: 0.12392, y:0.56062))
        myBezier.addCurveToPoint(CGPoint(x: 0.17907, y: 0.63769),
            controlPoint1: CGPoint(x: 0.15837, y:0.65889),
            controlPoint2: CGPoint(x: 0.16637, y:0.65879))
        myBezier.addCurveToPoint(CGPoint(x: 0.6259, y: 0.0862399999999),
            controlPoint1: CGPoint(x: 0.32801, y:0.45388),
            controlPoint2: CGPoint(x: 0.47696, y:0.27006))
        
        drawFilledInPath(myBezier, color: self.planetColor,position: CGPoint(x: -9,y: 5),scale: 22)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 1.99999999495e-05, y:0.28817))
        myBezier.addCurveToPoint(CGPoint(x: 0.1453, y: 0.0495),
            controlPoint1: CGPoint(x: 0.06312, y:0.21957),
            controlPoint2: CGPoint(x: 0.12276, y:0.14163))
        myBezier.addCurveToPoint(CGPoint(x: 0.1661, y: 0.0236),
            controlPoint1: CGPoint(x: 0.1503, y:0.0333999999999),
            controlPoint2: CGPoint(x: 0.1433, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 0.6054, y: 0.0965),
            controlPoint1: CGPoint(x: 0.29679, y:0.1029),
            controlPoint2: CGPoint(x: 0.45677, y:0.1143))
        myBezier.addCurveToPoint(CGPoint(x: 0.7038, y: 0.0785999999999),
            controlPoint1: CGPoint(x: 0.6385, y:0.0925),
            controlPoint2: CGPoint(x: 0.6714, y:0.0865))
        myBezier.addCurveToPoint(CGPoint(x: 0.7148, y: 0.29684),
            controlPoint1: CGPoint(x: 0.6668, y:0.1468),
            controlPoint2: CGPoint(x: 0.6862, y:0.22941))
        myBezier.addCurveToPoint(CGPoint(x: 0.7128, y: 0.33374),
            controlPoint1: CGPoint(x: 0.7218, y:0.31564),
            controlPoint2: CGPoint(x: 0.7462, y:0.34284))
        myBezier.addCurveToPoint(CGPoint(x: 0.0, y: 0.28814),
            controlPoint1: CGPoint(x: 0.4752, y:0.31854),
            controlPoint2: CGPoint(x: 0.2376, y:0.30334))
        
        drawFilledInPath(myBezier, color: self.planetColor,position: CGPoint(x: 30,y: -16),scale: 25)
        
        myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 0.31355, y:1.17041))
        myBezier.addCurveToPoint(CGPoint(x: 0.66945, y: 1.03234),
            controlPoint1: CGPoint(x: 0.40785, y:1.08231),
            controlPoint2: CGPoint(x: 0.53637, y:1.01078))
        myBezier.addCurveToPoint(CGPoint(x: 0.63095, y: 0.96574),
            controlPoint1: CGPoint(x: 0.68285, y:1.02734),
            controlPoint2: CGPoint(x: 0.63935, y:0.98634))
        myBezier.addCurveToPoint(CGPoint(x: 0.39616, y: 0.15208),
            controlPoint1: CGPoint(x: 0.47613, y:0.72497),
            controlPoint2: CGPoint(x: 0.39706, y:0.43766))
        myBezier.addCurveToPoint(CGPoint(x: 0.30816, y: 0.14708),
            controlPoint1: CGPoint(x: 0.39116, y:0.12918),
            controlPoint2: CGPoint(x: 0.33466, y:0.16228))
        myBezier.addCurveToPoint(CGPoint(x: 0.0, y: 0.0),
            controlPoint1: CGPoint(x: 0.19424, y:0.12778),
            controlPoint2: CGPoint(x: 0.09305, y:0.06558))
        myBezier.addCurveToPoint(CGPoint(x: 0.31455, y: 1.08826),
            controlPoint1: CGPoint(x: 0.18294, y:0.3333),
            controlPoint2: CGPoint(x: 0.30177, y:0.70671))
        myBezier.addCurveToPoint(CGPoint(x: 0.31355, y: 1.17006),
            controlPoint1: CGPoint(x: 0.3151, y:1.11556),
            controlPoint2: CGPoint(x: 0.31518, y:1.14286))
        
        drawFilledInPath(myBezier, color: self.planetColor,position: CGPoint(x: 80,y: 10),scale: 22)
        drawFilledInPath(myBezier, color: self.shadowColor,position: CGPoint(x: 80,y: 10),scale: 22)
        
    }
    
    func drawInternalCraters()
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
    
    func drawOcean()
    {
        var myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 1.14061, y:1.35928))
        myBezier.addCurveToPoint(CGPoint(x: 1.14061, y: 2.90615),
            controlPoint1: CGPoint(x: 1.14061, y:1.35928),
            controlPoint2: CGPoint(x: 0.90623, y:2.53115))
        myBezier.addCurveToPoint(CGPoint(x: 2.01561, y: 2.84365),
            controlPoint1: CGPoint(x: 1.24999, y:3.0624),
            controlPoint2: CGPoint(x: 1.65623, y:3.1874))
        myBezier.addCurveToPoint(CGPoint(x: 2.42186, y: 3.8749),
            controlPoint1: CGPoint(x: 2.37499, y:2.98428),
            controlPoint2: CGPoint(x: 1.95311, y:3.96865))
        myBezier.addCurveToPoint(CGPoint(x: 4.87498, y: 1.95303),
            controlPoint1: CGPoint(x: 3.06248, y:3.59365),
            controlPoint2: CGPoint(x: 3.18748, y:1.8749))
        myBezier.addCurveToPoint(CGPoint(x: 6.26561, y: 1.8437),
            controlPoint1: CGPoint(x: 5.18749, y:2.04673),
            controlPoint2: CGPoint(x: 5.93748, y:2.95308))
        myBezier.addCurveToPoint(CGPoint(x: 3.73436, y: 0.0312),
            controlPoint1: CGPoint(x: 6.39061, y:1.60932),
            controlPoint2: CGPoint(x: 5.49999, y:0.42183))
        myBezier.addCurveToPoint(CGPoint(x: 6.90624, y: 1.31245),
            controlPoint1: CGPoint(x: 4.98436, y:0.18745),
            controlPoint2: CGPoint(x: 5.68749, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 7.95311, y: 3.43745),
            controlPoint1: CGPoint(x: 6.90624, y:1.31245),
            controlPoint2: CGPoint(x: 7.98436, y:2.5312))
        myBezier.addCurveToPoint(CGPoint(x: 6.40624, y: 2.89058),
            controlPoint1: CGPoint(x: 7.95311, y:3.43745),
            controlPoint2: CGPoint(x: 6.68749, y:2.74995))
        myBezier.addCurveToPoint(CGPoint(x: 7.06249, y: 4.42183),
            controlPoint1: CGPoint(x: 6.03124, y:3.28121),
            controlPoint2: CGPoint(x: 7.29687, y:4.23433))
        myBezier.addCurveToPoint(CGPoint(x: 5.82811, y: 5.95308),
            controlPoint1: CGPoint(x: 6.65624, y:4.76558),
            controlPoint2: CGPoint(x: 6.62499, y:5.79683))
        myBezier.addCurveToPoint(CGPoint(x: 5.75001, y: 7.56245),
            controlPoint1: CGPoint(x: 5.31248, y:6.03118),
            controlPoint2: CGPoint(x: 6.34374, y:7.07807))
        myBezier.addCurveToPoint(CGPoint(x: 4.04688, y: 7.76558),
            controlPoint1: CGPoint(x: 5.75001, y:7.56245),
            controlPoint2: CGPoint(x: 4.37501, y:7.99996))
        myBezier.addCurveToPoint(CGPoint(x: 4.84376, y: 6.7187),
            controlPoint1: CGPoint(x: 4.04688, y:7.76558),
            controlPoint2: CGPoint(x: 4.67188, y:7.18745))
        myBezier.addCurveToPoint(CGPoint(x: 4.89066, y: 5.7187),
            controlPoint1: CGPoint(x: 5.03126, y:6.48432),
            controlPoint2: CGPoint(x: 4.70316, y:5.95308))
        myBezier.addCurveToPoint(CGPoint(x: 5.82816, y: 4.57808),
            controlPoint1: CGPoint(x: 5.07811, y:5.42183),
            controlPoint2: CGPoint(x: 5.37503, y:5.32808))
        myBezier.addCurveToPoint(CGPoint(x: 4.64066, y: 3.4687),
            controlPoint1: CGPoint(x: 5.92186, y:4.39058),
            controlPoint2: CGPoint(x: 5.87506, y:3.26557))
        myBezier.addCurveToPoint(CGPoint(x: 3.34379, y: 5.45308),
            controlPoint1: CGPoint(x: 4.10941, y:3.57808),
            controlPoint2: CGPoint(x: 3.76567, y:5.32808))
        myBezier.addCurveToPoint(CGPoint(x: 1.42191, y: 6.8437),
            controlPoint1: CGPoint(x: 3.34379, y:5.45308),
            controlPoint2: CGPoint(x: 2.03129, y:6.14057))
        myBezier.addCurveToPoint(CGPoint(x: 0.23441, y: 4.3437),
            controlPoint1: CGPoint(x: 1.42191, y:6.8437),
            controlPoint2: CGPoint(x: 0.20316, y:5.56245))
        myBezier.addCurveToPoint(CGPoint(x: 1.14063, y: 1.35928),
            controlPoint1: CGPoint(x: 0.23441, y:4.3437),
            controlPoint2: CGPoint(x: 0.0, y:2.59366))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: UIColor(hue: 0.57, saturation: 0.49, brightness: 0.8, alpha: 1),position: CGPoint(x: -11.5,y: -10),scale: 12.8)
    }
    
    func drawClouds(size : CGFloat)
    {
        var myBezier = UIBezierPath()
        let cloudColor : UIColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.8)

        myBezier.moveToPoint(CGPoint(x: 3.2343, y:1.36018))
        myBezier.addCurveToPoint(CGPoint(x: 0.0, y: 1.27378),
            controlPoint1: CGPoint(x: 3.2343, y:1.36018),
            controlPoint2: CGPoint(x: 1.3181, y:1.51129))
        myBezier.addCurveToPoint(CGPoint(x: 1.6393, y: 0.88517),
            controlPoint1: CGPoint(x: 0.43353, y:0.26216),
            controlPoint2: CGPoint(x: 1.33865, y:0.50671))
        myBezier.addCurveToPoint(CGPoint(x: 2.72479, y: 0.10796),
            controlPoint1: CGPoint(x: 1.6393, y:0.88517),
            controlPoint2: CGPoint(x: 1.7168, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 3.45583, y: 0.71246),
            controlPoint1: CGPoint(x: 3.47798, y:0.09716),
            controlPoint2: CGPoint(x: 3.45583, y:0.71246))
        myBezier.addCurveToPoint(CGPoint(x: 4.51916, y: 0.45338),
            controlPoint1: CGPoint(x: 3.45583, y:0.71246),
            controlPoint2: CGPoint(x: 3.84351, y:0.26987))
        myBezier.addCurveToPoint(CGPoint(x: 4.785, y: 1.36014),
            controlPoint1: CGPoint(x: 5.08359, y:0.60505),
            controlPoint2: CGPoint(x: 4.80432, y:1.3185))
        myBezier.addCurveToPoint(CGPoint(x: 3.2343, y: 1.36016),
            controlPoint1: CGPoint(x: 3.97485, y:1.44254),
            controlPoint2: CGPoint(x: 3.81028, y:1.39224))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: cloudColor,position: CGPoint(x: 15,y: 44),scale: 18*size)

        myBezier = UIBezierPath()
        
        myBezier.moveToPoint(CGPoint(x: 2.28863, y:1.74058))
        myBezier.addCurveToPoint(CGPoint(x: 6.29132, y: 1.63005),
            controlPoint1: CGPoint(x: 2.28863, y:1.74058),
            controlPoint2: CGPoint(x: 4.66008, y:1.93396))
        myBezier.addCurveToPoint(CGPoint(x: 4.26257, y: 1.13274),
            controlPoint1: CGPoint(x: 5.75481, y:0.33548),
            controlPoint2: CGPoint(x: 4.63464, y:0.64842))
        myBezier.addCurveToPoint(CGPoint(x: 2.91919, y: 0.13814),
            controlPoint1: CGPoint(x: 4.26257, y:1.13274),
            controlPoint2: CGPoint(x: 4.16667, y:0.0))
        myBezier.addCurveToPoint(CGPoint(x: 2.01448, y: 0.91172),
            controlPoint1: CGPoint(x: 1.98706, y:0.12424),
            controlPoint2: CGPoint(x: 2.01448, y:0.91172))
        myBezier.addCurveToPoint(CGPoint(x: 0.69852, y: 0.58019),
            controlPoint1: CGPoint(x: 2.01448, y:0.91172),
            controlPoint2: CGPoint(x: 1.53469, y:0.34535))
        myBezier.addCurveToPoint(CGPoint(x: 0.36953, y: 1.74056),
            controlPoint1: CGPoint(x: 0.0, y:0.77428),
            controlPoint2: CGPoint(x: 0.34562, y:1.68728))
        myBezier.addCurveToPoint(CGPoint(x: 2.28863, y: 1.74058),
            controlPoint1: CGPoint(x: 1.37215, y:1.84601),
            controlPoint2: CGPoint(x: 1.57581, y:1.78166))
        
        //The values below were found by trial and error
        drawFilledInPath(myBezier, color: cloudColor,position: CGPoint(x: -20,y: 8),scale: 11*size)
    
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
    
    func drawExampleWord()
    {
        var label : UILabel = UILabel();
        label.font = UIFont(name: "Muli", size: 150)
        label.frame = CGRectMake(0,100, 80,20)
        label.textAlignment = NSTextAlignment.Center
        label.text = self.exampleWord
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
    }
}
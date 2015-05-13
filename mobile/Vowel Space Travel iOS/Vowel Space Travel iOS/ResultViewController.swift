//
//  ResultViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: SubViewController {
    
    //Layout properties
    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    var currentGame : Game?
    
    //Results
    var numberOfCorrectAnswers : Int = 0
    var totalNumberOfAnswers : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Display a label
        var label = UILabel();
        var labelWidth : CGFloat = 300
        var labelHeigth : CGFloat = 30
        var distanceAboveCenter : CGFloat = 100
        
        label.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - distanceAboveCenter,labelWidth,labelHeigth)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Helvetica",size: 30)
        label.text = "Results: \(self.numberOfCorrectAnswers)/\(self.totalNumberOfAnswers) correct"
        
        self.view.addSubview(label)
        
        //Create the finish button
        let buttonWidth : CGFloat = 300
        let buttonHeight : CGFloat = 70
        
        let againButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+100,buttonWidth,buttonHeight))
        againButton.setTitle("Again with the same settings", forState: UIControlState.Normal)
        againButton.addTarget(self, action: "againButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(againButton)

        let backButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+200,buttonWidth,buttonHeight))
        backButton.setTitle("Back to the main menu", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func againButtonPressed()
    {
        self.currentGame!.stage = GameStage.Playing
        self.superController!.subControllerFinished(self)
    }
    
    func backButtonPressed()
    {
        self.currentGame!.stage = GameStage.Finished
        self.superController!.subControllerFinished(self)
    }
}
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
    
    var timer : NSTimer = NSTimer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Display a label
        var resultsLabel = UILabel();
        var labelWidth : CGFloat = 300
        var labelHeigth : CGFloat = 30
        var resultsLabelDistanceAboveCenter : CGFloat = 100
        
        resultsLabel.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - resultsLabelDistanceAboveCenter,labelWidth,labelHeigth)
        resultsLabel.textAlignment = NSTextAlignment.Center
        resultsLabel.font = UIFont(name: "Helvetica",size: 30)
        resultsLabel.text = "Results: \(self.numberOfCorrectAnswers)/\(self.totalNumberOfAnswers) correct"
        
        self.view.addSubview(resultsLabel)
        
        if self.currentGame!.autoPilotMode
        {
            var stopAutoPilotLabel = UILabel();
            var stopAutoPilotLabelDistanceAboveCenter : CGFloat = 0
            
            stopAutoPilotLabel.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - stopAutoPilotLabelDistanceAboveCenter,labelWidth,labelHeigth)
            stopAutoPilotLabel.textAlignment = NSTextAlignment.Center
            stopAutoPilotLabel.text = "Shake your device if you want to stop"
            
            self.view.addSubview(stopAutoPilotLabel)
        }
        else
        {
            //Create the finish button
            let normalButtonWidth : CGFloat = 300
            let normalButtonHeight : CGFloat = 70
            let againButtonWidth : CGFloat = normalButtonWidth * 2;
            let againButtonHeight : CGFloat = normalButtonHeight * 2;
            let distanceFromSide : CGFloat = 50;
            let distanceFromBottom : CGFloat = 50;
            
            let againButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-againButtonWidth-distanceFromSide,self.screenHeight!-againButtonHeight-distanceFromBottom,againButtonWidth,againButtonHeight))
            againButton.setTitle("Again with the same settings", forState: UIControlState.Normal)
            againButton.addTarget(self, action: "againButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(againButton)

            let backButton = TempStyledButton(frame: CGRectMake(distanceFromSide,self.screenHeight!-normalButtonHeight-distanceFromBottom,normalButtonWidth,normalButtonHeight))
            backButton.setTitle("Back to the main menu", forState: UIControlState.Normal)
            backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(backButton)
        }
        
    }
    
    override func viewDidAppear(animated : Bool)
    {        
        if self.currentGame!.autoPilotMode
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(kPauseBetweenRounds, target: self, selector: Selector("goBackToTheHomeScreen"), userInfo: nil, repeats: false)
        }
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
        self.goBackToTheHomeScreen()
    }
    
    func goBackToTheHomeScreen()
    {
        self.currentGame!.stage = GameStage.Finished
        self.superController!.subControllerFinished(self)
    }

    func pilotModeFinished()
    {
        self.currentGame!.autoPilotMode = false
        self.goBackToTheHomeScreen()
    }
}
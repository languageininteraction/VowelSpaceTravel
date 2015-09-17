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
    var exposedStimuli = [Stimulus]()
    var nrOfTruePositives : Int = 0
    var nrOfFalsePositives : Int = 0
    var nrOfTrueNegatives : Int = 0
    var nrOfFalseNegatives : Int = 0
    var nrOfCorrectAnswers : Int = 0

    var timer : NSTimer = NSTimer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.calculateStatistics()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Show the background image
        var backgroundImageView = UIImageView(image: UIImage(named: "results_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        //Display a label
        var labelWidth : CGFloat = 600
        
        let proportionCorrect : CGFloat = CGFloat(self.nrOfCorrectAnswers) / CGFloat(self.exposedStimuli.count - 1)
        
        self.showCenterFieldLabel("\(Int(100*proportionCorrect))% correct", frame: CGRectMake(0.5*(self.screenWidth!-labelWidth)-10,160,labelWidth,60), fontSize: 60)
        self.showCenterFieldLabel("Target \(self.nrOfTruePositives)/\(self.nrOfTruePositives+self.nrOfFalseNegatives) correct", frame: CGRectMake(0.5*(self.screenWidth!-labelWidth)-10,270,labelWidth,30), fontSize: 20, brightness: 0.6)
        self.showCenterFieldLabel("Non-target \(self.nrOfTrueNegatives)/\(self.nrOfTrueNegatives+self.nrOfFalsePositives) correct", frame: CGRectMake(0.5*(self.screenWidth!-labelWidth)-10,290,labelWidth,30), fontSize: 20, brightness: 0.6)
        
        if self.currentGame!.autoPilotMode
        {
            var stopAutoPilotLabel = UILabel();
            var stopAutoPilotLabelDistanceAboveCenter : CGFloat = 0
            
            self.showCenterFieldLabel("Shake your device if you want to stop", frame: CGRectMake(0.5*(self.screenWidth!-labelWidth)-10,400,labelWidth,40), fontSize: 20)
            
            self.view.addSubview(stopAutoPilotLabel)
        }
        else
        {
            //Create the finish button
            let backButtonLeft : CGFloat = 220
            let backButtonWidth : CGFloat = 250
            
            let againButtonLeft : CGFloat = 500
            let againButtonWidth : CGFloat = 325
            
            let buttonHeight : CGFloat = 70
            let buttonTop : CGFloat = 385
            
            let buttonLabelOffsetLeft : CGFloat = 15
            let buttonLabelDecreaseHeight : CGFloat = 12
            
            let backButton = UIButton(frame: CGRectMake(backButtonLeft,buttonTop,backButtonWidth,buttonHeight))
            backButton.setTitle("Back to the main menu", forState: UIControlState.Normal)
            backButton.setImage(UIImage(named: "back_button"), forState: UIControlState.Normal)
            backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(backButton)
            
            let againButton = UIButton(frame: CGRectMake(againButtonLeft,buttonTop,againButtonWidth,buttonHeight))
            againButton.setImage(UIImage(named: "retry_button"), forState: UIControlState.Normal)
            againButton.addTarget(self, action: "againButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(againButton)

            var backButtonLabel : UILabel = UILabel();
            backButtonLabel.frame = CGRectMake(backButtonLeft+buttonLabelOffsetLeft,buttonTop,backButtonWidth,buttonHeight-buttonLabelDecreaseHeight)
            backButtonLabel.textAlignment = NSTextAlignment.Center
            backButtonLabel.text = "Back to the menu"
            backButtonLabel.textColor = UIColor.whiteColor()
            backButtonLabel.font = UIFont(name: "Muli",size:16)
            self.view.addSubview(backButtonLabel)

            var againButtonLabel : UILabel = UILabel();
            againButtonLabel.frame = CGRectMake(againButtonLeft+buttonLabelOffsetLeft,buttonTop,againButtonWidth,buttonHeight-buttonLabelDecreaseHeight)
            againButtonLabel.textAlignment = NSTextAlignment.Center
            againButtonLabel.text = "Again with the same settings"
            againButtonLabel.textColor = UIColor.whiteColor()
            againButtonLabel.font = UIFont(name: "Muli",size:16)
            self.view.addSubview(againButtonLabel)
            
        }

        //Add the pan gestures
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))        
        
    }
    
    override func viewDidAppear(animated : Bool)
    {        
        if self.currentGame!.autoPilotMode
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(kPauseBetweenRounds, target: self, selector: Selector("goBackToTheHomeScreen"), userInfo: nil, repeats: false)
        }
    }
    
    func calculateStatistics()
    {
        var counter : Int = 0
        
        for stimulus in self.exposedStimuli
        {
            //This feels weird, but I can't figure out a more elegant way to do it
            counter++
            
            if counter == 1
            {
                println("Skipping one")
                continue
            }
            
            //If there is no data to this stimulus, it's the example one, which is always correct
            if stimulus.receivedResponse == nil
            {
                self.nrOfTruePositives++
                continue
            }
            
            if stimulus.requiresResponse
            {
                if stimulus.receivedResponse!
                {
                    self.nrOfTruePositives++
                }
                else
                {
                    self.nrOfFalseNegatives++
                }
            }
            else
            {
                if stimulus.receivedResponse!
                {
                    self.nrOfFalsePositives++
                }
                else
                {
                    self.nrOfTrueNegatives++
                }
            }
        }
        
        self.nrOfCorrectAnswers = self.nrOfTruePositives + self.nrOfTrueNegatives
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showCenterFieldLabel(text : String, frame : CGRect, fontSize : CGFloat, brightness : CGFloat = 0.4)
    {
        //Shows text, in the style of the text in the centerfield
        
        var label : UILabel = UILabel();
        label.frame = frame
        label.text = text
        label.textColor = UIColor(hue: 0, saturation: 0, brightness: brightness, alpha: 1)
        label.font = UIFont(name: "Muli",size:fontSize)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
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
    
    func handlePan(recognizer : UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            var startLocation : CGPoint = recognizer.locationInView(self.view)
            
            if kShowTouchLocation
            {
                println(startLocation)
            }
        }
    }
    
}
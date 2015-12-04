//
//  SettingsViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 16/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

//
//  LoginViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: SubViewController, UIPopoverControllerDelegate {
    
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?

    var downloadBarView : DownloadBarView = DownloadBarView(frame: CGRectMake(14,14,28,715))
    
    var currentGame : Game?
    var availableVowels : [String : VowelDefinition]?
    var server : VSTServer?
    
    var singleOrMultipleSpeakerSegmentedControl = UISegmentedControl()
    var sameOrDifferentStartingSoundSegmentedControl = UISegmentedControl()
    var autoPilotSegmentedControl = UISegmentedControl()
    
    var vowelIndicatorLabel = UILabel()
    var taskIndicatorLabel = UILabel()
    var popoverController : UIPopoverController?
    
    var numberOfRoundsStepper = UIStepper()
    var numberOfRoundsIndicator = UILabel()
    
    var readyForTask : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Show the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "control_panel_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        //Create the labels
        let topLabelWidth : CGFloat = 700
        let difficultyLabelLeft : CGFloat = 325
        let difficultyLabelWidth : CGFloat = 120
 
        self.showCenterFieldLabel("Back", frame: CGRectMake(800,322,difficultyLabelWidth,50), fontSize: 12)
        
        self.showCenterFieldLabel("Adjust settings as required", frame: CGRectMake(0.5*(self.screenWidth!-topLabelWidth)-10,70,topLabelWidth,50), fontSize: 25)
        self.showCenterFieldLabel("Difficulty", frame: CGRectMake(0.5*(self.screenWidth!-topLabelWidth)-10,135,topLabelWidth,50), fontSize: 20)
        self.showCenterFieldLabel("Mission", frame: CGRectMake(0.5*(self.screenWidth!-topLabelWidth),420,topLabelWidth,50), fontSize: 20)

        self.showCenterFieldLabel("Talkers", frame: CGRectMake(difficultyLabelLeft,210,difficultyLabelWidth,50), fontSize: 14)
        self.showCenterFieldLabel("Word onset", frame: CGRectMake(difficultyLabelLeft,310,difficultyLabelWidth,50), fontSize: 14)
        self.showCenterFieldLabel("Mode", frame: CGRectMake(difficultyLabelLeft,490,difficultyLabelWidth,50), fontSize: 14)

        let difficultyOptionLabel1Left : CGFloat = 445
        let difficultyOptionLabel2Left : CGFloat = 555
        
        self.showCenterFieldLabel("Single", frame: CGRectMake(difficultyOptionLabel1Left,250,difficultyLabelWidth,50), fontSize: 12)
        self.showCenterFieldLabel("Multiple", frame: CGRectMake(difficultyOptionLabel2Left,250,difficultyLabelWidth,50), fontSize: 12)

        self.showCenterFieldLabel("Same", frame: CGRectMake(difficultyOptionLabel1Left,350,difficultyLabelWidth,50), fontSize: 12)
        self.showCenterFieldLabel("Different", frame: CGRectMake(difficultyOptionLabel2Left,350,difficultyLabelWidth,50), fontSize: 12)

        self.showCenterFieldLabel("Manual", frame: CGRectMake(difficultyOptionLabel1Left,530,difficultyLabelWidth,50), fontSize: 12)
        self.showCenterFieldLabel("Autopilot", frame: CGRectMake(difficultyOptionLabel2Left,530,difficultyLabelWidth,50), fontSize: 12)
        
        //Create the segmented control to select how many speakers you want
        let speakerSegmentedControlDistanceFromTop : CGFloat = 210
        let segmentedControlWidth : CGFloat = 225
        let segmentedControlHeight : CGFloat = 50
        let segmentedControlLeft : CGFloat = 450

        self.singleOrMultipleSpeakerSegmentedControl = ReselectableSegmentedControl(items: ["",""])
        
        if self.currentGame!.multipleSpeakers
        {
            self.singleOrMultipleSpeakerSegmentedControl.selectedSegmentIndex = 1
        }
        else
        {
            self.singleOrMultipleSpeakerSegmentedControl.selectedSegmentIndex = 0
        }
        
        self.singleOrMultipleSpeakerSegmentedControl.frame = CGRect(x: segmentedControlLeft,y: speakerSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)

        //Custom appearance of the segmented control
        self.singleOrMultipleSpeakerSegmentedControl.setBackgroundImage(UIImage(named: "segmented_control_background"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.singleOrMultipleSpeakerSegmentedControl.setBackgroundImage(UIImage(named: "segmented_control_foreground"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        self.singleOrMultipleSpeakerSegmentedControl.tintColor = UIColor.clearColor()
        self.singleOrMultipleSpeakerSegmentedControl.addTarget(self, action: "segmentedControlTouched:", forControlEvents: UIControlEvents.AllEvents)
        
        self.view.addSubview(self.singleOrMultipleSpeakerSegmentedControl)
        
        //Create the segmented control to select whether you want variation in the starting sound
        let soundsSegmentedControlDistanceFromTop : CGFloat = 310
        
        self.sameOrDifferentStartingSoundSegmentedControl = ReselectableSegmentedControl(items: ["",""])

        if self.currentGame!.differentStartingSounds
        {
            self.sameOrDifferentStartingSoundSegmentedControl.selectedSegmentIndex = 1
        }
        else
        {
            self.sameOrDifferentStartingSoundSegmentedControl.selectedSegmentIndex = 0
        }
        
        self.sameOrDifferentStartingSoundSegmentedControl.frame = CGRect(x: segmentedControlLeft,y: soundsSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)

        self.sameOrDifferentStartingSoundSegmentedControl.setBackgroundImage(UIImage(named: "segmented_control_background"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.sameOrDifferentStartingSoundSegmentedControl.setBackgroundImage(UIImage(named: "segmented_control_foreground"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        self.sameOrDifferentStartingSoundSegmentedControl.tintColor = UIColor.clearColor()
        self.sameOrDifferentStartingSoundSegmentedControl.addTarget(self, action: "segmentedControlTouched:", forControlEvents: UIControlEvents.AllEvents)
        
        self.view.addSubview(self.sameOrDifferentStartingSoundSegmentedControl)
        
        //Create the autopilot segmented control
        let autoPilotSegmentedControlDistanceFromTop : CGFloat = 490
        
        self.autoPilotSegmentedControl = ReselectableSegmentedControl(items: ["",""])
        self.autoPilotSegmentedControl.selectedSegmentIndex = 0
        self.autoPilotSegmentedControl.frame = CGRect(x: segmentedControlLeft, y: autoPilotSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)

        self.autoPilotSegmentedControl.setBackgroundImage(UIImage(named: "segmented_control_background"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.autoPilotSegmentedControl.setBackgroundImage(UIImage(named: "playmode_segmented_control_foreground"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        self.autoPilotSegmentedControl.tintColor = UIColor.clearColor()
        self.autoPilotSegmentedControl.addTarget(self, action: "segmentedControlTouched:", forControlEvents: UIControlEvents.AllEvents)
        
        self.view.addSubview(self.autoPilotSegmentedControl)
        
        //Create the buttons
        let buttonWidth : CGFloat = 180
        let buttonHeight : CGFloat = 70
        
        let readyButton = UIButton(frame: CGRectMake(410,605,buttonWidth,buttonHeight))
        readyButton.setImage(UIImage(named: "launch_button"), forState: UIControlState.Normal)
        readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(readyButton)

        let readyButtonLabel : UILabel = UILabel();
        readyButtonLabel.frame = CGRectMake(425,598,buttonWidth,buttonHeight)
        readyButtonLabel.textAlignment = NSTextAlignment.Center
        readyButtonLabel.text = "Launch"
        readyButtonLabel.textColor = UIColor.whiteColor()
        readyButtonLabel.font = UIFont(name: "Muli",size:20)
        self.view.addSubview(readyButtonLabel)
        
        let backWindowButton = UIButton(frame: CGRectMake(750,60,220,300))
        //backWindowButton.backgroundColor = UIColor.redColor()
        backWindowButton.addTarget(self, action: "backWindowButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backWindowButton)
        
        //Add the pan gestures
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
        self.downloadBarView.updatePercentage(0)
        self.view.addSubview(self.downloadBarView)
        
    }

    override func viewDidAppear(animated: Bool)
    {
        print("\(self.currentGame!.stage.rawValue)")
        
        if (self.currentGame!.stage == GameStage.Playing)
        {
            self.readyButtonPressed()
        }
    
    }
    
    func startDownloadingStimulusFiles()
    {
        var counter : Int = 0
        var percentageDone : CGFloat = 0.0
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

        self.downloadBarView.updatePercentage(0.1)
        //sleep(1)
        self.downloadBarView.updatePercentage(0.2)
        
        dispatch_async(backgroundQueue,
            {
                for stimulus in self.currentGame!.stimuli
                {
                    stimulus.fileLocation = kCachedStimuliLocation+"\(stimulus.sampleID)"+kSoundFileExtension
                    self.server!.downloadSampleWithID(stimulus.sampleID,fileSafePath: stimulus.fileLocation!)
                    
                    percentageDone = CGFloat(counter) / CGFloat(self.currentGame!.stimuli.count)

                    self.downloadBarView.updatePercentage(percentageDone)
                    self.view.addSubview(self.downloadBarView)
                    
                    counter++;
                }
                
                dispatch_async(dispatch_get_main_queue(),
                    {
                        () -> Void in
                        self.downloadingCompleted()
                })
            })
        
        self.downloadBarView.updatePercentage(1)
        
    }
    
    func showCenterFieldLabel(text : String, frame : CGRect, fontSize : CGFloat)
    {
        //Shows text, in the style of the text in the centerfield
        
        let label : UILabel = UILabel();
        label.frame = frame
        label.text = text
        label.textColor = UIColor(hue: 0, saturation: 0, brightness: 0.3, alpha: 1)
        label.font = UIFont(name: "Muli",size:fontSize)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
    }
    
    func readyButtonPressed()
    {
        //Interpret all settings
        self.currentGame!.multipleSpeakers = self.singleOrMultipleSpeakerSegmentedControl.selectedSegmentIndex == 1
        self.currentGame!.differentStartingSounds = self.sameOrDifferentStartingSoundSegmentedControl.selectedSegmentIndex == 1
        self.currentGame!.autoPilotMode = self.autoPilotSegmentedControl.selectedSegmentIndex == 1

        //Collect stimulus info
        self.server!.getStimuliForSettings(self.currentGame!)
            {
                (stimuli,err) -> Void in
                self.currentGame!.stimuli = stimuli
                
                //When finished, start the download
                self.startDownloadingStimulusFiles()
        }
        
    }
    
    func downloadingCompleted()
    {
        self.readyForTask = true
        self.superController!.subControllerFinished(self)
    }
    
    func backWindowButtonPressed()
    {
        self.superController!.subControllerFinished(self)
    }
    
    func segmentedControlTouched(segmentedControl : UISegmentedControl)
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            segmentedControl.selectedSegmentIndex = 1
        }
        else
        {
            segmentedControl.selectedSegmentIndex = 0
        }

    }
    
    func handlePan(recognizer : UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            let startLocation : CGPoint = recognizer.locationInView(self.view)
            
            if kShowTouchLocation
            {
                print(startLocation)
            }
        }
    }
}
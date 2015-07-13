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
    
    var currentGame : Game?
    var availableVowels : [String : VowelDefinition]?
    
    var singleOrMultipleSpeakerSegmentedControl = UISegmentedControl()
    var sameOrDifferentStartingSoundSegmentedControl = UISegmentedControl()
    var autoPilotSegmentedControl = UISegmentedControl()
    
    var vowelIndicatorLabel = UILabel()
    var taskIndicatorLabel = UILabel()
    var popoverController : UIPopoverController?
    
    var numberOfRoundsStepper = UIStepper()
    var numberOfRoundsIndicator = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Create the top labels
        var topLabelWidth : CGFloat = 700;
        var topLabelHeight : CGFloat = 50;
        
        var suggestedSettingsLabel = UILabel();
        var suggestedSettingsLabelDistanceFromTop : CGFloat = 50;
        
        suggestedSettingsLabel.frame = CGRectMake(0.5*(self.screenWidth!-topLabelWidth),suggestedSettingsLabelDistanceFromTop,topLabelWidth,topLabelHeight)
        suggestedSettingsLabel.textAlignment = NSTextAlignment.Center
        suggestedSettingsLabel.font = UIFont(name: "Helvetica",size:30)
        suggestedSettingsLabel.text = "Suggested settings"
        
        self.view.addSubview(suggestedSettingsLabel)
        
        var youCanChangeThisLabel = UILabel();
        var youCanChangeThisLabelDistanceFromTop : CGFloat = 100;
        
        youCanChangeThisLabel.frame = CGRectMake(0.5*(self.screenWidth!-topLabelWidth),youCanChangeThisLabelDistanceFromTop,topLabelWidth,topLabelHeight)
        youCanChangeThisLabel.textAlignment = NSTextAlignment.Center
        youCanChangeThisLabel.text = "(You can change this if you want)"
        
        self.view.addSubview(youCanChangeThisLabel)
        
        //Create the segmented control to select how many speakers you want
        var speakerSegmentedControlDistanceFromTop : CGFloat = 200
        var segmentedControlWidth : CGFloat = 300
        var segmentedControlHeight : CGFloat = 50
        
        self.singleOrMultipleSpeakerSegmentedControl = UISegmentedControl(items: ["Single","Multiple"])
        self.singleOrMultipleSpeakerSegmentedControl.selectedSegmentIndex = 0
        self.singleOrMultipleSpeakerSegmentedControl.frame = CGRect(x: 0.5 * (self.screenWidth!-segmentedControlWidth),y: speakerSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)
        self.view.addSubview(self.singleOrMultipleSpeakerSegmentedControl)
        
        //Create the segmented control to select whether you want variation in the starting sound
        var soundsSegmentedControlDistanceFromTop : CGFloat = 300
        
        self.sameOrDifferentStartingSoundSegmentedControl = UISegmentedControl(items: ["Same","Different"])
        self.sameOrDifferentStartingSoundSegmentedControl.selectedSegmentIndex = 0
        self.sameOrDifferentStartingSoundSegmentedControl.frame = CGRect(x: 0.5 * (self.screenWidth!-segmentedControlWidth),y: soundsSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)
        self.view.addSubview(self.sameOrDifferentStartingSoundSegmentedControl)
        
        //Create the autopilot segmented control
        var autoPilotSegmentedControlDistanceFromTop : CGFloat = 400
        
        self.autoPilotSegmentedControl = UISegmentedControl(items: ["Single round","Autopilot"])
        self.autoPilotSegmentedControl.selectedSegmentIndex = 0
        self.autoPilotSegmentedControl.frame = CGRect(x: 0.5 * (self.screenWidth!-segmentedControlWidth),y: autoPilotSegmentedControlDistanceFromTop,width: segmentedControlWidth,height: segmentedControlHeight)
        self.view.addSubview(self.autoPilotSegmentedControl)
        
        //Create the labels to go with the various options
        let labelDistanceFromLeft : CGFloat = 100
        let labelWidth : CGFloat = 300
        let labelHeight : CGFloat = 100
        
        var singleOrMultipleSpeakersLabel : UILabel = UILabel();
        singleOrMultipleSpeakersLabel.frame = CGRectMake(labelDistanceFromLeft,speakerSegmentedControlDistanceFromTop-25,labelWidth,labelHeight)
        singleOrMultipleSpeakersLabel.text = "Speakers"
        self.view.addSubview(singleOrMultipleSpeakersLabel)
        
        var startingSoundLabel : UILabel = UILabel();
        startingSoundLabel.frame = CGRectMake(labelDistanceFromLeft,soundsSegmentedControlDistanceFromTop-25,labelWidth,labelHeight)
        startingSoundLabel.text = "Starting sound"
        self.view.addSubview(startingSoundLabel)
        
        var autoPilotLabel : UILabel = UILabel();
        autoPilotLabel.frame = CGRectMake(labelDistanceFromLeft,autoPilotSegmentedControlDistanceFromTop-25,labelWidth,labelHeight)
        autoPilotLabel.text = "Mode"
        self.view.addSubview(autoPilotLabel)
        
        //Create the area to see the selected vowels and game mode
        var chosenVowelsLabelDistanceFromTop : CGFloat = 0
        var selectedSettingsLabelsDistanceFromLeft : CGFloat = 20
        var selectedSettingsLabelsLabelWidth : CGFloat = 200
        
        var chosenVowelsLabel : UILabel = UILabel();
        chosenVowelsLabel.frame = CGRectMake(selectedSettingsLabelsDistanceFromLeft,chosenVowelsLabelDistanceFromTop, selectedSettingsLabelsLabelWidth,labelHeight)
        chosenVowelsLabel.textAlignment = NSTextAlignment.Center
        chosenVowelsLabel.text = "Chosen vowels"
        self.view.addSubview(chosenVowelsLabel)
        
        self.vowelIndicatorLabel = UILabel();
        self.vowelIndicatorLabel.frame = CGRectMake(selectedSettingsLabelsDistanceFromLeft,chosenVowelsLabelDistanceFromTop+20, selectedSettingsLabelsLabelWidth,labelHeight)
        self.vowelIndicatorLabel.textAlignment = NSTextAlignment.Center
        
        var vowelIndicatorText : String = "\(self.currentGame!.selectedBaseVowel!.exampleWord) vs \(self.currentGame!.selectedTargetVowel!.exampleWord)"
        
        self.vowelIndicatorLabel.text = vowelIndicatorText

        self.view.addSubview(self.vowelIndicatorLabel)
        
        var selectedGameModeLabelDistanceFromTop : CGFloat = 50
        
        var selectedGameModeLabel : UILabel = UILabel();
        selectedGameModeLabel.frame = CGRectMake(selectedSettingsLabelsDistanceFromLeft,selectedGameModeLabelDistanceFromTop, selectedSettingsLabelsLabelWidth,labelHeight)
        selectedGameModeLabel.textAlignment = NSTextAlignment.Center
        selectedGameModeLabel.text = "Chosen gamemode"
        self.view.addSubview(selectedGameModeLabel)

        var gameModeIndicatorLabelDistanceFromTop : CGFloat = 70
        
        var gameModeIndicatorLabel : UILabel = UILabel();
        gameModeIndicatorLabel.frame = CGRectMake(selectedSettingsLabelsDistanceFromLeft,gameModeIndicatorLabelDistanceFromTop, selectedSettingsLabelsLabelWidth,labelHeight)
        gameModeIndicatorLabel.textAlignment = NSTextAlignment.Center
        gameModeIndicatorLabel.text = self.currentGame!.selectedTask.rawValue
        self.view.addSubview(gameModeIndicatorLabel)
        
        //Create the buttons
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        let distanceFromBottom : CGFloat = 50
        let buttonMargin : CGFloat = buttonWidth/2 + 25

        let anotherSuggestionButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth)-buttonMargin,
            self.screenHeight!-buttonHeight-distanceFromBottom,buttonWidth,buttonHeight))
        anotherSuggestionButton.setTitle("Another suggestion", forState: UIControlState.Normal)
        anotherSuggestionButton.addTarget(self, action: "anotherSuggestionButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(anotherSuggestionButton)
        
        let readyButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth)+buttonMargin,
            self.screenHeight!-buttonHeight-distanceFromBottom,buttonWidth,buttonHeight))
        readyButton.setTitle("Ready", forState: UIControlState.Normal)
        readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(readyButton)
        
    }
    
    func anotherSuggestionButtonPressed()
    {
        
    }
    
    func readyButtonPressed()
    {
        //Interpret all settings
        self.currentGame!.multipleSpeakers = self.singleOrMultipleSpeakerSegmentedControl.selectedSegmentIndex == 1
        self.currentGame!.differentStartingSounds = self.sameOrDifferentStartingSoundSegmentedControl.selectedSegmentIndex == 1
        self.currentGame!.autoPilotMode = self.autoPilotSegmentedControl.selectedSegmentIndex == 1
        
        self.superController!.subControllerFinished(self)
    }
    
}
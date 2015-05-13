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

class SettingsViewController: SubViewController {
    
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    
    var currentGame : Game?
    
    var singleOrMultipleSpeakerSegmentedControl = UISegmentedControl()
    var sameOrDifferentStartingSoundSegmentedControl = UISegmentedControl()
    
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
        
        //Create the stepper to determin the number of rounds
        var numberOfRoundsStepperDistanceFromTop : CGFloat = 400
        var numberOfRoundsStepperWidth : CGFloat = 90
        var numberOfRoundsStepperHeight : CGFloat = 50
        
        self.numberOfRoundsStepper = UIStepper(frame: CGRect(x: 0.5 * (self.screenWidth!-numberOfRoundsStepperWidth),y: numberOfRoundsStepperDistanceFromTop,width: numberOfRoundsStepperWidth,height: numberOfRoundsStepperHeight))
        self.numberOfRoundsStepper.minimumValue = 1
        self.numberOfRoundsStepper.addTarget(self,action: "numberOfRoundsStepperChanged",
            forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.numberOfRoundsStepper)
        
        //Create the label that indicates the height of the stepper
        self.numberOfRoundsIndicator = UILabel();
        self.numberOfRoundsIndicator.frame = CGRectMake(0.5 * (self.screenWidth!-numberOfRoundsStepperWidth)-40,numberOfRoundsStepperDistanceFromTop-15,50,50)
        self.numberOfRoundsIndicator.text = "1"
        self.view.addSubview(numberOfRoundsIndicator)
        
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
        
        var numberOfRoundsLabel : UILabel = UILabel();
        numberOfRoundsLabel.frame = CGRectMake(labelDistanceFromLeft,numberOfRoundsStepperDistanceFromTop-25,labelWidth,labelHeight)
        numberOfRoundsLabel.text = "Number of rounds"
        self.view.addSubview(numberOfRoundsLabel)
        
        //Create the area to see and change the selected vowels
        var chosenVowelsLabelDistanceFromTop : CGFloat = 0
        var chosenVowelsLabelDistanceFromLeft : CGFloat = 20
        var chosenVowelsLabelWidth : CGFloat = 150
        
        var chosenVowelsLabel : UILabel = UILabel();
        chosenVowelsLabel.frame = CGRectMake(chosenVowelsLabelDistanceFromLeft,chosenVowelsLabelDistanceFromTop, chosenVowelsLabelWidth,labelHeight)
        chosenVowelsLabel.textAlignment = NSTextAlignment.Center
        chosenVowelsLabel.text = "Chosen vowels"
        self.view.addSubview(chosenVowelsLabel)
        
        var changeVowelButton = TempStyledButton(frame: CGRect(x: chosenVowelsLabelDistanceFromLeft,y: chosenVowelsLabelDistanceFromTop+60,width: chosenVowelsLabelWidth,height: 20))
        changeVowelButton.enabled = true
        changeVowelButton.addTarget(self, action: "changeVowelButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(changeVowelButton)
        
        var vowelIndicatorText : String
        
        if self.currentGame!.selectedVowelsToCompareWith.count > 1
        {
            vowelIndicatorText = "\(self.currentGame!.selectedInitialVowel!.exampleWord) vs multiple"
        }
        else
        {
            vowelIndicatorText = "\(self.currentGame!.selectedInitialVowel!.exampleWord) vs \(self.currentGame!.selectedVowelsToCompareWith[0].exampleWord)"
        }

        var vowelIndicatorLabel : UILabel = UILabel();
        vowelIndicatorLabel.frame = CGRectMake(chosenVowelsLabelDistanceFromLeft,chosenVowelsLabelDistanceFromTop+20, chosenVowelsLabelWidth,labelHeight)
        vowelIndicatorLabel.textAlignment = NSTextAlignment.Center
        vowelIndicatorLabel.text = vowelIndicatorText
        vowelIndicatorLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(vowelIndicatorLabel)
        
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
    
    func numberOfRoundsStepperChanged()
    {
        self.updateNumberOfRounds()
    }
    
    func presentVowelChangePopover()
    {
        var vowelSelectionTableViewController = VowelSelectionTableViewController()
        vowelSelectionTableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popoverController = UIPopoverController(contentViewController: vowelSelectionTableViewController)
        popoverController.presentPopoverFromRect(CGRect(x: 100,y: 100,width: 300,height: 300), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    func anotherSuggestionButtonPressed()
    {
        
    }
    
    func readyButtonPressed()
    {
        self.superController!.subControllerFinished(self)
    }
    
    func updateNumberOfRounds()
    {
        self.currentGame!.nrOfRounds = Int(self.numberOfRoundsStepper.value)
        self.numberOfRoundsIndicator.text = "\(self.currentGame!.nrOfRounds)"
    }
    
    func changeVowelButtonPressed()
    {
        self.presentVowelChangePopover()
    }
}
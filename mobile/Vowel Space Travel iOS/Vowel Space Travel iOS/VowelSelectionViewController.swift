//
//  ProgressViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

import UIKit

enum VowelSelectionStage
{
    case SelectingInitialVowel
    case SelectingVowelsToCompareWith
}

class VowelSelectionViewController: UIViewController, PassControlToSubControllerProtocol
{
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    
    var downloadViewController : DownloadViewController?
    var taskViewController : TaskViewController?
    var resultViewController : ResultViewController?
    var settingsViewController : SettingsViewController?
    var infoViewController : InfoViewController?
    var trialViewController : TrialViewController?
    
    var stage : VowelSelectionStage = VowelSelectionStage.SelectingInitialVowel
    var selectedInitialVowel : VowelDefinition?
    var selectedVowelsToCompareWith = [VowelDefinition]()
    
    var availableVowels : [String : VowelDefinition]?
    var vowelButtons : [String : UIButton]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Show the vowelbuttons
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70

        availableVowels = self.loadAvailableVowels()
        
        vowelButtons = [String: UIButton]()
        var currentButton : UIButton
        
        for (exampleWord,vowel) in availableVowels!
        {
            currentButton = UIButton(frame: CGRectMake(CGFloat(vowel.xPositionInMouth),CGFloat(vowel.yPositionInMouth),100,70))
            
            currentButton.enabled = true
            
            currentButton.setTitle(vowel.exampleWord, forState: UIControlState.Normal)
            currentButton.addTarget(self, action: "vowelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            currentButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            currentButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Selected)
            
            self.view.addSubview(currentButton)
            vowelButtons![vowel.exampleWord] = currentButton
        }
        
        
        //Create the info button
        let readyButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)-150,buttonWidth,buttonHeight))
        readyButton.setTitle("Ready", forState: UIControlState.Normal)
        readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(readyButton)

        let selectAllButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)-50,buttonWidth,buttonHeight))
        selectAllButton.setTitle("Select all", forState: UIControlState.Normal)
        selectAllButton.addTarget(self, action: "selectAllButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(selectAllButton)

        let deSelectAllButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+50,buttonWidth,buttonHeight))
        deSelectAllButton.setTitle("Deselect all", forState: UIControlState.Normal)
        deSelectAllButton.addTarget(self, action: "deselectAllButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(deSelectAllButton)
        
        let infoButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
        infoButton.setTitle("Info", forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(infoButton)
        
        //Preload the views
        self.downloadViewController = DownloadViewController();
        self.downloadViewController!.superController = self
        
        self.trialViewController = TrialViewController();
        self.trialViewController!.superController = self
        
        self.taskViewController = TaskViewController();
        self.taskViewController!.superController = self

        self.resultViewController = ResultViewController();
        self.resultViewController!.superController = self

        self.settingsViewController = SettingsViewController();
        self.settingsViewController!.superController = self

        self.infoViewController = InfoViewController();
        self.infoViewController!.superController = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAvailableVowels() -> [String: VowelDefinition]
    {
        var pit : VowelDefinition = VowelDefinition(exampleWord: "pit",xPositionInMouth: 50,yPositionInMouth: 50)

        var putt : VowelDefinition = VowelDefinition(exampleWord: "putt",xPositionInMouth: 100,yPositionInMouth: 100)

        var pet : VowelDefinition = VowelDefinition(exampleWord: "pet",xPositionInMouth: 150,yPositionInMouth: 150)
        
        return [pit.exampleWord: pit,putt.exampleWord: putt,pet.exampleWord: pet]
    }
    
    func vowelButtonPressed(sender : UIButton)
    {
        //Find out which vowel was chosen
        var vowelCorrespondingToButtonPressed : VowelDefinition?
        
        for (exampleWord,button) in self.vowelButtons!
        {
            if button == sender
            {
                vowelCorrespondingToButtonPressed = self.availableVowels![exampleWord]
            }
        }
        
        switch (self.stage)
        {
            case VowelSelectionStage.SelectingInitialVowel:

                self.selectedInitialVowel = vowelCorrespondingToButtonPressed
                self.goToSelectingVowelsToCompareWithStage()
            
            case VowelSelectionStage.SelectingVowelsToCompareWith:
            
                if !sender.selected
                {
                    self.selectedVowelsToCompareWith.append(vowelCorrespondingToButtonPressed!)
                    sender.selected = true
                }
                else
                {
                    var indexOfVowelThePlayerWantsToDeselect : Int = find(self.selectedVowelsToCompareWith,vowelCorrespondingToButtonPressed!)!
                    self.selectedVowelsToCompareWith.removeAtIndex(indexOfVowelThePlayerWantsToDeselect)
                    sender.selected = false
                }
        }
    }
    
    func readyButtonPressed()
    {
        self.goToDownloadView()
    }
    
    func selectAllButtonPressed()
    {
        //Make all vowelbuttons selected
        for (exampleWord,vowelButton) in self.vowelButtons!
        {
            vowelButton.selected = true
        }
            
        //Add all vowels to the selected vowels
        self.selectedVowelsToCompareWith = []
        
        for (exampleWord,availableVowel) in self.availableVowels!
        {
            self.selectedVowelsToCompareWith.append(availableVowel)
        }
        
    }

    func deselectAllButtonPressed()
    {
        //Make all vowelbuttons selected
        for (exampleWord,vowelButton) in self.vowelButtons!
        {
            vowelButton.selected = false
        }
        
        //Add all vowels to the selected vowels
        self.selectedVowelsToCompareWith = []
        
    }
    
    func infoButtonPressed()
    {
        
    }
        
    func goToSelectingVowelsToCompareWithStage()
    {
        self.stage = VowelSelectionStage.SelectingVowelsToCompareWith
        println(self.stage)
        
        //Make buttons appear, make title change
    }
        
    func goToDownloadView()
    {
        self.presentViewController(self.downloadViewController!, animated: false, completion: nil)
    }

    func goToTrialView()
    {
        self.presentViewController(self.trialViewController!, animated: false, completion: nil)
    }
    
    func goToTaskView()
    {
        self.presentViewController(self.taskViewController!, animated: false, completion: nil)
    }
    
    func goToResultView()
    {
        self.presentViewController(self.resultViewController!, animated: false, completion: nil)
    }
    
    func goToInfoView()
    {
        self.presentViewController(infoViewController!, animated: false, completion: nil)
    }
    
    func subControllerFinished(subController: SubViewController)
    {

        subController.dismissViewControllerAnimated(false, completion: nil)        
        
        switch subController
        {
            case self.downloadViewController!:
                self.goToTrialView()
            case self.trialViewController!:
                self.goToTaskView()
            case self.taskViewController!:
                self.goToResultView()
            default:
                println("")
        }
        
    }
}
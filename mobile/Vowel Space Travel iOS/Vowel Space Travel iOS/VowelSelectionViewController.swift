//
//  ProgressViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

import UIKit

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
    
    var currentGame : Game = Game()
    
    var instructionTitle : UILabel = UILabel()
    var taskDescription : UILabel = UILabel()
    
    var availableVowels : [String : VowelDefinition]?
    var vowelButtons : [String : UIButton]?
    
    var buttonsForSecondVowelSelectionStage = [UIButton]()
    var readyButton = UIButton()

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
            currentButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
            
            self.view.addSubview(currentButton)
            vowelButtons![vowel.exampleWord] = currentButton
        }
        
        
        //Create the static buttons
        var distanceFromRight : CGFloat = 50
        
        self.readyButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)-150,buttonWidth,buttonHeight))
        self.readyButton.setTitle("Ready", forState: UIControlState.Normal)
        self.readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.readyButton.enabled = false
        self.readyButton.hidden = true
        self.view.addSubview(readyButton)
        
        let selectAllButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)-50,buttonWidth,buttonHeight))
        selectAllButton.setTitle("Select all", forState: UIControlState.Normal)
        selectAllButton.addTarget(self, action: "selectAllButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonsForSecondVowelSelectionStage.append(selectAllButton)
        
        let deSelectAllButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)+50,buttonWidth,buttonHeight))
        deSelectAllButton.setTitle("Deselect all", forState: UIControlState.Normal)
        deSelectAllButton.addTarget(self, action: "deselectAllButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonsForSecondVowelSelectionStage.append(deSelectAllButton)
        
        let infoButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
        infoButton.setTitle("Info", forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.buttonsForSecondVowelSelectionStage.append(infoButton)
        
        for button in self.buttonsForSecondVowelSelectionStage
        {
            button.hidden = true
            button.enabled = false
            self.view.addSubview(button)
        }
        
        //Display the labels
        self.instructionTitle = UILabel();
        var instructionTitleWidth : CGFloat = 700;
        var instructionTitleHeight : CGFloat = 30;
        var instructionTitleDistanceFromTop : CGFloat = 50;
        
        self.instructionTitle.frame = CGRectMake(0.5*(self.screenWidth!-instructionTitleWidth),instructionTitleDistanceFromTop,instructionTitleWidth,instructionTitleHeight)
        self.instructionTitle.textAlignment = NSTextAlignment.Center
        self.instructionTitle.font = UIFont(name: "Helvetica",size:30)
        self.instructionTitle.text = "Select vowel to practice"
        
        self.view.addSubview(instructionTitle)
        
        self.taskDescription = UILabel();
        var taskDescriptionWidth : CGFloat = 500;
        var taskDescriptionHeight : CGFloat = 30;
        var taskDescriptionDistanceFromBottom : CGFloat = 50;
        var taskDescriptionDistanceFromLeft : CGFloat = 50;
        
        self.taskDescription.frame = CGRectMake(taskDescriptionDistanceFromLeft,self.screenHeight! - taskDescriptionDistanceFromBottom,taskDescriptionWidth,taskDescriptionHeight)
        self.taskDescription.text = "Task: None"
        self.taskDescription.hidden = true
        
        self.view.addSubview(taskDescription)
        
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
    
    func resetView()
    {
        //Make sure the vowel buttons are not yet selected
        for button in self.vowelButtons!.values
        {
            button.selected = false
            button.enabled = true
        }
        
        //Make sure the buttons are not yet visible
        for button in self.buttonsForSecondVowelSelectionStage
        {
            button.enabled = false
            button.hidden = true
        }
        
        //Make sure the title is set to its initial value
        self.instructionTitle.text = "Select vowel to practice"
        
        //Make sure the task description is not yet visible
        self.updateTaskAndTaskDescriptionLabel()
        self.updateReadyButton()
        self.taskDescription.hidden = true
        
        //Reset all the views of all other settings by simply recreating the view controller
        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.superController = self
    }
    
    func loadAvailableVowels() -> [String: VowelDefinition]
    {
        var pit : VowelDefinition = VowelDefinition(exampleWord: "pit",xPositionInMouth: 150,yPositionInMouth: 150)

        var putt : VowelDefinition = VowelDefinition(exampleWord: "putt",xPositionInMouth: 200,yPositionInMouth: 200)

        var pet : VowelDefinition = VowelDefinition(exampleWord: "pet",xPositionInMouth: 250,yPositionInMouth: 250)
        
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
        
        switch (self.currentGame.stage)
        {
            case GameStage.SelectingInitialVowel:

                self.currentGame.selectedInitialVowel = vowelCorrespondingToButtonPressed
                sender.enabled = false
                self.goToSelectingVowelsToCompareWithStage()
            
            case GameStage.SelectingVowelsToCompareWith:
            
                if !sender.selected
                {
                self.currentGame.selectedVowelsToCompareWith.append(vowelCorrespondingToButtonPressed!)
                    sender.selected = true
                }
                else
                {
                    var indexOfVowelThePlayerWantsToDeselect : Int = find(self.currentGame.selectedVowelsToCompareWith,vowelCorrespondingToButtonPressed!)!
                    self.currentGame.selectedVowelsToCompareWith.removeAtIndex(indexOfVowelThePlayerWantsToDeselect)
                    sender.selected = false
                }
            
                self.updateTaskAndTaskDescriptionLabel();
                self.updateReadyButton()
            default:
                println("Warning! You got in a gamestate you can't be in right now!")
            
        }

    }
    
    func readyButtonPressed()
    {
        self.goToSettingsView()
    }
    
    func selectAllButtonPressed()
    {
        //Make all vowelbuttons selected
        for (exampleWord,vowelButton) in self.vowelButtons!
        {
            if vowelButton.enabled
            {
                vowelButton.selected = true
            }
        }
            
        //Add all vowels to the selected vowels
        self.currentGame.selectedVowelsToCompareWith = []
        
        for (exampleWord,availableVowel) in self.availableVowels!
        {
            if availableVowel != self.currentGame.selectedInitialVowel!
            {
                self.currentGame.selectedVowelsToCompareWith.append(availableVowel)
            }
        }
        
        self.updateTaskAndTaskDescriptionLabel()
        self.updateReadyButton()
    }

    func deselectAllButtonPressed()
    {
        //Make all vowelbuttons selected
        for (exampleWord,vowelButton) in self.vowelButtons!
        {
            if vowelButton.enabled
            {
                vowelButton.selected = false
            }
        }
        
        //Add all vowels to the selected vowels
        self.currentGame.selectedVowelsToCompareWith = []
        
        self.updateTaskAndTaskDescriptionLabel()
        self.updateReadyButton()
    }
    
    func infoButtonPressed()
    {
        
    }
        
    func goToSelectingVowelsToCompareWithStage()
    {
        self.currentGame.stage = GameStage.SelectingVowelsToCompareWith
        
        //Make buttons appear
        for button in self.buttonsForSecondVowelSelectionStage
        {
            button.enabled = true
            button.hidden = false
        }
        
        //Make title change
        self.instructionTitle.text = "Select one or more vowels to compare with"
        
        //Make the task description text appear
        self.taskDescription.hidden = false
    }
    
    //I have doubts whether it's smart to combine view and model here
    func updateTaskAndTaskDescriptionLabel()
    {
        if self.currentGame.selectedVowelsToCompareWith.count == 0
        {
            self.currentGame.selectedTask = nil
            self.taskDescription.text = "Task: None"
        }
        else if self.currentGame.selectedVowelsToCompareWith.count == 1
        {
            self.currentGame.selectedTask = Task.Discrimination
            self.taskDescription.text = "Task: Discrimination"
        }
        else
        {
            self.currentGame.selectedTask = Task.Identification
            self.taskDescription.text = "Task: Identification"
        }
        
    }
    
    func updateReadyButton()
    {
        if self.currentGame.selectedVowelsToCompareWith.count > 0
        {
            self.readyButton.hidden = false
            self.readyButton.enabled = true
        }
        else
        {
            self.readyButton.hidden = true
            self.readyButton.enabled = false
        }
    }
    
    func goToSettingsView()
    {
        self.currentGame.stage = GameStage.SettingOtherSettings
        self.settingsViewController!.currentGame = self.currentGame
        self.presentViewController(self.settingsViewController!, animated: false, completion: nil)
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
        
        var stimulus1 : Stimulus = Stimulus(soundFileName: "cello",requiresResponse: false)
        var stimulus2 : Stimulus = Stimulus(soundFileName: "cello",requiresResponse: true)
        var stimulus3 : Stimulus = Stimulus(soundFileName: "cello",requiresResponse: false)

        self.taskViewController!.stimuli = [stimulus1,stimulus2,stimulus3]
        self.taskViewController!.startTask()
    }
    
    func goToResultView(numberOfCorrectAnswers : Int,totalNumberOfAnswers : Int)
    {
        self.resultViewController!.currentGame = self.currentGame
        self.resultViewController!.numberOfCorrectAnswers = numberOfCorrectAnswers
        self.resultViewController!.totalNumberOfAnswers = totalNumberOfAnswers
        
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
            case self.settingsViewController!:
                self.currentGame.stage = GameStage.Trial
                self.goToDownloadView()
            case self.downloadViewController!:
                self.goToTrialView()
            case self.trialViewController!:
                self.currentGame.stage = GameStage.Playing
                self.goToTaskView()
            case self.taskViewController!:
                
                //Show the result of the task
                self.currentGame.stage = GameStage.ShowingResult
                self.goToResultView(self.taskViewController!.countNumberOfCorrectResponses(),totalNumberOfAnswers: self.taskViewController!.correctResponses.count)
            
                //Reset the task view for later use
                self.taskViewController = TaskViewController()
                self.taskViewController!.superController = self
            
            case self.resultViewController!:
                if self.currentGame.stage == GameStage.Finished
                {
                    self.currentGame = Game()
                    self.resetView()
                }
                else if self.currentGame.stage == GameStage.Playing
                {
                    self.goToTaskView()
                }
            default:
                println("")
        }
        
    }
}
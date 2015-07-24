//
//  ProgressViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

import UIKit

enum VowelDraggingType
{
    case BaseVowel
    case TargetVowel
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

    var server : VSTServer = VSTServer(url: kWebserviceURL)
    var currentGame : Game = Game()
    
    var instructionTitle : UILabel = UILabel()
    var taskDescription : UILabel = UILabel()
    
    var availableVowels : [String : VowelDefinition]?
    var vowelButtons : [String : UIButton]?

    var suggestedBaseVowel : VowelDefinition?
    var suggestedTargetVowel : VowelDefinition?

    var currentVowelDraggingType : VowelDraggingType? = nil
    
    var suggestionViewForBaseVowel : SuggestionView?
    var suggestionViewForTargetVowel : SuggestionView?
    
    var readyButton = UIButton()
    var taskSegmentedControl : UISegmentedControl?

    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Set the suggested vowels
        var suggestedBaseVowelExampleWord : String = self.server.getSuggestedBaseVowelExampleWord()
        var suggestedTargetVowelExampleWord : String = self.server.getSuggestedTargetVowelExampleWord()

        availableVowels = self.loadAvailableVowels()
        
        self.suggestedBaseVowel = self.availableVowels![suggestedBaseVowelExampleWord]
        self.suggestedTargetVowel = self.availableVowels![suggestedTargetVowelExampleWord]

        //Prepare the suggestion view
        var suggestionViewWidth : Int = 250
        var suggestionViewHeight : Int = 40
        
        self.suggestionViewForBaseVowel = SuggestionView(frame: CGRect(x: 0,y: 0,width: suggestionViewWidth,height: suggestionViewHeight), text: "Why not compare this one...")
        self.view.addSubview(self.suggestionViewForBaseVowel!)

        self.suggestionViewForTargetVowel = SuggestionView(frame: CGRect(x: 0,y: 0,width: suggestionViewWidth,height: suggestionViewHeight), text: "... to this one?")
        self.view.addSubview(self.suggestionViewForTargetVowel!)
        
        self.view.addSubview(PlanetView(frame : CGRect(x: 50,y: 50,width: 10,height: 10)))
        
        //Preselect the suggestions
        self.currentGame.selectedBaseVowel = self.suggestedBaseVowel!
        self.currentGame.selectedTargetVowel = self.suggestedTargetVowel!
        
        //Show the vowelbuttons
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        vowelButtons = [String: UIButton]()
        var currentButton : UIButton
        
        for (exampleWord,vowel) in availableVowels!
        {
            currentButton = UIButton(frame: CGRectMake(CGFloat(vowel.xPositionInMouth),CGFloat(vowel.yPositionInMouth),50,35))
            
            currentButton.enabled = true
            
            currentButton.setTitle(vowel.exampleWord, forState: UIControlState.Normal)
            currentButton.addTarget(self, action: "vowelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)

            self.view.addSubview(currentButton)
            vowelButtons![vowel.exampleWord] = currentButton
            
            //If this is the suggested vowel, move the suggestion view to here
            if self.suggestedBaseVowel! == vowel
            {
                self.moveSuggestionViewToVowelButton(self.suggestionViewForBaseVowel!,vowelButton: currentButton)
            }
            else if self.suggestedTargetVowel! == vowel
            {
                self.moveSuggestionViewToVowelButton(self.suggestionViewForTargetVowel!,vowelButton: currentButton)
            }
        }
        
        self.updateVowelButtonColors()
        
        //Create the static buttons
        var distanceFromRight : CGFloat = 50
        
        self.readyButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)-150,buttonWidth,buttonHeight))
        self.readyButton.setTitle("Ready", forState: UIControlState.Normal)
        self.readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(readyButton)
        
        let infoButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
        infoButton.setTitle("Info", forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(infoButton)
        
        //Create the task selection segmented control
        var segmentedControlDistanceFromBottom : CGFloat = 50
        var segmentedControlDistanceFromLeft : CGFloat = 50
        var segmentedControlWidth : CGFloat = 300
        var segmentedControlHeight : CGFloat = 50
        
        self.taskSegmentedControl = UISegmentedControl(items: ["Distinguish","Recognize"])
        self.taskSegmentedControl!.selectedSegmentIndex = 0
        self.taskSegmentedControl!.frame =  CGRect(x: segmentedControlDistanceFromLeft,y: self.screenHeight!-segmentedControlHeight-segmentedControlDistanceFromBottom,width: segmentedControlWidth,height: segmentedControlHeight)
        self.taskSegmentedControl!.addTarget(self, action: "taskSegmentedControlPressed:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.taskSegmentedControl!)
        
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
        self.downloadViewController = DownloadViewController()
        self.downloadViewController!.superController = self
        
        self.trialViewController = TrialViewController()
        self.trialViewController!.superController = self
        
        self.taskViewController = TaskViewController()
        self.taskViewController!.superController = self

        self.resultViewController = ResultViewController()
        self.resultViewController!.superController = self

        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.superController = self

        self.infoViewController = InfoViewController();
        self.infoViewController!.superController = self
        
        //Add the pan gestures, possible depricated?
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateVowelButtonColors()
    {
        var currentButton : UIButton
        
        for (exampleWord, vowel) in self.availableVowels!
        {
            currentButton = self.vowelButtons![exampleWord]!;
            
            if self.currentGame.selectedBaseVowel! == vowel
            {
                currentButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            }
            else if self.currentGame.selectedTask == Task.Identification
            {

                currentButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
                
            }
            else if self.currentGame.selectedTask == Task.Discrimination
            {

                if self.currentGame.selectedTargetVowel! == vowel
                {
                    currentButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
                }
                else
                {
                    currentButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                }
                
            }
            
        }
    }
    
    func resetView() //Possibly: rename to resetSettingsViewController?
    {
        //Reset all the views of all other settings by simply recreating the view controller
        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.superController = self
        
        //Recreate the suggestion views
        self.view.addSubview(self.suggestionViewForBaseVowel!)
        self.view.addSubview(self.suggestionViewForTargetVowel!)
    }
    
    func loadAvailableVowels() -> [String: VowelDefinition]
    {
        var pit : VowelDefinition = VowelDefinition(exampleWord: "pit",xPositionInMouth: 150,yPositionInMouth: 150)

        var putt : VowelDefinition = VowelDefinition(exampleWord: "putt",xPositionInMouth: 200,yPositionInMouth: 200)

        var pet : VowelDefinition = VowelDefinition(exampleWord: "pet",xPositionInMouth: 250,yPositionInMouth: 250)
        
        return [pit.exampleWord: pit,putt.exampleWord: putt,pet.exampleWord: pet]
    }

    //Depricated
    func vowelButtonPressed(sender : UIButton)
    {
        /*
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
            
            case GameStage.SelectingVowels:
            
                println("Selected vowel")
            
                /*if !sender.selected
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
                self.updateReadyButton()*/
            
            default:
                println("Warning! You got in a gamestate you can't be in right now!")
            
        }
        */
    }
    
    func readyButtonPressed()
    {
        self.goToSettingsView()
    }
    
    
    func infoButtonPressed()
    {
        self.goToInfoView()
    }
    
    func taskSegmentedControlPressed(sender : UISegmentedControl)
    {
        switch(sender.selectedSegmentIndex)
        {
            case 0: self.currentGame.selectedTask = Task.Discrimination
            case 1: self.currentGame.selectedTask = Task.Identification
            default: println("Warning! You've selected as task that does not exist")
        }
        
        self.updateVowelButtonColors()
    }

    func findVowelForTouchLocation(touchLocation : CGPoint) -> VowelDefinition?
    {
        for (exampleWord, vowelButton) in self.vowelButtons!
        {
            if CGRectContainsPoint(vowelButton.frame, touchLocation)
            {
                return self.availableVowels![exampleWord]
            }
        }
        
        return nil
    }
    
    func handlePan(recognizer : UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            var startLocation : CGPoint = recognizer.locationInView(self.view)
            var startVowel : VowelDefinition? = self.findVowelForTouchLocation(startLocation)
            
            if startVowel != nil
            {
                //See whether this was the selected start vowel
                if startVowel == self.currentGame.selectedBaseVowel
                {
                    self.currentVowelDraggingType = VowelDraggingType.BaseVowel
                }
                
                //Or the vowel to compare with
                else if self.currentGame.selectedTask == Task.Discrimination && startVowel == self.currentGame.selectedTargetVowel
                {
                    self.currentVowelDraggingType = VowelDraggingType.TargetVowel
                }
            }
        
        }
        else if recognizer.state == UIGestureRecognizerState.Ended
        {
            var endLocation : CGPoint = recognizer.locationInView(self.view)
            var endVowel : VowelDefinition? = self.findVowelForTouchLocation(endLocation)
            
            if self.currentVowelDraggingType != nil && endVowel != nil
            {
                if self.currentVowelDraggingType == VowelDraggingType.BaseVowel && (endVowel != self.currentGame.selectedTargetVowel || self.currentGame.selectedTask == Task.Identification)
                {
                    self.currentGame.selectedBaseVowel = endVowel
                }
                else if self.currentVowelDraggingType == VowelDraggingType.TargetVowel && endVowel != self.currentGame.selectedBaseVowel
                {
                    self.currentGame.selectedTargetVowel = endVowel
                }
            }
            
            self.updateVowelButtonColors()
            
            //Remove the suggestion views
            self.suggestionViewForBaseVowel!.removeFromSuperview()
            self.suggestionViewForTargetVowel!.removeFromSuperview()
            
        }
        
    }
    
    func moveSuggestionViewToVowelButton(suggestionView : SuggestionView, vowelButton : UIButton)
    {
        suggestionView.frame = CGRect(x: vowelButton.frame.minX-15,y: vowelButton.frame.minY-30, width: suggestionView.frame.width,height: suggestionView.frame.height)
    }
    
    func goToSettingsView()
    {
        self.currentGame.stage = GameStage.SettingOtherSettings
        self.settingsViewController!.currentGame = self.currentGame
        self.settingsViewController!.availableVowels = self.availableVowels
        self.presentViewController(self.settingsViewController!, animated: false, completion: nil)
    }
    
    func goToDownloadView()
    {
        self.downloadViewController!.server = self.server
        self.downloadViewController!.currentGame = self.currentGame
        
        self.presentViewController(self.downloadViewController!, animated: false, completion: nil)
    }

    func goToTrialView()
    {
        self.presentViewController(self.trialViewController!, animated: false, completion: nil)
    }
    
    func goToTaskView()
    {
        self.presentViewController(self.taskViewController!, animated: false, completion: nil)
        
        self.taskViewController!.stimuli = self.currentGame.stimuli
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
    
    func collectStimuliForCurrentGameAndGoToDownloadView()
    {
        self.server.getSampleIDsAndExpectedAnswersForSettings(self.currentGame.selectedTask,multipleSpeakers: self.currentGame.multipleSpeakers,differentStartingSounds: self.currentGame.differentStartingSounds)
            {
                (sampleIDs,expectedAnswers,err) -> Void in

                var index : Int = 0
                var expectedAnswer : Bool
                
                for sampleID in sampleIDs
                {
                    expectedAnswer = expectedAnswers[index]
                    self.currentGame.stimuli.append(Stimulus(sampleID: sampleID,requiresResponse: expectedAnswer))
                    
                    index++;
                }
                
                self.goToDownloadView()
        }
    }
    
    func subControllerFinished(subController: SubViewController)
    {

        subController.dismissViewControllerAnimated(false, completion:
        {
            () -> Void in
            
            switch subController
            {
                case self.settingsViewController!:
                    self.currentGame.stage = GameStage.Trial
                    self.collectStimuliForCurrentGameAndGoToDownloadView();
                
                case self.downloadViewController!:
                                    
                    if !self.currentGame.autoPilotMode
                    {
                        self.goToTrialView()
                    }
                    else
                    {
                        self.currentGame.stage = GameStage.Playing
                        self.goToTaskView()
                    }

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
                        if !self.currentGame.autoPilotMode
                        {
                            self.currentGame = Game()
                            
                            //Preselect the suggestions
                            self.currentGame.selectedBaseVowel = self.suggestedBaseVowel!
                            self.currentGame.selectedTargetVowel = self.suggestedTargetVowel!
                            
                            self.resetView()
                        }
                        else
                        {
                            self.currentGame = self.CreateANewGameBasedOnServerSuggestions();
                            self.goToDownloadView()
                        }
                    }
                    else if self.currentGame.stage == GameStage.Playing
                    {
                        self.goToTaskView()
                    }
                
                    //Reset the result view for later use
                    self.resultViewController = ResultViewController()
                    self.resultViewController!.superController = self
                
                default:
                    println("")
            }
        })
    }
    
    func CreateANewGameBasedOnServerSuggestions() -> Game
    {
        var newGame : Game = Game()
        newGame.selectedBaseVowel = self.availableVowels!["pit"]
        newGame.selectedBaseVowel = self.availableVowels!["putt"]
        newGame.autoPilotMode = true
        
        return newGame
    }
}
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

class VowelSelectionViewController: SubViewController, PassControlToSubControllerProtocol
{
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    
    var downloadViewController : DownloadViewController?
    var taskViewController : TaskViewController?
    var resultViewController : ResultViewController?
    var settingsViewController : SettingsViewController?
    var infoViewController : InfoViewController?

    var server : VSTServer?
    var currentGame : Game = Game()
    
    var instructionTitle : UILabel = UILabel()
    var taskDescription : UILabel = UILabel()
    var playLabel : UILabel = UILabel()
    
    var availableVowels : [String : VowelDefinition]?
    var vowelButtons : [String : UIButton]?
    var vowelViews : [String: PlanetView] = [String: PlanetView]()
    var vowelSelectionShapeLayers : [CALayer] = [CALayer]()
    var planetLocationsForIpaNotation = [String : CGRect]()
    
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

        //Set the example words... is there a better place for this?
        var exampleWordsForIpaNotation : [String : String] = ["i":"bean","E":"pet","1":"bay","I":"pit","{":"pat","2":"bike","3":"burn","4":"boy","U":"push","6":"brow","5":"boat","V":"putt","u":"boot","Q":"pop","$":"born",
            "#":"bark"]
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
                
        //Show the background image
        var backgroundImageView = UIImageView(image: UIImage(named: "overview_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        //Set the suggested vowels
        var suggestedBaseVowelExampleWord : String = self.server!.getSuggestedBaseVowelExampleWord()
        var suggestedTargetVowelExampleWord : String = self.server!.getSuggestedTargetVowelExampleWord()

        self.availableVowels = self.loadAvailableVowels(exampleWordsForIpaNotation)
        
        self.suggestedBaseVowel = self.availableVowels![suggestedBaseVowelExampleWord]
        self.suggestedTargetVowel = self.availableVowels![suggestedTargetVowelExampleWord]

        //Prepare the suggestion view
        var suggestionViewWidth : Int = 250
        var suggestionViewHeight : Int = 40
        
        self.suggestionViewForBaseVowel = SuggestionView(frame: CGRect(x: 0,y: 0,width: suggestionViewWidth,height: suggestionViewHeight), text: "Why not compare this one...")
        self.view.addSubview(self.suggestionViewForBaseVowel!)

        self.suggestionViewForTargetVowel = SuggestionView(frame: CGRect(x: 0,y: 0,width: suggestionViewWidth,height: suggestionViewHeight), text: "... to this one?")
        self.view.addSubview(self.suggestionViewForTargetVowel!)
        
        self.planetLocationsForIpaNotation = ["i" : CGRect(x: 350,y: 140,width: 100,height: 100),
                                            "E" : CGRect(x: 305,y: 250,width: 100,height: 100),
                                            "1" : CGRect(x: 370,y: 210,width: 100,height: 100),
                                            "I" : CGRect(x: 435,y: 180,width: 100,height: 100),
            
                                            "{" : CGRect(x: 325,y: 330,width: 100,height: 100),
                                            "2" : CGRect(x: 410,y: 290,width: 100,height: 100),
                                            "3" : CGRect(x: 485,y: 245,width: 100,height: 100),

                                            "4" : CGRect(x: 470,y: 330,width: 100,height: 100),
                                            "U" : CGRect(x: 565,y: 205,width: 100,height: 100),

                                            "6" : CGRect(x: 540,y: 360,width: 100,height: 100),
                                            "5" : CGRect(x: 560,y: 280,width: 100,height: 100),

                                            "V" : CGRect(x: 640,y: 320,width: 100,height: 100),
                                            "u" : CGRect(x: 640,y: 230,width: 100,height: 100),
            
                                            "Q" : CGRect(x: 610,y: 390,width: 100,height: 100),
                                            "$" : CGRect(x: 690,y: 360,width: 100,height: 100),
            "#" : CGRect(x: 670,y: 430,width: 100,height: 100)]
        
        //Preselect the suggestions
        self.currentGame.selectedBaseVowel = self.suggestedBaseVowel!
        self.currentGame.selectedTargetVowel = self.suggestedTargetVowel!
        
        self.drawVowelViews()
        
        //Show the vowelbuttons
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
//        
//        vowelButtons = [String: UIButton]()
//        var currentButton : UIButton
//        
//        for (exampleWord,vowel) in availableVowels!
//        {
//            currentButton = UIButton(frame: CGRectMake(0,0,50,35))
//            
//            currentButton.enabled = true
//            
//            currentButton.setTitle(vowel.exampleWord, forState: UIControlState.Normal)
//            currentButton.addTarget(self, action: "vowelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//
//            self.view.addSubview(currentButton)
//            vowelButtons![vowel.exampleWord] = currentButton
//            
//            //If this is the suggested vowel, move the suggestion view to here
//            if self.suggestedBaseVowel! == vowel
//            {
//                self.moveSuggestionViewToVowelButton(self.suggestionViewForBaseVowel!,vowelButton: currentButton)
//            }
//            else if self.suggestedTargetVowel! == vowel
//            {
//                self.moveSuggestionViewToVowelButton(self.suggestionViewForTargetVowel!,vowelButton: currentButton)
//            }
//        }
//        
//        self.updateVowelButtonColors()
        
        //Create the static buttons
        self.readyButton = UIButton(frame: CGRectMake(545,475,25,30))
        self.readyButton.setImage(UIImage(named: "startButton"), forState: UIControlState.Normal)
        self.readyButton.setTitle("Ready", forState: UIControlState.Normal)
        self.readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(readyButton)
        
//        let infoButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
//        infoButton.setTitle("Info", forState: UIControlState.Normal)
//        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(infoButton)
        
        //Create the task selection segmented control
        self.taskSegmentedControl = UISegmentedControl(items: ["",""])
        self.taskSegmentedControl!.selectedSegmentIndex = 0
 
        //Custom appearance of the segmented control
        self.taskSegmentedControl!.setBackgroundImage(UIImage(named: "taskSegmentedControl"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.taskSegmentedControl!.setBackgroundImage(UIImage(named: "taskSegmentedControlSelected"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        self.taskSegmentedControl!.tintColor = UIColor.clearColor()
       
        self.taskSegmentedControl!.frame =  CGRect(x: 425,y: 475,width: 75,height: 30)
        self.taskSegmentedControl!.addTarget(self, action: "taskSegmentedControlPressed:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.taskSegmentedControl!)
        
        //Display the labels
        self.instructionTitle = UILabel();
        var instructionTitleWidth : CGFloat = 525;
        var instructionTitleHeight : CGFloat = 30;
        
        self.instructionTitle.frame = CGRectMake(240,120,instructionTitleWidth,instructionTitleHeight)
        self.instructionTitle.textAlignment = NSTextAlignment.Center
        self.instructionTitle.font = UIFont(name: "Muli",size:15)
        self.instructionTitle.textColor = UIColor.whiteColor()
        self.instructionTitle.text = "Pick the vowel to practice by dragging the circles"
        
        self.view.addSubview(instructionTitle)
        
        self.taskDescription = UILabel();
        self.taskDescription.textColor = UIColor.whiteColor()
        var labelWidth : CGFloat = 500;
        var labelHeight : CGFloat = 30;

        self.taskDescription.font = UIFont(name: "Muli",size:8)
        self.taskDescription.frame = CGRectMake(420,500,labelWidth,labelHeight)
        self.taskDescription.text = "Distinguish   Recognize"
        
        self.view.addSubview(taskDescription)

        self.playLabel = UILabel();
        self.playLabel.textColor = UIColor.whiteColor()
        
        self.playLabel.font = UIFont(name: "Muli",size:8)
        self.playLabel.frame = CGRectMake(545,500,labelWidth,labelHeight)
        self.playLabel.text = "Play"
        
        self.view.addSubview(playLabel)
        
        //Preload the views
        self.taskViewController = TaskViewController()
        self.taskViewController!.superController = self

        self.resultViewController = ResultViewController()
        self.resultViewController!.superController = self

        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.superController = self

        self.infoViewController = InfoViewController();
        self.infoViewController!.superController = self
        
        //Add the pan gestures
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawVowelViews()
    {
        //Remove what you had before (will be skipped first time)
        for vowelSelectionShapeLayer in self.vowelSelectionShapeLayers
        {
            vowelSelectionShapeLayer.removeFromSuperlayer()
        }
        self.vowelSelectionShapeLayers = []
        
        for (exampleWord,previousVowelView) in self.vowelViews
        {
            previousVowelView.removeFromSuperview()
        }

        self.vowelViews = [String:PlanetView]()
        var travelIndicationLineStartPoint : CGPoint = CGPoint(x: 0,y: 0)
        var travelIndicationLineEndPoint : CGPoint = CGPoint(x: 0,y: 0)
        
        //Create all views
        for (exampleWord,vowel) in self.availableVowels!
        {
            println(exampleWord)
            var planetView = self.createPlanetViewBasedOnVowel(vowel)
            
            if self.currentGame.selectedBaseVowel! == vowel
            {
                self.drawSelectionCircleAroundVowelView(planetView)
                travelIndicationLineStartPoint = planetView.center
            }
            else if self.currentGame.selectedTask == Task.Discrimination && self.currentGame.selectedTargetVowel! == vowel
            {
                self.drawSelectionCircleAroundVowelView(planetView)
                travelIndicationLineEndPoint = planetView.center
            }
            
            self.vowelViews[exampleWord] = planetView
        }
        
        if self.currentGame.selectedTask == Task.Discrimination
        {
            self.drawTravelIndicationLine(travelIndicationLineStartPoint,endPoint: travelIndicationLineEndPoint)
        }
            
        for (exampleWord,vowelView)in self.vowelViews
        {
            self.view.addSubview(vowelView)
        }
    }
    
    func drawSelectionCircleAroundVowelView(view : PlanetView)
    {
        var circlePositionCorrection : CGFloat = 3
        var path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX-circlePositionCorrection,y: view.frame.midY-circlePositionCorrection),radius: 20,startAngle: CGFloat(0),endAngle: CGFloat(100),clockwise: true)
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        
        self.vowelSelectionShapeLayers.append(shapeLayer)
        
        self.view.layer.addSublayer(shapeLayer)
    }
    
    func drawTravelIndicationLine(startPoint : CGPoint, endPoint : CGPoint)
    {
        var path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)

        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineDashPattern = [1,15]
        
        self.vowelSelectionShapeLayers.append(shapeLayer)
        self.view.layer.addSublayer(shapeLayer)
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
    
    func loadAvailableVowels(exampleWordsForIpaNotation : [String:String]) -> [String: VowelDefinition]
    {
        //self.server!.loadAvailableVowels()
        var vowelsFromTheServer : [VowelDefinition] = self.server!.availableVowels
        println(self.server!.availableVowels)
        var currentExampleWord : String
        var availableVowels = [String: VowelDefinition]()
        
        for vowel in vowelsFromTheServer
        {
            currentExampleWord = exampleWordsForIpaNotation[vowel.ipaNotation]!
            vowel.exampleWord = currentExampleWord
            availableVowels[currentExampleWord] = vowel
        }
        
        return availableVowels
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
        
        self.drawVowelViews()
    }

    func findVowelForTouchLocation(touchLocation : CGPoint) -> VowelDefinition?
    {
        for (exampleWord,vowelView) in self.vowelViews
        {
            if CGRectContainsPoint(vowelView.frame, touchLocation)
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
            
            if kShowTouchLocation
            {
                println(startLocation)
            }
                
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
            
            self.drawVowelViews()
            
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
        
        self.settingsViewController!.server = self.server
        self.settingsViewController!.currentGame = self.currentGame
        self.settingsViewController!.availableVowels = self.availableVowels

        self.presentViewController(self.settingsViewController!, animated: false, completion: nil)
    }
    
    func goToDownloadView()
    {
        self.downloadViewController = DownloadViewController()
        self.downloadViewController!.superController = self
        
        self.downloadViewController!.server = self.server
        self.downloadViewController!.currentGame = self.currentGame
        
        self.presentViewController(self.downloadViewController!, animated: false, completion: nil)
    }
    
    func goToTaskView()
    {
        self.presentViewController(self.taskViewController!, animated: false, completion: nil)
        
        self.taskViewController!.stimuli = self.currentGame.stimuli
        self.taskViewController!.startTask()
    }
    
    func goToResultView(stimuli : [Stimulus])
    {
        self.resultViewController!.currentGame = self.currentGame
        self.resultViewController!.exposedStimuli = stimuli
        self.presentViewController(self.resultViewController!, animated: false, completion: nil)
    }
    
    func goToInfoView()
    {
        self.presentViewController(infoViewController!, animated: false, completion: nil)
    }
    
    //Depricated?
    func collectStimuliForCurrentGameAndGoToTaskView()
    {
        self.server!.getSampleIDsAndExpectedAnswersForSettings(self.currentGame)
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
                
                self.goToTaskView()
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
                    
                    if self.settingsViewController!.readyForTask
                    {
                        self.goToTaskView();
                    }
                    else
                    {
                        self.superController!.subControllerFinished(self)
                    }

                case self.taskViewController!:
                    
                    //Show the result of the task
                    self.currentGame.stage = GameStage.ShowingResult
                    self.goToResultView(self.taskViewController!.stimuli)
                
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
                            
                            self.superController!.subControllerFinished(self)
                        }
                        else
                        {
                            self.currentGame = self.createANewGameBasedOnServerSuggestions();
                            self.goToSettingsView()
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
    
    func createANewGameBasedOnServerSuggestions() -> Game
    {
        var newGame : Game = Game()
        newGame.selectedBaseVowel = self.availableVowels!["pet"]
        newGame.selectedTargetVowel = self.availableVowels!["putt"]
        newGame.autoPilotMode = true
        
        return newGame
    }
    
    func createPlanetViewBasedOnVowel(vowel : VowelDefinition) -> PlanetView
    {
        var ringOpacity : CGFloat
        
        if vowel.rounded!
        {
            ringOpacity = 1.0
        }
        else
        {
            ringOpacity = 0.0
        }

        var hue : CGFloat = 0
        
        switch(vowel.manner!)
        {
            case VowelManner.close: hue = 0; break
            case VowelManner.near_close: hue = 0.2; break
            case VowelManner.close_mid: hue = 0.4; break
            case VowelManner.mid : hue = 0.5; break
            case VowelManner.open_mid : hue = 0.6; break
            case VowelManner.near_open : hue = 0.7; break
            case VowelManner.open : hue = 0.8; break
            default : println("Warning: your planet corresponds to a vowel with an unknown manner of articulation")
        }
        
        var waterOpacity : CGFloat = 0
        var craters : Bool = false
        
        switch(vowel.place!)
        {
            case VowelPlace.back:
                waterOpacity = 1
                break
            case VowelPlace.near_back:
                waterOpacity = 0.5
                break
            case VowelPlace.near_front:
                craters = true
            case VowelPlace.front:
                craters = true
            default: break
        }
                
        return PlanetView(frame : self.planetLocationsForIpaNotation[vowel.ipaNotation]!,
            exampleWord: vowel.exampleWord, hue: hue, ringOpacity: ringOpacity, waterOpacity : waterOpacity, craters : craters)
        
    }
    
}
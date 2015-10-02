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
    var helpLabel : UILabel = UILabel()
    var aboutLabel : UILabel = UILabel()
    
    var availableVowels : [String : VowelDefinition]?
    var vowelButtons : [String : UIButton]?
    var vowelViews : [String: PlanetView] = [String: PlanetView]()
    var vowelSelectionShapeLayers : [CALayer] = [CALayer]()
    var planetLocationsForIpaNotation = [String : CGRect]()
    
    var suggestedBaseVowel : VowelDefinition?
    var suggestedTargetVowel : VowelDefinition?

    var currentVowelDraggingType : VowelDraggingType? = nil
    
    var readyButton = UIButton()
    var helpButton = UIButton()
    var infoButton = UIButton()
    
    var viewingHelp : Bool = false
    
    var taskSegmentedControl : UISegmentedControl?
    
    var circleCurrentlyBeingDragged : CAShapeLayer?
    var circleAroundBaseVowel : CAShapeLayer?
    var circleAroundTargetVowel : CAShapeLayer?
    var travelIndicationLine : CAShapeLayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Set the example words... is there a better place for this?
        let exampleWordsForIpaNotation : [String : String] = ["i":"bean","E":"pet","1":"bay","I":"pit","{":"pat","2":"bike","3":"burn","4":"boy","U":"push","6":"brow","5":"boat","V":"putt","u":"boot","Q":"pop","$":"born",
            "#":"bark"]

        self.availableVowels = self.loadAvailableVowels(exampleWordsForIpaNotation)
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
                
        //Show the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "overview_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        //Set the suggested vowels
        self.server!.getSuggestionForGame()
        {
            (gameSuggestion) -> Void in
            
            self.suggestedBaseVowel = gameSuggestion.targetVowel //This is because of a mix-up in terminology
            self.suggestedTargetVowel = gameSuggestion.standardVowel
            
            //Preselect the suggestions
            if self.currentGame.selectedBaseVowel == nil || self.currentGame.selectedTargetVowel == nil
            {
                self.currentGame.selectedBaseVowel = self.suggestedBaseVowel!
                self.currentGame.selectedTargetVowel = self.suggestedTargetVowel!
                self.currentGame.multipleSpeakers = gameSuggestion.multipleSpeakers
                self.currentGame.differentStartingSounds = gameSuggestion.differentStartingSounds
            }
            
            //Get the confidences for vowel combinations
            self.updateConfidencesAndDrawVowelViews()
            
        }
        
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
        
        //Show the vowelbuttons
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
        self.readyButton = UIButton(frame: CGRectMake(575,475,25,30))
        self.readyButton.setImage(UIImage(named: "startButton"), forState: UIControlState.Normal)
        self.readyButton.addTarget(self, action: "readyButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(readyButton)

        self.infoButton = UIButton(frame: CGRectMake(265,475,25,30))
        self.infoButton.setImage(UIImage(named: "infobutton"), forState: UIControlState.Normal)
        self.infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(infoButton)

        self.helpButton = UIButton(frame: CGRectMake(295,475,25,30))
        self.helpButton.setImage(UIImage(named: "question_button"), forState: UIControlState.Normal)
        self.helpButton.addTarget(self, action: "helpButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(helpButton)
        
//        let infoButton = TempStyledButton(frame: CGRectMake(self.screenWidth!-buttonWidth-distanceFromRight,0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
//        infoButton.setTitle("Info", forState: UIControlState.Normal)
//        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(infoButton)
        
        //Create the task selection segmented control
        self.taskSegmentedControl = UISegmentedControl(items: ["",""])
        self.taskSegmentedControl!.selectedSegmentIndex = 0
 
        //Custom appearance of the segmented control
        self.taskSegmentedControl!.setBackgroundImage(UIImage(named: "taskSegmentedControlv3"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.taskSegmentedControl!.setBackgroundImage(UIImage(named: "taskSegmentedControlSelectedv3"), forState: UIControlState.Selected, barMetrics: UIBarMetrics.Default)
        self.taskSegmentedControl!.tintColor = UIColor.clearColor()
       
        self.taskSegmentedControl!.frame =  CGRect(x: 425,y: 475,width: 75,height: 30)
        self.taskSegmentedControl!.addTarget(self, action: "taskSegmentedControlPressed:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.taskSegmentedControl!)
        
        //Display the labels
        self.instructionTitle = UILabel();
        let instructionTitleWidth : CGFloat = 525;
        let instructionTitleHeight : CGFloat = 30;
        
        self.instructionTitle.frame = CGRectMake(240,120,instructionTitleWidth,instructionTitleHeight)
        self.instructionTitle.textAlignment = NSTextAlignment.Center
        self.instructionTitle.font = UIFont(name: "Muli",size:15)
        self.instructionTitle.textColor = UIColor.whiteColor()
        self.instructionTitle.text = "The suggested vowels are circled, drag to change."
        
        self.view.addSubview(instructionTitle)

        let labelWidth : CGFloat = 500;
        let labelHeight : CGFloat = 30;
        
        self.helpLabel = UILabel();
        self.helpLabel.textColor = UIColor.whiteColor()
        
        self.helpLabel.font = UIFont(name: "Muli",size:8)
        self.helpLabel.frame = CGRectMake(299,500,labelWidth,labelHeight)
        self.helpLabel.text = "Help"
        
        self.aboutLabel = UILabel();
        self.aboutLabel.textColor = UIColor.whiteColor()

        self.aboutLabel.font = UIFont(name: "Muli",size:8)
        self.aboutLabel.frame = CGRectMake(267,500,labelWidth,labelHeight)
        self.aboutLabel.text = "About"

        self.taskDescription = UILabel();
        self.taskDescription.textColor = UIColor.whiteColor()
        
        self.taskDescription.font = UIFont(name: "Muli",size:8)
        self.taskDescription.frame = CGRectMake(420,500,labelWidth,labelHeight)
        self.taskDescription.text = "Distinguish      Recognize"

        self.view.addSubview(self.aboutLabel)
        self.view.addSubview(self.helpLabel)
        self.view.addSubview(self.taskDescription)

        self.playLabel = UILabel();
        self.playLabel.textColor = UIColor.whiteColor()
        
        self.playLabel.font = UIFont(name: "Muli",size:8)
        self.playLabel.frame = CGRectMake(545,500,labelWidth,labelHeight)
        self.playLabel.text = "Prepare for takeoff"
        
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
    
    func updateConfidencesAndDrawVowelViews()
    {
        self.server!.loadAllConfidenceValuesForCurrentUserID(self.availableVowels!)
            {
                (confidencesForVowelPairsByTargetVowelId,err) -> Void in
                
                addMixingWeightToConfidences(confidencesForVowelPairsByTargetVowelId)
                self.drawVowelViews()
        }
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
            let planetView = self.createPlanetViewBasedOnVowelAndConfidences(vowel)
            
            if self.currentGame.selectedBaseVowel! == vowel
            {
                self.circleAroundBaseVowel = self.drawPulsatingSelectionCircleAroundVowelView(planetView)
                travelIndicationLineStartPoint = planetView.center
            }
            else if self.currentGame.selectedTask == Task.Discrimination && self.currentGame.selectedTargetVowel! == vowel
            {
                self.circleAroundTargetVowel = self.drawPulsatingSelectionCircleAroundVowelView(planetView)
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
    
    func drawPulsatingSelectionCircleAroundVowelView(view : PlanetView) -> CAShapeLayer
    {
        let circlePositionCorrection : CGFloat = 3
        let circle : CAShapeLayer = self.drawCircleAroundPoint(CGPoint(x: view.frame.midX-circlePositionCorrection,y: view.frame.midY-circlePositionCorrection))

        circle.anchorPoint = CGPoint(x: view.frame.midX/40,y: view.frame.midY/40)
        circle.frame = CGRectMake(0,0,40,40)
        
        let pulsatingAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulsatingAnimation.duration = 0.6
        pulsatingAnimation.repeatCount = Float.infinity
        pulsatingAnimation.autoreverses = true
        pulsatingAnimation.fromValue = 1
        pulsatingAnimation.toValue = 1.2
        
        circle.addAnimation(pulsatingAnimation, forKey: "scale")
        
        return circle
    }
        
    func drawCircleAroundPoint(point : CGPoint) -> CAShapeLayer
    {
        let path = UIBezierPath(arcCenter: point,radius: 20,startAngle: CGFloat(0),endAngle: CGFloat(100),clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        print(shapeLayer.bounds)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        
        self.vowelSelectionShapeLayers.append(shapeLayer)
        
        self.view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    
    func drawTravelIndicationLine(startPoint : CGPoint, endPoint : CGPoint)
    {
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer.lineDashPattern = [1,15]
        
        self.vowelSelectionShapeLayers.append(shapeLayer)
        self.travelIndicationLine = shapeLayer
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
        let vowelsFromTheServer : [VowelDefinition] = self.server!.availableVowels
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
            
                print("Selected vowel")
            
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
                print("Warning! You got in a gamestate you can't be in right now!")
            
        }
        */
    }
    
    func readyButtonPressed()
    {
        //Sometimes randomly flip target and base vowel
        if arc4random()%2 == 0
        {
            let saveTargetVowel : VowelDefinition? = self.currentGame.selectedTargetVowel
            self.currentGame.selectedTargetVowel = self.currentGame.selectedBaseVowel
            self.currentGame.selectedBaseVowel = saveTargetVowel
        }
        
        self.currentGame.stage = GameStage.SettingOtherSettings
        self.goToSettingsView()
    }
    
    
    func infoButtonPressed()
    {
        self.goToInfoView()
    }
    
    func helpButtonPressed()
    {
        self.viewingHelp = true
        self.superController!.subControllerFinished(self)
    }
    
    func taskSegmentedControlPressed(sender : UISegmentedControl)
    {
        switch(sender.selectedSegmentIndex)
        {
            case 0: self.currentGame.selectedTask = Task.Discrimination
            case 1: self.currentGame.selectedTask = Task.Identification
            default: print("Warning! You've selected as task that does not exist")
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
            let startLocation : CGPoint = recognizer.locationInView(self.view)
            
            if kShowTouchLocation
            {
                print(startLocation)
            }
                
            let startVowel : VowelDefinition? = self.findVowelForTouchLocation(startLocation)
            
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
        else if recognizer.state == UIGestureRecognizerState.Changed
        {
            let currentTouchLocation : CGPoint = recognizer.locationInView(self.view)
            
            self.circleCurrentlyBeingDragged?.removeFromSuperlayer()
            self.travelIndicationLine?.removeFromSuperlayer()
            var travelIndicationLineStartPosition : CGPoint!
            
            if self.currentVowelDraggingType != nil
            {
                if self.currentVowelDraggingType! == VowelDraggingType.BaseVowel
                {
                    self.circleAroundBaseVowel!.removeFromSuperlayer()
                    travelIndicationLineStartPosition = self.vowelViews[self.currentGame.selectedTargetVowel!.exampleWord]!.center
                }
                else if self.currentVowelDraggingType! == VowelDraggingType.TargetVowel
                {
                    self.circleAroundTargetVowel!.removeFromSuperlayer()

                    travelIndicationLineStartPosition = self.vowelViews[self.currentGame.selectedBaseVowel!.exampleWord]!.center
                }
                
                if self.currentGame.selectedTask == Task.Discrimination
                {
                
                    self.drawTravelIndicationLine(travelIndicationLineStartPosition, endPoint: currentTouchLocation)
                }
                self.circleCurrentlyBeingDragged = self.drawCircleAroundPoint(currentTouchLocation)
                
            }
            
        }
        else if recognizer.state == UIGestureRecognizerState.Ended
        {
            let endLocation : CGPoint = recognizer.locationInView(self.view)
            let endVowel : VowelDefinition? = self.findVowelForTouchLocation(endLocation)
            
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
            
            self.updateConfidencesAndDrawVowelViews()
            
        }
        
    }
    
    func moveSuggestionViewToVowelButton(suggestionView : SuggestionView, vowelButton : UIButton)
    {
        suggestionView.frame = CGRect(x: vowelButton.frame.minX-15,y: vowelButton.frame.minY-30, width: suggestionView.frame.width,height: suggestionView.frame.height)
    }
    
    func goToSettingsView()
    {
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
        self.server!.getStimuliForSettings(self.currentGame)
            {
                (stimuli,err) -> Void in

                self.currentGame.stimuli = stimuli
                
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
                        self.currentGame.stage = GameStage.Playing
                        self.goToTaskView();
                    }
                    else
                    {
                        self.superController!.subControllerFinished(self)
                    }

                case self.infoViewController!:
                    self.superController!.subControllerFinished(self)
                
                case self.taskViewController!:
                    
                    if self.taskViewController!.finished
                    {
                        //Show the result of the task
                        self.currentGame.stage = GameStage.ShowingResult
                        self.goToResultView(self.taskViewController!.stimuli)
                    }
                    else
                    {
                        //Go back to vowelselection
                        self.superController!.subControllerFinished(self)
                    }
                
                    //Reset the task view for later use
                    self.taskViewController = TaskViewController()
                    self.taskViewController!.superController = self
                
                case self.resultViewController!:
                    //Save the results online
                    self.server?.saveStimulusResults(self.resultViewController!.exposedStimuli,stimuliRequestUsedToGenerateTheseStimuli: self.currentGame)
                    
                    //View flow
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
                            self.createANewGameBasedOnServerSuggestionsAndGoToSettingsView()
                        }
                    }
                    else if self.currentGame.stage == GameStage.Playing
                    {
                        self.currentGame = self.createANewGameWithTheSameSettings(self.currentGame)
                        self.currentGame.stage = GameStage.Playing
                        self.goToSettingsView()
                    }
                
                    //Reset the result view for later use
                    self.resultViewController = ResultViewController()
                    self.resultViewController!.superController = self
                
                default:
                    print("")
            }
        })
    }
    
    func createANewGameBasedOnServerSuggestionsAndGoToSettingsView()
    {
        self.server!.getSuggestionForGame()
        {
            (gameSuggestion) -> Void in

            let newGame : Game = Game()
            newGame.selectedBaseVowel = gameSuggestion.targetVowel
            newGame.selectedTargetVowel = gameSuggestion.standardVowel
            newGame.multipleSpeakers = gameSuggestion.multipleSpeakers
            newGame.differentStartingSounds = gameSuggestion.differentStartingSounds
            
            newGame.autoPilotMode = true
            
            self.currentGame = newGame
            self.currentGame.stage = GameStage.Playing
            self.goToSettingsView()
            
        }
    }
    
    func createANewGameWithTheSameSettings(game : Game) -> Game
    {
        let newGame : Game = Game()
        newGame.selectedBaseVowel = game.selectedBaseVowel!
        newGame.selectedTargetVowel = game.selectedTargetVowel!
        newGame.multipleSpeakers = game.multipleSpeakers
        newGame.differentStartingSounds = game.differentStartingSounds
        newGame.selectedTask = game.selectedTask
        
        return newGame
    }
    
    func createPlanetViewBasedOnVowelAndConfidences(vowel : VowelDefinition) -> PlanetView
    {
        //The things commented out here are the way it was originally done, when the planets showed 
        // the end state of the vowels
        
        let featuresAdjustedForThisUser : (place : Float, manner : Float, roundedness : Float) = adjustFeaturesForVowelUsingOtherVowelsAndMixingWeights(self.availableVowels![vowel.exampleWord]!,allVowels: self.availableVowels!, confidencesForVowelPairsByTargetVowelId: self.server!.confidencesForVowelPairsByTargetVowelId )
        
        let ringOpacity : CGFloat = CGFloat(featuresAdjustedForThisUser.roundedness)
        
        let hue : CGFloat = CGFloat(featuresAdjustedForThisUser.manner)
        
        /*switch(vowel.manner!)
        {
            case VowelManner.close: hue = 0; break
            case VowelManner.near_close: hue = 0.2; break
            case VowelManner.close_mid: hue = 0.4; break
            case VowelManner.mid : hue = 0.5; break
            case VowelManner.open_mid : hue = 0.6; break
            case VowelManner.near_open : hue = 0.7; break
            case VowelManner.open : hue = 0.8; break
            default : print("Warning: your planet corresponds to a vowel with an unknown manner of articulation")
        }*/
        
        var waterOpacity : CGFloat = CGFloat(1 - featuresAdjustedForThisUser.place * 2)
        
        if waterOpacity < 0
        {
            waterOpacity = 0
        }
        
        var craterFrequency : CraterFrequency = CraterFrequency.none
        
        if featuresAdjustedForThisUser.place > 0.75
        {
            craterFrequency = CraterFrequency.high
        }
        else if featuresAdjustedForThisUser.place > 0.5
        {
            craterFrequency = CraterFrequency.low
        }
        
        /*switch(vowel.place!)
        {
            case VowelPlace.back:
                waterOpacity = 1
                break
            case VowelPlace.near_back:
                waterOpacity = 0.5
                break
            case VowelPlace.near_front:
                craterFrequency = CraterFrequency.low
            case VowelPlace.front:
                craterFrequency = CraterFrequency.high
            default: break
        }*/
                
        return PlanetView(frame : self.planetLocationsForIpaNotation[vowel.ipaNotation]!,
            exampleWord: vowel.exampleWord, hue: hue, ringOpacity: ringOpacity, waterOpacity : waterOpacity, craterFrequency : craterFrequency)
        
    }
    
}
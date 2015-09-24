//
//  TaskViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit
import AVFoundation

class TaskViewController: SubViewController {

    //Layout properties
    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    var label : UILabel!
    
    //Sound properties
    var audioPlayer = AVAudioPlayer()
    
    //Gameplay properties
    var stimuli = [Stimulus]()
    var currentStimulusIndex : Int = -1 //Increased at the start, so we start at 0
    var tapDetectedDuringThisStimulus = false
    var exampleFeedbackWasPlayed = false
    var finished = false
    
    var timer = NSTimer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width;
        self.screenHeight = self.view.frame.size.height;
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Display a label
        self.label = UILabel();
        var labelWidth : CGFloat = 500;
        var labelHeigth : CGFloat = 30;
        var distanceAboveCenter : CGFloat = 0;
        
        label.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - distanceAboveCenter,labelWidth,labelHeigth)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Target"
        
        self.view.addSubview(label)
        
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTask()
    {
        NSTimer.scheduledTimerWithTimeInterval(kTimeBeforeStimuli, target: self, selector: Selector("startStimuli"), userInfo: nil, repeats: false)
    }
    
    func startStimuli()
    {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(kTimeBetweenStimuliWhenShowingTheExample, target: self, selector: Selector("processStimulusResponseAndPresentNext"), userInfo: nil, repeats: true)
        
        self.processStimulusResponseAndPresentNext()
    }
    
    func processStimulusResponseAndPresentNext()
    {
        //If this is the first time, make sure the auditive feedback will be played, and the instructions will be changed
        if self.currentStimulusIndex == -1
        {
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:Selector("playAuditiveTouchFeedback"), userInfo : nil, repeats: false)
            
            NSTimer.scheduledTimerWithTimeInterval(1.4, target:self, selector:Selector("showInstructions"), userInfo : nil, repeats: false)
            
        }

        else if self.currentStimulusIndex == 0
        {
            //And from now on, the stimuli will come faster
            self.timer.invalidate()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(kTimeBetweenStimuli, target: self, selector: Selector("processStimulusResponseAndPresentNext"), userInfo: nil, repeats: true)
            
        }
        
        //Process stimulus response if this is not the example
        else if self.currentStimulusIndex > 0
        {
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            currentStimulus.receivedResponse = self.tapDetectedDuringThisStimulus

        }
        
        //Debugging option
        if kOnlyOneStimulus && self.currentStimulusIndex == 1
        {
            self.taskIsFinished()
        }
            
        //Present next one
        self.tapDetectedDuringThisStimulus = false
        self.currentStimulusIndex++
        
        if self.currentStimulusIndex < self.stimuli.count
        {
            println(self.currentStimulusIndex)
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            self.playSound(currentStimulus.fileLocation!,volume: 1)
        }
        else
        {
            self.taskIsFinished()
        }
    }
    
    func playSound(soundFileName : String, volume : Float,ofType: String = "wav", absolutePath : Bool = true)
    {
        var soundPath : NSURL
        
        if absolutePath
        {
            soundPath = NSURL(fileURLWithPath: soundFileName)!
        }
        else
        {
            soundPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundFileName, ofType: ofType)!)!
        }
            
        self.audioPlayer = AVAudioPlayer(contentsOfURL: soundPath, error: nil)
        self.audioPlayer.volume = volume
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
        
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.tapDetectedDuringThisStimulus = true
        self.playAuditiveTouchFeedback()
    }

    func playAuditiveTouchFeedback()
    {
        self.playSound("click",volume: kFeedbackSoundVolume, absolutePath : false)
    }
    
    func taskIsFinished()
    {
        self.finished = true
        self.timer.invalidate()
        self.superController!.subControllerFinished(self)
    }
    
    func showInstructions()
    {
        self.label.text = "Tap the screen when you hear the target vowel again"
    }
    
    func quit()
    {
        println("Quiting")
        self.timer.invalidate()
        self.superController!.subControllerFinished(self)
    }
}
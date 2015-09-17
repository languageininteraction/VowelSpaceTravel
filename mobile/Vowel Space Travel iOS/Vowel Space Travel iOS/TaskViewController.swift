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
        //Start the timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(kTimeBetweenStimuli, target: self, selector: Selector("processStimulusResponseAndPresentNext"), userInfo: nil, repeats: true)
        
        self.processStimulusResponseAndPresentNext()
    }
    
    func processStimulusResponseAndPresentNext()
    {
        //Process stimulus response
        if self.currentStimulusIndex > 0
        {
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            currentStimulus.receivedResponse = self.tapDetectedDuringThisStimulus
        }
    
        //If this was the first stimulus, play example feedback and wait till next cycle
        if self.currentStimulusIndex == 0 && !self.exampleFeedbackWasPlayed
        {
            self.playAuditiveTouchFeedback()
            self.exampleFeedbackWasPlayed = true
            return
        }

        //If this was the first stimulus, switch from the example to the real deal
        if self.currentStimulusIndex == 0 && self.exampleFeedbackWasPlayed
        {
            self.label.text = "Tap the screen when you hear the target vowel again"
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
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            self.playSound(currentStimulus.fileLocation!)
        }
        else
        {
            self.taskIsFinished()
        }
    }
    
    func playSound(soundFileName : String, ofType: String = "wav", absolutePath : Bool = true)
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
        self.playSound("click",ofType: "aiff",absolutePath : false)
    }
    
    func taskIsFinished()
    {
        self.timer.invalidate()
        self.superController!.subControllerFinished(self)
    }
    
}
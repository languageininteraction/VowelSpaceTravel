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
    
    //Sound properties
    var audioPlayer = AVAudioPlayer()
    
    //Gameplay properties
    var stimuli = [Stimulus]()
    var currentStimulusIndex : Int = -1 //Increased at the start, so we start at 0
    var correctResponses = [Bool]()
    var tapDetectedDuringThisStimulus = false

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
        var label = UILabel();
        var labelWidth : CGFloat = 500;
        var labelHeigth : CGFloat = 30;
        var distanceAboveCenter : CGFloat = 0;
        
        label.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - distanceAboveCenter,labelWidth,labelHeigth)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Tap the screen when you hear a difference"
        
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
        if self.currentStimulusIndex > -1
        {
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            self.correctResponses.append(currentStimulus.requiresResponse == self.tapDetectedDuringThisStimulus)
        }
            
        //Present next one
        self.tapDetectedDuringThisStimulus = false
        self.currentStimulusIndex++
        
        if self.currentStimulusIndex < self.stimuli.count
        {
            var currentStimulus : Stimulus = self.stimuli[self.currentStimulusIndex]
            self.playSound(currentStimulus.soundFileName)
        }
        else
        {
            self.taskIsFinished()
        }
    }
    
    func playSound(soundFileName : String, ofType: String = "wav")
    {
        var soundToPlay = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundFileName, ofType: ofType)!)
        
        self.audioPlayer = AVAudioPlayer(contentsOfURL: soundToPlay, error: nil)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    func countNumberOfCorrectResponses() -> Int
    {
        var numberOfCorrectResponses = 0
        
        for response in self.correctResponses
        {
            if response
            {
                numberOfCorrectResponses++
            }
        }
        
        return numberOfCorrectResponses
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        self.tapDetectedDuringThisStimulus = true
        self.playSound("click",ofType: "aiff")
    }
    
    func taskIsFinished()
    {
        self.timer.invalidate()
        self.superController!.subControllerFinished(self)
    }
    
}
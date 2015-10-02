//
//  DownloadViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

//
//  TaskViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit
import AVFoundation

class DownloadViewController: SubViewController
{

    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0

    var downloadProgress : Float = 0.0
    var downloadProgressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    var tempTimer : NSTimer?
    
    var server : VSTServer?
    var currentGame : Game?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Show the download label
        let label = UILabel();
        let labelWidth : CGFloat = 300;
        let labelHeigth : CGFloat = 30;
        let distanceAboveCenter : CGFloat = 100;
        
        label.frame = CGRectMake(0.5*(self.screenWidth-labelWidth),0.5*(self.screenHeight-labelHeigth) - distanceAboveCenter,labelWidth,labelHeigth)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Downloading files"
        self.view.addSubview(label)
        
        //Style and show the progressbar
        self.downloadProgressBar.center = self.view.center
        self.downloadProgressBar.trackTintColor = UIColor.lightGrayColor()
        self.downloadProgressBar.tintColor = UIColor.blackColor()
        self.view.addSubview(self.downloadProgressBar)
    }

    override func viewDidAppear(animated: Bool)
    {
        setProgressBar(0.0,animated:false)
        
        //Start updating the progress bar
        var counter : Int = 0
        var percentageDone : Float = 0.0
        
        for stimulus in self.currentGame!.stimuli
        {
            stimulus.fileLocation = kCachedStimuliLocation+"\(stimulus.sampleID)"+kSoundFileExtension
            self.server!.downloadSampleWithID(stimulus.sampleID,fileSafePath: stimulus.fileLocation!)
                        
            percentageDone = Float(counter) / Float(self.currentGame!.stimuli.count)
            self.setProgressBar(percentageDone, animated: true)
            
            counter++;
        }
        
        self.downloadingCompleted()
        
    }
    
    func increaseProgressBarWithOnePercent()
    {
        if !kSpeedUpDownload
        {
            self.increaseProgressBar(0.01)
        }

        //To prevent the dev having to wait all the time
        else
        {
            self.increaseProgressBar(0.1)
        }
    }
    
    func increaseProgressBar(progressToAdd: Float)
    {
        let newProgress = self.downloadProgress + progressToAdd
        setProgressBar(newProgress)
        
        if self.downloadProgress >= 1
        {
            self.downloadingCompleted()
        }
        
    }
    
    func setProgressBar(progress: Float,animated : Bool = true)
    {
        self.downloadProgress = progress
        downloadProgressBar.setProgress(progress, animated: animated)
    }    
    
    func downloadingCompleted()
    {
        self.superController!.subControllerFinished(self)
    }
    
}

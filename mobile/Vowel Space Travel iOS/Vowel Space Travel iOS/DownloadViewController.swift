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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Show the download label
        var label = UILabel();
        var labelWidth : CGFloat = 300;
        var labelHeigth : CGFloat = 30;
        var distanceAboveCenter : CGFloat = 100;
        
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
        println("View did appear")
        
        setProgressBar(0.0,animated:false)
        
        //Start updating the progress bar
        self.tempTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("increaseProgressBarWithOnePercent"), userInfo: nil, repeats: true)
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
        var newProgress = self.downloadProgress + progressToAdd
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
    
    func downloadFile()
    {
        let url = NSURL(string: "http://cls.ru.nl/staff/wstoop/test.zip")
        let fileSafePath = "/Users/woseseltops/Desktop/test.zip"
        let dataFromURL = NSData(contentsOfURL: url!)
        
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(fileSafePath, contents: dataFromURL, attributes: nil)
        
        println("Saved at \(fileSafePath)")
        
        /*let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()*/
    }
    
    
    func downloadingCompleted()
    {
        self.tempTimer!.invalidate()
        self.superController!.subControllerFinished(self)
    }
    
}

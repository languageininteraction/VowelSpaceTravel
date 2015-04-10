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

class DownloadViewController: UIViewController {

    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    var downloadProgress : Float = 0.0
    var downloadProgressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
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
        downloadProgressBar.center = self.view.center
        downloadProgressBar.trackTintColor = UIColor.lightGrayColor()
        downloadProgressBar.tintColor = UIColor.blackColor()
        self.view.addSubview(downloadProgressBar)

        //Start updating the progress bar
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("increaseProgressBarWithOnePercent"), userInfo: nil, repeats: true)
        
    }
    
    func increaseProgressBarWithOnePercent()
    {
        self.increaseProgressBar(0.01)
    }
    
    func increaseProgressBar(progressToAdd: Float)
    {
        self.downloadProgress += progressToAdd
        downloadProgressBar.setProgress(self.downloadProgress, animated: true)
        
        if downloadProgress >= 1
        {
            let taskViewController = TaskViewController();
            self.presentViewController(taskViewController, animated: false, completion: nil)
        }
        
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
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

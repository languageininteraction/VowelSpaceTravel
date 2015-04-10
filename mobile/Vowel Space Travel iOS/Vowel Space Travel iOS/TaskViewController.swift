//
//  TaskViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit
import AVFoundation

class TaskViewController: UIViewController {
    
    var tempSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cello", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    
    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width;
        self.screenHeight = self.view.frame.size.height;
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()

        //Play audio
        audioPlayer = AVAudioPlayer(contentsOfURL: tempSound, error: nil)
        audioPlayer.prepareToPlay()
        //audioPlayer.play()
        
        //Display a label
        var label = UILabel();
        var labelWidth : CGFloat = 300;
        var labelHeigth : CGFloat = 30;
        var distanceAboveCenter : CGFloat = 0;
        
        label.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) - distanceAboveCenter,labelWidth,labelHeigth)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Tap here when you hear a difference"
        
        self.view.addSubview(label)
        
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
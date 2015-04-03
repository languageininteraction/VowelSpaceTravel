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
    
    override func viewDidLoad()
    {
        audioPlayer = AVAudioPlayer(contentsOfURL: tempSound, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        super.viewDidLoad()
        println("loaded taskviewer!")
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
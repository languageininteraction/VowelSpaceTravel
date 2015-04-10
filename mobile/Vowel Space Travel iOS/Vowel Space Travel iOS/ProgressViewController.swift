//
//  ProgressViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

import UIKit

class ProgressViewController: UIViewController {
    
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        //Create start buttons        
        let discriminateButton = TempStyledButton(frame: CGRectMake(100,100,100,100))
        //discriminateButton.backgroundColor = UIColor.blueColor()
        discriminateButton.setTitle("Discriminate", forState: UIControlState.Normal)
        discriminateButton.addTarget(self, action: "discriminateButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(discriminateButton)

        let identificateButton = TempStyledButton(frame: CGRectMake(100,300,100,100))
        identificateButton.setTitle("Identificate", forState: UIControlState.Normal)
        identificateButton.addTarget(self, action: "identificateButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(identificateButton)
        
        //Create the settings button
        let settingsButton = TempStyledButton(frame: CGRectMake(100,500,100,100))
        settingsButton.setTitle("Settings", forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: "settingsButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(settingsButton)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func discriminateButtonPressed()
    {
        self.goToDownloadView();
    }

    func identificateButtonPressed()
    {
        self.goToDownloadView();
    }
    
    func settingsButtonPressed()
    {
        self.goToSettingsView();
    }
    
    func goToDownloadView()
    {
        let downloadViewController = DownloadViewController();
        self.presentViewController(downloadViewController, animated: false, completion: nil)
    }

    func goToSettingsView()
    {
//        let settingsViewController = SettingsViewController();
//        self.presentViewController(downloadViewController, animated: false, completion: nil)
    }

    func goToInfoView()
    {
//        let infoViewController = InfoViewController();
//        self.presentViewController(infoViewController, animated: false, completion: nil)
    }
    
}
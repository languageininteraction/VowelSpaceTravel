//
//  ProgressViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

import UIKit

class ProgressViewController: UIViewController, PassControlToSubControllerProtocol
{
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var downloadViewController : DownloadViewController?
    var taskViewController : TaskViewController?
    var resultViewController : ResultViewController?
    var settingsViewController : SettingsViewController?
    var infoViewController : InfoViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        //Create start buttons        
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let discriminateButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)-150,buttonWidth,buttonHeight))
                discriminateButton.setTitle("Discriminate", forState: UIControlState.Normal)
        discriminateButton.addTarget(self, action: "discriminateButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(discriminateButton)
        
        let identificateButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)-50,buttonWidth,buttonHeight))
        identificateButton.setTitle("Identify", forState: UIControlState.Normal)
        identificateButton.addTarget(self, action: "identificateButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(identificateButton)
        
        //Create the settings and info button
        let settingsButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+50,buttonWidth,buttonHeight))
        settingsButton.setTitle("Settings", forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: "settingsButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(settingsButton)

        let infoButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+150,buttonWidth,buttonHeight))
        infoButton.setTitle("Info", forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "infoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(infoButton)
        
        //Preload the views
        self.downloadViewController = DownloadViewController();
        self.downloadViewController!.superController = self
        
        self.taskViewController = TaskViewController();
        self.taskViewController!.superController = self

        self.resultViewController = ResultViewController();
        self.resultViewController!.superController = self

        self.settingsViewController = SettingsViewController();
        self.settingsViewController!.superController = self

        self.infoViewController = InfoViewController();
        self.infoViewController!.superController = self
        
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

    func infoButtonPressed()
    {
        self.goToInfoView();
    }
    
    func goToDownloadView()
    {
        self.presentViewController(self.downloadViewController!, animated: false, completion: nil)
    }

    func goToTaskView()
    {
        self.presentViewController(self.taskViewController!, animated: false, completion: nil)
    }
    
    func goToResultView()
    {
        self.presentViewController(self.resultViewController!, animated: false, completion: nil)
    }
    
    func goToSettingsView()
    {
        self.presentViewController(settingsViewController!, animated: false, completion: nil)
    }

    func goToInfoView()
    {
        self.presentViewController(infoViewController!, animated: false, completion: nil)
    }
    
    func subControllerFinished(subController: SubViewController)
    {

        subController.dismissViewControllerAnimated(false, completion: nil)        
        
        switch subController
        {
            case self.downloadViewController!:
                self.goToTaskView()
            case self.taskViewController!:
                self.goToResultView()
            default:
                println("")
        }
        
    }
}
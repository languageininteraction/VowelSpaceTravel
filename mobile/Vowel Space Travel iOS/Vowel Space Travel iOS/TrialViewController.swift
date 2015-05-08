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

class TrialViewController: SubViewController
{

    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()

        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let skipTrialButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)-150,buttonWidth,buttonHeight))
        skipTrialButton.setTitle("Skip trial", forState: UIControlState.Normal)
        skipTrialButton.addTarget(self, action: "skipTrialButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(skipTrialButton)
        
    }
    
    func skipTrialButtonPressed()
    {
        self.superController!.subControllerFinished(self)
    }
    
}

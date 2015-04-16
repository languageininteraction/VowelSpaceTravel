//
//  SettingsViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 16/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

//
//  LoginViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: SubViewController {
    
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
        
        //Create back button
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let finishButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight),buttonWidth,buttonHeight))
        finishButton.setTitle("Back", forState: UIControlState.Normal)
        finishButton.addTarget(self, action: "finishButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(finishButton)

    }
    
    func finishButtonPressed()
    {
        self.superController!.subControllerFinished(self)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
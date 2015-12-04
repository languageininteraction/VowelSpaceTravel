//
//  LoginViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,PassControlToSubControllerProtocol {
    
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var server : VSTServer?
    var vowelSelectionViewController : VowelSelectionViewController = VowelSelectionViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Show the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        //Create the text fields
        let inputFieldWidth : CGFloat = 400
        let inputFieldHeight : CGFloat = 80

        let loginField = UITextField(frame: CGRectMake(0.5*(self.screenWidth!-inputFieldWidth),0.5*(self.screenHeight!-inputFieldHeight)-100,inputFieldWidth,inputFieldHeight))
        loginField.borderStyle = UITextBorderStyle.RoundedRect
        loginField.placeholder = "Login name"
        loginField.font = UIFont(name: "Helvetica", size: 35)
        //self.view.addSubview(loginField)

        let passwordField = UITextField(frame: CGRectMake(0.5*(self.screenWidth!-inputFieldWidth),0.5*(self.screenHeight!-inputFieldHeight),inputFieldWidth,inputFieldHeight))
        passwordField.borderStyle = UITextBorderStyle.RoundedRect
        passwordField.placeholder = "Password"
        passwordField.font = UIFont(name: "Helvetica", size: 35)
        passwordField.secureTextEntry = true
        //self.view.addSubview(passwordField)
        
        //Create login button
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        let buttonTop : CGFloat = 250
        
        let loginButton = UIButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+buttonTop,buttonWidth,buttonHeight))

        loginButton.setImage(UIImage(named: "loginbutton"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
        
        let loginButtonText = UILabel();
        
        loginButtonText.frame = CGRectMake(0.5*(self.screenWidth!-buttonWidth)+15,0.5*(self.screenHeight!-buttonHeight-2)+buttonTop,buttonWidth,buttonHeight)
        loginButtonText.textAlignment = NSTextAlignment.Center
        loginButtonText.font = UIFont(name: "Muli",size:25)
        loginButtonText.text = "Start"
        loginButtonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(loginButtonText)

        //Show the text
        let titleText = UILabel()
        let padding : CGFloat = 120
        
        titleText.frame = CGRectMake(padding,-50,screenWidth!-(padding*2),350)
        titleText.textAlignment = NSTextAlignment.Center
        titleText.font = UIFont(name: "Muli",size:35)
        titleText.text = "Explore the vowels of English!"
        titleText.textAlignment = NSTextAlignment.Center
        titleText.numberOfLines = 0
        titleText.textColor = UIColor.whiteColor()
        self.view.addSubview(titleText)
        
        let instructionText = UILabel()
        
        instructionText.frame = CGRectMake(padding,padding+60,screenWidth!-(padding*2),350)
        instructionText.textAlignment = NSTextAlignment.Center
        instructionText.font = UIFont(name: "Muli",size:28)
        instructionText.text = "When learning a language you will not always be familiar with all the sounds in the new language. Here you can explore your knowledge of vowels in the British English vowel space, and learn to distinguish and recognize them. We represent each vowel with a planet: the better you become at keeping the vowels apart, the more distinct the planets will look!"
        instructionText.textAlignment = NSTextAlignment.Center
        instructionText.numberOfLines = 0
        //instructionText.backgroundColor = UIColor.blackColor()
        
        instructionText.textColor = UIColor.whiteColor()
        self.view.addSubview(instructionText)
        
        
        //Create the VSTServer object
        self.server = VSTServer(url: kWebserviceURL)
        self.server!.showAlert = self.showAlert
        
        let uudid : String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        self.server!.createUserIfItDoesNotExistAndLogin(uudid,lastName: uudid)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonPressed()
    {
        //Look at username and password
        self.login(username: "Wessel", password: "hunter2");
    }
    
    func login(username username : String,password : String)
    {
        print("Loggin in");
        self.zoomFromVowelTractOverViewToVowelSelection(nil,speed: 0.05)
    }
    
    func zoomFromVowelTractOverViewToVowelSelection(game : Game?,speed : Float)
    {
        self.vowelSelectionViewController = VowelSelectionViewController();
        self.vowelSelectionViewController.superController = self
        self.vowelSelectionViewController.server = self.server!

        if game != nil
        {
            self.vowelSelectionViewController.currentGame = game!
        }
        
        let oldTransform = vowelSelectionViewController.view.layer.transform;
        let transformScale = CATransform3DMakeScale(1.8, 1.8, 1)
        let newTransform = CATransform3DTranslate(transformScale, 0, 60, 0)
        
        CATransaction.begin()
 
        CATransaction.setCompletionBlock(
        {
            self.vowelSelectionViewController.fadeInUI()
        })
        
        let zoomAnimation = CABasicAnimation(keyPath: "transform")
        zoomAnimation.speed = speed
        zoomAnimation.fromValue = NSValue(CATransform3D: oldTransform)
        zoomAnimation.toValue = NSValue(CATransform3D: newTransform)
        vowelSelectionViewController.view.layer.addAnimation(zoomAnimation, forKey: "to new transform")
        vowelSelectionViewController.view.layer.transform = newTransform
        
        CATransaction.commit()
        
        self.view.addSubview(vowelSelectionViewController.view)
    }
    
    func showAlert(title : String,message : String)
    {
        print("Showing alert")
        
        let alertController : UIAlertController = UIAlertController(title: title,message: message,preferredStyle : UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close app", style : UIAlertActionStyle.Default,handler:
            {
                action -> Void in
                exit(0)
            })
        )
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func subControllerFinished(subController: SubViewController)
    {
        //This can only be the vowel selection view controller, and that almost always want to be restarted
        let oldVowelSelectionViewController : VowelSelectionViewController = subController as! VowelSelectionViewController
        
        subController.view.removeFromSuperview()
        
        if oldVowelSelectionViewController.viewingHelp
        {
            oldVowelSelectionViewController.viewingHelp = false
        }
        else
        {            
            self.zoomFromVowelTractOverViewToVowelSelection(oldVowelSelectionViewController.currentGame,speed: 0.6)
        }
    }
    
    //Motions can only be picked up here, because the vowel selection view controller is never officially presented
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        print("Detected shake")
        
        if self.vowelSelectionViewController.currentGame.autoPilotMode && self.vowelSelectionViewController.currentGame.stage == GameStage.ShowingResult
        {
            self.vowelSelectionViewController.resultViewController!.pilotModeFinished()
        }
        else if self.vowelSelectionViewController.currentGame.stage == GameStage.Playing
        {
            print("Got inside")
            self.vowelSelectionViewController.taskViewController!.quit()
        }
    }
    
}
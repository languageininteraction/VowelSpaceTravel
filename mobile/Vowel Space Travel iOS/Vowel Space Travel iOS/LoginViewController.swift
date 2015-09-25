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
        var backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
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
        let buttonTop : CGFloat = 200
        
        let loginButton = UIButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+buttonTop,buttonWidth,buttonHeight))

        loginButton.setImage(UIImage(named: "loginbutton"), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)

        var labelWidth : CGFloat = 300;
        var labelHeigth : CGFloat = 30;
        
        var loginButtonText = UILabel();
        
        loginButtonText.frame = CGRectMake(0.5*(self.screenWidth!-buttonWidth)+15,0.5*(self.screenHeight!-buttonHeight-2)+buttonTop,buttonWidth,buttonHeight)
        loginButtonText.textAlignment = NSTextAlignment.Center
        loginButtonText.font = UIFont(name: "Muli",size:25)
        loginButtonText.text = "Start"
        loginButtonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(loginButtonText)
        
        //Show the text
        var instructionText = UILabel()
        var padding : CGFloat = 120
        
        instructionText.frame = CGRectMake(padding,padding+10,screenWidth!-(padding*2),350)
        instructionText.textAlignment = NSTextAlignment.Center
        instructionText.font = UIFont(name: "Muli",size:28)
        instructionText.text = "In this app, you will learn to distinguish and recognize vowels in English. Each vowel is represented by a planet. The better get at keeping these vowels apart, the more distinct the planets will look.\n\n Good luck finding your way around the English \n vowel space!"
        instructionText.textAlignment = NSTextAlignment.Center
        instructionText.numberOfLines = 0
        //instructionText.backgroundColor = UIColor.blackColor()
        
        instructionText.textColor = UIColor.whiteColor()
        self.view.addSubview(instructionText)
        
        
        //Create the VSTServer object
        self.server = VSTServer(url: kWebserviceURL)
        self.server!.showAlert = self.showAlert
        
        var uudid : String = UIDevice.currentDevice().identifierForVendor.UUIDString
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
    
    func login(#username : String,password : String)
    {
        println("Loggin in");
        self.zoomFromVowelTractOverViewToVowelSelection(nil)
    }
    
    func zoomFromVowelTractOverViewToVowelSelection(game : Game?)
    {
        self.vowelSelectionViewController = VowelSelectionViewController();
        self.vowelSelectionViewController.superController = self
        self.vowelSelectionViewController.server = self.server!

        if game != nil
        {
            self.vowelSelectionViewController.currentGame = game!
        }
        
        var oldTransform = vowelSelectionViewController.view.layer.transform;
        var transformScale = CATransform3DMakeScale(1.8, 1.8, 1)
        var newTransform = CATransform3DTranslate(transformScale, 0, 60, 0)
        
        CATransaction.begin()
        
        var zoomAnimation = CABasicAnimation(keyPath: "transform")
        zoomAnimation.speed = 0.1
        zoomAnimation.fromValue = NSValue(CATransform3D: oldTransform)
        zoomAnimation.toValue = NSValue(CATransform3D: newTransform)
        vowelSelectionViewController.view.layer.addAnimation(zoomAnimation, forKey: "to new transform")
        vowelSelectionViewController.view.layer.transform = newTransform
        
        CATransaction.commit()
        
        self.view.addSubview(vowelSelectionViewController.view)
    }
    
    func showAlert(title : String,message : String)
    {
        var alertController : UIAlertController = UIAlertController(title: title,message: message,preferredStyle : UIAlertControllerStyle.Alert)
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
        var oldVowelSelectionViewController : VowelSelectionViewController = subController as! VowelSelectionViewController
        
        subController.view.removeFromSuperview()
        
        if oldVowelSelectionViewController.viewingHelp
        {
            oldVowelSelectionViewController.viewingHelp = false
        }
        else
        {            
            self.zoomFromVowelTractOverViewToVowelSelection(oldVowelSelectionViewController.currentGame)
        }
    }
    
    //Motions can only be picked up here, because the vowel selection view controller is never officially presented
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent)
    {
        println("Detected shake")
        
        if self.vowelSelectionViewController.currentGame.autoPilotMode && self.vowelSelectionViewController.currentGame.stage == GameStage.ShowingResult
        {
            self.vowelSelectionViewController.resultViewController!.pilotModeFinished()
        }
        else if self.vowelSelectionViewController.currentGame.stage == GameStage.Playing
        {
            println("Got inside")
            self.vowelSelectionViewController.taskViewController!.quit()
        }
    }
    
}
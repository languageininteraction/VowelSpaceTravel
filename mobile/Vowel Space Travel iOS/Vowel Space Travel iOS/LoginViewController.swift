//
//  LoginViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var server : VSTServer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Make the background white
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Create the text fields
        let inputFieldWidth : CGFloat = 400
        let inputFieldHeight : CGFloat = 80

        let loginField = UITextField(frame: CGRectMake(0.5*(self.screenWidth!-inputFieldWidth),0.5*(self.screenHeight!-inputFieldHeight)-100,inputFieldWidth,inputFieldHeight))
        loginField.borderStyle = UITextBorderStyle.RoundedRect
        loginField.placeholder = "Login name"
        loginField.font = UIFont(name: "Helvetica", size: 35)
        self.view.addSubview(loginField)

        let passwordField = UITextField(frame: CGRectMake(0.5*(self.screenWidth!-inputFieldWidth),0.5*(self.screenHeight!-inputFieldHeight),inputFieldWidth,inputFieldHeight))
        passwordField.borderStyle = UITextBorderStyle.RoundedRect
        passwordField.placeholder = "Password"
        passwordField.font = UIFont(name: "Helvetica", size: 35)
        passwordField.secureTextEntry = true
        self.view.addSubview(passwordField)
        
        //Create login button
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let loginButton = TempStyledButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+100,buttonWidth,buttonHeight))

        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)

        //Show account creation label
        var createAccountLink = UILabel();
        var labelWidth : CGFloat = 300;
        var labelHeigth : CGFloat = 30;
        
        createAccountLink.frame = CGRectMake(0.5*(self.screenWidth!-labelWidth),0.5*(self.screenHeight!-labelHeigth) + 200,labelWidth,labelHeigth)
        createAccountLink.textAlignment = NSTextAlignment.Center
        createAccountLink.text = "Create account"
        self.view.addSubview(createAccountLink)
        
        //Create the VSTServer object
        self.server = VSTServer(url: kWebserviceURL)
        
        self.server!.tryLoggingIn("wessel", password: "hunter2")
        self.server!.createNewUser("Wessel")
        
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
        self.zoomFromVowelTractOverViewToVowelSelection()
    }
    
    func zoomFromVowelTractOverViewToVowelSelection()
    {
        let vowelSelectionViewController = VowelSelectionViewController();
        vowelSelectionViewController.server = self.server!
        
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
    
}
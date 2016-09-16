//
//  LoginViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 11/12/15.
//  Copyright © 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: SubViewController, PassControlToSubControllerProtocol, UITextFieldDelegate
{
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var registerViewController : RegisterViewController = RegisterViewController()
    var server : VSTServer!
    
    let textFieldWidth : CGFloat = 300
    let textFieldHeight : CGFloat = 100
    
    var emailTextField : UITextField = UITextField()
    var passwordTextField : UITextField = UITextField()

    var numberOfActiveTextFields : Int = 0
    
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
        let textFieldLeft : CGFloat = 360
        let textFieldFirstRow : CGFloat = 190
        let textFieldSecondRow : CGFloat = 336
        
        self.emailTextField = self.createTextField(textFieldLeft, y: textFieldFirstRow, placeHolder: "Email address")
        self.passwordTextField = self.createTextField(textFieldLeft, y: textFieldSecondRow, placeHolder: "Password", hidden: true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.emailTextField.text = defaults.valueForKey("email") as? String
        self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
        
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        
        //Create start button
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        let buttonTop : CGFloat = 170
        
        let loginbutton = UIButton(frame: CGRectMake(0.5*(self.screenWidth!-buttonWidth),0.5*(self.screenHeight!-buttonHeight)+buttonTop,buttonWidth,buttonHeight))
        
        loginbutton.setImage(UIImage(named: "loginbutton"), forState: UIControlState.Normal)
        loginbutton.addTarget(self, action: "loginButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginbutton)
        
        let loginbuttonText = UILabel();
        
        loginbuttonText.frame = CGRectMake(0.5*(self.screenWidth!-buttonWidth)+15,0.5*(self.screenHeight!-buttonHeight-2)+buttonTop,buttonWidth,buttonHeight)
        loginbuttonText.textAlignment = NSTextAlignment.Center
        loginbuttonText.font = UIFont(name: "Muli",size:25)
        loginbuttonText.text = "Log in"
        loginbuttonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(loginbuttonText)
    
        let registerTextTop : CGFloat = 290
        
        let registerText = UILabel();
        
        registerText.frame = CGRectMake(0.5*(self.screenWidth!-buttonWidth)+15,0.5*(self.screenHeight!-buttonHeight-2)+registerTextTop,buttonWidth,buttonHeight)
        registerText.textAlignment = NSTextAlignment.Center
        registerText.font = UIFont(name: "Muli",size:25)
        registerText.text = "Register"
        registerText.textColor = UIColor.whiteColor()
        self.view.addSubview(registerText)
        
        let registerButton = UIButton()
        registerButton.frame = CGRectMake(0.5*(self.screenWidth!-buttonWidth)+15,0.5*(self.screenHeight!-buttonHeight-2)+registerTextTop,buttonWidth,buttonHeight)
//        registerButton.backgroundColor = UIColor.redColor()
        registerButton.addTarget(self, action: "registerButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
        
    }
    
    func loginButtonPressed()
    {
        self.server!.logIn(self.emailTextField.text!, password: self.passwordTextField.text!)
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(self.emailTextField.text!,forKey: "email")
            self.superController!.subControllerFinished(self)            
        }
    }

    func registerButtonPressed()
    {
        self.registerViewController.superController = self
        self.registerViewController.server = self.server
        self.view.addSubview(self.registerViewController.view)
    }
    
    func createTextField(x : CGFloat, y : CGFloat, placeHolder : String, hidden : Bool = false) -> UITextField
    {
        let textField : UITextField = UITextField()
        textField.frame = CGRect(x : x, y: y, width: self.textFieldWidth, height: self.textFieldHeight)
        textField.placeholder = placeHolder
        textField.textAlignment = NSTextAlignment.Center
        textField.font = UIFont(name: "Muli",size: 40)
        textField.textColor = UIColor.whiteColor()
        textField.delegate = self
        textField.secureTextEntry = hidden
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        
        //textField.backgroundColor = UIColor.redColor()
        
        return textField
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        self.numberOfActiveTextFields++
        
        self.moveWholeViewUp()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        self.numberOfActiveTextFields--
                
        if (self.numberOfActiveTextFields == 0)
        {
            self.moveWholeViewDown()
        }
        
        return true
    }    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func moveWholeViewUp()
    {
        UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = -100})
    }
    
    func moveWholeViewDown()
    {
        if self.view.frame.origin.y != 0
        {
            UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = 0})
        }
    }
    
    func subControllerFinished(subController: SubViewController)
    {        
        subController.view.removeFromSuperview()
    }
    
}
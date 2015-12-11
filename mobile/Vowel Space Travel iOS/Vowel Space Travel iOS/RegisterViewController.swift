//
//  RegisterViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 11/12/15.
//  Copyright © 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: SubViewController, UITextFieldDelegate
{
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    
    var largeTextFieldWidth : CGFloat = 450
    var smallTextFieldWidth : CGFloat = 260
    
    var textFieldHeight : CGFloat = 70
    
    var firstNameTextField : UITextField = UITextField()
    var lastNameTextField : UITextField = UITextField()
    var emailTextField : UITextField = UITextField()
    var passwordTextField : UITextField = UITextField()
    var repeatPasswordTextField : UITextField = UITextField()
    
    var server : VSTServer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Remember the screen sizes
        self.screenWidth = self.view.frame.size.width
        self.screenHeight = self.view.frame.size.height
        
        //Show the background image
        let backgroundImageView = UIImageView(image: UIImage(named: "register_background"))
        backgroundImageView.frame = CGRect(x: 0,y: 0,width: self.screenWidth!,height: screenHeight!)
        self.view.addSubview(backgroundImageView)
        
        let firstRowTop : CGFloat = 105
        let secondRowTop : CGFloat = 275
        let thirdRowTop : CGFloat = 455
        let fourthRowTop : CGFloat = 625
        
        let firstColumnLeft : CGFloat = 150
        let secondColumnLeft : CGFloat = 300
        let thirdColumnLeft : CGFloat = 600
        
        self.firstNameTextField = self.createTextField(firstColumnLeft, y: firstRowTop, large: false, placeHolder: "First name")
        self.view.addSubview(self.firstNameTextField)

        self.lastNameTextField = self.createTextField(thirdColumnLeft, y: firstRowTop, large: false, placeHolder: "Last name")
        self.view.addSubview(self.lastNameTextField)
        
        self.emailTextField = self.createTextField(secondColumnLeft, y: secondRowTop, large: true, placeHolder: "Email address")
        self.view.addSubview(self.emailTextField)

        self.passwordTextField = self.createTextField(firstColumnLeft, y: thirdRowTop, large: false, placeHolder: "Password", hidden: true)
        self.view.addSubview(self.passwordTextField)
        
        self.repeatPasswordTextField = self.createTextField(thirdColumnLeft, y: thirdRowTop, large: false, placeHolder: "Repeat password", hidden: true)
        self.view.addSubview(self.repeatPasswordTextField)
        
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let registerButton = UIButton(frame: CGRectMake(thirdColumnLeft,fourthRowTop,buttonWidth,buttonHeight))
        
        registerButton.setImage(UIImage(named: "loginbutton"), forState: UIControlState.Normal)
        registerButton.addTarget(self, action: "registerButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
        
        let registerButtonText = UILabel();
        
        registerButtonText.frame = CGRectMake(thirdColumnLeft+3,fourthRowTop-2,buttonWidth,buttonHeight)
        registerButtonText.textAlignment = NSTextAlignment.Center
        registerButtonText.font = UIFont(name: "Muli",size:25)
        registerButtonText.text = "Register"
        registerButtonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(registerButtonText)

        let backButton = UIButton(frame: CGRectMake(firstColumnLeft,fourthRowTop,buttonWidth,buttonHeight))
        
        backButton.setImage(UIImage(named: "backbutton"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        let backButtonText = UILabel();
        
        backButtonText.frame = CGRectMake(firstColumnLeft,fourthRowTop,buttonWidth,buttonHeight)
        backButtonText.textAlignment = NSTextAlignment.Center
        backButtonText.font = UIFont(name: "Muli",size:25)
        backButtonText.text = "Back"
        backButtonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(backButtonText)
        
        //Add the pan gestures
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
    }

    func createTextField(x : CGFloat, y : CGFloat, large : Bool, placeHolder : String, hidden : Bool = false) -> UITextField
    {
        let textField : UITextField = UITextField()
        textField.frame = CGRect(x : x, y: y, width: large ? self.largeTextFieldWidth : self.smallTextFieldWidth, height: self.textFieldHeight)
        textField.placeholder = placeHolder
        textField.textAlignment = NSTextAlignment.Center
        textField.font = UIFont(name: "Muli",size: 30)
        textField.textColor = UIColor.whiteColor()
        textField.delegate = self
        textField.secureTextEntry = hidden
        
        return textField
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if textField.frame.minY > 300
        {
            self.moveWholeViewUp()
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        self.moveWholeViewDown()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    func moveWholeViewUp()
    {
        UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = -200})
    }

    func moveWholeViewDown()
    {
        if self.view.frame.origin.y != 0
        {
            UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = 0})
        }
    }
    
    func backButtonPressed()
    {
        print("back button")
        self.superController!.subControllerFinished(self)
    }
    
    func registerButtonPressed()
    {
        self.register()
        self.superController!.subControllerFinished(self)
    }
    
    func register()
    {
        let firstName : String = self.firstNameTextField.text!
        let lastName : String = self.lastNameTextField.text!
        let email : String = self.emailTextField.text!
        let password : String = self.passwordTextField.text!
        //let repeatPassword : String = self.repeatPasswordTextField.text!
        
        self.server!.createNewUser(firstName,lastName : lastName, email : email,token : password)
    }
    
    func handlePan(recognizer : UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            let startLocation : CGPoint = recognizer.locationInView(self.view)
            
            if kShowTouchLocation
            {
                print(startLocation)
            }
        }
    }
    
}
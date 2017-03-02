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
    
    var numberOfActiveTextFields : Int = 0
    
    var largeTextFieldWidth : CGFloat = 450
    var smallTextFieldWidth : CGFloat = 260
    
    var textFieldHeight : CGFloat = 70
    
    var firstNameTextField : UITextField = UITextField()
    var lastNameTextField : UITextField = UITextField()
    var emailTextField : UITextField = UITextField()
    var passwordTextField : UITextField = UITextField()
    var repeatPasswordTextField : UITextField = UITextField()
    var nativeLanguageTextField : UITextField = UITextField()

    var radioButtonSelectedImage : UIImageView?
    var allowDataUse : Bool?
    
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
        
        let firstRowTop : CGFloat = 75
        let secondRowTop : CGFloat = 250
        let thirdRowTop : CGFloat = 420
        let fourthRowTop : CGFloat = 540
        let fifthRowTop : CGFloat = 645
        
        let firstColumnLeft : CGFloat = 150
        let secondColumnLeft : CGFloat = 300
        let thirdColumnLeft : CGFloat = 600

// VST team decided they don't need these fields, so they will probably not return
//        self.firstNameTextField = self.createTextField(firstColumnLeft, y: firstRowTop, large: false, placeHolder: "First name")
//        self.view.addSubview(self.firstNameTextField)
//
//        self.lastNameTextField = self.createTextField(thirdColumnLeft, y: firstRowTop, large: false, placeHolder: "Last name")
//        self.view.addSubview(self.lastNameTextField)
        
        self.emailTextField = self.createTextField(secondColumnLeft, y: firstRowTop, large: true, placeHolder: "Email address")
        self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
        self.view.addSubview(self.emailTextField)

        self.passwordTextField = self.createTextField(firstColumnLeft, y: secondRowTop, large: false, placeHolder: "Choose password", hidden: true)
        self.view.addSubview(self.passwordTextField)
        
        self.repeatPasswordTextField = self.createTextField(thirdColumnLeft, y: secondRowTop, large: false, placeHolder: "Repeat password", hidden: true)
        self.view.addSubview(self.repeatPasswordTextField)

        self.nativeLanguageTextField = self.createTextField(secondColumnLeft, y: thirdRowTop, large: true, placeHolder: "Your best language")
        self.view.addSubview(self.nativeLanguageTextField)
        
        let allowDataUseLabel = UILabel()
        
        allowDataUseLabel.frame = CGRectMake(firstColumnLeft,fourthRowTop,500,80)
        allowDataUseLabel.font = UIFont(name: "Muli",size:15)
        allowDataUseLabel.numberOfLines = 0
        allowDataUseLabel.textAlignment = NSTextAlignment.Center
        allowDataUseLabel.text = "I allow my anonymized data to be used in scientific \n analyses of vowel-learning behaviour"
        allowDataUseLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(allowDataUseLabel)
        
        let buttonWidth : CGFloat = 200
        let buttonHeight : CGFloat = 70
        
        let yesButton = UIButton(frame: CGRectMake(620,fourthRowTop,buttonWidth,buttonHeight))
        yesButton.setTitle("yes", forState: UIControlState.Normal)
        yesButton.titleLabel!.font = UIFont(name: "Muli",size:25)
        yesButton.titleLabel!.textColor = UIColor.whiteColor()
        yesButton.addTarget(self, action: "yesRadioButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(yesButton)
        
        let noButton = UIButton(frame: CGRectMake(800,fourthRowTop,buttonWidth,buttonHeight))
        noButton.setTitle("no", forState: UIControlState.Normal)
        noButton.titleLabel!.font = UIFont(name: "Muli",size:25)
        noButton.titleLabel!.textColor = UIColor.whiteColor()
        noButton.addTarget(self, action: "noRadioButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(noButton)
        
        let registerButton = UIButton(frame: CGRectMake(thirdColumnLeft,fifthRowTop,buttonWidth,buttonHeight))
        
        registerButton.setImage(UIImage(named: "loginbutton"), forState: UIControlState.Normal)
        registerButton.addTarget(self, action: "registerButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(registerButton)
        
        let registerButtonText = UILabel()
        
        registerButtonText.frame = CGRectMake(thirdColumnLeft+3,fifthRowTop-2,buttonWidth,buttonHeight)
        registerButtonText.textAlignment = NSTextAlignment.Center
        registerButtonText.font = UIFont(name: "Muli",size:25)
        registerButtonText.text = "Register"
        registerButtonText.textColor = UIColor(hue: 0.87, saturation: 0.3, brightness: 0.3, alpha: 1)
        self.view.addSubview(registerButtonText)

        let backButton = UIButton(frame: CGRectMake(firstColumnLeft,fifthRowTop,buttonWidth,buttonHeight))
        
        backButton.setImage(UIImage(named: "backbutton"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        let backButtonText = UILabel();
        
        backButtonText.frame = CGRectMake(firstColumnLeft,fifthRowTop,buttonWidth,buttonHeight)
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
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        
        return textField
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if textField.frame.minY > 300
        {
            self.moveWholeViewUp(300)
        }
        else if textField.frame.minY > 100
        {
            self.moveWholeViewUp(100)
        }
        
        self.numberOfActiveTextFields++
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
    
    func moveWholeViewUp(amount : CGFloat)
    {
        UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = -amount})
    }

    func moveWholeViewDown()
    {
        if self.view.frame.origin.y != 0
        {
            UIView.animateWithDuration(1, animations: {self.view.frame.origin.y = 0})
        }
    }

    func yesRadioButtonPressed()
    {
        if self.radioButtonSelectedImage == nil
        {
            self.radioButtonSelectedImage = UIImageView(image: UIImage(named: "radioButtonSelected"))
            self.view.addSubview(radioButtonSelectedImage!)
        }
        self.radioButtonSelectedImage!.frame = CGRect(x: 656,y: 571,width: 15,height: 15)
        
        self.allowDataUse = true
    }
    
    func noRadioButtonPressed()
    {
        if self.radioButtonSelectedImage == nil
        {
            self.radioButtonSelectedImage = UIImageView(image: UIImage(named: "radioButtonSelected"))
            self.view.addSubview(radioButtonSelectedImage!)
        }
        self.radioButtonSelectedImage!.frame = CGRect(x: 834,y: 571,width: 15,height: 15)
        
        self.allowDataUse = false
    }
    
    func backButtonPressed()
    {
        self.superController!.subControllerFinished(self)
    }
    
    func registerButtonPressed()
    {
        self.register()
    }

    func register()
    {
        let firstName : String = self.firstNameTextField.text!
        let lastName : String = self.lastNameTextField.text!
        let email : String = self.emailTextField.text!
        let password : String = self.passwordTextField.text!
        let repeatPassword : String = self.repeatPasswordTextField.text!
        let nativeLanguage : String = self.nativeLanguageTextField.text!
        
        if [email,password,repeatPassword,nativeLanguage].contains("") || self.allowDataUse == nil
        {
            self.showAlert("Empty fields",message: "Please make sure all input fields are filled.")
        }
        else if (password != repeatPassword)
        {
            self.showAlert("Passwords don't match",message: "Please make sure the two passwords match.")
        }
        else
        {
            self.server!.checkWhetherEmailIsInDatabase(email)
            {
                (inDatabase,err) -> Void in
                
                print("In database \(inDatabase)")
                
                if inDatabase
                {
                    self.showAlert("Email address already in database", message: "We already found this email address in our database, please use another one.")
                }
                else
                {
                    self.server!.createNewUser(email,token : password,nativeLanguage: nativeLanguage,allowsUseForResearch: self.allowDataUse!)
                    self.superController!.subControllerFinished(self)
                }
            }
        }
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
    
    func showAlert(title : String,message : String)
    {
        let alertController : UIAlertController = UIAlertController(title: title,message: message,preferredStyle : UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style : UIAlertActionStyle.Default,handler:
            {
                action -> Void in
        })
        )
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
//
//  PassControlBackAndForth.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit

protocol PassControlToSubControllerProtocol
{
    func subControllerFinished(subController:SubViewController)
}

protocol TakeControlFromSuperControllerProtocol
{
    func setSuperController(superController:PassControlToSubControllerProtocol)
}

class SubViewController: UIViewController, TakeControlFromSuperControllerProtocol
{
    var superController: PassControlToSubControllerProtocol?
    
    func setSuperController(superController:PassControlToSubControllerProtocol) {
        self.superController = superController
    }
}
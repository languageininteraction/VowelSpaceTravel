//
//  TempObjects.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class TempStyledButton : UIButton
{
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required override init(frame CGframe: CGRect)
    {
        super.init(frame: CGframe)
        self.backgroundColor = UIColor.lightGrayColor()
        self.layer.cornerRadius = 10.0;
    }
        
}

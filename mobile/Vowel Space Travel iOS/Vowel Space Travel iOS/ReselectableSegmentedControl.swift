//
//  ReselectableSegmentedControl.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 20/08/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation
import UIKit

class ReselectableSegmentedControl: UISegmentedControl
{
    @IBInspectable var allowReselection: Bool = true
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let previousSelectedSegmentIndex = self.selectedSegmentIndex
        super.touchesEnded(touches, withEvent: event)
        if allowReselection && previousSelectedSegmentIndex == self.selectedSegmentIndex
        {
            if let touch = touches.first as? UITouch
            {
                let touchLocation = touch.locationInView(self)
                if CGRectContainsPoint(bounds, touchLocation)
                {
                    self.sendActionsForControlEvents(.ValueChanged)
                }
            }
        }
    }
}
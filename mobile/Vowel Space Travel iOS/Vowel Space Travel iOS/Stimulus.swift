//
//  Stimulus.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 13/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

class Stimulus : NSObject
{
    var requiresResponse : Bool
    var soundFileName : String
    
    init(soundFileName : String, requiresResponse : Bool)
    {
        self.requiresResponse = requiresResponse
        self.soundFileName = soundFileName
    }
}
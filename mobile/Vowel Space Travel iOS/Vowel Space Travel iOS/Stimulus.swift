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
    var receivedResponse : Bool?
    var sampleID : Int
    var fileLocation : String?
    
    init(sampleID : Int, requiresResponse : Bool)
    {
        self.sampleID = sampleID
        self.requiresResponse = requiresResponse
    }
    
    func hasCorrectAnswer() -> Bool?
    {
        if receivedResponse != nil
        {
            return self.requiresResponse == self.receivedResponse
        }
        else
        {
            return nil
        }
    }
}
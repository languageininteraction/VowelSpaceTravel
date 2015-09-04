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
    var relevance : String //unclear what this is, but the server requires it
    var receivedResponse : Bool?
    var sampleID : Int
    var vowelID : Int
    var speakerLabel : String
    var fileLocation : String?
    
    init(sampleID : Int, requiresResponse : Bool, relevance : String, vowelID : Int, speakerLabel : String)
    {
        self.sampleID = sampleID
        self.requiresResponse = requiresResponse
        self.relevance = relevance
        self.vowelID = vowelID
        self.speakerLabel = speakerLabel
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
    
    func packageToDictionary() -> Dictionary<String,AnyObject>
    {
        println("Received response \(receivedResponse) \(self.receivedResponse != nil && self.receivedResponse! == false)")
        
        var result : Dictionary<String,AnyObject> = ["responseTimeMs":"1",
                                                    "relevance":self.relevance,
                                                    "playerResponse":self.receivedResponse != nil && self.receivedResponse! == false,
                                                    "vowelID":self.vowelID,
                                                    "sampleID":self.sampleID,
                                                    "speakerLabel":self.speakerLabel,
                                                    "wordString":""]
        
        return result
    }
}
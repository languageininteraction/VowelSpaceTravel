//
//  Vowel.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 07/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

enum VowelPlace : String
{
    case back = "back"
    case near_back = "near_back"
    case central = "central"
    case near_front = "near_front"
    case front = "front"
}

enum VowelManner : String
{
    case open = "open"
    case near_open = "near_open"
    case open_mid = "open_mid"
    case mid = "mid"
    case close_mid = "close_mid"
    case near_close = "near_close"
    case close = "close"
}


class VowelDefinition : NSObject
{
    var exampleWord : String = ""
    var place : VowelPlace?
    var manner : VowelManner?
    var rounded : Bool?
    var ipaNotation : String
    var id : Int
    
    init(id : Int, ipaNotation : String)
    {
        self.id = id
        self.ipaNotation = ipaNotation
    }
    
    func placeAsFloat() -> Float
    {
        switch(self.place!)
        {
            case VowelPlace.back: return 0
            case VowelPlace.near_back: return 0.25
            case VowelPlace.central: return 0.5
            case VowelPlace.near_front: return 0.75
            case VowelPlace.front: return 1
        }
    }
    
    func mannerAsFloat() -> Float
    {
        switch(self.manner!)
        {
            case VowelManner.close : return 0
            case VowelManner.near_close : return 0.16
            case VowelManner.close_mid : return 0.33
            case VowelManner.mid : return 0.5
            case VowelManner.open_mid : return 0.66
            case VowelManner.near_open : return 0.85
            case VowelManner.open : return 1
        }
    }
    
    func roundednessAsFloat() -> Float
    {
        if self.rounded!
        {
            return 1
        }
        else
        {
            return 0
        }
    }
}
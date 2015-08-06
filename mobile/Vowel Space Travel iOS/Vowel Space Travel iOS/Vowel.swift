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
    
    init(ipaNotation : String) //, place : VowelPlace, manner : VowelManner, rounded : Bool)
    {
        self.ipaNotation = ipaNotation
//        self.place = place
//        self.manner = manner
//        self.rounded = rounded
    }
}
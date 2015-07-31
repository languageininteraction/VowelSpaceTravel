//
//  Vowel.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 07/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

enum VowelPlace
{
    case back
    case near_back
    case mid
    case front
}

enum VowelManner
{
    case open
    case center
    case near_close
    case close
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
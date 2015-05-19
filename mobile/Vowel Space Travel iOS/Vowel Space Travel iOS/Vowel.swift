//
//  Vowel.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 07/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

class VowelDefinition : NSObject
{
    var exampleWord : String
    var xPositionInMouth : Float
    var yPositionInMouth : Float

    init(exampleWord : String, xPositionInMouth : Float, yPositionInMouth : Float)
    {
        self.exampleWord = exampleWord
        self.xPositionInMouth = xPositionInMouth
        self.yPositionInMouth = yPositionInMouth
    }
}
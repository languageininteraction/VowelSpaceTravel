//
//  Game.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 08/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

enum Task
{
    case Discrimination
    case Identification
}

enum GameStage
{
    case SelectingInitialVowel
    case SelectingVowelsToCompareWith
    case SettingOtherSettings
    case Trial
    case Playing
    case ShowingResult
    case Finished
}

class Game : NSObject
{
    var stage : GameStage = GameStage.SelectingInitialVowel
    
    var roundNr : Int = 0
    var nrOfRounds : Int = 1
    
    var selectedInitialVowel : VowelDefinition?
    var selectedVowelsToCompareWith = [VowelDefinition]()
    var selectedTask : Task?
    
    var multipleSpeakers : Bool = false
    var differentStartingSounds : Bool = false
    
    override init() {}
}
//
//  Game.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 08/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

public enum Task
{
    case Discrimination
    case Identification
}

enum GameStage
{
    case SelectingVowels
    case SettingOtherSettings
    case Trial
    case Playing
    case ShowingResult
    case Finished
}

class Game : NSObject
{
    var stage : GameStage = GameStage.SelectingVowels
    
    var roundNr : Int = 0
    var autoPilotMode : Bool = false
    
    var selectedBaseVowel : VowelDefinition?
    var selectedTargetVowel : VowelDefinition?
    var selectedTask : Task = Task.Discrimination
    
    var multipleSpeakers : Bool = false
    var differentStartingSounds : Bool = false
    
    override init() {}
}
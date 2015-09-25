//
//  Game.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 08/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

enum Task : String
{
    case Discrimination = "discrimination"
    case Identification = "identification"
}

enum GameStage : String
{
    case SelectingVowels = "vowels"
    case SettingOtherSettings = "settings"
    case Playing = "playing"
    case ShowingResult = "results"
    case Finished = "finished"
}

class GameSuggestion
{
    var targetVowel: VowelDefinition
    var standardVowel : VowelDefinition
    var task : Task
    var multipleSpeakers : Bool
    var differentStartingSounds : Bool
    
    init(targetVowel : VowelDefinition, standardVowel : VowelDefinition, task : Task, multipleSpeakers : Bool, differentStartingSounds : Bool)
    {
        self.targetVowel = targetVowel
        self.standardVowel = standardVowel
        self.task = task
        self.multipleSpeakers = multipleSpeakers
        self.differentStartingSounds = differentStartingSounds
    }
}

class Game : NSObject, StimuliRequest
{
    var stage : GameStage = GameStage.SelectingVowels
    
    var roundNr : Int = 0
    var autoPilotMode : Bool = false
    
    var selectedBaseVowel : VowelDefinition?
    var selectedTargetVowel : VowelDefinition?
    var selectedTask : Task = Task.Discrimination
    
    var multipleSpeakers : Bool = false
    var differentStartingSounds : Bool = false
    
    var stimuli : [Stimulus] = []
    
    override init() {}
}
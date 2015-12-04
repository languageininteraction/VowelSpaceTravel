//
//  Constants.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 10/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

let kDevelopmentMode = true
let kSpeedUpDownload = kDevelopmentMode ? true : false
let kOnlyOneStimulus = kDevelopmentMode ? true : false
let kShowTouchLocation = kDevelopmentMode ? false : false
let kShowPlanetsForExampleUser = kDevelopmentMode ? false : false

let kWebserviceURL = kDevelopmentMode ? "http://applejack.science.ru.nl:8080/" : "http://applejack.science.ru.nl:8080/"
let kWebserviceUsername = kDevelopmentMode ? "jane@bsmoth.none" : "jane@bsmoth.none"
let kWebserviceUserPassword = kDevelopmentMode ? "1234" : "1234"

let kFeedbackSoundVolume : Float = 0.2

let kTimeBeforeStimuli : Double = 1
let kTimeBetweenStimuli : Double = 2
let kTimeBetweenStimuliWhenShowingTheExample : Double = 4
let kPauseBetweenRounds : Double = 6
let kNumberOfStimuliInRound : Int = 15
let kMaxNumberOfTargetsInRound : Int = 6

let kCachedStimuliLocation : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask,true)[0] + "/Caches/"
let kSoundFileExtension = ".wav"
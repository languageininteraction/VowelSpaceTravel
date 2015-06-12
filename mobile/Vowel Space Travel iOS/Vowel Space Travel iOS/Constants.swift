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

let kWebserviceURL = kDevelopmentMode ? "http://applejack.science.ru.nl:8080/" : ""

let kTimeBetweenStimuli : Double = 2
let kPauseBetweenRounds : Double = 6
let kNumberOfStimuliInRound : Int = 10 //Not used yet
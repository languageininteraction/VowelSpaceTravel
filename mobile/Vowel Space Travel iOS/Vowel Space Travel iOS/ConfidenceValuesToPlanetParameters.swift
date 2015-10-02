//
//  ConfidenceValuesToPlanetParameters.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 09/09/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

func addMixingWeightToConfidences(confidencesForVowelPairsByTargetVowelId : Dictionary<Int,[ConfidenceForVowelPair]>)
{
    var allConfidenceValues = [ConfidenceForVowelPair]()
    
    //First gather all summed inverted confidence values for all target ids
    var summedInvertedConfidenceValuesPerTargetId = Dictionary<Int,Float>()
    
    for (targetVowelId,confidenceValues) in confidencesForVowelPairsByTargetVowelId
    {
        summedInvertedConfidenceValuesPerTargetId[targetVowelId] = 0
        
        for confidenceValue in confidenceValues
        {
            summedInvertedConfidenceValuesPerTargetId[targetVowelId]! += confidenceValue.inverted
            allConfidenceValues.append(confidenceValue)
        }
    }
    
    //Then, save the mixing weight for each confidence
    for confidenceValue in allConfidenceValues
    {
        confidenceValue.mixingWeigth = confidenceValue.inverted / summedInvertedConfidenceValuesPerTargetId[confidenceValue.targetVowelId]!
    }
    
    print("Added confidences")
}

func adjustFeaturesForVowelUsingOtherVowelsAndMixingWeights(vowel : VowelDefinition, allVowels : Dictionary<String,VowelDefinition>,confidencesForVowelPairsByTargetVowelId : Dictionary<Int,[ConfidenceForVowelPair]>) -> (place : Float, manner : Float, roundedness : Float)
{
    var mixingWeightForThisVowel : Float = 0
    
    var endPlaceValueForThisVowel : Float
    var resultPlace : Float = 0
    var endMannerValueForThisVowel : Float
    var resultManner : Float = 0
    var endRoundednessValueForThisVowel : Float
    var resultRoundedness : Float = 0
    
    for (exampleWord, otherVowel) in allVowels
    {
        endPlaceValueForThisVowel = otherVowel.placeAsFloat()
        endMannerValueForThisVowel = otherVowel.mannerAsFloat()
        endRoundednessValueForThisVowel = otherVowel.roundednessAsFloat()
        
        for confidence in confidencesForVowelPairsByTargetVowelId[vowel.id]!
        {
            if confidence.standardVowelId == otherVowel.id
            {
                mixingWeightForThisVowel = confidence.mixingWeigth!
                break
            }
        }
                
        resultPlace += endPlaceValueForThisVowel * mixingWeightForThisVowel
        resultManner += endMannerValueForThisVowel * mixingWeightForThisVowel
        resultRoundedness += endRoundednessValueForThisVowel * mixingWeightForThisVowel
    }
        
    return (place: resultPlace, manner: resultManner, roundedness: resultRoundedness)
}
//
//  VSTServer.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 23/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

enum LoginResult
{
    case Successful
    case UserDoesNotExist
    case IncorrectPassword
}

class VSTServer : NSObject
{
    var url : String
    
    var userName : String?
    var userLoggedInSuccesfully : Bool = false
    
    var latestResponse : NSArray?
    
    init(url: String)
    {
        self.url = url
    }
    
    func HTTPGetToJSON(urlExtension: String, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        var jsonData : NSDictionary?
        
        var request : NSURLRequest = NSURLRequest(URL: NSURL(string: self.url+urlExtension)!)

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, responseData: NSData!,error:NSError!) -> Void in
            
            if error == nil
            {
                jsonData = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary?
                
                completionHandler(jsonData,error);

            }
            else
            {
                println("Error: \(error.localizedDescription)")
            }
            
        })
        
    }
    
    func HTTPPostToJSON(urlExtension: String, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        var jsonData : NSDictionary?
        
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+urlExtension)!)
        
        println(self.url+urlExtension)
        
        var jsonString : String = "{ \"firstName\" : \"Wessel\", \"lastName\" : \"Stoop\" }"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion:true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, responseData: NSData!,error:NSError!) -> Void in
            
            if error == nil
            {
                jsonData = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary?
                
                completionHandler(jsonData,error);
                
            }
            else
            {
                println("Error: \(error.localizedDescription)")
            }
            
        })
        
    }
    
    func tryLoggingIn(userName : String, password: String) -> LoginResult
    {
        self.userName = userName
        self.userLoggedInSuccesfully = true
        
        return LoginResult.Successful
    }
    
    func createNewUser(userName : String)
    {
        self.HTTPPostToJSON("players")
            {
                (jsonData,err) -> Void in                
            }
    }

    func getAllVowels()
    {
        assert(self.userLoggedInSuccesfully, "You have to be logged in to do this")

        var urlExtensionToGetVowels : String = "vowels?page=0&size=30"
        self.HTTPGetToJSON(urlExtensionToGetVowels)
        {
            (jsonData,err) -> Void in
            
            var unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as NSDictionary
            
            for vowel in unpackagedJsonData["vowels"] as NSArray
            {
                
                println(vowel["ipa"]!)
            }

        }
    }
    
    func getSuggestedBaseVowelExampleWord() -> String
    {
        return "pit"
    }
    
    func getSuggestedTargetVowelExampleWord() -> String
    {
        return "putt"
    }

    func translateSettingsToDifficultyString(multipleSpeakers : Bool, differentStartingSounds : Bool) -> String
    {
        if !multipleSpeakers && !differentStartingSounds
        {
            return "easy"
        }
        else if multipleSpeakers && !differentStartingSounds
        {
            return "medium"
        }
        else if !multipleSpeakers && differentStartingSounds
        {
            return "hard"
        }
        else if multipleSpeakers && differentStartingSounds
        {
            return "veryhard"
        }
        
        return "easy"
    }
    
    func getSampleIDsAndExpectedAnswersForSettings(task : Task, multipleSpeakers : Bool, differentStartingSounds : Bool, completionHandler: (([Int],[Bool], NSError?) -> Void))
    {
        //Turned off until logging in is fixed
        //assert(self.userLoggedInSuccesfully, "You have to be logged in to do this")
        
        var difficulty : String = self.translateSettingsToDifficultyString(multipleSpeakers, differentStartingSounds: differentStartingSounds);
        
        var urlExtensionToGetSoundFileUrls : String = "stimulus/sequence/"+task.rawValue+"/"+difficulty+"/2?maxSize=10&maxTargetCount=3&target=3&standard=6"

        var sampleIDs : [Int] = []
        var expectedAnswers : [Bool] = []
        
        self.HTTPGetToJSON(urlExtensionToGetSoundFileUrls)
            {
                (jsonData,err) -> Void in
                
                var unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as NSDictionary
                
                for stimulus in unpackagedJsonData["stimuli"] as NSArray
                {
                    sampleIDs.append(stimulus["sampleId"] as Int)
                    expectedAnswers.append(stimulus["relevance"] as String == "isTarget")
                }
                
                completionHandler(sampleIDs,expectedAnswers,nil);
            }
    }
    
    func downloadSampleWithID(id : Int, fileSafePath : String)
    {
        println("Downloading sample \(id)")
        var urlExtensionToDownloadSample : String = "stimulus/audio/\(id)"
        
        let url = NSURL(string: self.url + urlExtensionToDownloadSample)
        let dataFromURL = NSData(contentsOfURL: url!)
        
        let fileManager = NSFileManager.defaultManager()
        var result = fileManager.createFileAtPath(fileSafePath, contents: dataFromURL, attributes: nil)
        println(result)
        
        println("Saved at \(fileSafePath)")
    }
    
}
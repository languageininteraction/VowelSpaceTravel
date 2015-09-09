//
//  VSTServer.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 23/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import Foundation

protocol StimuliRequest
{
    var selectedTask : Task { get }
    var multipleSpeakers : Bool { get }
    var differentStartingSounds : Bool { get }
    var selectedBaseVowel : VowelDefinition? { get }
    var selectedTargetVowel : VowelDefinition? { get }
}

enum LoginResult
{
    case Successful
    case UserDoesNotExist
    case IncorrectPassword
}

class VSTServer : NSObject
{
    var url : String

    var availableVowels : [VowelDefinition] = []
    
    var userName : String?
    var userID : Int?
    var userLoggedInSuccesfully : Bool = false
    
    var latestResponse : NSArray?
    
    init(url: String)
    {
        self.url = url
        super.init()
        self.loadAvailableVowels()
    }
    
    func createCredentialString() -> String
    {
        //Set up the credentials
        var loggedIn : Bool = self.userID != nil
        var username : String = loggedIn ? "\(self.userID!)" : kWebserviceUsername
        var password : String = loggedIn ? "\(self.userID!)" : kWebserviceUserPassword
        
        let loginString = NSString(format: "%@:%@", kWebserviceUsername, kWebserviceUserPassword)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
    
        return base64LoginString
    }
        
    func HTTPGetToJSON(urlExtension: String, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        //Create the request
        var jsonData : NSDictionary?
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+urlExtension)!)
        request.setValue("Basic \(self.createCredentialString())", forHTTPHeaderField : "Authorization")
        
        //Do the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, responseData: NSData!,error:NSError!) -> Void in
            
            if error == nil
            {
                jsonData = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as! NSDictionary?
                
                completionHandler(jsonData,error);

            }
            else
            {
                println("Error: \(error.localizedDescription)")
            }
            
        })
        
    }
    
    func HTTPPostToJSON(urlExtension: String, data : AnyObject, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        //Create the request
        var jsonData : NSDictionary?
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+urlExtension)!)

        //Add the POST data
        var jsonString = NSString(data: NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(0), error: nil)!,encoding: NSASCIIStringEncoding)!
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion:true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Do the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, responseData: NSData!,error:NSError!) -> Void in
            
            if error == nil
            {
                jsonData = NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers, error:nil) as! NSDictionary?
                
                println("Response to POST \(jsonData)")
                
                completionHandler(jsonData,error);
                
            }
            else
            {
                println("Error: \(error.localizedDescription)")
            }
            
        })
        
    }
    
    func createNewUser(firstName : String,lastName: String, email: String,token: String)
    {
        self.HTTPPostToJSON("players",data: ["firstName":firstName,"lastName":lastName, "token":token, "email":email])
        {
            (jsonData,err) -> Void in
            
            self.HTTPGetToJSON("players/search/findByFirstName?firstName=\(firstName)")
            {
                    (response,err) -> Void in
                    self.getUserIDFromResponseToSearchByFirstName(response!)
            }
        }
    }

    func createUserIfItDoesNotExist(firstName : String,lastName : String)
    {
        print(1)
        self.HTTPGetToJSON("players/search/findByFirstName?firstName=\(firstName)")
        {
            (jsonData,err) -> Void in
            print(2)            
            if jsonData!.count == 0
            {
                self.createNewUser(firstName,lastName : lastName, email : firstName,token : "1234")
            }
            else
            {
                self.getUserIDFromResponseToSearchByFirstName(jsonData!)
            }
            print(3)
        }
    }
    
    func getUserIDFromResponseToSearchByFirstName(response : NSDictionary)
    {
        var embeddedData : NSDictionary = response["_embedded"] as! NSDictionary
        var allPlayers : NSArray = embeddedData["players"] as! NSArray
        var foundPlayer : NSDictionary = allPlayers[0] as! NSDictionary
        var linksForPlayers : NSDictionary = foundPlayer["_links"] as! NSDictionary
        var basicLink : NSDictionary = linksForPlayers["self"] as! NSDictionary
        var urlForThisPlayer : NSString = basicLink["href"] as! NSString
        var userIDString : String = urlForThisPlayer.componentsSeparatedByString("/")[4] as! String
        self.userID = userIDString.toInt()
    }
    
    func loadAvailableVowels()
    {
        var urlExtensionToGetVowels : String = "vowels?page=0&size=30"
        self.HTTPGetToJSON(urlExtensionToGetVowels)
        {
            (jsonData,err) -> Void in
            
            var unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
            var idCounter : Int = 1
            
            //Get the basic info
            for vowel in unpackagedJsonData["vowels"] as! NSArray
            {
                var discNotation : String = vowel["disc"] as! String
                var currentVowel : VowelDefinition = VowelDefinition(id: idCounter, ipaNotation: discNotation)
                self.availableVowels.append(currentVowel)

                idCounter++
            }
            
            //Get the vowel qualities
            urlExtensionToGetVowels = "qualities?page=0&size=30"
            self.HTTPGetToJSON(urlExtensionToGetVowels)
                {
                    (jsonData,err) -> Void in
                    
                    var unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                    
                    var counter = 0
                    var currentVowel : VowelDefinition
                    
                    for vowelQuality in unpackagedJsonData["qualities"] as! NSArray
                    {
                        currentVowel = self.availableVowels[counter]
                        
                        currentVowel.manner = VowelManner(rawValue: vowelQuality["manner"]! as! String)
                        currentVowel.place = VowelPlace(rawValue: vowelQuality["place"]! as! String)
                        currentVowel.rounded = vowelQuality["roundness"]! as! String == "rounded"
                        
                        counter++
                        
                        if counter == self.availableVowels.count
                        {
                            break
                        }
                        
                    }
            }
            
        }
    }
    
    func getSuggestedBaseVowelExampleWord() -> String
    {
        return "pet"
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
    
    func getStimuliForSettings(stimuliRequest : StimuliRequest, completionHandler: (([Stimulus], NSError?) -> Void))
    {
        //Turned off until logging in is fixed
        //assert(self.userLoggedInSuccesfully, "You have to be logged in to do this")
        
        var difficulty : String = self.translateSettingsToDifficultyString(stimuliRequest.multipleSpeakers, differentStartingSounds: stimuliRequest.differentStartingSounds);
        
        var urlExtensionToGetSoundFileUrls : String = "stimulus/sequence/"+stimuliRequest.selectedTask.rawValue+"/"+difficulty+"/2?maxSize=10&maxTargetCount=3&target=\(stimuliRequest.selectedBaseVowel!.id)&standard=\(stimuliRequest.selectedTargetVowel!.id)"
        
        var stimuli = [Stimulus]()
        
        self.HTTPGetToJSON(urlExtensionToGetSoundFileUrls)
            {
                (jsonData,err) -> Void in
                
                if jsonData != nil && jsonData!["_embedded"] != nil
                {
                    var unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                    
                    for stimulus in unpackagedJsonData["stimuli"] as! NSArray
                    {
                        var newStimulus : Stimulus = Stimulus(sampleID: stimulus["sampleId"] as! Int,requiresResponse: stimulus["relevance"] as! String == "isTarget",
                            relevance: stimulus["relevance"] as! String,
                            vowelID: stimulus["vowelId"] as! Int,
                            speakerLabel: stimulus["speakerLabel"] as! String)
                        stimuli.append(newStimulus)
                    }
                    
                    completionHandler(stimuli,nil);
                }
                else
                {
                    //If this fails, try again until it does not
                    println("Retry downloading the files")
                    
                    self.getStimuliForSettings(stimuliRequest, completionHandler: completionHandler)
                }
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
    
    func saveStimulusResults(stimuli : [Stimulus],stimuliRequestUsedToGenerateTheseStimuli : StimuliRequest)
    {
        var postData = [Dictionary<String,AnyObject>]()
        
        for stimulus in stimuli
        {
            postData.append(stimulus.packageToDictionary())
        }
        
        var difficulty : String = self.translateSettingsToDifficultyString(stimuliRequestUsedToGenerateTheseStimuli.multipleSpeakers, differentStartingSounds: stimuliRequestUsedToGenerateTheseStimuli.differentStartingSounds);
        
        self.HTTPPostToJSON("stimulus/response/"+stimuliRequestUsedToGenerateTheseStimuli.selectedTask.rawValue+"/"+difficulty+"/1",data: postData)
            {
                (jsonData,err) -> Void in
        }
        
    }
}
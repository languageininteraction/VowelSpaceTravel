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
    var confidencesForVowelPairsByTargetVowelId = Dictionary<Int,[ConfidenceForVowelPair]>()
    
    var userName : String?
    var userID : Int?
    var genericToken : String = kWebserviceUserPassword
    var userLoggedInSuccesfully : Bool = false
    
    var latestResponse : NSArray?
    
    var showAlert : ((String,String) -> ())?
    
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
        var username : String = loggedIn ? "\(self.userName!)" : kWebserviceUsername
        
        println("Using credentials with un \(username) and password \(self.genericToken)")
        
        let loginString = NSString(format: "%@:%@", username, self.genericToken)
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
                self.presentErrorMessage()
            }
            
        })
        
    }
    
    func HTTPPostToJSON(urlExtension: String, data : AnyObject, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        //Create the request
        var jsonData : NSDictionary?
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+urlExtension)!)
        request.setValue("Basic \(self.createCredentialString())", forHTTPHeaderField : "Authorization")
        
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
                                
                completionHandler(jsonData,error);
                
            }
            else
            {
                self.presentErrorMessage()
            }
            
        })
        
    }
    
    func createNewUser(firstName : String,lastName: String, email: String,token: String)
    {
        println("Creating new user")
        
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

    func createUserIfItDoesNotExistAndLogin(firstName : String,lastName : String)
    {
        println("Trying to log in")
        
        self.HTTPGetToJSON("players/search/findByFirstName?firstName=\(firstName)")
        {
            (jsonData,err) -> Void in
            
            println(jsonData)
            
            if jsonData!.count == 0
            {
                self.createNewUser(firstName,lastName : lastName, email : firstName,token : self.genericToken)
            }
            else
            {
                self.getUserIDFromResponseToSearchByFirstName(jsonData!)
            }
            
            self.userName = firstName
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
                            speakerLabel: stimulus["speakerLabel"] as! String,
                            wordString : stimulus["wordString"] as! String)
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
        
        self.HTTPPostToJSON("stimulus/response/"+stimuliRequestUsedToGenerateTheseStimuli.selectedTask.rawValue+"/"+difficulty+"/\(self.userID!)",data: postData)
            {
                (jsonData,err) -> Void in
        }
        
    }
    
    func loadAllConfidenceValuesForCurrentUserID(allVowels : Dictionary<String,VowelDefinition>,completionHandler: ((Dictionary<Int,[ConfidenceForVowelPair]>,NSError?) -> Void))
    {
        //Make sure there is at least a key for every targetID
        for (exampleWord, vowel) in allVowels
        {
            self.confidencesForVowelPairsByTargetVowelId[vowel.id] = []
        }
        
        //Load what confidences there are on the server
        var playerIdToUse : Int
        
        if kShowPlanetsForExampleUser
        {
            playerIdToUse = 2
        }
        else
        {
            playerIdToUse = self.userID!
        }
        
        var urlExtensionToGetConfidenceValues : String = "confidence/search/findByPlayer?player=\(playerIdToUse)"
        
        self.HTTPGetToJSON(urlExtensionToGetConfidenceValues)
        {
            (jsonData,err) -> Void in

            if (jsonData!["_embedded"] != nil)
            {
                var embeddedData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                var confidences : NSArray = embeddedData["confidence"] as! NSArray
                
                var currentConfidenceObject : ConfidenceForVowelPair
                
                for confidence in confidences
                {
                    var targetVowelId : Int = confidence["targetId"] as! Int
                    
                    currentConfidenceObject = ConfidenceForVowelPair(raw: confidence["confidenceLevel"] as! Float, targetVowelId: targetVowelId, standardVowelId: confidence["standardId"] as! Int)
                    self.confidencesForVowelPairsByTargetVowelId[targetVowelId]!.append(currentConfidenceObject)
                    
                }
            }

            //Add confidences not present
            for (targetID, confidences) in self.confidencesForVowelPairsByTargetVowelId
            {
                for (exampleWord, vowel) in allVowels
                {
                    var foundVowel : Bool = false
                    for confidence in confidences
                    {
                        if confidence.standardVowelId == vowel.id
                        {
                            foundVowel = true
                            break
                        }
                    }
                    
                    if !foundVowel
                    {
                        self.confidencesForVowelPairsByTargetVowelId[targetID]!.append(ConfidenceForVowelPair(raw: 0, targetVowelId: targetID, standardVowelId: vowel.id) )
                    }
                }
            }
            
            completionHandler(self.confidencesForVowelPairsByTargetVowelId,nil)
        }
    }
    
    func presentErrorMessage()
    {
        self.showAlert!("Problem connecting to the server","An internet connection is required for this app.")
    }
    
}

class ConfidenceForVowelPair
{
    var raw : Float
    var inverted : Float

    var targetVowelId : Int
    var standardVowelId : Int

    var mixingWeigth : Float?
    
    init(raw : Float, targetVowelId : Int, standardVowelId : Int)
    {
        self.raw = raw
        self.inverted = 1 - raw
        self.targetVowelId = targetVowelId
        self.standardVowelId = standardVowelId
    }
}
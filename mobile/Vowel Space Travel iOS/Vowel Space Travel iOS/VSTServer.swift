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
    var email : String?
    var password : String?
    var genericToken : String = kWebserviceUserPassword
    var userLoggedInSuccesfully : Bool = false
    
    var latestResponse : NSArray?
    
    var showAlert : ((String,String,Bool) -> ())?
    
    init(url: String)
    {
        self.url = url
        super.init()
        self.loadAvailableVowels()
    }
    
    func createCredentialString() -> String
    {
        //Set up the credentials
        let loggedIn : Bool = self.userID != nil
        let username : String = loggedIn ? "\(self.email!)" : kWebserviceUsername
        let password : String = loggedIn ? "\(self.password!)" : self.genericToken
        
        print("Using credentials with un \(username) and password \(password)")
        
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    
        return base64LoginString
    }
        
    func HTTPGetToJSON(urlExtension: String, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        //Create the request
        var jsonData : NSDictionary?
        let cleanedUrlExtension : String = urlExtension.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+cleanedUrlExtension)!)
        request.setValue("Basic \(self.createCredentialString())", forHTTPHeaderField : "Authorization")
        
        //Do the request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
        {
            
            (response: NSURLResponse?, responseData: NSData?, error: NSError?) -> Void in
        
            if responseData == nil
            {
                self.presentConnectionErrorMessage()
                return
            }
            
            do
            {
                jsonData = try NSJSONSerialization.JSONObjectWithData(responseData!,options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            }
            catch
            {
                print(error)
                self.presentConnectionErrorMessage()
            }
                
            completionHandler(jsonData,error);
        
        })

    }
    
    func HTTPPostToJSON(urlExtension: String, data : AnyObject, processResponse : Bool = true, completionHandler: ((NSDictionary?, NSError?) -> Void))
    {
        //Create the request
        var jsonData : NSDictionary?
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: self.url+urlExtension)!)
        request.setValue("Basic \(self.createCredentialString())", forHTTPHeaderField : "Authorization")
        
        //Add the POST data
        do
        {
            let jsonString = try NSString(data: NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0)),encoding: NSASCIIStringEncoding)!
            
            request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion:true)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        catch
        {
            print(error)
            self.presentConnectionErrorMessage()
        }
    
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
        {
            (response: NSURLResponse?, responseData: NSData?, error: NSError?) -> Void in

            if !processResponse
            {
                completionHandler(jsonData,error)
                return
            }
            
            if responseData == nil
            {
                self.presentConnectionErrorMessage()
                return
            }            
            
            do
            {
                jsonData = try NSJSONSerialization.JSONObjectWithData(responseData!,options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            }
            catch
            {
                print(error)
                self.presentConnectionErrorMessage()
            }
                
            completionHandler(jsonData,error);
        
        }
        
    }
    
    func createNewUser(firstName : String,lastName: String, email: String,token: String)
    {
        print("Creating new user")
        
        self.HTTPPostToJSON("players",data: ["firstName":firstName,"lastName":lastName, "token":token, "email":email],processResponse: false)
        {
            (jsonData,err) -> Void in
            
            self.HTTPGetToJSON("players/search/findByEmail?email=\(email)")
            {
                    (response,err) -> Void in
                    self.getUserIDFromResponseToSearchByEmail(response!)
            }
        }
    }

    func logIn(email : String,password : String, completionHandler: Void -> Void)
    {
        print("Trying to log in")
        self.email = email
        self.password = password
        
        self.HTTPGetToJSON("players/search/findByEmail?email=\(email)")
        {
            (jsonData,err) -> Void in
            
            print(jsonData)
            print(err)
            
            if err != nil
            {
                self.presentAuthenticationErrorMessage()
            }
            else if jsonData!.count == 0
            {
                print("User not found")
                self.presentAuthenticationErrorMessage()
            }
            else
            {
                print("Found a user")

                self.getUserIDFromResponseToSearchByEmail(jsonData!)
                
                //Final check credentials
                print("Final credential check")
                self.HTTPGetToJSON("players/search/findByEmail?email=\(email)")
                {
                    (jsonData,err) -> Void in

                    print(err)
                    
                    if err != nil
                    {
                        self.presentAuthenticationErrorMessage()
                    }
                    else
                    {
                        completionHandler()
                    }
                }
            }
        }
    }
    
    func getUserIDFromResponseToSearchByEmail(response : NSDictionary)
    {
        let embeddedData : NSDictionary = response["_embedded"] as! NSDictionary
        let allPlayers : NSArray = embeddedData["players"] as! NSArray
        let foundPlayer : NSDictionary = allPlayers[0] as! NSDictionary
        let linksForPlayers : NSDictionary = foundPlayer["_links"] as! NSDictionary
        let basicLink : NSDictionary = linksForPlayers["self"] as! NSDictionary
        let urlForThisPlayer : NSString = basicLink["href"] as! NSString
        let separatedURL : NSArray = urlForThisPlayer.componentsSeparatedByString("/")
        let userIDString : String = separatedURL[separatedURL.count-1] as! String
        self.userID = Int(userIDString)
    }
    
    func checkWhetherEmailIsInDatabase(email : String, completionHandler: ((Bool, NSError?) -> Void))
    {
        self.userID = nil
        self.HTTPGetToJSON("players/search/findByEmail?email=\(email)")
        {
            (jsonData,err) -> Void in
            completionHandler(jsonData!.count != 0,err)
        }
    }
    
    func loadAvailableVowels()
    {
        var urlExtensionToGetVowels : String = "vowels?page=0&size=30"
        print("loading vowels")
        self.HTTPGetToJSON(urlExtensionToGetVowels)
        {
            (jsonData,err) -> Void in
            
            let unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
            var idCounter : Int = 1
            
            //Get the basic info
            for vowel in unpackagedJsonData["vowels"] as! NSArray
            {
                let discNotation : String = vowel["disc"] as! String
                let currentVowel : VowelDefinition = VowelDefinition(id: idCounter, ipaNotation: discNotation)
                self.availableVowels.append(currentVowel)

                idCounter++
            }
            
            //Get the vowel qualities
            urlExtensionToGetVowels = "qualities?page=0&size=30"
            self.HTTPGetToJSON(urlExtensionToGetVowels)
                {
                    (jsonData,err) -> Void in
                    
                    let unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                    
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
        
        let difficulty : String = self.translateSettingsToDifficultyString(stimuliRequest.multipleSpeakers, differentStartingSounds: stimuliRequest.differentStartingSounds);
        
        let urlExtensionToGetSoundFileUrls : String = "stimulus/sequence/"+stimuliRequest.selectedTask.rawValue+"/"+difficulty+"/2?maxSize=\(kNumberOfStimuliInRound)&maxTargetCount=\(kMaxNumberOfTargetsInRound)&target=\(stimuliRequest.selectedBaseVowel!.id)&standard=\(stimuliRequest.selectedTargetVowel!.id)"
        
        var stimuli = [Stimulus]()
        
        self.HTTPGetToJSON(urlExtensionToGetSoundFileUrls)
            {
                (jsonData,err) -> Void in
                
                if jsonData != nil && jsonData!["_embedded"] != nil
                {
                    let unpackagedJsonData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                    
                    for stimulus in unpackagedJsonData["stimuli"] as! NSArray
                    {
                        let newStimulus : Stimulus = Stimulus(sampleID: stimulus["sampleId"] as! Int,requiresResponse: stimulus["relevance"] as! String == "isTarget",
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
                    print("Retry downloading the files")
                    
                    self.getStimuliForSettings(stimuliRequest, completionHandler: completionHandler)
                }
            }
    }
    
    func downloadSampleWithID(id : Int, fileSafePath : String)
    {
        print("Downloading sample \(id)")
        let urlExtensionToDownloadSample : String = "stimulus/audio/\(id)"
        
        let url = NSURL(string: self.url + urlExtensionToDownloadSample)
        let dataFromURL = NSData(contentsOfURL: url!)
        
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(fileSafePath, contents: dataFromURL, attributes: nil)
        
        print("Saved at \(fileSafePath)")
    }
    
    func saveStimulusResults(stimuli : [Stimulus],stimuliRequestUsedToGenerateTheseStimuli : StimuliRequest,completionHandler: (NSError?) -> Void)
    {
        var postData = [Dictionary<String,AnyObject>]()
        
        for stimulus in stimuli
        {
            postData.append(stimulus.packageToDictionary())
        }
        
        let difficulty : String = self.translateSettingsToDifficultyString(stimuliRequestUsedToGenerateTheseStimuli.multipleSpeakers, differentStartingSounds: stimuliRequestUsedToGenerateTheseStimuli.differentStartingSounds);
        
        self.HTTPPostToJSON("stimulus/response/"+stimuliRequestUsedToGenerateTheseStimuli.selectedTask.rawValue+"/"+difficulty+"/\(self.userID!)",data: postData,processResponse: false)
        {
            (jsonData,err) -> Void in
            
            completionHandler(err)
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
        
        let confidenceName : String = "score"
        let urlExtensionToGetConfidenceValues : String = confidenceName+"/search/findByPlayer?player=\(playerIdToUse)"
        
        print("loading confidences")
        self.HTTPGetToJSON(urlExtensionToGetConfidenceValues)
        {
            (jsonData,err) -> Void in

            if (jsonData!["_embedded"] != nil)
            {
                let embeddedData : NSDictionary = jsonData!["_embedded"] as! NSDictionary
                let confidences : NSArray = embeddedData[confidenceName] as! NSArray
                
                var currentConfidenceObject : ConfidenceForVowelPair
                
                for confidence in confidences
                {
                    let targetVowelId : Int = confidence["targetId"] as! Int
                    
                    currentConfidenceObject = ConfidenceForVowelPair(raw: confidence["score"] as! Float, targetVowelId: targetVowelId, standardVowelId: confidence["standardId"] as! Int)
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
    
    func getSuggestionForGame(completionHandler: ((GameSuggestion) -> Void))
    {
        let urlExtensionToGetSuggestion : String = "suggestion/tasksuggestion/\(self.userID!)"
        
        print("suggestion")
        self.HTTPGetToJSON(urlExtensionToGetSuggestion)
        {
            (jsonData,err) -> Void in
            
            print("data")
            print(err)

            print(jsonData!["task"])
            let task : Task = Task(rawValue: jsonData!["task"] as! String)!
            
            let targetVowelInfo : NSDictionary = jsonData!["targetVowel"] as! NSDictionary
            let standardVowelInfo : NSDictionary
            let standardVowelID : String
            
            if task == Task.Discrimination
            {
                standardVowelInfo = jsonData!["standardVowel"] as! NSDictionary
                standardVowelID = standardVowelInfo["disc"] as! String
            }
            else
            {
                standardVowelID = "6" //Because we need something here
            }
            
            let targetVowelID : String = targetVowelInfo["disc"] as! String
            
            var targetVowel : VowelDefinition?
            var standardVowel : VowelDefinition?
            
            for vowel in self.availableVowels
            {
                print(vowel.ipaNotation)
                print(targetVowelID)
                
                if vowel.ipaNotation == targetVowelID
                {
                    targetVowel = vowel
                }
                
                if vowel.ipaNotation == standardVowelID
                {
                    standardVowel = vowel
                }
            }
            
            if targetVowel == standardVowel
            {
                standardVowel = self.availableVowels[0]
            }
            
            let difficulty : String = jsonData!["difficulty"] as! String

            var multipleSpeakers : Bool
            var differentStartingSounds : Bool
            
            switch(difficulty)
            {
                case "easy": multipleSpeakers = false; differentStartingSounds = false; break;
                case "medium": multipleSpeakers = true; differentStartingSounds = false; break;
                case "hard": multipleSpeakers = false; differentStartingSounds = true; break;
                case "veryhard": multipleSpeakers = true; differentStartingSounds = true; break;
                default : multipleSpeakers = false; differentStartingSounds = false; break;
            }
            
            let gameSuggestion = GameSuggestion(targetVowel: targetVowel!, standardVowel: standardVowel!, task: task, multipleSpeakers: multipleSpeakers, differentStartingSounds:differentStartingSounds)
            
            completionHandler(gameSuggestion)
        }
        
    }
    
    func presentAuthenticationErrorMessage()
    {
        self.showAlert!("Incorrect credentials","It looks like either your email or password is not in our database. Please try again.",false)
    }
    
    func presentConnectionErrorMessage()
    {
        self.showAlert!("Problem connecting to the server","An internet connection is required for this app.",true)
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
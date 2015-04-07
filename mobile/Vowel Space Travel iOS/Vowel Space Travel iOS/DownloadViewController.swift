//
//  DownloadViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

//
//  TaskViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit
import AVFoundation

class DownloadViewController: UIViewController {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.downloadFile();
        
    }
    
    func downloadFile()
    {
        let url = NSURL(string: "http://cls.ru.nl/staff/wstoop/test.zip")
        let fileSafePath = "/Users/woseseltops/Desktop/test.zip"
        let dataFromURL = NSData(contentsOfURL: url!)
        
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(fileSafePath, contents: dataFromURL, attributes: nil)
        
        println("Saved at \(fileSafePath)")
        
        /*let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()*/
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

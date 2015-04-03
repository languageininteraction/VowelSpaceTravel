//
//  RootViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 03/04/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        println("loaded!")

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var taskViewController = TaskViewController();
        
        self.presentViewController(taskViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


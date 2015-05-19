//
//  VowelSelectionTableViewController.swift
//  Vowel Space Travel iOS
//
//  Created by Wessel Stoop on 13/05/15.
//  Copyright (c) 2015 Radboud University. All rights reserved.
//

import UIKit

class VowelSelectionTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView  =   UITableView()
    var vowelExampleWords = [String]()
    var selectedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.frame         =   CGRectMake(0, 50, 320, 200);
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        self.tableView.allowsMultipleSelection = true
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //Preselect the previously selected vowels
        for selectedWord in self.selectedWords
        {
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: find(self.vowelExampleWords, selectedWord)! , inSection: 0) , animated: false, scrollPosition: UITableViewScrollPosition.Top )
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vowelExampleWords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.vowelExampleWords[indexPath.row]
                
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
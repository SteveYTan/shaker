//
//  firstViewController.swift
//  shaker
//
//  Created by Steve T on 8/17/15.
//  Copyright © 2015 Steve T. All rights reserved.
//

import Foundation

//
//  ViewController.swift
//  shaker
//
//  Created by Steve T on 8/17/15.
//  Copyright © 2015 Steve T. All rights reserved.
//


import UIKit

var people = Person.all()

/////inputing name into table via text field///////

class firstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func registerButton(sender: UIButton) {
        
        if nameTextField.text! != ""{
            print("u made it into register")
            var person = Person(obj: nameTextField.text!)
            nameTextField.text = ""
            person.save()
            people = Person.all()
            view.endEditing(true)
            tableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    // what cell should I display for each row?
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell")!
        
        // if the cell has a text label, set it to the model that is corresponding to the row in array
        cell.textLabel?.text = people[indexPath.row].objective as! String
        
        // return cell so that Table View knows what to draw in each ro
        return cell
    }

     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        people[indexPath.row].destroy()
        people.removeAtIndex(indexPath.row)
         tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        for(var i = 0; i < people.count; i++) {
            people[i].destroy()
        }
        people = Person.all()
        
    }
    
}


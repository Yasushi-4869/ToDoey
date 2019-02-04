//
//  ViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/04.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    let itemArray = ["Find Mike","But Eggos","Destoty Demogorogon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK - TableView Datasource Methods 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    // MARK - TableView Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
        
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                        tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
            tableView.deselectRow(at: indexPath, animated: true)
    }
}


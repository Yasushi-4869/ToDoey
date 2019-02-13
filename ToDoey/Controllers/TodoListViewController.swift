//
//  ViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/04.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    // MARK - TableView Datasource Methods 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    // MARK - TableView Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // print(itemArray[indexPath.row])
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいリストを加える", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "アイテムを加える", style: .default) { (action) in
            // what will happen once the user clicks the button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
           self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "新しいアイテムを作成"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model Manupulation Methods
    
    func saveItems() {
        let encorder = PropertyListEncoder()
        
        do {
            let data = try encorder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encording item array, \(error)!")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decorder = PropertyListDecoder()
            do {
            itemArray = try decorder.decode([Item].self, from: data)
            } catch {
                print("Error decording item Array \(error)")
            }
        }
        
    }
}


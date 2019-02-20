//
//  ViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/04.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

    //MARK: - TableView Datasource Methods
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
    //MARK: - TableView Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいリストを加える", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "アイテムを加える", style: .default) { (action) in
            // what will happen once the user clicks the button on our UIAlert
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        
        do {
            try self.context.save()
        } catch {
         print("Error, saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {

        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionalpredicate])
        } else {
            request.predicate = categorypredicate
        }
        
//        let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, predicate])
//        request.predicate = compoundpredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    
  
}

//MARK: - Search bar Methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            
        }
    }
}


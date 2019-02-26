//
//  ViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/04.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeViewController {

    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        
        title = selectedCategory!.name
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHex) else {fatalError()}
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else {fatalError()}
        
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(todoItems!.count)) ){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "アイテムがありません"
        }

    
        
        
        return cell
    }
    //MARK: - TableView Delegete Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Errror saving done status, \(error)")
            }
        }

        tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Delete Item Methods
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let deleteItem = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(deleteItem)
                }
            } catch {
                print("Error Deleting Items \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいリストを加える", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "アイテムを加える", style: .default) { (action) in
//            // what will happen once the user clicks the button on our UIAlert

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)                    }
                } catch {
                    print("Error saving data, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "新しいアイテムを作成"
            textField = alertTextField
        }

        alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manupulation Methods
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }
}

//MARK: - Search bar Methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

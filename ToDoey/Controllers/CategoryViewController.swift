//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/19.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController:SwipeViewController {
    
    let realm = try! Realm()
    
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
                
    }
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        } else {
            cell.textLabel?.text = "まだカテゴリーがありません"
            
            cell.backgroundColor = UIColor(hexString: "21C7FF")
            
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
    func save (category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItem () {
       
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }

    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryFromDeletion = categories?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(categoryFromDeletion)
                }
            } catch {
                print("Error deleting data, \(error)")
            }
        }
    }
    
    //MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "カテゴリー", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "新しいカテゴリーを作成"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
 
}

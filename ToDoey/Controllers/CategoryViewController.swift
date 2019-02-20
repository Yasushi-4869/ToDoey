//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/19.
//  Copyright © 2019 小田康史. All rights reserved.
//

import UIKit
import CoreData



class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()

    }
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
    func saveItems () {
        
        do {
        try self.context.save()
        } catch {
            print("Error saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItem () {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
        categories = try self.context.fetch(request)
        } catch {
            print("Error fetching \(error)")
        }
        
        tableView.reloadData()
    }

    //MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "カテゴリー", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "新しいカテゴリーを作成"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
 
}

//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Matheus Diniz on 08/04/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categoryArray: Results <Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
   
      // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none

        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if it's nil return 1 and if it's not nil return the numbers of category we have
        return categoryArray?.count ?? 1
        
        
    
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        guard let categoryColour = UIColor(hexString: (categoryArray?[indexPath.row].colour)!) else {fatalError()}
        
        cell.backgroundColor =  categoryColour
        
        cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
    
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        
        do {
            //add new items and save into our Realm
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        //auto updates our categories objects inside our Realm
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
            }
            } catch {
                print("Error deliting category, \(error)")
            }
        }
    }
        
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
      
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen when the user clicks on the add botton on the popup
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // if indexPath.row == 0 {
            performSegue(withIdentifier: "goToItems", sender: self)
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
        
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row] 
            }
       // }
    
    }

}


//MARK: - Swipe Cell Delegate Methods


//
//  ReviewViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 3/4/20.
//  Copyright © 2020 Tommy Dato and Syed Ali. All rights reserved.
//

import UIKit
import CoreData

class ReviewViewController: SwipeTableViewController{
    
    var itemArray = [Restaraunt?]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Swiping gesture for tab bar controller
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
        loadItems()
    }
    //MARK: - Swipe Gesture Test
    @objc func swiped(_ gesture: UISwipeGestureRecognizer)
    {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 4 {
                self.tabBarController?.selectedIndex += 1
                
            }
        }
        else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
                
            }
        }
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "\(String(describing: item.rating!)) Stars"
        }
        
        
        //cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //to delete items by clicking on them
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        //itemArray[indexPath.row].setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        //tableView.reloadData()
    }
    
    
    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var ratingField = UITextField()
        
        let alert = UIAlertController(title: "Add New Review", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Restaraunt", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on the UIAlert
            
            let newRest = Restaraunt(context: self.context)
            newRest.name = textField.text!
            newRest.rating = ratingField.text!
            self.itemArray.append(newRest)
            //self.tableView.reloadData()
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Restaraunt"
            textField = alertTextField
        }
        
        alert.addTextField { (alertTextField2) in
            alertTextField2.placeholder = "Create New Rating"
            alertTextField2.keyboardType = .decimalPad
            ratingField = alertTextField2
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manipulation Methods
    func saveItems()
    {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        let request : NSFetchRequest<Restaraunt> = Restaraunt.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error for load items \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray[indexPath.row] {
            context.delete(item)
            itemArray.remove(at: indexPath.row)
            
            do {
                try self.context.save()
            } catch {
                print("Error updating items \(error)")
            }
            
        }
    }
}
//MARK: - Search Bar Methods
extension ReviewViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Restaraunt> = Restaraunt.fetchRequest()
        //Query filter
        //print(searchBar.text)
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        //Sort
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //run requests and fetch results
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error for load items \(error)")
        }
        
        //update table view
        tableView.reloadData()
        
    }
    
    //Whenever text is typed in the search bar aka text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 || searchBar.text! == ""
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
        
    }
}

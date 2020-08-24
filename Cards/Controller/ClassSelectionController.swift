//
//  ClassSelectionController.swift
//  Cards
//
//  Created by Jordan Van Den Bruel on 2020-07-08.
//  Copyright © 2020 Jordan Van Den Bruel. All rights reserved.
//

import UIKit
import CoreData

class ClassSelectionViewController: UITableViewController {
    
    // array of all the classes
    var classes = [Class]()
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // load all of the classes in when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClasses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClasses()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.classCell, for: indexPath)
        
        cell.textLabel?.text = classes[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // runs when table view is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.classInfoSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ClassInfoController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedClass = classes[indexPath.row]
        }
    }
    
    // next 2 functions handle swipeable cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteClass(deleteItemAt: indexPath.row)
        }
    }
    
    // MARK: - Data Manipulation Methods
    func saveClasses() {
        do {
        try context.save()
        } catch {
            print("Error saving class: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // will load items based on request, or all items if not specified
    func loadClasses(with request: NSFetchRequest<Class> = Class.fetchRequest()) {
        do {
            classes = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // remove a class from a certain index
    func deleteClass(deleteItemAt index: Int) {
        context.delete(classes[index])
        classes.remove(at: index)
        
        // you need to save the changes made to the context so that the item is deleted
        saveClasses()
        
        tableView.reloadData()
    }
    

    
    // MARK: - Add Class
    @IBAction func addClass(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Class", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Class", style: .default) { (action) in
            let newClass = Class(context: self.context)
            newClass.name = textField.text
            
            self.classes.append(newClass)
            
            self.saveClasses()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Class"
            
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Search Bar Functionality
extension ClassSelectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query the database for classes that contain string in search bar
        let request: NSFetchRequest<Class> = Class.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadClasses(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // load all items when searchbar is blank
        if searchBar.text!.count == 0 {
            loadClasses()
            
            // this will make sure the search is dismissed
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


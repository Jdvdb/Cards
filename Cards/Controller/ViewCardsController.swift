//
//  ViewCardsController.swift
//  Cards
//
//  Created by Jordan Van Den Bruel on 2020-08-26.
//  Copyright © 2020 Jordan Van Den Bruel. All rights reserved.
//

import UIKit
import CoreData

class ViewCardsController: UITableViewController {
    
    // the currently selected class
    var selectedClass: Class?
    // array of all the classes
    var cards = [Card]()
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCards()
    }
    // reload classes whenvever returning to this screen
    override func viewWillAppear(_ animated: Bool) {
        loadCards()
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cardCell, for: indexPath)
        
        cell.textLabel?.text = cards[indexPath.row].question
        
        return cell
    }
    
    // MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: K.classInfoSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // allow cell to be swipeable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // handle deleting a class
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteCard(deleteItemAt: indexPath.row)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditCardController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCard = cards[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    func saveCards() {
        do {
        try context.save()
        } catch {
            print("Error saving class: \(error)")
        }
        self.tableView.reloadData()
    }
    
    // will load items based on request, or all items if not specified
    func loadCards(with request: NSFetchRequest<Card> = Card.fetchRequest(), predicate: NSPredicate? = nil) {
        let classPredicate = NSPredicate(format: "parentClass.name MATCHES %@", selectedClass!.name!)
        
        // add additional predicates if user provided one
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, classPredicate])
        } else {
            request.predicate = classPredicate
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "question", ascending: true)]
        
        do {
            cards = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // remove a class from a certain index
    func deleteCard(deleteItemAt index: Int) {
        context.delete(cards[index])
        cards.remove(at: index)
        
        // you need to save the changes made to the context so that the item is deleted
        saveCards()
        
        tableView.reloadData()
    }
    
    // MARK: - Add Card
    @IBAction func addCard(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Card", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Card", style: .default) { (action) in
            let newCard = Card(context: self.context)
            newCard.question = textField.text
            newCard.answer = "yes."
            newCard.parentClass = self.selectedClass
            
            self.cards.append(newCard)
            
            self.saveCards()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Card"
            
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    

}

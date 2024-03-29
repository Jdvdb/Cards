//
//  ClassInfoController.swift
//  Cards
//
//  Created by Jordan Van Den Bruel on 2020-07-31.
//  Copyright © 2020 Jordan Van Den Bruel. All rights reserved.
//

import UIKit
import CoreData

class ClassInfoController: UIViewController {
    
    var selectedClass : Class?
    
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var CardAmountLabel: UILabel!
    
    // TODO - Make function for loading screen
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleLabel.text = selectedClass?.name ?? "Class"
        CardAmountLabel.text = "Number of cards: \(String(loadNumberOfCards()))"
    }
    
    // reload classes whenvever returning to this screen
    override func viewWillAppear(_ animated: Bool) {
        TitleLabel.text = selectedClass?.name ?? "Class"
        CardAmountLabel.text = "Number of cards: \(String(loadNumberOfCards()))"
    }
    
    @IBAction func presentButton(_ sender: UIButton) {
        print("Presenting Cards")
        
        performSegue(withIdentifier: K.cardPresentationSegue, sender: self)
    }
    @IBAction func editButton(_ sender: UIButton) {
        print("Edit Cards")
        
        performSegue(withIdentifier: K.classEditSegue, sender: self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Class", message: "You will lose all cards in this class too", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("delete")
            self.deleteClass()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    func loadNumberOfCards() -> Int {
        let request : NSFetchRequest<Card> = Card.fetchRequest()
        if (selectedClass != nil) {
            request.predicate = NSPredicate(format: "parentClass.name MATCHES %@", selectedClass!.name!)
            do {
                let cards = try context.fetch(request);
                return cards.count
            } catch {
                print("Error getting cards: \(error)")
                return 0;
            }
        } else {
            return 0;
        }
    }
    
    // delete the current class and then go back to class selection screen
    func deleteClass() {
        if (selectedClass != nil) {
            context.delete(selectedClass!)
            do {
                try context.save()
            } catch {
                print("Error saving class: \(error)")
            }
        }
        
        // navigate home
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PresentCardController {
            destinationVC.selectedClass = selectedClass!
            destinationVC.order = true
        }
        else if let destinationVC = segue.destination as? ViewCardsController {
            destinationVC.selectedClass = selectedClass!
        }
        
//        destinationVC.selectedClass = selectedClass!
        
    }
    
}

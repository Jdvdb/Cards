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
    
    var selectedClassName : String?
    
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading class info")
        TitleLabel.text = selectedClassName ?? "Class"
        CardAmountLabel.text = "Number of classes: \(String(loadNumberOfCards()))"
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var CardAmountLabel: UILabel!
    
    @IBAction func presentButton(_ sender: UIButton) {
        print("Presenting Cards")
    }
    @IBAction func editButton(_ sender: UIButton) {
        print("Edit Cards")
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        print("Delete Class")
    }
    
    func loadNumberOfCards() -> Int {
        let request : NSFetchRequest<Card> = Card.fetchRequest()
        if (selectedClassName != nil) {
            request.predicate = NSPredicate(format: "parentClass.name MATCHES %@", selectedClassName!)
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
    
}

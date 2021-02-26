//
//  CreateCardController.swift
//  Cards
//
//  Created by Jordan Van Den Bruel on 2021-01-07.
//  Copyright © 2021 Jordan Van Den Bruel. All rights reserved.
//

import UIKit
import CoreData

class CreateCardController: UIViewController {
    
    var selectedCard : Card?
    
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // TODO - Make function for loading screen
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // reload card whenvever returning to this screen
    override func viewWillAppear(_ animated: Bool) {
        questionText.text = selectedCard!.question
        answerText.text = selectedCard!.answer
        questionText.isScrollEnabled = false
        answerText.isScrollEnabled = false
    }
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextView!
    
    // save the answers and alert the user when the save button is pressed
    @IBAction func saveButton(_ sender: UIButton) {
        let saveSuccess = saveClassInfo()
        
        if saveSuccess {
            let alert = UIAlertController(title: "Save Successful", message: "You can continue to edit the card", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default)
            alert.addAction(action)
                
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error Saving", message: "Please try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default)
            alert.addAction(action)
                
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    // MARK: - Data Manipulation Methods
    func saveClassInfo() -> Bool {
        selectedCard!.question = questionText.text
        selectedCard!.answer = answerText.text
        do {
            try context.save()
            return true
            
        } catch {
            print("Error saving info: \(error)")
            return false
        }
    }
    
    
    
}

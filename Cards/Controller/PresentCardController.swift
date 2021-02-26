//
//  PresentCardController.swift
//  Cards
//
//  Created by Jordan Van Den Bruel on 2021-01-09.
//  Copyright © 2021 Jordan Van Den Bruel. All rights reserved.
//

import UIKit
import CoreData

class PresentCardController: UIViewController {
    
    var selectedClass : Class?
    var cards: [Card]?
    // true for in order, false for random
    var order: Bool? = true
    
    // determines if the question or answer should be displayed
    var question = true
    
    // keep track of which card you are currently on
    var currentCard = 0
    
    // boolean for end of review
    var finished = false
    
    // possible instruction strings
    let instructions = ["Tap the screen to see the next question", "Tap the screen to see the answer", "Tap the screen to finish reviewing"]
    
    // the context needed for persistent data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBAction func tapGesture(_ sender: Any) {
        if currentCard >= cards!.count - 1 && !question && !finished {
            print("showing last answer")
            messageLabel.text = cards?[currentCard].answer
            instructionLabel.text = instructions[2]
            question = !question
            finished = true
        } else if currentCard >= cards!.count - 1 && !finished {
            print("showing last question")
            messageLabel.text = cards?[currentCard].question
            instructionLabel.text = instructions[1]
            question = !question
        }
        else if question && !finished {
            print("showing question")
            messageLabel.text = cards?[currentCard].question
            instructionLabel.text = instructions[1]
            question = !question
        } else if !question && !finished {
            print("showing answer")
            messageLabel.text = cards?[currentCard].answer
            instructionLabel.text = instructions[0]
            question = !question
            currentCard += 1
        } else {
            print("done reviewing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // reload classes whenvever returning to this screen
    override func viewWillAppear(_ animated: Bool) {
        loadCards()
        // randomize the cards if needed
        if !order! {
            print("shuffle")
            cards?.shuffle()
        }
        messageLabel.text = cards?[currentCard].question
        instructionLabel.text = instructions[1]
        question = !question
    }
    
    
    // MARK: - Data Manipulation Methods
    // load all cards to be used
    func loadCards() {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.predicate = NSPredicate(format: "parentClass.name MATCHES %@", selectedClass!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "question", ascending: true)]
        
        do {
            cards = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
}

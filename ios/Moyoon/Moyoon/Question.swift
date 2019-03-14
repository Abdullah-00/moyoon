//
//  Question.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class Question: UIViewController {
    let db = Firestore.firestore()
    var counter = 0;
    override func viewDidLoad() {        
        super.viewDidLoad()
        getQuestion()
        counter = counter + 1;
        //print("Round: " + GlobalVariables.roundId)
       if(GlobalVariables.roundId == "3")
       {
        counter = 0;
        }
        if(GlobalVariables.roundId == "1" && counter == 1)
        {
            let isSuspended = db.collection("Session").document(GlobalVariables.sessionId).collection("Players").document(GlobalVariables.playerId)
            
            isSuspended.getDocument { (document, error) in
                if let document = document, document.exists {
                    let q = document.data()!["isSuspended"] as! Bool
                    //self.question.text = q
                    
                    print("Suspended: \(q)")
                } else {
                    print("Document does not exist")
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var question: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        questionNumberLabel.text = "Question: \(GlobalVariables.questionId)"
        roundNumberLabel.text = "Round: \(GlobalVariables.roundId)"
    }
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var roundNumberLabel: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getQuestion(){
        

        let docRef = db.collection("Session").document(GlobalVariables.sessionId).collection("Rounds").document(GlobalVariables.roundId).collection("Questions").document(GlobalVariables.questionId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let q = document.data()!["name"] as! String
                self.question.text = q
                print("Document data: \(q)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

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
    
    override func viewDidLoad() {
        getQuestion()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var question: UILabel!
    
    
    func getQuestion(){
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("Session").document(GlobalVariables.sessionId).collection("Rounds").document("1").collection("Questions").document("1")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let a = dataDescription.toDictionary()
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

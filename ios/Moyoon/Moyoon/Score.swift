//
//  Score.swift
//  Moyoon
//
//  Created by Bandar Maher on 17/03/2019.
//  Copyright © 2019 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Score : UIViewController{
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        let db = Firestore.firestore();
        let docPath = "/Session/\(GlobalVariables.sessionId)/Players/\(GlobalVariables.playerId)/"
        let docRef = db.document(docPath)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let score = document.data()!["Score"] as! Int
                GlobalVariables.currentScore = score;
                self.scoreLabel.text = "\(GlobalVariables.currentScore)";
                User.user.updateUser(newScore: score, isWin: true) // true always
            } else {
                print("Score not found")
            }
        }
    }
}

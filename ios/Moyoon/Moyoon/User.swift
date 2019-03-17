//
//  User.swift
//  Moyoon
//
//  Created by Bandar Maher on 17/03/2019.
//  Copyright © 2019 KFUPM-SWE417. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    static let user = User()
    
    var displayName : String?
    var email : String?
    var uid : String?
    
    var totalScore : Int?
    var lastScore : Int?
    var numberOfGamesPlayed : Int?
    var numberOfWins : Int?
     
    //Initializer access level change now
    private init(){
        let firebaseUser = Auth.auth().currentUser;
        displayName = firebaseUser?.displayName;
        email = firebaseUser?.email;
        uid = firebaseUser?.uid;
        syncData();
    }

    
    func syncData(){
        let docPath = "/Players/\(uid)"
        let docRef = Firestore.firestore().document(docPath)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.displayName = document.data()!["displayName"] as! String
                self.email = document.data()!["email"] as! String
                self.totalScore = document.data()!["totalScore"] as! Int
                self.lastScore = document.data()!["lastScore"] as! Int
                self.numberOfGamesPlayed = document.data()!["gamesPlayed"] as! Int
                self.numberOfWins = document.data()!["wins"] as! Int
            } else { // user document not found
                self.createUser();
            }
        }
    }
    
    func createUser(){
        let db = Firestore.firestore();

        let docData: [String: Any] = [
            "displayName": self.displayName!,
            "email": self.email!,
            "totalScore": self.totalScore ?? 0,
            "lastScore": self.totalScore ?? 0,
            "gamesPlayed": self.totalScore ?? 0,
            "wins": self.totalScore ?? 0
        ]
        db.collection("Players").document(self.uid!).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateUser(newScore : Int, isWin : Bool){
        let docPath = "/Players/\(uid)"
        let docRef = Firestore.firestore().document(docPath)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.totalScore = document.data()!["totalScore"] as! Int + newScore;
                self.numberOfGamesPlayed = self.numberOfGamesPlayed ?? 0+1;
                if(isWin){
                    self.numberOfWins = self.numberOfWins ?? 0+1;
                    document.setValue(self.numberOfWins, forKey: "wins")
                }
                document.setValue(self.totalScore, forKey: "totalScore")
                document.setValue(self.lastScore, forKey: "lastScore")
                document.setValue(self.numberOfGamesPlayed, forKey: "gamesPlayed")
            } else { // user document not found
            }
        }
}
}

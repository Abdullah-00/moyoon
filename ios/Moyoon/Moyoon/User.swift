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
    
    private static var user : User!

    var displayName : String!
    var email : String!
    var uid : String!
    var totalScore : Int!
    var lastScore : Int!
    var numberOfGamesPlayed : Int!
    var numberOfWins : Int!
    
    let db = Firestore.firestore();
    let firebaseUser = Auth.auth().currentUser;

     
    //Initializer access level change now
    private init(){
        self.uid = firebaseUser?.uid;
        syncData { (array) in
            self.displayName = (array[0] as! String)
            self.email = (array[1] as! String)
            self.totalScore = (array[2] as! Int)
            self.lastScore = (array[3] as! Int)
            self.numberOfGamesPlayed = (array[4] as! Int)
            self.numberOfWins = (array[5] as! Int)
            print(array)
        }
    }
    
    class func getUser() -> User { // change class to final to prevent override
        guard let myUser = user else {
            user = User()
            return user!
        }
        return myUser
    }
    
    func signOut(){
        var displayName : String!
        var email : String!
        var uid : String!
        var totalScore : Int!
        var lastScore : Int!
        var numberOfGamesPlayed : Int!
        var numberOfWins : Int!
    }
    
    func syncData(_ completion: @escaping (Array<Any>) -> ()) {
        print("Uid is \(self.uid)")
        let docPath = "/Players/\(self.uid!)/"
        let docRef = db.document(docPath)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var array = Array<Any>();
                array.append(document.data()!["displayName"] as! String)
                array.append(document.data()!["email"] as! String)
                array.append(document.data()!["totalScore"] as! Int)
                array.append(document.data()!["lastScore"] as! Int)
                array.append(document.data()!["gamesPlayed"] as! Int)
                array.append(document.data()!["wins"] as! Int)
                completion(array)
            } else { // user document not found
                print("User Not Found !!")
                self.displayName = self.firebaseUser!.displayName;
                self.email = self.firebaseUser!.email;
                self.uid = self.firebaseUser!.uid;
                
                self.createUser();
            }
            
        }
        
    }
    
    func createUser(){
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
        if(Auth.auth().currentUser == nil){
            return;
        }
        let docPath = "/Players/\(self.uid!)/"
        let docRef = db.document(docPath)
        print("Updating...")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Found Doc!!!!")
                self.totalScore = document.data()!["totalScore"] as! Int + newScore;
                self.numberOfGamesPlayed = self.numberOfGamesPlayed ?? 0+1;
                if(isWin){
                    self.numberOfWins = self.numberOfWins ?? 0+1;
                }
                docRef.updateData([
                    "totalScore": self.totalScore,
                    "lastScore": self.lastScore,
                    "gamesPlayed": self.numberOfGamesPlayed,
                    "wins": self.numberOfWins
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                print("Updated statistics");
            } else { // user document not found
                print(error)
            }
        }
}
}

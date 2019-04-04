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
    @IBOutlet weak var Players: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // After leave and join another variables won't reset itself
        GlobalVariables.roundId = "1";
        GlobalVariables.questionId = "1";
        GlobalVariables.submitCounter = 0;
        // End reseting variables
        initlizeLobby()
        let db = Firestore.firestore();
        let docPath = "/Session/\(GlobalVariables.sessionId)/Players/\(GlobalVariables.playerId)/"
        let docRef = db.document(docPath)
        sleep(3);
        indicator.stopAnimating();
        indicator.isHidden = true;
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user = User.getUser();
                let score = document.data()!["Score"] as! Int
                let isWin = document.data()!["winner"] as! Bool
                GlobalVariables.currentScore = score;
                self.scoreLabel.text = "Score : \(GlobalVariables.currentScore)";
                if(isWin){
                    self.rankLabel.text = "Winner 😎"
                }
                else{
                    self.rankLabel.text = "Loser 😂"
                }
                if(Auth.auth().currentUser != nil){
                    user.updateUser(newScore: score, isWin: isWin)
                }
            } else {
                print("Score not found")
            }
        }
    }
    
    var playersArray : [String] = []
    var scoresArray : [Int] = []

    
    fileprivate func initlizeLobby() {
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = "/Session/\(GlobalVariables.sessionId)/Players"
        let query: Query = Firestore.firestore().collection(path)
        query.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.playersArray = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let nickName = document.data()["nick-name"] as! String
                    let score = document.data()["Score"] as! Int
                    self.playersArray.append(nickName)
                    self.scoresArray.append(score)
                }
                self.Players.reloadData()
            }
        }
        
        let SessionPath = "/Session/\(GlobalVariables.sessionId)"
        Firestore.firestore().document(SessionPath)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
        }
        
        Players.dataSource = self
        Players.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Score:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath);
        cell.textLabel?.text = playersArray[indexPath.row]
        cell.detailTextLabel?.text = String(scoresArray[indexPath.row])
        return cell;
    }
    
}

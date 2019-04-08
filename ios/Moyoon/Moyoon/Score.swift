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
    
    let layer = CAGradientLayer()
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var Players: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet var homeButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Players.layer.cornerRadius = 10
        Players.layer.masksToBounds = true
        setupBackground()
        setupButtons()
        self.scoreLabel.textColor = UIColor.white;
        self.scoreLabel.font = UIFont(name: "Lato-Bold", size: 17)
        self.rankLabel.textColor = UIColor.white;
        self.rankLabel.font = UIFont(name: "Lato-Bold", size: 17)

        
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
    
    func setupBackground()
    {
        // Setup Background
        layer.frame = view.bounds
        layer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor /* #000000 */, UIColor(red: 0, green: 0.696, blue: 0.766, alpha: 1).cgColor /* #00B2C3 */]
        layer.locations = [0, 0.757]
        layer.startPoint = CGPoint(x: 0.311, y: 1.098)
        layer.endPoint = CGPoint(x: 0.689, y: -0.098)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    func setupButtons()
    {
        // Setup buttons
        homeButton.layer.masksToBounds = true
        homeButton.layer.cornerRadius = 5
        homeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        homeButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        homeButton.layer.shadowRadius = 25
        homeButton.layer.shadowOpacity = 1
        
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

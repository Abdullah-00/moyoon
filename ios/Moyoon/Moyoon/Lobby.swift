//
//  Lobby.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 12/3/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseUI
import Alamofire

class Lobby: UIViewController {
    
    let layer = CAGradientLayer()
    
    @IBOutlet var players_inLobby: UILabel!
    @IBOutlet var waitingSession: UILabel!
    

    @IBOutlet var leaveButton: UIButton!
    @IBAction func leaveSessionClicked(_ sender: Any) {
        leaveSession()
    }
    
    
    func leaveSession(){
        print("Sending leave Request")
        let urlExtension = "/leaveSession/"
        let parameters: Parameters = [
            "session_id": GlobalVariables.sessionId,
            "player_id": GlobalVariables.playerId
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
        
        Alamofire.request(urlString!, parameters: parameters).response { response in
            
        }
        // After leave and join another variables won't reset itself
        GlobalVariables.roundId = "1";
        GlobalVariables.questionId = "1";
        GlobalVariables.submitCounter = 0;
        // End reseting variables
        
        self.performSegue(withIdentifier: "reset", sender: self)
    }
    var playersArray : [String] = []

    
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
                    self.playersArray.append(document.data()["nick-name"] as! String)
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
                if(data["addPlayers"] as! Bool == false){
                    self.performSegue(withIdentifier: "StartGame", sender: self)
                }
        }
        
        Players.dataSource = self
        Players.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        Players.layer.cornerRadius = 10
        Players.layer.masksToBounds = true
        self.players_inLobby.textColor = UIColor.white;
        self.players_inLobby.font = UIFont(name: "Lato-Bold", size: 17)
        self.waitingSession.textColor = UIColor.white;
        self.waitingSession.font = UIFont(name: "Lato-Bold", size: 17)
        
        
        initlizeLobby()
    }
    
    
    


    @IBOutlet weak var Players: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Lobby:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath);
        cell.textLabel?.text = playersArray[indexPath.row]
        return cell;
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
        leaveButton.layer.masksToBounds = true
        leaveButton.layer.cornerRadius = 5
        leaveButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        leaveButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        leaveButton.layer.shadowRadius = 25
        leaveButton.layer.shadowOpacity = 1
        
    }
    
    
    
    /*
    func bindUI(){
        
        let path = "/Session/\(GlobalVariables.sessionId)/Players"
        let query: Query = Firestore.firestore().collection(path)
        var dataSource: FUIFirestoreTableViewDataSource!
        
        dataSource = self.Players.bind(toFirestoreQuery: query , populateCell: { (tableView, indexPath, snapshot) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
            
            let value = snapshot.data()!
            
            let someProp = value["nick_name"] as? String ?? "no found"
            
            cell.textLabel?.text = someProp
            
            return cell
        })
    }
 */

}


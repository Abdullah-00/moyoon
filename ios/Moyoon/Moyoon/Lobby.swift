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


class Lobby: UIViewController {

    
    
    var playersArray : [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        Players.dataSource = self
        Players.delegate = self

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


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
    
    let myarray = ["item1", "item2", "item3"]

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let db = Firestore.firestore()
        let query = db.collection("/Session/052074/Players").document("1lov5jxfeCSZE4Uzk0i1")
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

        

        
        let dataSource = self.Players.bind(toFirestoreQuery: query as! Query, populateCell: { (tableView: UITableView, indexPath: IndexPath, snapshot: DocumentSnapshot) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            
            let value = snapshot.data() as! NSDictionary
            
            let someProp = value["Score"] as? String ?? ""
            
            cell.textLabel?.text = someProp
            
            return cell
        })
    }

    @IBOutlet weak var Players: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


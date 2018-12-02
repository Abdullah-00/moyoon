//
//  Homepage.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


class Homepage: UIViewController {


    @IBOutlet weak var sessionField: UITextField!
    
    @IBOutlet weak var nicknameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

    @IBAction func JoinSession(_ sender: UIButton) {
        var session : String
        var nickname : String
        nickname = nicknameField.text!
        session = sessionField.text!
        loadSession(session: session)
        
    }
    
    func connectAPI(nickname: String, session: String)
    {
        let urlString = "YOUR_URL"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch {
                    print("Could not serialise")
                }
            }
        }
         task.resume() 
    }
    
    func loadSession(session: String){
        let db = Firestore.firestore()

        let docRef = db.collection("Sessions").document(session)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

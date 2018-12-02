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
import Alamofire

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
        connectAPI(nickname: nickname, gameSession: session)
        
    }

    func connectAPI(nickname: String, gameSession: String)
    {
      //  var urlComponents = URLComponents()
      //  urlComponents.scheme = "http"
      //  urlComponents.host = GlobalVariables.hostname
     //   urlComponents.path = "/enterSession/"
      //  let nick_name = URLQueryItem(name: "nick_name", value: "\(nickname)")
       // let session_id = URLQueryItem(name: "session_id", value: "\(gameSession)")
       // urlComponents.queryItems = [nick_name,session_id]
      //  guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
      //  var request = URLRequest(url: url)
      //  request.httpMethod = "GET"
        
        var playerId = ""
        Alamofire.request("http://localhost:8000/enterSession/?nick_name="+nickname+"&session_id="+gameSession).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            print("Timeline: \(response.timeline)")
            if let data = response.data, let playerId = String(data: data, encoding: .utf8) {
                print("Data: \(playerId)")
                GlobalVariables.playerId = playerId
                print ("Global: \(GlobalVariables.playerId)")
            }
        }

        
        
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

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
import FirebaseUI
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
        //loadSession(session: session)
        
        requestJoinAPI(nickname: nickname, gameSession: session)

        /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "chooseAnswer") as! ChooseAnswer
        self.present(balanceViewController, animated: true, completion: nil)*/
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)

    }
    
    fileprivate func displayError(msg : String) {
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            return;
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func requestJoinAPI(nickname: String, gameSession: String)
    {
        if(nickname.count == 0 || gameSession.count == 0){
            displayError(msg: "Please provide a session id and a nickname");
        }
        
        print("Sending API Request")
        let urlExtension = "/enterSession/"
        let parameters: Parameters = [
            "nick_name": nickname,
            "session_id": gameSession
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
    
        Alamofire.request(urlString!, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            print("Timeline: \(response.timeline)")
            if let data = response.data, let playerId = String(data: data, encoding: .utf8) {
                if(response.response?.statusCode != 200){
                    self.displayError(msg: "Session ID is not valid.")
                }else{
                    GlobalVariables.playerId = playerId
                    GlobalVariables.sessionId = gameSession
                    self.performSegue(withIdentifier: "JoinSession", sender: self)
                }
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

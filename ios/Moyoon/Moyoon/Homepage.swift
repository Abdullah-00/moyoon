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

class Homepage: UIViewController, UITextFieldDelegate {

    //var text = "hey"
    let layer = CAGradientLayer()
    
    @IBOutlet weak var sessionField: UITextField!
    
    @IBOutlet weak var nicknameField: UITextField!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var SignoutButton: UIButton!
    @IBOutlet var FindGameButton: UIButton!
    @IBOutlet var JoinButton: UIButton!
    @IBOutlet var JoinView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        do{
            let user = Auth.auth().currentUser
            if(user?.displayName != nil)
            {
                nicknameField.text = user?.displayName!;
                LoginButton.isHidden = true;
                SignoutButton.isHidden = false;
            }
            else
            {
                LoginButton.isHidden = false;
                SignoutButton.isHidden = true;
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTextFields()
        setupButtons()
        self.hideKeyboardWhenTappedAround()
        self.sessionField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        JoinButton.sendActions(for: .touchUpInside)
        return true
    }
    /*func changeName(s: String?){
        userName.text = s;
        print(s!)
        print(userName.text!)
    }*/
    
    @IBAction func SignOut(_ sender: Any) {
        try! Auth.auth().signOut()
        User.getUser().signOut();
        performSegue(withIdentifier: "SignOut", sender: self)
        
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
    
    func requestJoinRandomAPI(nickname: String){
        if(nickname.count == 0){
            displayError(msg: "Please provide a nickname");
            return;
        }
        print("Sending Join Random Request")
        let urlExtension = "/enterSession/"
        let parameters: Parameters = [
            "nick_name": nickname,
            "category" : "Algebra"
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
        
        Alamofire.request(urlString!, parameters: parameters).response { response in

            if let data = response.data, let serverResponse = String(data: data, encoding: .utf8)?.components(separatedBy: ",") {
                if(response.response?.statusCode != 200){
                    self.displayError(msg: "Cannot join a random session.")
                }else{
                    GlobalVariables.playerId = serverResponse[0]
                    GlobalVariables.sessionId = serverResponse[1]
                    self.performSegue(withIdentifier: "JoinSession", sender: self)
                }
            }
        }
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
            if let data = response.data, let playerId = String(data: data, encoding: .utf8) {
                if(response.response?.statusCode != 200){
                    self.displayError(msg: "Session ID is not valid.")
                }else{
                    GlobalVariables.playerId = playerId
                    GlobalVariables.sessionId = gameSession
                    print(response.response)
                    self.performSegue(withIdentifier: "JoinSession", sender: self)
                }
            }
        }
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
    func setupTextFields()
    {
        //Setup join view
        self.JoinView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        self.JoinView.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.JoinView.layer.shadowRadius = 25
        self.JoinView.layer.shadowOpacity = 1
        self.JoinView.layer.cornerRadius = 2
        self.JoinView.layer.masksToBounds = true
    }
    func setupButtons()
    {
        // Setup buttons
        LoginButton.layer.masksToBounds = true
        LoginButton.layer.cornerRadius = 5
        LoginButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        LoginButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        LoginButton.layer.shadowRadius = 25
        LoginButton.layer.shadowOpacity = 1
        
        SignoutButton.layer.masksToBounds = true
        SignoutButton.layer.cornerRadius = 5
        SignoutButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        SignoutButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        SignoutButton.layer.shadowRadius = 25
        SignoutButton.layer.shadowOpacity = 1
        
        FindGameButton.layer.masksToBounds = true
        FindGameButton.layer.cornerRadius = 5
        FindGameButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        FindGameButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        FindGameButton.layer.shadowRadius = 25
        FindGameButton.layer.shadowOpacity = 1
        
        JoinButton.layer.masksToBounds = true
        JoinButton.layer.cornerRadius = 5
        JoinButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        JoinButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        JoinButton.layer.shadowRadius = 25
        JoinButton.layer.shadowOpacity = 1
    }
    
    @IBAction func JoinRandomSessionClicked(_ sender: Any) {
        var nickname = nicknameField.text!
        requestJoinRandomAPI(nickname: nickname)
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

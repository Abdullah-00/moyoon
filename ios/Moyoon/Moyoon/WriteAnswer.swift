//
//  WriteAnswer.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import FirebaseFirestore
import FirebaseUI

class WriteAnswer: UIViewController {

    
    let layer = CAGradientLayer()
    
    @IBOutlet var QuestionBorder: UIView!
    
    @IBAction func leaveSessionClicked(_ sender: Any) {
        leaveSession();
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupTextFields()
        setupButtons()
        
        
        // Question boreer enhancements
        QuestionBorder.layer.cornerRadius = 10
        QuestionBorder.layer.masksToBounds = true
        
        
        let questionPath = "/Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)"
        Firestore.firestore().document(questionPath)
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
                if(data["isDoneSubmitAnswer"] as! Bool == true){
                    self.sendAnswerToAPI(answer: self.answerField.text!)
                    self.performSegue(withIdentifier: "TypeToSelect", sender: self)
                }
        }


        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var answerField: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var leaveButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitAnswer(_ sender: Any) {
     //   var answer = answerField.text!
      //  sendAnswerToAPI(answer: answer)
        answerField.isEnabled = false
        submitButton.isEnabled = false;
        GlobalVariables.submitCounter += 1;
    }
    
    
    func sendAnswerToAPIAux(){
        sendAnswerToAPI(answer: (answerField.text)!);
    }
    
    
    func sendAnswerToAPI(answer: String)
    {
        let urlExtension = "/SubmitAnswer/"
        let parameters: Parameters = [
            "player_id": GlobalVariables.playerId,
            "session_id": GlobalVariables.sessionId,
            "question_id": GlobalVariables.questionId,
            "round_id": GlobalVariables.roundId,
            "answer": answer
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
        
        Alamofire.request(urlString!, parameters: parameters).response { response in

            if let data = response.data, let result = String(data: data, encoding: .utf8) {

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
        self.answerField.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        self.answerField.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.answerField.layer.shadowRadius = 25
        self.answerField.layer.shadowOpacity = 1
        self.answerField.layer.cornerRadius = 2
        self.answerField.layer.masksToBounds = true
    }
    func setupButtons()
    {
        // Setup buttons
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 5
        submitButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        submitButton.layer.shadowRadius = 25
        submitButton.layer.shadowOpacity = 1
        
        leaveButton.layer.masksToBounds = true
        leaveButton.layer.cornerRadius = 5
        leaveButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        leaveButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        leaveButton.layer.shadowRadius = 25
        leaveButton.layer.shadowOpacity = 1
        
    }
}

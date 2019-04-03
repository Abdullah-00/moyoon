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
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitAnswer(_ sender: Any) {
     //   var answer = answerField.text!
      //  sendAnswerToAPI(answer: answer)
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
}

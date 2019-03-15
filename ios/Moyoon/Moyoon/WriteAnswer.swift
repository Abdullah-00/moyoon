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
    var submitted : Bool = false;
    
    var seconds = 11 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer =  Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    func runTimer() {
        if(!isTimerRunning){
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(WriteAnswer.updateTimer)), userInfo: nil, repeats: true)
        }
        isTimerRunning = true;
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func updateTimer() {
        if(isTimerRunning){
            seconds -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)" //This will update the label.
            if(seconds < 1){
                sendAnswerToAPI(answer: (answerField.text)!)
                timer.invalidate()
                performSegue(withIdentifier: "TypeToSelect", sender: self)
        }
        }
    }
    
    @IBOutlet var QuestionBorder: UIView!
    
    @IBAction func leaveSessionClicked(_ sender: Any) {
        if(isTimerRunning){
            self.timer.invalidate();
        }
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
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            print("Timeline: \(response.timeline)")
        }
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
                    self.timer.invalidate()
                    self.sendAnswerToAPI(answer: self.answerField.text!)
                    self.performSegue(withIdentifier: "TypeToSelect", sender: self)
                }
        }

        runTimer()

        
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
    }
    
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "TypeToSelect"{
            while(submitted == false){
                //stall
            }
        }
        return true;
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
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            print("Timeline: \(response.timeline)")
            if let data = response.data, let result = String(data: data, encoding: .utf8) {
                print("Data: \(result)")
            }
        }
        submitted = true;
    }
}

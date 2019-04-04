//
//  Question.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class Question: UIViewController {
    
    @IBOutlet var status: UILabel!
    
    var q = true;
    let db = Firestore.firestore()
    override func viewDidLoad() {
        runTimer()
        super.viewDidLoad()
        getQuestion()
        updateScore();
        
        // Check suspension
        
        let isSuspended = db.collection("Session").document(GlobalVariables.sessionId).collection("Players").document(GlobalVariables.playerId)
        
        isSuspended.getDocument { (document, error) in
            if let document = document, document.exists {
                
                if document.data()!["isSuspended"] != nil {
                    self.q = document.data()!["isSuspended"] as! Bool
                }
                //self.question.text = q
                
                print("Suspended: \(self.q)")
            } else {
                print("Document does not exist")
            }
            if(self.q != true)
            {
                GlobalVariables.isSunspended = self.q;
                self.status.text = "Active"
                self.status.textColor = self.hexStringToUIColor(hex: "#06BC00")
            }
            else
            {
                GlobalVariables.isSunspended = self.q;
                self.status.text = "Suspended"
                self.status.textColor = UIColor.red
            }
        }
        
        
    }
    @IBOutlet weak var question: UILabel!
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        questionNumberLabel.text = "Question: \(GlobalVariables.questionId)"
        roundNumberLabel.text = "Round: \(GlobalVariables.roundId)"
    }
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var roundNumberLabel: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getQuestion(){
        

        let docRef = db.collection("Session").document(GlobalVariables.sessionId).collection("Rounds").document(GlobalVariables.roundId).collection("Questions").document(GlobalVariables.questionId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let q = document.data()!["name"] as! String
                self.question.text = q
                print("Document data: \(q)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    func updateScore(){
        //
        let docPath = "/Session/\(GlobalVariables.sessionId)/Players/\(GlobalVariables.playerId)/"
        let docRef = db.document(docPath)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let score = document.data()!["Score"] as! Int
                GlobalVariables.currentScore = score;
                print("Current Score: \(score)")
            } else {
                print("Score not found")
            }
        }
    }
        
    var seconds = 11 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer =  Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    func runTimer() {
        if(!isTimerRunning){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(Question.updateTimer)), userInfo: nil, repeats: true)
        }
        isTimerRunning = true;
    }
    
    
    @objc func updateTimer() {
        if(isTimerRunning){
            seconds -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)" //This will update the label.
            if(seconds < 1){
                timer.invalidate()
            }
        }
    }
}

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

class WriteAnswer: UIViewController {
    var submitted : Bool = false;
    
    var seconds = 15 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(WriteAnswer.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        if(seconds < 1){
            timer.invalidate()
            performSegue(withIdentifier: "TypeToSelect", sender: self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runTimer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var answerField: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        var answer = answerField.text!
        sendAnswerToAPI(answer: answer)
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
            if let data = response.data, let playerId = String(data: data, encoding: .utf8) {
                print("Data: \(playerId)")
                GlobalVariables.playerId = playerId
                print ("Global: \(GlobalVariables.playerId)")
            }
        }
        submitted = true;
    }
}

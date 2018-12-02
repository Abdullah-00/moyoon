//
//  WriteAnswer.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit

class WriteAnswer: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var answerField: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        sendAnswerToServer(answerField.text)
    }
    
    func sendAnswerToServer(answer: String){
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = GlobalVariables.hostname
        urlComponents.path = "/SubmitAnswer/"
        let player_id = URLQueryItem(name: "player_id", value: "\(GlobalVariables.playerId)")
        let session_id = URLQueryItem(name: "session_id", value: "\(GlobalVariables.sessionId)")
        let round_id = URLQueryItem(name: "round_id", value: "\(GlobalVariables.roundId)")
        let question_id = URLQueryItem(name: "question_id", value: "\(GlobalVariables.questionId)")
        let answer = URLQueryItem(name: "answer", value: "\(answer)")

        urlComponents.queryItems = [player_id,session_id,round_id,question_id,answer]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    }
}

//
//  ItemCell.swift
//  GridViewExampleApp
//
//  Created by Chandimal, Sameera on 12/22/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit
import Alamofire

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    func sendAnswerToAPI(answer: String)
    {
        let urlExtension = "/SubmitAnswerChoice/"
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
    }
    
    @IBAction func submit(_ sender: Any) {
        sendAnswerToAPI(answer: textLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(text: String) {
        self.textLabel.text = text
    }
}

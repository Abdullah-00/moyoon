//
//  GlobalVariables.swift
//  Moyoon
//
//  Created by Bandar on 02/12/2018.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
extension String{
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
}
struct GlobalVariables{
    static var hostname = "localhost"
    static var playerId = "X60jLqHU0kljpBA90jga";
    static var sessionId = "CSC8hsgaLCwz6OcLmblN";
    static var roundId = "1";
    static var questionId = "1";
    
    
}

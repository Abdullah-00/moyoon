//
//  GlobalVariables.swift
//  Moyoon
//
//  Created by Bandar on 02/12/2018.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit

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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


struct GlobalVariables{
    
    static var hostname = "http://68.183.67.247"
    static var playerId = "1";
    static var sessionId = "1";
    static var roundId = "1";
    static var questionId = "1";
    static var currentScore = 0;
    public static var submitCounter = 0;
    public static var isSunspended = false;
}

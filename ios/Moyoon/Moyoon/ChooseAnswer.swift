//
//  ChooseAnswer.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit

class ChooseAnswer: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: UITableViewDataSource
    

    @IBAction func selectAnswer(_ sender: Any) {
        var currentId = Int(GlobalVariables.questionId)
        var nextId = currentId!+1
        GlobalVariables.questionId = String(nextId)
        performSegue(withIdentifier: "SelectToType", sender: self)
    }
    
}


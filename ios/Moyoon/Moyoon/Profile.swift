//
//  Profile.swift
//  Moyoon
//
//  Created by Bandar Maher on 15/03/2019.
//  Copyright © 2019 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Profile : UIViewController{
    
    override func viewDidLoad() {
        let user = Auth.auth().currentUser;
        welcomeMsg.text = "Welcome "+user!.displayName!;
    }
    
    @IBOutlet weak var welcomeMsg: UILabel!
    
}

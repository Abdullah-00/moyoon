//
//  TabVC.swift
//  Moyoon
//
//  Created by Bandar Maher on 15/03/2019.
//  Copyright © 2019 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit

import FirebaseUI
import Firebase

class TabVC : UITabBarController {
    
    @IBOutlet weak var myTabBar: UITabBar!
    
    
    
    
    override func viewDidLoad() {
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let profile = myTabBar.items?.last
        let user = Auth.auth().currentUser;
        if (user == nil) {
            profile?.isEnabled = false;
        }
        else{
            profile?.isEnabled = true;
            print(user?.displayName)
        }
    }
    
}

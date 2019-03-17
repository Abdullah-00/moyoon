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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let user = User.getUser();
        user.syncData { (array) in
            self.displayName.text = user.displayName;
            self.displayEmail.text = user.email;
            self.displayLastScore.text = "\(user.lastScore!)" ;
            self.displayTotalScore.text = "\(user.totalScore!)" ;
            self.displayGamesPlayed.text = "\(user.numberOfGamesPlayed!)" ;
            self.displayNumberOfWins.text = "\(user.numberOfWins!)" ;
        }
    }
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayEmail: UILabel!
    @IBOutlet weak var displayLastScore: UILabel!
    @IBOutlet weak var displayTotalScore: UILabel!
    @IBOutlet weak var displayGamesPlayed: UILabel!
    @IBOutlet weak var displayNumberOfWins: UILabel!
}

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
        let user = User.user;
        displayName.text = user.displayName;
        displayEmail.text = user.email;
        displayLastScore.text = "\(user.lastScore)" ;
        displayTotalScore.text = "\(user.totalScore)" ;
        displayGamesPlayed.text = "\(user.numberOfGamesPlayed)" ;
        displayNumberOfWins.text = "\(user.numberOfWins)" ;
    }
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayEmail: UILabel!
    @IBOutlet weak var displayLastScore: UILabel!
    @IBOutlet weak var displayTotalScore: UILabel!
    @IBOutlet weak var displayGamesPlayed: UILabel!
    @IBOutlet weak var displayNumberOfWins: UILabel!
}

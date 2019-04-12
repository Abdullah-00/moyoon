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
    
    let list = ["" , "Email", "Last Game Score", "Total Score", "#Games Played", "#Wins", "#Loses", "Wins/Loses Ratio"]
    var list2 : [String] = []
    let layer = CAGradientLayer()
    var totalScore = 0
    
    override func viewDidLoad() {
        setupBackground()
        whiteView.layer.masksToBounds = true
        
        whiteView.layer.cornerRadius = 200
       // detailsTable.roundCorners([.topLeft, .bottomLeft], radius: 50)
        detailsTable.layer.cornerRadius = 50
        
        self.detailsTable.dataSource = self;
        self.detailsTable.delegate = self;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initlizeProfile()

        
    }
    fileprivate func initlizeProfile() {
        // Do any additional setup after loading the view, typically from a nib.
        let user = User.getUser();
        print("Getting data")
        
        user.syncData { (array) in
            self.list2 = []
            self.displayName.text = user.displayName;
            self.list2.append("")
            self.list2.append(user.email)
            self.list2.append("\(user.lastScore!)")
            self.list2.append("\(user.totalScore!)")
            self.list2.append("\(user.numberOfGamesPlayed!)")
            self.list2.append("\(user.numberOfWins!)")
            let loses = user.numberOfGamesPlayed! - user.numberOfWins!
            var ratio = 0.0
            if(loses != 0)
            {
                ratio = Double(user.numberOfWins!) / Double(loses)
                ratio = round(100*ratio) / 100.0
            }
            self.list2.append("\(loses)")
            self.list2.append("\(ratio)")

            
            self.totalScore = user.totalScore!
            self.detailsTable.reloadData()
            if(self.totalScore <= 100)
            {
                self.levelTitle.text = "Rookie🤓"
            }
            else if(self.totalScore <= 250)
            {
                self.levelTitle.text = "Semi-Pro🤨"
            }
            else if(self.totalScore <= 500)
            {
                self.levelTitle.text = "Pro🧐"
            }
            else if(self.totalScore <= 800)
            {
                self.levelTitle.text = "Expert😌"
            }
            else if(self.totalScore <= 1500)
            {
                self.levelTitle.text = "Master😎"
            }
            else
            {
                self.levelTitle.text = "Legend🤩"
            }
            
            //self.displayEmail.text = user.email;
            //self.displayLastScore.text = "\(user.lastScore!)" ;
            //  self.displayTotalScore.text = "\(user.totalScore!)" ;
            //  self.displayGamesPlayed.text = "\(user.numberOfGamesPlayed!)" ;
            //  self.displayNumberOfWins.text = "\(user.numberOfWins!)" ;
            // self.totalScore = Int(user.totalScore!);
        }
        
        
        
        
    }
    
    
    func setupBackground()
    {
        // Setup Background
        layer.frame = view.bounds
        layer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor /* #000000 */, UIColor(red: 0, green: 0.696, blue: 0.766, alpha: 1).cgColor /* #00B2C3 */]
        layer.locations = [0, 0.757]
        layer.startPoint = CGPoint(x: 0.311, y: 1.098)
        layer.endPoint = CGPoint(x: 0.689, y: -0.098)
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    
    
    @IBOutlet weak var levelTitle: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayEmail: UILabel!
    @IBOutlet weak var displayLastScore: UILabel!
    @IBOutlet weak var displayTotalScore: UILabel!
    @IBOutlet weak var displayGamesPlayed: UILabel!
    @IBOutlet weak var displayNumberOfWins: UILabel!
    
    @IBOutlet weak var detailsTable: UITableView!
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension Profile:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list2.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textAlignment = .right
        print(cell.textLabel?.text)
        cell.detailTextLabel?.text = list2[indexPath.row]
        cell.detailTextLabel?.textAlignment = .left
        print(cell.detailTextLabel?.text)
        return cell;
    }
}

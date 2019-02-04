//
//  Login.swift
//  Moyoon
//
//  Created by Bandar Maher on 26/05/1440 AH.
//  Copyright © 1440 KFUPM-SWE417. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import UIKit
class Login: UIViewController, GIDSignInUIDelegate {
    
    /*func goToHomePage()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "homepage") as! Homepage
        self.present(balanceViewController, animated: true, completion: nil)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        print("fff2")
        
        print("fff6")
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        
        print("fff3")
        if let error = error {
            // ...
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            


            // User is signed in
            // ...
            
            self.performSegue(withIdentifier: "LogInDone", sender: self)
        }
        print("fff4")
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        
        
        
        print("fff5")
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "homepage") as! Homepage
        self.present(balanceViewController, animated: true, completion: nil)
    }
    
    
}

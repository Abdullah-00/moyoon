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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
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
    }
    
}

//
//  ViewController.swift
//  Earocity
//
//  Created by John Jones on 11/21/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController:HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let currentEmail : String = (Auth.auth().currentUser?.email)!
            homeViewController.user = User(at: currentEmail)
            self.present(homeViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                self.presentLoggedInScreen()
            })
        }
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                var ref: DatabaseReference!
                ref = Database.database().reference()

                let user = User(at: email)
                
                let userData : Dictionary<String, Any> = ["Username" : user.getUsername(), "Email" : user.getEmail(), "Scores" : user.getScores()]
                ref.child("Users").child(user.getUsername()).setValue(userData)
                
                self.presentLoggedInScreen()
                print("success!")
            })
        }
    }
    
    func presentLoggedInScreen() {
    
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController:HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        if let email = emailTextField.text {
            
            //Property Injection
            homeViewController.user = User(at: email)
        }
        
        self.present(homeViewController, animated: true, completion: nil)
    }
    
}


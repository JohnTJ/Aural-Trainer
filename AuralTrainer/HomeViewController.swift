//
//  HomeViewController.swift
//  Earocity
//
//  Created by John Jones on 11/21/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    var user : User?
    var scores : [String] = []
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            presentWelcome()
            
        } catch {
            print ("There was a problem logging out")
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            presentWelcome()
            
        } catch {
            print ("There was a problem logging out")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Preparing tableview data to inject on the table view controller
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Users").child((user?.getUsername())!).child("Scores").observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot.childrenCount)
            
            //Looping through all scores in current user's scores branch
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let value = child.value as? NSDictionary
                let quizType = value?["Quiz"] as? String ?? ""
                let scoreValue = value?["Score"] as? String ?? ""
                
                let score = Score(scoreValue, onQuiz: quizType)
                self.scores.append("Score: " + score.getScore() + ", Quiz: " + score.getQuiz())
                
            }
        })

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chordsTapped(_ sender: Any) {
    
            self.presentQuiz()
        
    }
    
    @IBAction func myScoresTapped(_ sender: Any) {
        
        presentScoresTableViewController()
        
    }
    
    func presentScoresTableViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let scoresTableViewController:ScoresTableViewController = storyboard.instantiateViewController(withIdentifier: "ScoresTableViewController") as! ScoresTableViewController
        
        //Property Injection
        scoresTableViewController.user = user
        scoresTableViewController.scores = scores
        
        self.present(scoresTableViewController, animated: true, completion: nil)
    }
    
    func presentQuiz() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let quizViewController:QuizViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        
        quizViewController.user = user
        
        
        
        self.present(quizViewController, animated: true, completion: nil)
    }
    
    func presentWelcome() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let welcomeViewController:ViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! ViewController
        
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

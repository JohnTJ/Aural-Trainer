//
//  ResultsViewController.swift
//  Earocity
//
//  Created by John Jones on 11/23/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var user : User?
    
    var correctPassed: String = ""
    var totalPassed: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        correctLabel.text = correctPassed
        totalLabel.text = totalPassed

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        self.presentQuiz()
    }
    
    
    @IBAction func menuTapped(_ sender: Any) {
        self.presentHome()
    }
    
    func presentQuiz() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let quizViewController:QuizViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        quizViewController.user = user
        
        self.present(quizViewController, animated: true, completion: nil)
    }
    
    func presentHome() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController:HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.user = user
        
        homeViewController.modalTransitionStyle = .flipHorizontal
        
        self.present(homeViewController, animated: true, completion: nil)
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

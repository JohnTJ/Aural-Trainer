//
//  QuizViewController.swift
//  Earocity
//
//  Created by John Jones on 11/22/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QuizViewController: UIViewController {
    
    var user : User?
    
    let cMaj = Chord(chordType: "Major", name: "Cmaj")
    let gMaj = Chord(chordType: "Major", name: "Gmaj")
    let eMaj = Chord(chordType: "Major", name: "Emaj")
    let am = Chord(chordType: "Minor", name: "Am")
    let dm = Chord(chordType: "Minor", name: "Dm")
    let fm = Chord(chordType: "Minor", name: "Fm")
    let cDim = Chord(chordType: "Diminished", name: "cDim")
    let dDim = Chord(chordType: "Diminished", name: "dDim")
    let fDim = Chord(chordType: "Diminished", name: "fDim")
    let cAug = Chord(chordType: "Augmented", name: "cAug")
    let eAug = Chord(chordType: "Augmented", name: "eAug")
    let gAug = Chord(chordType: "Augmented", name: "gAug")
    
    
    lazy var majors = [cMaj, gMaj, eMaj]
    lazy var minors = [am, dm, fm]
    lazy var dims = [cDim, dDim, fDim]
    lazy var augs = [cAug, eAug, gAug]
    lazy var chords = [cMaj, gMaj, eMaj, am, dm, fm, cDim, dDim, fDim, cAug, eAug, gAug]
    
    let answers = [["Major", "Minor", "Diminished", "Augmented"], ["Augmented", "Minor", "Diminished", "Major"],
                   ["Minor", "Major", "Diminished", "Augmented"], ["Diminished", "Minor", "Major", "Augmented"]]
    
    var currentQuestion = 0
    var correctAnswerPlace:UInt32 = 0
    var index = 0
    var currentChord = ""
    var tester = 0
    var correct = 4
    var totalQuestions = 4
    var scoreDecrement = 25
    var currentScore = 100
    var score : Score?
    var tapped : Bool = false
    let timestamp = NSDate().timeIntervalSince1970
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newSound()
    }
    
    /**
     This method returns to the home view controller
     when user taps the quit button
     
     - Parameter sender: "Quit" button
    */
    @IBAction func quitTapped(_ sender: Any) {
        self.presentHome()
    }
    
    
    /**
     This method presents the home view controller.
     
     Using property injection, the user object on the
     home view controller is set to the user on this
     view controller
     */
    func presentHome() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController:HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        homeViewController.modalTransitionStyle = .flipHorizontal
        homeViewController.user = user
        
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    
    /**
     This method presents the results view controller.
     
     Using ~property injection~, the user object on the
     results view controller is set to the user on this
     view controller
    */
    func presentResults() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let resultsViewController:ResultsViewController = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        
        resultsViewController.correctPassed = String(correct)
        resultsViewController.totalPassed = String(totalQuestions)
        resultsViewController.user = user
        
        resultsViewController.modalTransitionStyle = .flipHorizontal
        
        self.present(resultsViewController, animated: true, completion: nil)
    }
    
    
    /**
     This method responds to each answer choice being tapped.

     If the incorrect choice is tapped,the score is decremented
     and a newSound with new answer choice is generated
     
     When the button is tapped on the last question, the users
     current score is added to its scores array. The updated
     array of the user's scores is then added to firebase.
     Finally, the results view controller is presented.
     
     - Parameter sender: Any answer choice button
     */
    @IBAction func action(_ sender: Any) {
        if ((sender as AnyObject).tag == Int(correctAnswerPlace)) {
            print("Right")
            
        } else {
            print("Wrong")
            correct = correct - 1
            currentScore = currentScore - scoreDecrement
            scoreLbl.text = "Score: \(currentScore)%"
            print(user!.getUsername())
        }
        
        if (currentQuestion != 4) {
            newSound()
            questionLbl.text = "Question: \(currentQuestion)/4"
        } else {
            let score : Score = Score(String(currentScore), onQuiz: "Chords")
            if let user = user {
                print("done")
            
                user.addScore(score)
                self.user = user
            
                var ref: DatabaseReference!
                ref = Database.database().reference()
               
                var userData : Dictionary<String, Any> = [:]
                
                for score in user.getScores() {
                    userData["Quiz"] = score.getQuiz()
                    userData["Score"] = score.getScore()
                }
                
                ref.child("Users").child(user.getUsername()).child("Scores").childByAutoId().setValue(userData)
            }
            self.presentResults()
        }
    }
    
    /**
     This method responds to the "Play Sound" button being
     tapped. A random chord is played from the correct array
     of Sound objects. After the initial tap, tapped is set
     to true and only that chord can be played for as long
     as the user is on this question.
     
     - Parameter sender: "PlaySound" button
     */
    @IBAction func playSoundAction(_ sender: Any) {
        if (currentQuestion == 1 && !tapped) {
            randomMajor().play()
            tapped = true
        } else if (currentQuestion == 1 && tapped) {
            majors[index].play()
        } else if (currentQuestion == 2 && !tapped) {
            randomAug().play()
            tapped = true
        } else if (currentQuestion == 2 && tapped) {
            augs[index].play()
        } else if (currentQuestion == 3 && !tapped) {
            randomMinor().play()
            tapped = true
        }  else if (currentQuestion == 3 && tapped) {
            minors[index].play()
        } else if (currentQuestion == 4 && !tapped) {
            randomDim().play()
            tapped = true
        }  else if (currentQuestion == 4 && tapped) {
            dims[index].play()
        }
    }
    
    
    /**
     This generates a new question / new Chord type to play
     
     Each answer choice is set to a button. Each buttons label
     is an answer choice in the answers array. The correct answer,
     chosen by the random correctAnswerPlace variable, is placed on
     correct button
     */
    func newSound() {
        
        correctAnswerPlace = arc4random_uniform(4) + 1
        
        //Create a button
        var button:UIButton = UIButton()
        
        var x = 1
        //Create a button based on tag
        for i in 1...4 {
            button = view.viewWithTag(i) as! UIButton
            
            //Sets correct answer to button
            if (i == Int(correctAnswerPlace)) {
                button.setTitle(" " + answers[currentQuestion][0] + " ", for: .normal)
            } else {
                button.setTitle(" " + answers[currentQuestion][x] + " ", for: .normal)
                x += 1
            }
        }
        currentQuestion += 1
        tester = 0
    }
    
    
    /**
     Chooses a random major from the array of major chords
     using a random index
     
     - Returns: A Sound object from the major array
    */
    func randomMajor() -> Sound {
        index = Int(arc4random_uniform(UInt32(majors.count)))
        currentChord = majors[index].getTitle()
        return majors[index]
    }
    
    
    /**
     Chooses a random minor from the array of minor chords
     using a random index
     
     - Returns: A Sound object from the minor array
     */
    func randomMinor() -> Sound {
        index = Int(arc4random_uniform(UInt32(minors.count)))
        currentChord = minors[index].getTitle()
        return minors[index]
    }
    
    
    /**
     Chooses a random diminished from the array of diminished
     chords using a random index.
     
     - Returns: Returns a Sound object from the diminished array
     */
    func randomDim() -> Sound {
        index = Int(arc4random_uniform(UInt32(dims.count)))
        currentChord = dims[index].getTitle()
        return dims[index]
    }
    
    
    /**
     Chooses a random augmented from the array of augmented
     chords using a random index.
     
     - Returns: Returns a Sound object from the augmented array
     */
    func randomAug() -> Sound {
        index = Int(arc4random_uniform(UInt32(augs.count)))
        currentChord = augs[index].getTitle()
        return augs[index]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

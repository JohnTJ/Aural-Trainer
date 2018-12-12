//
//  Score.swift
//  Earocity
//
//  Created by John Jones on 11/25/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import Foundation

class Score {
    var score : String = ""
    var quiz : String = ""
    
    public init(_ score : String, onQuiz quiz : String) {
        self.score = score
        self.quiz = quiz
    }
    
    public func getScore() -> String {
        return score
    }
    
    public func setScore(score : String) {
        self.score = score
    }
    
    public func getQuiz() -> String {
        return quiz
    }
    
    public func setQuiz(onQuiz quiz : String) {
        self.quiz = quiz
    }
    
}

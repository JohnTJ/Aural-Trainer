//
//  User.swift
//  Earocity
//
//  Created by John Jones on 11/23/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import Foundation

class User {
    
    var username: String = ""
    var email: String = ""
    var scores: [Score] = []
    
    public init(at email: String) {
        self.email = email
        
        //Sets username to everything before '@' in email
        let at = "@"
        var token = email.components(separatedBy: at)
        username = token[0]
    }
    
    public func getUsername() -> String {
        return username
    }
    
    public func setEmail(_ email: String) {
        self.email = email
    }
    
    public func getEmail() -> String {
        return email
    }
    
    public func getScores() -> [Score] {
        return scores
    }
    
    public func addScore(_ score : Score) {
        scores.append(score)
    }
}

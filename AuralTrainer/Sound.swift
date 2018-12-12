//
//  Sound.swift
//  Earocity
//
//  Created by John Jones on 11/22/18.
//  Copyright © 2018 John Jones. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var title = ""
    private var keyName = ""
    
    public init(named name: String) {
        if let soundURL = Bundle.main.path(forResource: name, ofType: "mp3") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: soundURL) as URL)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        } else {
            print(name + " does not work")
        }
        
        title = name
    }
    
    public func getTitle() -> String {
        return title
    }
    
    public func getName() -> String {
        return keyName
    }
    
    public func play() {
        audioPlayer.play()
    }
    
    public func stop() {
        audioPlayer.stop()
    }
}


class Chord: Sound {
    private var chordType = ""
    init(chordType: String, name: String) {
        self.chordType = chordType
        super.init(named: name)
    }
}

class Key: Sound {
    override init(named name: String) {
        super.init(named: name)
    }
}

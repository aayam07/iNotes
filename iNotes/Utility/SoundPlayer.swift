//
//  SoundPlayer.swift
//  iNotes
//
//  Created by Aayam Adhikari on 06/12/2023.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

// to play any selected sound file from the local app bundle
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find and play the sound file.")
        }
    }
}

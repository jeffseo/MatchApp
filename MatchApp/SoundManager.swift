//
//  SoundManager.swift
//  MatchApp
//
//  Created by Jeff Seo on 2020-10-03.
//

import Foundation

// Import modules needed for music files
import AVFoundation


class SoundManager {
  
  var audioPlayer:AVAudioPlayer?
  
  enum SoundEffect {
    case flip
    case match
    case nomatch
    case shuffle
  }
  
  func playSound(effect: SoundEffect) {
    var soundFileName = ""
    
    switch effect {
      case .flip:
        soundFileName = "cardflip"
        break
      case .match:
        soundFileName = "dingcorrect"
        break
      case .nomatch:
        soundFileName = "dingwrong"
        break
      case .shuffle:
        soundFileName = "shuffle"
        break
    }
    
    // Files within the app will be in a "Bundle" and we have to be able to access them
    // Get the path to the resource
    let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
    
    // Check that it's not nil
    // Functionally guard is same as using an if but guard is used more for sanity checks
    guard bundlePath != nil else {
      return
    }
    
    // AVPlayer object expects a URL to the object
    let url = URL(fileURLWithPath: bundlePath!)
    
    // Initializing an AVAudioPlayer can throw. Need to use a try catch to handle error
    do {
      // Create the audio player
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      
      // Play the sound effect
      audioPlayer?.play()
    }
    catch {
      print("Couldn't create an audio player")
      return
    }
  }
}



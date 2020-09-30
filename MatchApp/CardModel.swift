//
//  CardModel.swift
//  MatchApp
//
//  Created by Jeff Seo on 2020-09-29.
//

import Foundation

class CardModel {
  
  func getCards() -> [Card] {
    // Declare an empty array
    var generatedCards = [Card]()
    
    // Randomly generate 8 pairs of cards
    for _ in 1...8 {
      // Generate a random number
      let randomNumber = Int.random(in: 1...13)
      
      // Create two new card object
      let cardOne = Card()
      let cardTwo = Card()
      
      // Set their image names
      cardOne.imageName = "card\(randomNumber)"
      cardTwo.imageName = "card\(randomNumber)"
      
      // Add them to the array
      generatedCards += [cardOne, cardTwo]
      
      print(randomNumber)
    }
    
    // Randomize the card within the array
    generatedCards.shuffle()
    
    // Return the array
    return generatedCards
  }
}

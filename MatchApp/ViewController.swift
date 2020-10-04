//
//  ViewController.swift
//  MatchApp
//
//  Created by Jeff Seo on 2020-09-28.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let model = CardModel()
  var cardsArray = [Card]()
  
  var firstFlippedCardIndex:IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    cardsArray = model.getCards()
    
    // Set the view controller as the datasource and delegate of the collection view
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  // MARK: - Collection View Delegate Methods
  
  // CollectionView uses this function to get the number of items
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    // Return number of cards
    return cardsArray.count
  }	
  
  // Method is called when the collection view wants to create/use a cell for that certain index
  // Wants to know what type of cell to use for that index
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // IndexPath represents which cell in the collection view we are targetting

    // Get a Cell
    // The withReuseIdentfier is the name given to the prototype cell
    // dequeueResuableCell returns a UICell object. We must cast it to the object we want which inherits the UICell which is CardCollectionViewCell (set manually in prototype property)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
    // Return it
    return cell
  }
  
  // Method is called right before the cell is displayed at indexPath
  // Gives a chance to configure the cell before display
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // Configure the state of the cell based on the properties of the Card that it represents
    
    let cardCell = cell as? CardCollectionViewCell
    
    // Get the card from the card array
    let card = cardsArray[indexPath.row]
    
    cardCell?.configureCell(card: card)
  }

  
  // This function is the delegate function that is responsible for handling taps
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Get a reference to the cell that was tapped
    let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
    
    // Check the status of the card to determine how to flip it
    if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
      // Flip the card up
      cell?.flipUp()
      
      // Check if this is the first card that was flipped or the second card
      if firstFlippedCardIndex == nil {
        // This is the first card flipped over
        firstFlippedCardIndex = indexPath
      }
      else {
        // Second card that is flipped
        
        // Run the comparison logic
        checkForMatch(indexPath)
      }
    }
  }

  // MARK: - Game Logic Methods
  func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
    // Get the two card objects for the two indices and see if they match
    let cardOne = cardsArray[firstFlippedCardIndex!.row]
    let cardTwo = cardsArray[secondFlippedCardIndex.row]
    
    // Get the two collection view cells that represent card one and two
    let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
    let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
    
    // Compare the two cards
    if cardOne.imageName == cardTwo.imageName {
      // It's a match
      
      // Set the status and remove them
      cardOne.isMatched = true
      cardTwo.isMatched = true
      
      cardOneCell?.remove()
      cardTwoCell?.remove()
    }
    else {
      // It's not a match
      cardOne.isFlipped = false
      cardTwo.isFlipped = false
      
      // Flip them back over
      cardOneCell?.flipDown()
      cardTwoCell?.flipDown()
    }
    
    // Reset the firstFlippedCardIndex property for the next match
    firstFlippedCardIndex = nil
  }
  
}


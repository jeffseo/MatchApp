//
//  ViewController.swift
//  MatchApp
//
//  Created by Jeff Seo on 2020-09-28.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var timerLabel: UILabel!
  
  let model = CardModel()
  var cardsArray = [Card]()
  
  static let maxGameTime:Int = 60 * 1000 // 60 seconds in milliseconds
  var timer:Timer?
  var milliseconds = maxGameTime
  
  var firstFlippedCardIndex:IndexPath?
  
  var soundPlayer = SoundManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    cardsArray = model.getCards()
    
    // Set the view controller as the datasource and delegate of the collection view
    collectionView.dataSource = self
    collectionView.delegate = self
    
    // Initialize the timer
    // Selector is the function that will be called when the timer is fired
    timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common	)
  }
  
  // This function is called when view appears on screen
  override func viewDidAppear(_ animated: Bool) {
    // Play shuffle sound
    soundPlayer.playSound(effect: .shuffle)
  }
  
  // MARK: - Timer Methods
  // @objc allows the function to be used as a selector (legacy objective-c)
  @objc func timerFired() {
    // Decrement the counter
    milliseconds -= 1
    
    // Update the label
    let seconds:Double = Double(milliseconds) / 1000.0
    timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
    
    // Stop the timer if it reaches zero
    if milliseconds == 0 {
      timerLabel.textColor = UIColor.red
      timer?.invalidate()
      
      // Check if the user has cleared all the pairs
      checkForGameEnd()
    }

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
    // Check if there's any time remaining. Don't let the user interact if the time is 0
    if milliseconds <= 0 {
      return
    }
    
    // Get a reference to the cell that was tapped
    let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
    
    // Check the status of the card to determine how to flip it
    if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
      
      // Flip the card up
      cell?.flipUp()
      
      // Play sound
      soundPlayer.playSound(effect: .flip)
      
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
      
      // Play match sound
      soundPlayer.playSound(effect: .match)
      
      // Set the status and remove them
      cardOne.isMatched = true
      cardTwo.isMatched = true
      
      cardOneCell?.remove()
      cardTwoCell?.remove()
      
      // Was that the last pair?
      checkForGameEnd()
    }
    else {
      // It's not a match
      
      // Play no match sound
      soundPlayer.playSound(effect: .nomatch)
      
      cardOne.isFlipped = false
      cardTwo.isFlipped = false
      
      // Flip them back over
      cardOneCell?.flipDown()
      cardTwoCell?.flipDown()
    }
    
    // Reset the firstFlippedCardIndex property for the next match
    firstFlippedCardIndex = nil
  }
  
  func checkForGameEnd() {
    // Check if there's any card that is unmatched
    // Assume the user has won, loop through all the cards to see if all of them are matched
    var hasWon = true
    
    for card in cardsArray {
      if card.isMatched == false {
        // We've found a card that is unmatched
        hasWon = false
        break
      }
    }
    
    if hasWon == true {
      // User has won, show an alert
      showAlert(title: "Congratulations!", message: "You've won the game!")
    }
    else {
      // User hasn't won yet, check if there's any time left
      if milliseconds <= 0 {
        showAlert(title: "Time's Up", message: "Sorry, better luck next time.")
      }
    }
  }
  
  func showAlert(title:String, message:String) {
    // Create the alert to display
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Add a button for the user to dismiss it
    // This is to add a button to the alert window for user to dismiss the message
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: alertHandler)
    alert.addAction(okAction)
    
    // Show the alert
    present(alert, animated: true, completion: nil)
    
  }
  
  func alertHandler(action: UIAlertAction) {
      reset()
  }
  
  func reset() {
    firstFlippedCardIndex = nil
    cardsArray = model.getCards()
    collectionView.reloadData()
    milliseconds = ViewController.maxGameTime
    timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common  )
  }
}


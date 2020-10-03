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
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // IndexPath represents which cell in the collection view we are targetting

    // Get a Cell
    // The withReuseIdentfier is the name given to the prototype cell
    // dequeueResuableCell returns a UICell object. We must cast it to the object we want which inherits the UICell which is CardCollectionViewCell (set manually in prototype property)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
    
    // Get the card from the card array
    let card = cardsArray[indexPath.row]
    
    cell.configureCell(card: card)
    
    // Return it
    return cell
  }
  
  // This function is the delegate function that is responsible for handling taps
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Get a reference to the cell that was tapped
    let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
    
    // Check the status of the card to determine how to flip it
    if cell?.card?.isFlipped == false {
      // Flip the card up
      cell?.flipUp()
    }
    else {
      // Flip the card down
      cell?.flipDown()
    }
  }

}


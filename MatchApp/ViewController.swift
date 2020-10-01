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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
    
    // TODO: Finish configuring the cell
    
    // Return it
    return cell
  }

}


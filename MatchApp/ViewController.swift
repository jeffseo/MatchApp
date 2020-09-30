//
//  ViewController.swift
//  MatchApp
//
//  Created by Jeff Seo on 2020-09-28.
//

import UIKit

class ViewController: UIViewController {
  
  let model = CardModel()
  var cardsArray = [Card]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    cardsArray = model.getCards()
  }


}


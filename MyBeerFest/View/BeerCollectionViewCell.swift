//
//  BeerCollectionViewCell.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
  
  // MARK: Variables
  
  var beer: Beer? {
    didSet {
      self.fillCell(with: self.beer)
    }
  }
  
  @IBOutlet var beerImage: UIImageView!
  
  // MARK: Private
  
  func fillCell(with beer: Beer?) {
    self.beerImage.image = beer?.image
  }
  
  // MARK: UIView Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.fillCell(with: self.beer)
  }

}

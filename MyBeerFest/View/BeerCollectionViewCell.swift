//
//  BeerCollectionViewCell.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var beerImage: UIImageView!
  
  var beer: Beer? {
    didSet {
      self.fillCell(with: beer)
    }
  }
  
  func fillCell(with beer: Beer?) {
    self.beerImage.image = beer?.image
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.fillCell(with: self.beer)
  }
}

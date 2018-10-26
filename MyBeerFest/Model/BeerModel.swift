//
//  BeerModel.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import Foundation
import UIKit

class BeerModel {
  
  private var beerArray = [UIImage]()
  
  var BeerCount: Int {
    get {
      return beerArray.count
    }
  }
  
  func addBeer(withImage image: UIImage) {
    if let clone = image.copy() as? UIImage {
      let imageData = UIImagePNGRepresentation(image)
      
      let matchedQuantity = self.beerArray.filter { (internalImage) -> Bool in
        let internalImageData = UIImagePNGRepresentation(internalImage)
        
        return internalImageData == imageData
      }.count
      
      if matchedQuantity == 0 {
        self.beerArray.append(clone)
      }
    }
  }
  
  func beerImage(at index: Int) -> UIImage? {
    return index < beerArray.count ? self.beerArray[index] : nil
  }
  
  func allBeerImages() -> [UIImage] {
    var result: [UIImage]
    result = self.beerArray.compactMap { (image: UIImage) -> UIImage? in
      if let clone = image.copy() as? UIImage {
        return clone
      }

      return nil
    }
    
    return result
  }
}

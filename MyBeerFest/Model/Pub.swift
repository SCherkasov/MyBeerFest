//
//  BeerModel.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import Foundation
import UIKit

class Pub {
  
  private var beerArray = [UIImage]()
  var beers: [Beer] = []
  var name: String = "\(NSUUID().uuidString).png"
  var namesOfImages: [String] = []
  
  var BeerCount: Int {
    get {
      return beerArray.count
    }
  }
  
  func addBeer(withImage image: UIImage) {
    if let clone = image.copy() as? UIImage,
      let imageName = name.copy() as? String {
      
      let imageData = UIImagePNGRepresentation(image)
      let nameData = imageName
      
      let matchedQuantity = self.beerArray.filter { (internalImage) -> Bool in
        let internalImageData = UIImagePNGRepresentation(internalImage)
        
        return internalImageData == imageData
        }.count
      
      let matchedQuantityNames = self.namesOfImages.filter { (intermalImageName)
        -> Bool in
        let internalImageNameData = intermalImageName
        
        return internalImageNameData == nameData
        }.count
      
      
      if matchedQuantity == 0 && matchedQuantityNames == 0 {
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

class Beer {
  var fileName: String
  var image: UIImage

  init(fileName: String, image: UIImage) {
    self.fileName = fileName
    self.image = image
  }
}

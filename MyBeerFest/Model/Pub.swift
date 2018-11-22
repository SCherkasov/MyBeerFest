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
  
  private var beers = [Beer]()
  
  var name: String = "\(NSUUID().uuidString).png"
  var namesOfImages: [String] = []
  
  var BeerCount: Int {
    get {
      return beers.count
    }
  }
  
  func addBeer(withImage image: UIImage) {
    if let clone = image.copy() as? UIImage,
      let imageName = name.copy() as? String {
      
      let imageData = UIImagePNGRepresentation(image)
      let nameData = imageName
      
      let matchedQuantity = self.beers.filter { (internalImage) -> Bool in
        let internalImageData = UIImagePNGRepresentation(internalImage.image)
        
        return internalImageData == imageData
        }.count
      
      let matchedQuantityNames = self.namesOfImages.filter { (intermalImageName)
        -> Bool in
        let internalImageNameData = intermalImageName
        
        return internalImageNameData == nameData
        }.count
      
      
      if matchedQuantity == 0 && matchedQuantityNames == 0 {
        let imageObject = Beer(fileName: imageName, image: clone)
        self.beers.append(imageObject)
      }
    }
  }
  
  func beerImage(at index: Int) -> UIImage? {
    if (index >= beers.count) {
      return nil
    }
    let beer = self.beers[index]
    
    return beer.image
  }
  
  func allBeerImages() -> [UIImage] {
    var result: [UIImage] = []
    for beer in beers {
      if let clone = beer.image.copy() as? UIImage {
        
        result.append(clone)
      }
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

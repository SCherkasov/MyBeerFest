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
  
  var BeerCount: Int {
    get {
      return beers.count
    }
  }
  
  var dataPath: URL? {
    get {
      return try? FileManager.default.url(for: .documentDirectory,
                                          in: .userDomainMask,
                                          appropriateFor: nil,
                                          create: true)
    }
  }
  
  var beerImages: [UIImage] {
    get {
      var result: [UIImage] = []
      
      for beer in beers {
        if let clone = beer.image.copy() as? UIImage {
          result.append(clone)
        }
      }
      
      return result
    }
  }
  
  func beer(at index: Int) -> Beer? {
    if (index >= BeerCount) {
      return nil
    }
    
    return self.beers[index]
  }
  
  func addBeer(_ beer: Beer) {
    self.beers.append(beer)
  }
  
  func addBeer(with image: UIImage) {
    var isBeerWithImageExist = false
    let imagePNGRepresentation = UIImagePNGRepresentation(image)
    for beerImage in self.beerImages {
      let beerImagePNGRepresentation = UIImagePNGRepresentation(beerImage)
      if imagePNGRepresentation == beerImagePNGRepresentation {
        isBeerWithImageExist = true
        break
      }
    }
    if isBeerWithImageExist {
      return
    }
    var beer: Beer?
    if let imageClone = image.copy() as? UIImage {
      beer = Beer(fileName: NSUUID().uuidString, image: imageClone)
    }
    if let unwrappedBeer = beer {
      self.addBeer(unwrappedBeer)
    }
  }
  
  func removeBeer(at index: Int) {
    if (index >= BeerCount) {
      return
    }
    self.beers.remove(at: index)
  }
  
  func save() {
    guard let path = self.dataPath else { return }
    
    for beer in self.beers {
      let imageURL = path.appendingPathComponent(beer.fileName)
      if !FileManager.default.fileExists(atPath: imageURL.path) {
        do {
          try UIImagePNGRepresentation(beer.image)?.write(to: imageURL)
        } catch {
          print("error, image not saved")
        }
      }
    }
  }
  
  func load() {
    guard let path = self.dataPath else { return }
    
    let fileEnumerator = FileManager.default.enumerator(at: path,
                                              includingPropertiesForKeys: nil)
    fileEnumerator?.forEach { (item) in
      if let fileURL = item as? URL {
        let fileName = fileURL.lastPathComponent
        
        let path = fileURL.path
        guard let image = UIImage.init(contentsOfFile: path) else { return }
        
        let beer = Beer.init(fileName: fileName, image: image)
        self.addBeer(beer)
      }
    }
  }
  
  func delete() {
    guard let path = self.dataPath else { return }
    
    for beer in self.beers {
      let imageURL = path.appendingPathComponent(beer.fileName)
      if FileManager.default.fileExists(atPath: imageURL.path) {
        do {
          try
            //UIImagePNGRepresentation(beer.image).remove(at: imageURL) as String
            
            FileManager.default.removeItem(at: imageURL)
           
          print("image was deleted")
        } catch {
          print("we can't to delete")
        }
      }
    }
  }
  
}

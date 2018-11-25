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
  
  // MARK: Variables
  
  private var beers = [Beer]()
  
  // MARK: Properties
  
  var beerCount: Int {
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

  // MARK: Public
  
  func beer(at index: Int) -> Beer? {
    if (index >= beers.count) {
      return nil
    }
    
    return self.beers[index]
  }
  
  func addBeer(_ beer: Beer) {
    self.beers.append(beer)
  }
  
  func addBeer(with image: UIImage) {
    
    // Step 1: check if beer with image exists in beers array
    
    var isBeerWithImageExists = false
    
    // Get the Data object for passed image of UIImage type
    
    let imagePNGRepresentation = UIImagePNGRepresentation(image)
    
    for beerImage in self.beerImages {
      
      // Get the Data object for current beer's image in beers array
      
      let beerImagePNGRepresentation = UIImagePNGRepresentation(beerImage)
      
      // Compare two Data objects to check if they have the same content
      
      if (beerImagePNGRepresentation == imagePNGRepresentation) {
        
        // If they have the same content then set the isBeerWithImageExists flag to TRUE
        
        isBeerWithImageExists = true;
        break
      }
    }
    
    // Step 2: if there is a beer with a same image as passed into this function, return without adding beer
    
    if isBeerWithImageExists {
      return;
    }
    
    // Step 3: if there is no beer with a same image as passed into current function, create a beer with image
    
    var beer: Beer?
    if let imageClone = image.copy() as? UIImage {
      beer = Beer(fileName: NSUUID().uuidString, image: imageClone)
    }
    
    // Step 4: if beer was created on previous step then add beer to beers array
    
    if let unwrappedBeer = beer {
      self.addBeer(unwrappedBeer)
    }
  }
  
  func save() {
    
    // Step 1: get the path, if returned nil as a path return from function
    
    guard let path = self.dataPath
      else {
        return
    }
  
    // Step 2: go through all beers and format urls for image storage
    
    for beer in self.beers {
      let imageURL = path.appendingPathComponent(beer.fileName)
      
      // Step 3: check is file exists at the imageURL path
      
      if !FileManager.default.fileExists(atPath: imageURL.path) {
        do {
          
          // Step 4: if the file does not exist, then try save it at the imageURL
          
          try UIImagePNGRepresentation(beer.image)?.write(to: imageURL)
          
        } catch {
          // If they is exception, then print an error
          
          print("image not saved")
        }
      }
    }
  }
  
  func load() {
    
    // Step 1: get the path, if returned nil as a path return from function
    
    guard let path = self.dataPath
      else {
        return
    }
    
    // Step 2: go though all files at the path location
    
    let fileEnumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: nil)
    fileEnumerator?.forEach { (item) in
      if let fileURL = item as? URL {
        
        // Step 3: get the file name from file path
        
        let fileName = fileURL.lastPathComponent
        
        // Step 4: load the image at given path
        
        let path = fileURL.path
        guard let image = UIImage.init(contentsOfFile: path)
          else {
            return
        }
        
        // Step 5: Create a beer with a loaded image and its file name
        
        let beer = Beer.init(fileName: fileName, image: image)
        
        // Step 6: add a newly created beer
        
        self.addBeer(beer)
      }
    }
  }
}


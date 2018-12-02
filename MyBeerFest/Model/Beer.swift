//
//  Beer.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 11/29/18.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class Beer {
  
  var fileName: String
  var image: UIImage
  
  init(fileName: String, image: UIImage) {
    self.fileName = fileName
    self.image = image
  }
}

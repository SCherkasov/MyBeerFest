//
//  ImagePreviewViewController.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 11/21/18.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
  
  @IBOutlet var previewImage: UIImageView!
  
  var image = UIImage()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      previewImage.image = image
      
    }
}

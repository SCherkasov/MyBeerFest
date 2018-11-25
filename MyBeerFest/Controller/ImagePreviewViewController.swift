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
  @IBOutlet var scrollView: UIScrollView!
  
  var beer: Beer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    previewImage.image = beer?.image
    
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 8.0
    
    scrollView.delegate = self
  }
}

// MARK: UIScrollViewDelegate
extension ImagePreviewViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return previewImage
  }
}

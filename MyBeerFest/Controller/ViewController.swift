//
//  ViewController.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  
  var beerModel = BeerModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nibName = UINib(nibName: "BeerCollectionViewCell", bundle: nil)
    collectionView.register(nibName,
                            forCellWithReuseIdentifier: "BeerCollectionViewCell")
    
    setupLayoutToCollectionView()
    addLogoToNavigationBarTitle()
  }
  
  // Add logo to ToNavigationBarTitle
  func addLogoToNavigationBarTitle() {
    let naviController = navigationController
    let logoImage = #imageLiteral(resourceName: "BeerLogo")
    let imageView = UIImageView(image: logoImage)
    let logoWigth = naviController?.navigationBar.frame.size.width
    let logoHeight = naviController?.navigationBar.frame.size.height
    let logoX = logoWigth! / 2 - logoImage.size.width / 2
    let logoY = logoHeight! / 2 - logoImage.size.height / 2
    
    imageView.frame = CGRect(x: logoX, y: logoY, width: logoWigth!,
                             height: logoHeight!)
    imageView.contentMode = .scaleAspectFit
    navigationItem.titleView = imageView
    naviController?.navigationBar.barTintColor = UIColor.black
  }
  
  // make layout to Collection View
  func setupLayoutToCollectionView() {
    let itemSize = UIScreen.main.bounds.width / 3
    
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    layout.itemSize = CGSize(width: itemSize, height: itemSize)
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    
    collectionView.collectionViewLayout = layout
  }
  
  // Motion effect to show alert
  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      alertAfterShakeMotion()
      print("motion was greate")
    }
  }
  
  // Added alert after shake motion
  func alertAfterShakeMotion() {
    let alertController = UIAlertController(title: "Alert",
                                            message: "Please make you choose:", preferredStyle: .alert)
    let actionCamera = UIAlertAction(title: "Camera", style: .default) {
      (action: UIAlertAction) in
      self.takePhoto()
      print("I was open yout camera")
    }
    let actionLibrary = UIAlertAction(title: "Library", style: .default) {
      (action: UIAlertAction) in
      self.takePhotoLibrary()
      print("I was open your Library")
    }
    
    alertController.addAction(actionCamera)
    alertController.addAction(actionLibrary)
    self.present(alertController, animated: true, completion: nil)
  }
  
  //****************************************
  
  var documentsURL: URL? {
    get {
      return try? FileManager.default.url(for: .documentDirectory,
                                          in: .userDomainMask,
                                          appropriateFor: nil,
                                          create: true)
    }
  }
  
  func saveBeerImages() {
    for image in beerModel.allBeerImages() {
      if let folderURL = self.documentsURL {
        print(folderURL.absoluteString)
        
        let fileName =  "\(NSUUID().uuidString).png";
        
        let imageURL = folderURL.appendingPathComponent(fileName)
        
        if !FileManager.default.fileExists(atPath: imageURL.path) {
          do {
            try UIImagePNGRepresentation(image)?.write(to: imageURL)
            print("image added good")
          } catch {
            print("image not saved")
          }
        }
      }
    }
  }
  
  func loadBeerImager() {
    if let folderURL = documentsURL {
      let fileEnumerator = FileManager.default.enumerator(at: folderURL, includingPropertiesForKeys: nil)
      fileEnumerator?.forEach { (item) in
        if let fileURL = item as? URL,
          let image = UIImage.init(contentsOfFile: fileURL.path) {
          self.beerModel.addBeer(withImage: image)
        }
      }
    }
  }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return beerModel.BeerCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as! BeerCollectionViewCell
    
    cell.beerImage.image = beerModel.beerImage(at: indexPath.row)
    
    return cell
  }
}

// MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ViewController: UINavigationControllerDelegate,
UIImagePickerControllerDelegate {
  
  func takePhoto() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerControllerSourceType.camera
      imagePicker.allowsEditing = true
      present(imagePicker, animated: true, completion: nil)
    } else {
      print("ERROR")
    }
  }
  
  func takePhotoLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
      imagePicker.allowsEditing = false
      present(imagePicker, animated: true, completion: nil)
    } else {
      print("ERROR")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      beerModel.addBeer(withImage: pickedImage)
      collectionView.reloadData()
    }
    dismiss(animated: true, completion: nil)
  }
}

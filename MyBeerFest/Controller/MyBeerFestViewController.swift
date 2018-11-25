//
//  ViewController.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import AudioToolbox

class MyBeerFestViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  
  var pub = Pub()
  
  var longPressedGestured: UILongPressGestureRecognizer!

  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load pub right after view is loaded
    
    self.pub.load()
    
    let nibName = UINib(nibName: "BeerCollectionViewCell", bundle: nil)
    collectionView.register(nibName,
                            forCellWithReuseIdentifier: "BeerCollectionViewCell")
    
    setupLayoutToCollectionView()
    addLogoToNavigationBarTitle()
    
    longPressed()
  }
  
  // Long press function to call actionSheet to delete cell
  func longPressed() {
    longPressedGestured = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
    longPressedGestured.minimumPressDuration = 0.6
    collectionView.addGestureRecognizer(longPressedGestured)
  }
  
  @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      guard let selectedIndexPath = collectionView.indexPathForItem(at:
        gesture.location(in: collectionView)) else { break }
      collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
      AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
      print("selectedLongPress")
      
      let aleretController = UIAlertController(title: "DeleteItem",
                               message: "Would you like to delete this beer?", preferredStyle: .actionSheet)
      let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
        print("ok action")
      }
      let cancelAction = UIAlertAction(title: "cancel", style: .cancel) {
        (action) in
        print("cancel action")
      }
      aleretController.addAction(okAction)
      aleretController.addAction(cancelAction)
      self.present(aleretController, animated: true, completion: nil)
      
    default:
      collectionView.cancelInteractiveMovement()
    }
  }
  
  // Add logo to ToNavigationBarTitle
  func addLogoToNavigationBarTitle() {
    
    // Step 1: get navigation bar, if nil then return
    
    guard let navigationBar = self.navigationController?.navigationBar
      else {
        return
    }
    
    // Step 2: set navigation bar tint color
    
    navigationBar.barTintColor = UIColor.black
  
    // Step 3: load logo image from bundle, if nil then return
    
    guard let logoImage = UIImage.init(named: "BeerLogo")
      else {
        return
    }
    
    // Step 4: get loaded image width to height ration, this is required to fill navigation bar bar using its hegiht as invariant
    
    let widthToHeightRatio = logoImage.size.width / logoImage.size.height
    
    // Step 5: calculate logo view height and width
    
    let navigationBarBounds = navigationBar.bounds
    let barHeight = navigationBarBounds.size.height
    let logoHeight = barHeight
    let logoWidth = logoHeight * widthToHeightRatio
    
    // Step 6: as per https://stackoverflow.com/questions/28121388/cant-set-titleview-in-the-center-of-navigation-bar-because-back-button I should create interim view, titleView, add imageView to it and only after that add titleView as a navigationItem.titleView
    
    let imageView = UIImageView(image: logoImage)
    let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: logoWidth, height: logoHeight))
    
    imageView.frame = titleView.bounds;
    imageView.contentMode = .scaleAspectFit
    
    titleView.addSubview(imageView)
    
    self.navigationItem.titleView = titleView;
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
      self.presentAddBeerAlert()
    }
  }
  
  @IBAction func addBeerBarButtonTouched(_ sender: Any) {
    self.presentAddBeerAlert()
  }
  
  // Added alert after shake motion
  func presentAddBeerAlert() {
    let alertController = UIAlertController(title: "Alert",
                                            message: "Please make you choose:", preferredStyle: .alert)
    let actionCamera = UIAlertAction(title: "Camera", style: .default) {
      (action: UIAlertAction) in
      self.takePhoto()
      print("Дверь мне запили")
    }
    let actionLibrary = UIAlertAction(title: "Library", style: .default) {
      (action: UIAlertAction) in
      self.takePhotoLibrary()
      print("Я твой дом труба шатал")
    }
    
    alertController.addAction(actionCamera)
    alertController.addAction(actionLibrary)
    self.present(alertController, animated: true, completion: nil)
  }
  
}

// MARK: UICollectionViewDataSource
extension MyBeerFestViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return self.pub.beerCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) ->
                                                        UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as! BeerCollectionViewCell
    
    cell.beer = pub.beer(at: indexPath.row)
    
    return cell
  }
}

//MARK: UICollectionViewDelegate
extension MyBeerFestViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    
    let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let destSB = mainSB.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
    destSB.beer = pub.beer(at: indexPath.row)
    
    self.navigationController?.pushViewController(destSB, animated: true)
  }
}

// MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension MyBeerFestViewController: UINavigationControllerDelegate,
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
  
  // fixed image orientation when load image
  func fixImageOrientation(_ image: UIImage)->UIImage {
    UIGraphicsBeginImageContext(image.size)
    image.draw(at: .zero)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage ?? image
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      
      self.pub.addBeer(with: fixImageOrientation(pickedImage))
      
      // Save pub each time the new beer is added
      
      self.pub.save()
      
      self.collectionView.reloadData()
    }
    
    dismiss(animated: true, completion: nil)
  }
}

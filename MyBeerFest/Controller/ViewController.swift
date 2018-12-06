//
//  ViewController.swift
//  MyBeerFest
//
//  Created by Stanislav Cherkasov on 08.10.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  
  var pub = Pub()
  var longPressedGestured: UILongPressGestureRecognizer!
  var player: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    longPressedGestured = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
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
      
      let aleretController = UIAlertController(title: "Delete..?",
                                               message: "Would you like to delete this beer?", preferredStyle: .actionSheet)
      let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
        print("ok action")
        self.playOpenOrDeleteBeerSound(soundName: "deleteBeerSound")
        self.pub.delete()
        self.pub.removeBeer(at: selectedIndexPath.row)
        self.collectionView.deleteItems(at: [selectedIndexPath])
      }
      let cancelAction = UIAlertAction(title: "cancel", style: .default) {
        (action) in
        print("cancel action")
      }
      
      aleretController.view.tintColor = UIColor.darkGray
      
      aleretController.addAction(okAction)
      aleretController.addAction(cancelAction)
      self.present(aleretController, animated: true, completion: nil)
      
    default:
      collectionView.cancelInteractiveMovement()
    }
  }
  
  // Add logo to ToNavigationBarTitle
  func addLogoToNavigationBarTitle() {
    guard let navigationBar = self.navigationController?.navigationBar
      else { return }
    
    navigationBar.barTintColor = UIColor.black
    
    guard let logoImage = UIImage.init(named: "BeerLogo") else { return }
    
    let widthToHeightRatio = logoImage.size.width / logoImage.size.height
    let navigationBarBounds = navigationBar.bounds
    let barHeight = navigationBarBounds.size.height
    let logoHeight = barHeight
    let logoWidth = logoHeight * widthToHeightRatio
    
    let imageView = UIImageView(image: logoImage)
    let titleView = UIView.init(frame: CGRect(x: 0, y: 0, width: logoWidth, height: logoHeight))
    
    imageView.frame = titleView.bounds
    imageView.contentMode = .scaleAspectFit
    
    titleView.addSubview(imageView)
    
    self.navigationItem.titleView = titleView
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
      self.playOpenOrDeleteBeerSound(soundName: "openBeerSound")
      print("motion was greate")
    }
  }
  
  @IBAction func addBeerBarButton(_ sender: Any) {
    self.playOpenOrDeleteBeerSound(soundName: "openBeerSound")
    self.alertAfterShakeMotion()
  }
  
  // Sound effect
  func playOpenOrDeleteBeerSound(soundName: String) {
    guard let url = Bundle.main.url(forResource: soundName,
                                    withExtension: "wav") else { return }
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
      
      guard let player = player else { return }
      player.play()
    } catch let error {
      print(error.localizedDescription)
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

    alertController.view.tintColor = UIColor.black

    alertController.addAction(actionCamera)
    alertController.addAction(actionLibrary)
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return pub.BeerCount
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
extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    
    let mainSB: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let destSB = mainSB.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
    //var data = beerModel.allBeerImages()
    destSB.beer = pub.beer(at: indexPath.row)
    
    self.navigationController?.pushViewController(destSB, animated: true)
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
      self.pub.save()
      self.collectionView.reloadData()
    }
    
    dismiss(animated: true, completion: nil)
  }
}

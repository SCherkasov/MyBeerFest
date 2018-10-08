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
  
  func setupLayoutToCollectionView() {
    let itemSize = UIScreen.main.bounds.width / 3
    
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    layout.itemSize = CGSize(width: itemSize, height: itemSize)
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    
    collectionView.collectionViewLayout = layout
  }
  
}

extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return beerModel.beerArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as! BeerCollectionViewCell
    
    cell.beerImage.image = UIImage(named: beerModel.beerArray[indexPath.row])
    
    return cell
  }
  
}

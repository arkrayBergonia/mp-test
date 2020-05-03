//
//  ViewController.swift
//  mp-test
//
//  Created by Francis Jemuel Bergonia on 5/3/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit
import Photos

struct Item {
    var imageName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //Array of PHAsset type for storing photos
    var images = [PHAsset]()
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "ItemCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setupCollectionViewItemSize()
        self.getImages()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }

    private func setupCollectionViewItemSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 3
            let lineSpacing: CGFloat = 5
            let interItemSpacing: CGFloat = 5
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
            let height = width
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    private func getImages() {
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
           // self.cameraAssets.add(object)
            self.images.append(object)
        })

        //In order to get latest image first, we just reverse the array
        self.images.reverse()

        // To show photos, I have taken a UICollectionView
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        if cell.tag != 0 {
                manager.cancelImageRequest(PHImageRequestID(cell.tag))
            }
        cell.tag = Int(manager.requestImage(for: asset,
                                                targetSize: CGSize(width: 120.0, height: 120.0),
                                                contentMode: .aspectFill,
                                                options: nil) { (result, _) in
                                                    cell.imageView.image = result
            })
        return cell
    }
    
    
}

//
//  ViewController.swift
//  mp-test
//
//  Created by Francis Jemuel Bergonia on 5/3/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import UIKit

struct Item {
    var imageName: String
}

class ViewController: UIViewController {

    enum Mode {
        case view
        case select
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Item] = [Item(imageName: "1"),
                         Item(imageName: "2"),
                         Item(imageName: "3"),
                         Item(imageName: "4"),
                         Item(imageName: "5"),
                         Item(imageName: "6"),
                         Item(imageName: "7"),
                         Item(imageName: "8"),
                         Item(imageName: "9"),
                         Item(imageName: "10"),
                         Item(imageName: "11"),
                         Item(imageName: "12")]
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let cellIdentifier = "ItemCollectionViewCell"
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                for (key, value) in dictionarySelectedIndecPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                dictionarySelectedIndecPath.removeAll()
                
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
      return barButtonItem
    }()

    lazy var deleteBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
      return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtonItems()
        setupCollectionView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setupCollectionViewItemSize()
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
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mMode = mMode == .view ? .select : .view
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        var deleteNeededIndexPaths: [IndexPath] = []
        for (key, value) in dictionarySelectedIndecPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        
        for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            items.remove(at: i.item)
        }
        
        collectionView.deleteItems(at: deleteNeededIndexPaths)
        dictionarySelectedIndecPath.removeAll()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        
        cell.imageView.image = UIImage(named: items[indexPath.item].imageName)
        
        return cell
    }
    
    
}

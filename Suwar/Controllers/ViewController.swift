//
//  ViewController.swift
//  Suwar
//
//  Created by Ilyasa Azmi on 21/03/20.
//  Copyright © 2020 Ilyasa Azmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoSearchBar: UISearchBar!
    
    var listOfPhotos = [PhotoDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
                self.navigationItem.title = "\(self.listOfPhotos.count) found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.register(UINib.init(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FotoCollectionViewCell")
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoSearchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
        
        //check rest API
//        startRestApi()
    }
    
    func startRestApi(){
        let photoRequest = PhotoRequest(searchInput: "office")
        photoRequest.getPhotos { (result) in
            print(result)
        }
        photoRequest.getPhotos { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                print("error here")
            case .success(let photos):
                self?.listOfPhotos = photos
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionViewCell",
        for: indexPath) as! FotoCollectionViewCell
        
        let photo = listOfPhotos[indexPath.row]
        
        cell.descriptionLabel.text = photo.id
        cell.photoImageView.image = UIImage(named: "\(photo.urls.thumb)")
        cell.backgroundColor = .blue
//        cell.descriptionLabel.text = "Label TES"
        
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("tapped")
        guard let searchBarText = photoSearchBar.text else {return}
        let photoRequest = PhotoRequest(searchInput: searchBarText)
        photoRequest.getPhotos { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let photos):
                self?.listOfPhotos = photos
            }
        }
    }
}


//
//  ViewController.swift
//  Suwar
//
//  Created by Ilyasa Azmi on 21/03/20.
//  Copyright © 2020 Ilyasa Azmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoSearchBar: UISearchBar!
    
    private var reuseIdentifier = "PhotoCell"
    
    //Fetch and reload data
    var listOfPhotos = [PhotoDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
                self.navigationItem.title = self.photoSearchBar.text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Suwar"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoSearchBar.delegate = self
        
        photoCollectionView.reloadData()
        
        
        //Implement Layout
        
        if let layout = photoCollectionView.collectionViewLayout as? PhotoLayout {
                   layout.delegate = self
               }
               photoCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //check rest API
//        startRestApi()
    }
    
//    func startRestApi(){
//        let photoRequest = PhotoRequest(searchInput: "office")
//        photoRequest.getPhotos { (result) in
//            print(result)
//        }
//        photoRequest.getPhotos { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print(error)
//                print("error here")
//            case .success(let photos):
//                self?.listOfPhotos = photos
//            }
//        }
//    }
    
    

}

//MARK: Flow Layout
//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfColumns: CGFloat = 2
//        let width = collectionView.frame.size.width
//        let xInsets: CGFloat = 10
//        let cellSpacing:CGFloat = 5
//        let photo = listOfPhotos[indexPath.item]
//        let height = photo.height / 10
//
//        return CGSize(width: (width/numberOfColumns) - (xInsets + cellSpacing), height: CGFloat(height))
//    }
//}

extension ViewController: PhotoLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let photo = listOfPhotos[indexPath.item]
        let height = photo.height / 10
        
        return CGFloat(height)
    }
    
    
}

//MARK: Data Source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.layer.cornerRadius = 10
        
        cell.configure(with: listOfPhotos[indexPath.row])
        
        return cell
    }
}



extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
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
        print("on search \(searchBarText)")
    }
}

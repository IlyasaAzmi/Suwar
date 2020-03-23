//
//  PhotoCell.swift
//  Suwar
//
//  Created by Ilyasa Azmi on 22/03/20.
//  Copyright © 2020 Ilyasa Azmi. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    private var cancellable: AnyCancellable?
    
    public func configure(with photo: PhotoDetail) {
        
        if let imageURL = URL(string: "\(photo.urls.small)") {
            photoLabel.text = ""
            
            let imagePlaceHolder = UIImage(named: "logo")
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: imageURL, placeholder: imagePlaceHolder, options: nil)
        }

    }
    
    func downloadImage(`with` urlString : String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func showImage(image: UIImage?) {
        photoImageView.alpha = 0.0
        photoImageView.image = image
    }
}

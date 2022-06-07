//
//  RandomPhotosViewCell.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 04.06.2022.
//

import UIKit

class RandomPhotosViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func customizeUI() {
        addSubview(imageView)
        addSubview(activityIndicator)

        imageView.frame = bounds
        activityIndicator.frame = bounds
    }
    
    func getImage(result: Result) {
        activityIndicator.startAnimating()
        imageView.image = nil
        
        let imageURL = result.urls.small
        
        NetworkManager.shared.fetchImage(url: imageURL) { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.imageView.image = image
        }
    }
}

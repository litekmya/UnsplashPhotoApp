//
//  DescriptionViewController.swift
//  UnsplashPhotoApp
//
//  Created by Владимир Ли on 07.06.2022.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    //MARK: - Public properties
    var result: Result!
    var databaseResult: DatabaseResult!
    var currentResult: DatabaseResult!
    var fromDataBase: Bool!
    
    //MARK: - Private properties
    private var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private var authorLabel: UILabel! = {
        let label = UILabel()
        label.contentMode = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var dateLabel: UILabel! = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var likesCountLabel: UILabel! = {
        let label = UILabel()
        label.contentMode = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var favoriteButton: UIBarButtonItem!
    
    private let starImage = UIImage(
        systemName: "star",
        withConfiguration:UIImage.SymbolConfiguration(weight: .regular))?
        .withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    
    private let fillStarImage = UIImage(
        systemName: "star.fill",
        withConfiguration:UIImage.SymbolConfiguration(weight: .regular))?
        .withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    
    private let alertTitle = "Внимание"
    private let alertMessage = "Вы уверены, что хотите удалить данное фото из коллекции?"
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Description"
        view.backgroundColor = .white
        
        addSubviews()
        setupAuthorLabelLayout()
        setupImageViewLayout()
        setupDateLabelLayout()
        setupDownloadsCountLabelLayout()
        addFavoriteButton()
        
        checkReceivedData()
    }
    
    //MARK: - private methods "layout"
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(authorLabel)
        view.addSubview(dateLabel)
        view.addSubview(likesCountLabel)
    }
    
    private func setupAuthorLabelLayout() {
        authorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupImageViewLayout() {
        imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    private func setupDateLabelLayout() {
        dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setupDownloadsCountLabelLayout() {
        likesCountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
        likesCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        likesCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func addFavoriteButton() {
        favoriteButton = UIBarButtonItem(image: starImage, style: .done, target: self, action: #selector(addFaforite))
        
        if fromDataBase {
            favoriteButton.image = fillStarImage
        } else {
            favoriteButton.image = starImage
        }
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    //MARK: - Private methods
    private func getDataFromNetwork() {
        authorLabel.text = result.user.name
        dateLabel.text = "Дата создания: \(dateFormat(date: result.created_at))"
        likesCountLabel.text = "👍 \(String(result.likes))"
        
        NetworkManager.shared.fetchImage(url: result.urls.small) { image in
            self.imageView.image = image
        }
    }
    
    private func getDataFromDatabase() {
        authorLabel.text = databaseResult.user
        dateLabel.text = "Дата создания: \(dateFormat(date: databaseResult.createdAt))"
        likesCountLabel.text = "👍 \(String(databaseResult.likes))"
        
        guard let imageData = databaseResult.imageData else { return }
        let image = UIImage(data: imageData)
        imageView.image = image
    }
    
    private func dateFormat(date: String) -> String {
        let isoDate = date
        let dateFormater = ISO8601DateFormatter()
        guard let date = dateFormater.date(from: isoDate) else { return ""}
        let stringDate = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        
        return stringDate
    }
    
    private func checkReceivedData() {
        if fromDataBase {
            getDataFromDatabase()
        } else {
            getDataFromNetwork()
        }
        
        if databaseResult != nil {
            currentResult = databaseResult
        } else {
            currentResult = DatabaseResult(result: self.result)
        }
    }
    
    //MARK: - @objc
    @objc private func addFaforite() {
        if favoriteButton.image == starImage {
            let imageData = imageView.image?.pngData()
            
            currentResult.imageData = imageData
            currentResult.isFavorite = true
            favoriteButton.image = fillStarImage
            
            StorageManager.shared.save(databaseResult: currentResult)
        } else {
            showAlert(databaseResult: currentResult)
        }
    }
}

//MARK: - UIAlertController
extension DescriptionViewController {
    
    private func showAlert(databaseResult: DatabaseResult) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { [weak self] _ in
            StorageManager.shared.delete(databaseResult: databaseResult)
            self?.favoriteButton.image = self?.starImage
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

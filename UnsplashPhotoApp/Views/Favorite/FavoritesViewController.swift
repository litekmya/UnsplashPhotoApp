//
//  FavoritesViewController.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 05.06.2022.
//

import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController {
    
    private var results: Results<DatabaseResult>!
    private var identifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        results = StorageManager.shared.realm.objects(DatabaseResult.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let result = results[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        guard let imageData = result.imageData else { return cell }
        let image = UIImage(data: imageData)
                
        content.image = image
        content.text = result.user
        cell.contentConfiguration = content

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = results[indexPath.row]
        
        let descriptionVC = DescriptionViewController()
        descriptionVC.databaseResult = result
        descriptionVC.fromDataBase = true
        
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
}

//
//  MainTabBarController.swift
//  UnsplashPhotoApp
//
//  Created by Владимир Ли on 07.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let randomPhotosViewController = createNavigationController(
            view: RandomPhotosViewController(),
            itemName: "Unspash photos",
            itemImage: "globe.europe.africa"
        )
        let favoritesViewController = createNavigationController(
            view: FavoritesViewController(),
            itemName: "Favorites",
            itemImage: "star.circle"
        )
        
        tabBar.alpha = 0.9
        
        setViewControllers([randomPhotosViewController, favoritesViewController], animated: true)
        selectedViewController = randomPhotosViewController
    }
    
    private func createNavigationController(view: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage), tag: 0)
        
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.tabBarItem = item
        
        return navigationController
    }
}

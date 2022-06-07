//
//  DatabaseModel.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 05.06.2022.

import Foundation
import RealmSwift

class DatabaseResult: Object {
    @objc dynamic var id = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var likes = 0
    @objc dynamic var user = ""
    @objc dynamic var imageData: Data?

    @objc dynamic var isFavorite = false
    
    convenience init(result: Result) {
        let image = UIImage(systemName: "star")
        let imageData = image?.pngData()
        
        self.init()
        self.createdAt = result.created_at
        self.likes = result.likes
        self.user = result.user.name
        self.imageData = imageData
        self.isFavorite = true
    }
}


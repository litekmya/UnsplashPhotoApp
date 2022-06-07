//
//  Result.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 04.06.2022.
//

import Foundation

struct SearchResults: Codable {
    var total: Int
    var results: [Result]
}

struct Result: Codable {
    var id: String
    var created_at: String
    var likes: Int
    var user: User
    var urls: URLs
}

struct User: Codable {
    var name: String
}

struct URLs: Codable {
    var small: String
}


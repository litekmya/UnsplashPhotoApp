//
//  StorageManager.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 05.06.2022.


import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    func save(databaseResult: DatabaseResult) {
        write {
            print("save")
            realm.add(databaseResult)
        }
    }
    
    func delete(databaseResult: DatabaseResult) {
        write {
            print("delete")
            realm.delete(databaseResult)
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try realm.write({
                completion()
            })
        } catch let error {
            print("StorageManager/write: \(error)")
        }
    }
}

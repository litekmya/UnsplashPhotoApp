//
//  NetworkManager.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 04.06.2022.
//

import UIKit

enum URLExamples: String {
    case search = "https://api.unsplash.com/search/photos?per_page=30&query="
    case random = "https://api.unsplash.com/photos/random?count=30"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private var token = "-RcT_9CaglD7W48dTqngi3YjyFEvZRrwh9KSNCvw0Sc"
    private var url: URL!
    
    private init() {}
    
    func fetchData<T: Codable>(type: T.Type, urlString: String, searchText: String, completion: @escaping(T) -> Void) {
        guard let url = URL(string: urlString + searchText) else { return }
        URLSession.shared.dataTask(with: makeRequest(url: url)) { data, _, error in
            self.checkFor(error: error)
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let results = try jsonDecoder.decode(type.self, from: data)
                completion(results)
            } catch let error {
                print("Ошибка JSONDecoder: \(error)")
            }
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let imageURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: makeRequest(url: imageURL)) { data, _, error in
            self.checkFor(error: error)
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func checkFor(error: Error?) {
        guard error == nil else {
            print("Ошибка URLSession image: \(String(describing: error))")
            return
        }
    }
}

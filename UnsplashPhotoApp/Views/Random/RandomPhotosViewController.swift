//
//  RandomPhotosViewController.swift
//  UnsplashPhoto
//
//  Created by Владимир Ли on 04.06.2022.
//

import UIKit

class RandomPhotosViewController: UIViewController {
    
    //MARK: - Private properties
    private var searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView!
    
    private var results: [Result] = []
    private var foundedResults: [Result] = []
    
    private var searchText = ""
    private var found = false
    private var result: Result!
    private var timer: Timer!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random photos"
        
        setupSearchController()
        setupCollectionView()
        loadRandomImages()
    }
    
    //MARK: - Private methods
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(RandomPhotosViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    private func loadRandomImages() {
        NetworkManager.shared.fetchData(
            type: [Result].self,
            urlString: URLExamples.random.rawValue,
            searchText: "") { results in
            DispatchQueue.main.async {
                self.results = results
                self.collectionView.reloadData()
            }
        }
    }
    
    private func checkResults(at indexPath: IndexPath) {
        if found {
            result = foundedResults[indexPath.row]
        } else {
            result = results[indexPath.row]
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension RandomPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if found {
            return foundedResults.count
        } else {
            return results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RandomPhotosViewCell
        checkResults(at: indexPath)
        
        cell.getImage(result: result)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        checkResults(at: indexPath)
        
        let descriptionVC = DescriptionViewController()
        descriptionVC.result = result
        descriptionVC.fromDataBase = false
        
        navigationController?.pushViewController(descriptionVC, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension RandomPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
}

//MARK: - UISearchBarDelegate
extension RandomPhotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            NetworkManager.shared.fetchData(
                type: SearchResults.self,
                urlString: URLExamples.search.rawValue,
                searchText: searchBar.text ?? "") { results in
                    DispatchQueue.main.async {
                        self.foundedResults = results.results
                        self.found = true
                    }
                }
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.found = false
        collectionView.reloadData()
    }
}

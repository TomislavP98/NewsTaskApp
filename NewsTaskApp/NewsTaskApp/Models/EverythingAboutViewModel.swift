//
//  EverythingAboutViewModel.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 14.05.2023..
//

import Foundation

protocol EverythingAboutViewModelDelegate: AnyObject {
    func reloadData()
}

class EverythingAboutViewModel {
    
    var dataArray = [Article]()
    var lastPage: Int = 0
    var isLoadingList = false
    var totalCount: Int?
    var query: String = ""
    var sort: String = "relevancy"
    
    var networkClient = NetworkClient()
    weak var delegate: EverythingAboutViewModelDelegate?
    
    func getEverything(page: Int, sort: String, q: String) {
        let networkClient = NetworkClient()
        networkClient.getEverything(page: page, sort: sort, q: q ) { [weak self] result in
            if let data = result.value {
                self?.totalCount = result.value?.totalResults
                self?.lastPage += 1
                self?.dataArray += data.articles
            }
            self?.delegate?.reloadData()
            self?.isLoadingList = false
            
        }
    }
}

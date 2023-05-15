//
//  CurrentNewsViewModel.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import Foundation
protocol CurrentNewsViewModelDelegate: AnyObject {
    func reloadData()
}

class CurrentNewsViewModel {
    
    var dataArray = [Article]()
    var lastPage: Int = 0
    var isLoadingList = false
    var totalCount: Int?
    
    var networkClient = NetworkClient()
    weak var delegate: CurrentNewsViewModelDelegate?
    
    func getTopNews(page: Int) {
        let networkClient = NetworkClient()
        networkClient.getTopNews(page: page) { [weak self] result in
            if let data = result.value {
                self?.totalCount = result.value?.totalResults
                self?.lastPage += 1
                self?.dataArray += data.articles
                self?.delegate?.reloadData()
            }
            self?.isLoadingList = false
        }
    }
}

//
//  EverythingAboutTableViewController.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 14.05.2023..
//

import UIKit

enum menuTypes: String {
    case relevancy = "relevancy"
    case popularity = "popularity"
    case publishedAt = "publishedAt"
}


class EverythingAboutTableViewController: UITableViewController, EverythingAboutViewModelDelegate, UISearchResultsUpdating {
    
    
    let viewModel = EverythingAboutViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        configureSearchBar()
        tableView.register(UINib(nibName: "CurrentNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.separatorStyle = .singleLine

                
        let sortMenu = UIMenu(title: "Sort by", options: .displayInline, children: [
            UIDeferredMenuElement.uncached { [weak self] completion in
                let actions = [
                    UIAction(title: "Relevancy", image: UIImage(systemName: "star"), state: self?.viewModel.sort == "relevancy" ? .on : .off, handler: { (action) in
                        self?.viewModel.sort = "popularity"
                    }),
                    UIAction(title: "Popularity", image: UIImage(systemName: "person.fill.checkmark"), state: self?.viewModel.sort == "popularity" ? .on : .off, handler: { (action) in
                        self?.viewModel.sort = "popularity"
                    }),
                    UIAction(title: "Published At", image: UIImage(systemName: "calendar.badge.clock"), state: self?.viewModel.sort == "publishedAt" ? .on : .off, handler: { (action) in
                        self?.viewModel.sort = "publishedAt"
                    })
                ]
                completion(actions)
            }
        ])
        
        let navItems = [UIBarButtonItem(image:  UIImage(systemName: "arrow.up.and.down.text.horizontal"), primaryAction: nil, menu: sortMenu) ,
                        .fixedSpace(10)]
        self.navigationItem.rightBarButtonItems = navItems
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataArray.count == 0 {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "No Results? Start typing in search!"
                emptyLabel.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = emptyLabel
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                return 0
            } else {
                self.tableView.backgroundView = nil
                return viewModel.dataArray.count
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! CurrentNewsTableViewCell
        
        cell.titleLabel?.text = viewModel.dataArray[indexPath.row].title
        cell.descriptionLabel?.text = viewModel.dataArray[indexPath.row].description
        
        let dateFormatter = DateFormatter()
        let displayDateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        
        if let publishDateString = viewModel.dataArray[indexPath.row].publishedAt {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            displayDateFormatter.dateFormat = "yyyy/MM/dd"
            if let publishDate = dateFormatter.date(from: publishDateString) {
                dateFormatter.timeZone = TimeZone.current
                cell.timeLabel?.text = displayDateFormatter.string(from: publishDate)
            }
        }
        
        if let urlStringUnwrapped = viewModel.dataArray[indexPath.row].urlToImage, let imageURL = URL(string: urlStringUnwrapped) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.newsImageView?.image = image
                        }
                    }
                }
            }
        }
        
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !viewModel.isLoadingList) {
            if (viewModel.totalCount != nil && viewModel.totalCount! > viewModel.dataArray.count) || viewModel.totalCount == nil {
                self.viewModel.isLoadingList = true
                self.viewModel.getEverything(page: viewModel.lastPage + 1, sort: "popularity", q: viewModel.query)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTextUnwrapped = searchController.searchBar.text {
            viewModel.query = searchTextUnwrapped
        }
        self.viewModel.dataArray.removeAll()
        self.viewModel.totalCount = nil
        self.viewModel.lastPage = 0
        self.viewModel.getEverything(page: viewModel.lastPage + 1, sort: viewModel.sort, q: viewModel.query)
    }
    
    func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func returnState(_ whichMenu: menuTypes) -> UIMenuElement.State {
        if whichMenu.rawValue == viewModel.sort {
            
            return UIMenuElement.State.on
        } else {
            return UIMenuElement.State.off
        }
    }
    
}

//
//  CurrentNewsTableViewController.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import UIKit

class CurrentNewsTableViewController: UITableViewController, CurrentNewsViewModelDelegate {
    let viewModel = CurrentNewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        tableView.register(UINib(nibName: "CurrentNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.separatorStyle = .singleLine
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
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
                self.viewModel.getTopNews(page: viewModel.lastPage + 1)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//
//  TabViewController.swift
//  NewsTaskApp
//
//  Created by Tomislav Petrov on 13.05.2023..
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
          viewControllers = [
              createNavController(for: EverythingAboutTableViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass")!),
              createNavController(for: CurrentNewsTableViewController(), title: "Top Headlines", image: UIImage(systemName: "chart.bar.doc.horizontal")!)
          ]
      }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    title: String,
                                                    image: UIImage) -> UIViewController {
          let navController = UINavigationController(rootViewController: rootViewController)
          navController.tabBarItem.title = title
          navController.tabBarItem.image = image
          navController.navigationBar.prefersLargeTitles = true
          rootViewController.navigationItem.title = title
          return navController
      }
}

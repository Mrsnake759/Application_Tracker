//
//  TabBarControleer.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarBorder()
        self.viewControllers = [createTrackerViewController(), createStatisticViewController()]
    }
    
    func createTrackerViewController() -> UINavigationController {
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Trackers", comment: ""),
            image: UIImage(named: "TrackerItem"),
            tag: 0)
        
        return UINavigationController(rootViewController: trackerViewController)
    }
    
    func createStatisticViewController() -> UINavigationController {
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Statistics", comment: ""),
            image: UIImage(named: "StatisticItem"),
            tag: 1)
        return UINavigationController(rootViewController: statisticViewController)
    }
    
    func setTabBarBorder() {
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.ypGray.cgColor
    }
}




//
//  FirstSetupViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 27.01.2024.
//

import UIKit

final class FirstSetupViewController: UIViewController {
    private let firstLaunchStorage = OnboardingStorage.shared
    
    private func checkFirstSetup() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось инициализировать AppDelegate")
        }
        if firstLaunchStorage.checkSecondSetup == false {
            appDelegate.window?.rootViewController = OnboardingPageViewController()
            firstLaunchStorage.checkSecondSetup = true
        } else {
            appDelegate.window?.rootViewController = TabBarController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFirstSetup()
    }
}

//
//  AppDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.12.2023.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
    let yandexMobileMetrica = YandexMobileMetrica.shared
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackersModelCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FirstSetupViewController()
        window?.makeKeyAndVisible()
        DaysTransformer.register()
        return true
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "5d57d158-dd3c-417a-b654-25fead389f30") else { return true }
        YMMYandexMetrica.activate(with: configuration)
        return true
    }
    
    
}

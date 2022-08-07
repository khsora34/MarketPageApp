//
//  AppDelegate.swift
//  MarketPageApp
//
//  Created by Francisco del Real Escudero on 4/8/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var dependencies: Dependencies!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        let dependencies = Dependencies(navigationController: navigationController)
        self.dependencies = dependencies
        self.window?.rootViewController = navigationController
        let initialCoordinator = dependencies.coinListCoordinator()
//        let initialCoordinator = dependencies.coinDetailCoordinator()
        initialCoordinator.start()
        self.window?.makeKeyAndVisible()
        return true
    }
}

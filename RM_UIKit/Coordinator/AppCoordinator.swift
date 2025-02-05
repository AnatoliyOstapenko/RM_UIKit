//
//  AppCoordinator.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navController = UINavigationController()
        let rmCoordinator = RMCoordinator(
            navController: navController,
            apiService: APIService(),
            dbService: CoreDataService()
        )
        rmCoordinator.start()
        childCoordinators = [rmCoordinator]
        window.rootViewController = navController
    }
}

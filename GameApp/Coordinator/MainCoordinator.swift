//
//  MainCoordinator.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let gamesListViewController: GamesListViewController = GamesListViewController()
        navigationController.pushViewController(gamesListViewController, animated: true)
    }
}

//
//  MainCoordinator.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.childCoordinators = [Coordinator]()
        self.navigationController = navigationController
    }
    
    func start() {
        let gamesListViewController: GamesListViewController = GamesListViewController()
        gamesListViewController.mainCoordinator = self
        navigationController.pushViewController(gamesListViewController, animated: true)
    }
    
    func popTopViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToGenresList() {
        let genresListViewController: GenresListViewController = GenresListViewController()
        genresListViewController.mainCoordinator = self
        navigationController.pushViewController(genresListViewController, animated: true)
    }
}

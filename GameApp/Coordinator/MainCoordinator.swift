//
//  MainCoordinator.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
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
    
    func presentGameDetails() {
        let gameDetailsViewController: GameDetailsViewController = GameDetailsViewController()
        gameDetailsViewController.mainCoordinator = self
        navigationController.present(gameDetailsViewController, animated: true)
    }
}

extension MainCoordinator {
    func presentGetAllGenresFailure(handler: @escaping () -> Void) {
        let alertController: UIAlertController = UIAlertController(title: "Error with fetching genres", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in handler() }))
        navigationController.present(alertController, animated: true)
    }
    
    func presentGetGamesFailure(handler: @escaping () -> Void) {
        let alertController: UIAlertController = UIAlertController(title: "Error with fetching games", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in handler() }))
        navigationController.present(alertController, animated: true)
    }
    
    func presentGetGameDetailsFailure(handler: @escaping () -> Void) {
        let alertController: UIAlertController = UIAlertController(title: "Error with fetching game details", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in handler() }))
        navigationController.present(alertController, animated: true)
    }
}

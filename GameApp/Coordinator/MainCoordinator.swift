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
        let gamesListViewModel: GamesListViewModel = GamesListViewModel()
        gamesListViewModel.mainCoordinator = self
        
        let gamesListView: GamesListView = GamesListView()
        
        let gamesListViewController: GamesListViewController = GamesListViewController(gamesListViewModel: gamesListViewModel, gamesListView: gamesListView)
        
        navigationController.pushViewController(gamesListViewController, animated: true)
    }
    
    func popTopViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToGenresList() {
        let genresListViewModel: GenresListViewModel = GenresListViewModel()
        genresListViewModel.mainCoordinator = self
        
        let genresListView: GenresListView = GenresListView()
        
        let genresListViewController: GenresListViewController = GenresListViewController(genresListViewModel: genresListViewModel, genresListView: genresListView)
        
        navigationController.pushViewController(genresListViewController, animated: true)
    }
    
    func presentGameDetails(gameId: Int) {
        let gameDetailsViewModel: GameDetailsViewModel = GameDetailsViewModel(gameId: gameId)
        gameDetailsViewModel.mainCoordinator = self
        
        let gameDetailsView: GameDetailsView = GameDetailsView()
        
        let gameDetailsViewController: GameDetailsViewController = GameDetailsViewController(gameDetailsViewModel: gameDetailsViewModel, gameDetailsView: gameDetailsView)
        
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

//
//  GameTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GameTableViewController: UITableViewController {
    var gameResponse: GameResponse = GameResponse(count: 0, next: nil, previous: nil, results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGamesFromAPI()
        
        title = "Games"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showGenreSelectionModal))
        
        tableView.register(UINib(nibName: "GameTableCellView", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        if UserDefaults().string(forKey: "selectedGenres") == nil {
            showGenreSelectionModal()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameResponse.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        
        let game = gameResponse.results[indexPath.row]
        
        cell.gameLabel.text = game.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = gameResponse.results[indexPath.row]
        
        showGameDetailsModal(game: game)
    }
    
    func getGamesFromAPI() {
        guard let selectedGenres = UserDefaults().string(forKey: "selectedGenres") else {
            return
        }
        APIManager.shared.getGames(genres: selectedGenres) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gameResponse):
                    self.gameResponse = gameResponse
                    self.tableView.reloadData()
                case .failure:
                    print("Error with getting games from API")
                }
            }
        }
    }
    
    func showGameDetailsModal(game: Game) {
        let gameDetailsViewController = GameDetailsViewController(game: game)
        
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(gameDetailsViewController, animated: true)
    }
    
    @objc func showGenreSelectionModal() {
        let genreTableViewController: GenreTableViewController = GenreTableViewController()
        genreTableViewController.isModalInPresentation = true
        genreTableViewController.genreTableViewDelegate = self
        
        let modalNavigationController = UINavigationController()
        modalNavigationController.pushViewController(genreTableViewController, animated: true)
        
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(modalNavigationController, animated: true)
    }
}

extension GameTableViewController: GenreTableViewDelegate {
    func modalDismiss() {
        getGamesFromAPI()
    }
}

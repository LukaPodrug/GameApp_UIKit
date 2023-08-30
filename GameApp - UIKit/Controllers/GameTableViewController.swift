//
//  GameTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GameTableViewController: UITableViewController {
    var gameResponse: GameResponse = GameResponse(count: 0, next: nil, previous: nil, results: [])
    var games: [Game] = []
    var gamePage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGamesFromAPI(page: gamePage)
        
        title = "Games"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showGenreSelectionModal))
        
        tableView.register(UINib(nibName: "GameTableCellView", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        if UserDefaults().string(forKey: "selectedGenres") == nil {
            showGenreSelectionModal()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        
        let game = games[indexPath.row]
        
        cell.gameLabel.text = game.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        
        showGameDetailsModal(game: game)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= games.count - 1 && gameResponse.next != nil {
            getGamesFromAPI(page: gamePage)
        }
    }
    
    func getGamesFromAPI(page: Int) {
        guard let selectedGenres = UserDefaults().string(forKey: "selectedGenres") else {
            return
        }
        APIManager.shared.getGames(genres: selectedGenres, page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gameResponse):
                    self.gameResponse = gameResponse
                    if self.gamePage == 1 {
                        self.games = gameResponse.results
                        self.tableView.animatedReload()
                    }
                    else {
                        var indexPaths: [IndexPath] = []
                        for i in self.games.count ..< self.games.count + gameResponse.results.count {
                            indexPaths.append(IndexPath(row: i, section: 0))
                        }
                        self.games.append(contentsOf: gameResponse.results)
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                    }
                    self.gamePage = self.gamePage + 1
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
        gamePage = 1
        getGamesFromAPI(page: gamePage)
    }
}

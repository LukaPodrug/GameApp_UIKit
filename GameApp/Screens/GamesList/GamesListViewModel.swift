//
//  GamesListViewModel.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class GamesListViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable>

    @Published var games: [GameModel]
    var gamesPage: Int
    var gamesLoadMore: Bool
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        
        self.games = []
        self.gamesPage = 1
        self.gamesLoadMore = false
        
        getGames()
    }
}

extension GamesListViewModel {
    func getGames() {
        gamesPage = 1
        
        APIManager.shared.getGames(page: gamesPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        self.handleGetGamesFailure(message: error.localizedDescription)
                    default:
                        break
                }
            }
            receiveValue: { gamesResponse in
                self.handleGetGamesSuccess(games: gamesResponse.results)
                if gamesResponse.next != nil {
                    self.gamesLoadMore = true
                    self.gamesPage = self.gamesPage + 1
                }
            }
            .store(in: &cancellables)
    }
    
    func handleGetGamesFailure(message: String) {
        
    }
    
    func handleGetGamesSuccess(games: [GameModel]) {
        self.games = games
    }
    
    func getMoreGames() {
        if gamesLoadMore == true {
            APIManager.shared.getGames(page: gamesPage)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.handleGetMoreGamesFailure(message: error.localizedDescription)
                    default:
                        break
                    }
                }
                receiveValue: { gamesResponse in
                    self.handleGetMoreGamesSuccess(games: gamesResponse.results)
                    if gamesResponse.next != nil {
                        self.gamesLoadMore = true
                        self.gamesPage = self.gamesPage + 1
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func handleGetMoreGamesFailure(message: String) {
        
    }
    
    func handleGetMoreGamesSuccess(games: [GameModel]) {
        self.games.append(contentsOf: games)
    }
}

extension GamesListViewModel {
    var updateGamesTableView: AnyPublisher<Bool, Never> {
        return $games.didSet
            .map { games in
                if games.count == 0 {
                    return false
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
}

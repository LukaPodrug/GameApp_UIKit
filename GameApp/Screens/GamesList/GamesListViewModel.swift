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
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        
        self.games = []
        
        getGames()
    }
}

extension GamesListViewModel {
    func getGames() {
        APIManager.shared.getGames()
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
            }
            .store(in: &cancellables)
    }
    
    func handleGetGamesFailure(message: String) {
        
    }
    
    func handleGetGamesSuccess(games: [GameModel]) {
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

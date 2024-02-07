//
//  GamesListViewModel.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class GamesListViewModel: ObservableObject {
    var mainCoordinator: MainCoordinator?
    
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
                        self.mainCoordinator?.presentGetGamesFailure(handler: self.getGames)
                    default:
                        break
                }
            }
            receiveValue: { gamesResponse in
                self.games = gamesResponse.results
                if gamesResponse.next != nil {
                    self.gamesLoadMore = true
                    self.gamesPage = self.gamesPage + 1
                }
            }
            .store(in: &cancellables)
    }
    
    func getMoreGames() {
        if gamesLoadMore == true {
            APIManager.shared.getGames(page: gamesPage)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                        case .failure(let error):
                            self.mainCoordinator?.presentGetGamesFailure(handler: self.getMoreGames)
                        default:
                            break
                        }
                }
                receiveValue: { gamesResponse in
                    self.games.append(contentsOf: gamesResponse.results)
                    if gamesResponse.next != nil {
                        self.gamesLoadMore = true
                        self.gamesPage = self.gamesPage + 1
                    }
                }
                .store(in: &cancellables)
        }
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

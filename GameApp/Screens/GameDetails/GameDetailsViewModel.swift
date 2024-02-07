//
//  GameDetailsViewModel.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class GameDetailsViewModel: ObservableObject {
    var mainCoordinator: MainCoordinator?
    
    var cancellables: Set<AnyCancellable>

    let gameId: Int
    @Published var gameDetails: GameDetailsModel?
    
    init(gameId: Int) {
        self.cancellables = Set<AnyCancellable>()
        
        self.gameId = gameId
        self.gameDetails = nil
        
        getGameDetails()
    }
}

extension GameDetailsViewModel {
    func getGameDetails() {
        APIManager.shared.getGameDetails(gameId: gameId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        self.mainCoordinator?.presentGetGameDetailsFailure(handler: self.getGameDetails)
                    default:
                        break
                }
            }
            receiveValue: { gameDetailsResponse in
                self.gameDetails = gameDetailsResponse
            }
            .store(in: &cancellables)
    }
}

extension GameDetailsViewModel {
    var gameDetailsData: AnyPublisher<GameDetailsModel?, Never> {
        return $gameDetails.didSet
            .map { gameDetails in
                return gameDetails ?? nil
            }
            .eraseToAnyPublisher()
    }
}

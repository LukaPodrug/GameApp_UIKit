//
//  GameDetailsViewModel.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class GameDetailsViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable>

    @Published var gameDetails: GameDetailsModel?
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        
        self.gameDetails = nil
        
        getGameDetails()
    }
}

extension GameDetailsViewModel {
    func getGameDetails() {
        APIManager.shared.getGameDetails()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        self.handleGetGameDetailsFailure(message: error.localizedDescription)
                    default:
                        break
                }
            }
            receiveValue: { gameDetailsResponse in
                self.handleGetGameDetailsSuccess(gameDetails: gameDetailsResponse)
            }
            .store(in: &cancellables)
    }
    
    func handleGetGameDetailsFailure(message: String) {

    }
    
    func handleGetGameDetailsSuccess(gameDetails: GameDetailsModel) {
        self.gameDetails = gameDetails
    }
}

extension GameDetailsViewModel {
    var updateGameDetailsData: AnyPublisher<Bool, Never> {
        return $gameDetails.didSet
            .map { gameDetails in
                if gameDetails == nil {
                    return false
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
}

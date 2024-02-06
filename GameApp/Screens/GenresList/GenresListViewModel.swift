//
//  GenresListViewModel.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class GenresListViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable>
    
    @Published var oldSelectedGenresIds: [Int]
    @Published var genres: [GenreModel]
    @Published var newSelectedGenresIds: [Int]
    @Published var genresAPIError: Bool
    
    init() {
        self.cancellables = Set<AnyCancellable>()
        
        self.oldSelectedGenresIds = []
        self.genres = []
        self.newSelectedGenresIds = []
        self.genresAPIError = false
        
        getOldSelectedGenresIds()
        getAllGenres()
    }
}

extension GenresListViewModel {
    func getAllGenres() {
        genresAPIError = false
        
        APIManager.shared.getAllGenres()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .failure(let error):
                        self.handleGetAllGenresFailure(message: error.localizedDescription)
                    default:
                        break
                }
            }
            receiveValue: { genresResponse in
                self.handleGetAllGenresSuccess(genres: genresResponse.results)
            }
            .store(in: &cancellables)
    }
    
    func handleGetAllGenresFailure(message: String) {
        genresAPIError = true
    }
    
    func handleGetAllGenresSuccess(genres: [GenreModel]) {
        self.genres = genres
    }
}

extension GenresListViewModel {
    func getOldSelectedGenresIds() {
        UserDefaults.standard
            .publisher(for: \.selectedGenresIds)
            .sink(receiveValue: { oldSelectedGenresIds in
                self.oldSelectedGenresIds = oldSelectedGenresIds
                self.newSelectedGenresIds = oldSelectedGenresIds
            })
            .store(in: &cancellables)
    }
    
    func updateSelectedGenresIds() {
        UserDefaults.standard.selectedGenresIds = newSelectedGenresIds
    }
}

extension GenresListViewModel {
    var backButtonEnabled: AnyPublisher<Bool, Never> {
        return $oldSelectedGenresIds
            .map { oldSelectedGenresIds in
                if oldSelectedGenresIds.count == 0 {
                    return false
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
    
    var confirmButtonEnabled: AnyPublisher<Bool, Never> {
        return $newSelectedGenresIds
            .map { newSelectedGenresIds in
                let oldSelectedGenresIdsSorted: [Int] = self.oldSelectedGenresIds.sorted()
                let newSelectedGenresIdsSorted: [Int] = newSelectedGenresIds.sorted()
                
                if newSelectedGenresIds.count == 0 || oldSelectedGenresIdsSorted == newSelectedGenresIdsSorted {
                    return false
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
    
    var updateGenresTableView: AnyPublisher<Bool, Never> {
        return $genres.didSet
            .map { genres in
                if genres.count == 0 {
                    return false
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
    
    var presentGenresAPIErrorModal: AnyPublisher<Bool, Never> {
        return $genresAPIError.didSet
            .map { genresAPIError in
                return genresAPIError
            }
            .eraseToAnyPublisher()
    }
}

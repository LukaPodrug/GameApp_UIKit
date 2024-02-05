//
//  APIManager.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case missingResponse
    case user
    case server
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return NSLocalizedString("Invalid URL", comment: "")
            case .missingResponse:
                return NSLocalizedString("Missing response", comment: "")
            case .user:
                return NSLocalizedString("User error", comment: "")
            case .server:
                return NSLocalizedString("Server error", comment: "")
            case .unknown:
                return NSLocalizedString("Unknown error", comment: "")
        }
    }
}

class APIManager {
    static let shared: APIManager = APIManager()
    
    var cancellables = Set<AnyCancellable>()
    
    let baseAPIURL: String = "https://api.rawg.io/api"
    
    func getAllGenres() -> Future<GenresResponseModel, Error> {
        let fullAPIURL: String = baseAPIURL + "/genres" + "?" + "key=\(APIKey)"
        
        return Future<GenresResponseModel, Error> { promise in
            guard let url = URL(string: fullAPIURL) else {
                return promise(.failure(APIError.invalidURL))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.missingResponse
                    }

                    if 400...499 ~= httpResponse.statusCode {
                        throw APIError.user
                    }
                    
                    else if 500...599 ~= httpResponse.statusCode {
                        throw APIError.server
                    }
                    
                    else if !(200...299 ~= httpResponse.statusCode) {
                        throw APIError.unknown
                    }
                    
                    return data
                }
                .decode(type: GenresResponseModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as APIError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(APIError.unknown))
                        }
                    }
                }, receiveValue: { data in
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func getGames() -> Future<GamesResponseModel, Error> {
        let fullAPIURL: String = baseAPIURL + "/games" + "?" + "genres=\(UserDefaults.standard.selectedGenresIds.toString())" + "&" + "key=\(APIKey)"
        
        return Future<GamesResponseModel, Error> { promise in
            guard let url = URL(string: fullAPIURL) else {
                return promise(.failure(APIError.invalidURL))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.missingResponse
                    }
                    if 400...499 ~= httpResponse.statusCode {
                        throw APIError.user
                    }
                    
                    else if 500...599 ~= httpResponse.statusCode {
                        throw APIError.server
                    }
                    
                    else if !(200...299 ~= httpResponse.statusCode) {
                        throw APIError.unknown
                    }
                    
                    return data
                }
                .decode(type: GamesResponseModel.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                            case let decodingError as DecodingError:
                                print(decodingError)
                                promise(.failure(decodingError))
                            case let apiError as APIError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(APIError.unknown))
                        }
                    }
                }, receiveValue: { data in
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
    }
}

extension APIManager {
    private var APIKey: String {
        get {
            guard let configPlistFilePath: String = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                fatalError("Could not find Config.plist file")
            }
            
            let configPlist: NSDictionary? = NSDictionary(contentsOfFile: configPlistFilePath)
            
            guard let APIKey = configPlist?.object(forKey: "API_KEY") as? String else {
                fatalError("Could not find API_KEY in Config.plist file")
            }
            
            return APIKey
        }
    }
}

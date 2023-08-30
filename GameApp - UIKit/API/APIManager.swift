//
//  APIManager.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import Foundation

class APIManager {
    static let shared: APIManager = APIManager()
    
    let baseURL: String = "https://api.rawg.io/api"
    let APIKey: String = "30db7eab85324eb6b06f81a0137fe86a"
    
    func buildURL(endpoint: String, queryItems: [URLQueryItem]) -> URL {
        var URLComponents = URLComponents(string: baseURL + endpoint)!
        let APIKeyQueryItem = URLQueryItem(name: "key", value: APIKey)
        URLComponents.queryItems = [APIKeyQueryItem] + queryItems
        
        return URLComponents.url!
    }
    
    func getGenres(completion: @escaping (Result<GenreResponse, ErrorType>) -> Void) {
        let URL = buildURL(endpoint: "/genres", queryItems: [])
        
        let task = URLSession.shared.dataTask(with: URL) { data, response, error in
            guard let data else {
                completion(.failure(.network))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decodedResponse = try? decoder.decode(GenreResponse.self, from: data) {
                completion(.success(decodedResponse))
            } else {
                completion(.failure(.decoding))
            }
        }
        
        task.resume()
    }
}

enum ErrorType: Error {
    case network
    case decoding
    case unknown
}

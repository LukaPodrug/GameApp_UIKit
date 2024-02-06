//
//  GenreModel.swift
//  GameApp
//
//  Created by Luka Podrug on 03.02.2024..
//

import Foundation

struct GenresResponseModel: Decodable {
    let count: Int
    let next: String?
    let results: [GenreModel]
}

struct GenreModel: Decodable {
    let id: Int
    let name: String
    let backgroundImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case backgroundImage = "image_background"
   }
}

//
//  GameModel.swift
//  GameApp
//
//  Created by Luka Podrug on 05.02.2024..
//

import Foundation

struct GamesResponseModel: Decodable {
    let count: Int
    let next: String?
    let results: [GameModel]
}

struct GameModel: Decodable {
    let id: Int
    let name: String
    let rating: Float
    let rating_top: Float
    let background_image: String
    let genres: [GameGenreModel]
}

struct GameGenreModel: Decodable {
    let id: Int
    let name: String
}

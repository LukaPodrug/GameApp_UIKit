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
    let previous: String?
    let results: [GenreModel]
}

struct GenreModel: Decodable {
    let id: Int
    let name: String
    let slug: String
    let games_count: Int
    let image_background: String
}
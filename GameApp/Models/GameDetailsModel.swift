//
//  GameDetailsModel.swift
//  GameApp
//
//  Created by Luka Podrug on 06.02.2024..
//

import Foundation

struct GameDetailsModel: Decodable {
    let id: Int
    let name: String
    let rating: Float
    let metacritic: Float
    let background_image: String
    let description_raw: String
}

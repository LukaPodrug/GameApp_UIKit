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
    let backgroundImage: String
    let descriptionRaw: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, metacritic
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
   }
}

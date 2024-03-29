//
//  GameModel.swift
//  GameApp
//
//  Created by Luka Podrug on 05.02.2024..
//

import Foundation
import SwiftUI

struct GamesResponseModel: Decodable {
    let count: Int
    let next: String?
    let results: [GameModel]
}

struct GameModel: Decodable {
    let id: Int
    let name: String
    let rating: Float
    let backgroundImage: String
    let genres: [GameGenreModel]
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, genres
        case backgroundImage = "background_image"
   }
}

struct GameGenreModel: Decodable {
    let id: Int
    let name: String
}

struct GameRatingDonutChartModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let value: Float
    let color: Color
}

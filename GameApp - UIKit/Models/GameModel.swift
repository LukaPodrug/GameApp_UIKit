//
//  GameModel.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import Foundation

struct GameScreenshot {
    let image: String
}

struct GameGenre {
    let id: Int
}

struct Game {
    let id: Int
    let name: String
    let rating: Decimal
    let backgroundImage: String
    let shortScreenshots: [GameScreenshot]
    let genres: [GameGenre]
    let released: String
}

struct GameResponse {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}

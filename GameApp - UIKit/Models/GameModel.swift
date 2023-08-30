//
//  GameModel.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import Foundation

struct GameScreenshot: Decodable {
    let image: String
}

struct GameGenre: Decodable {
    let id: Int
}

struct Game: Decodable {
    let id: Int
    let name: String
    let rating: Decimal
    let backgroundImage: String
    let shortScreenshots: [GameScreenshot]
    let genres: [GameGenre]
    let released: String
}

struct GameResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}

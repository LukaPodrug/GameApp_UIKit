//
//  GenreModel.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import Foundation

struct Genre {
    let id: Int
    let name: String
}

struct GenreResponse {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Genre]
}

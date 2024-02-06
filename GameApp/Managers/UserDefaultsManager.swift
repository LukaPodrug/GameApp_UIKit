//
//  UserDefaultsManager.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation

extension UserDefaults {
    @objc var selectedGenresIds: [Int] {
        get {
            return UserDefaults.standard.array(forKey: "selected_genres_ids") as? [Int] ?? []
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selected_genres_ids")
        }
    }
    
    @objc var selectedGameId: Int {
        get {
            return UserDefaults.standard.integer(forKey: "selected_game_id")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selected_game_id")
        }
    }
}

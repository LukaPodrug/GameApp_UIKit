//
//  APIManager.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import Combine

class APIManager {
    static let shared: APIManager = APIManager()
    
    private var APIKey: String {
        get {
            guard let configPlistFilePath: String = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                fatalError("Could not find Config.plist file")
            }
            
            let configPlist: NSDictionary? = NSDictionary(contentsOfFile: configPlistFilePath)
            
            guard let APIKey = configPlist?.object(forKey: "API_KEY") as? String else {
                fatalError("Could not find API_KEY in Config.plist file")
            }
            
            return APIKey
        }
    }
    
    func getAllGameGenres() {

    }
}

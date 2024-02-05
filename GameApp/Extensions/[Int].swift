//
//  [Int].swift
//  GameApp
//
//  Created by Luka Podrug on 05.02.2024..
//

import Foundation

extension [Int] {
    func toString() -> String {
        return self.map{String($0)}.joined(separator: ",")
    }
}

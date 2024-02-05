//
//  Published.swift
//  GameApp
//
//  Created by Luka Podrug on 05.02.2024..
//

import Foundation
import Combine

extension Published.Publisher {
    var didSet: AnyPublisher<Value, Never> {
        self.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
}

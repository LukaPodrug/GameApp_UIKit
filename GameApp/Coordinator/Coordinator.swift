//
//  Coordinator.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

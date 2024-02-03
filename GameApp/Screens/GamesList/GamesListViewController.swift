//
//  GamesListViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit

class GamesListViewController: UIViewController {
    var mainCoordinator: MainCoordinator?
    
    var subscriptions: Set<AnyCancellable>
    
    init() {
        self.subscriptions = Set<AnyCancellable>()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        setupUIFunctionality()
    }
    
    func setupUIFunctionality() {
        navigationItem.hidesBackButton = true
        
        UserDefaults.standard
            .publisher(for: \.selectedGenresIds)
            .sink(receiveValue: { selectedGenresIds in
                guard selectedGenresIds != nil else {
                    self.navigateToGenresList(initialGenresChoiceMade: false)
                    return
                }
                
                print(selectedGenresIds!)
            })
            .store(in: &subscriptions)
    }
}

extension GamesListViewController {
    func navigateToGenresList(initialGenresChoiceMade: Bool) {
        mainCoordinator?.navigateToGenresList(initialGenresChoiceMade: initialGenresChoiceMade)
    }
}

//
//  GenresListViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit

class GenresListViewController: UIViewController {
    var mainCoordinator: MainCoordinator?
    
    var subscriptions: Set<AnyCancellable>
    
    let initialGenresChoiceMade: Bool
    
    init(initialGenresChoiceMade: Bool) {
        self.subscriptions = Set<AnyCancellable>()
        
        self.initialGenresChoiceMade = initialGenresChoiceMade
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        setupUIFunctionality()
    }
    
    func setupUIFunctionality() {
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popTopViewController))
        navigationItem.leftBarButtonItem?.isEnabled = initialGenresChoiceMade
    }
}

extension GenresListViewController {
    @objc func popTopViewController() {
        mainCoordinator?.popTopViewController()
    }
}

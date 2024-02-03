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
    let genresListViewModel: GenresListViewModel
    
    init() {
        self.subscriptions = Set<AnyCancellable>()
        self.genresListViewModel = GenresListViewModel()
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmButtonTapped))
        
        genresListViewModel.backButtonEnabled
            .assign(to: \.navigationItem.leftBarButtonItem!.isEnabled, on: self)
            .store(in: &subscriptions)
        
        genresListViewModel.confirmButtonEnabled
            .assign(to: \.navigationItem.rightBarButtonItem!.isEnabled, on: self)
            .store(in: &subscriptions)
    }
}

extension GenresListViewController {
    @objc func backButtonTapped() {
        mainCoordinator?.popTopViewController()
    }
    
    @objc func confirmButtonTapped() {
        
    }
}

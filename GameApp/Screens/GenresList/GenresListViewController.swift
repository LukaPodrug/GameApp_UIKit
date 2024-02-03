//
//  GenresListViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit
import SnapKit

class GenresListViewController: UIViewController {
    var mainCoordinator: MainCoordinator?
    
    var subscriptions: Set<AnyCancellable>
    let genresListViewModel: GenresListViewModel
    let genresListView: GenresListView
    
    init() {
        self.subscriptions = Set<AnyCancellable>()
        self.genresListViewModel = GenresListViewModel()
        self.genresListView = GenresListView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        navigationItem.title = "Pick genres"
        
        view.backgroundColor = .white
        
        view.addSubview(genresListView)
        genresListView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
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

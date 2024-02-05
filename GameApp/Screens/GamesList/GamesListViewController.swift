//
//  GamesListViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit
import SnapKit
import SDWebImage

class GamesListViewController: UIViewController {
    let gameTableCellHeight: CGFloat = 80
    
    var mainCoordinator: MainCoordinator?
    
    var subscriptions: Set<AnyCancellable>
    let gamesListViewModel: GamesListViewModel
    let gamesListView: GamesListView
    
    init() {
        self.subscriptions = Set<AnyCancellable>()
        self.gamesListViewModel = GamesListViewModel()
        self.gamesListView = GamesListView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        navigationItem.title = "Games"
        
        view.backgroundColor = .white
        
        view.addSubview(gamesListView)
        gamesListView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupUIFunctionality() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Genres", style: .plain, target: self, action: #selector(genresButtonTapped))
        
        UserDefaults.standard
            .publisher(for: \.selectedGenresIds)
            .sink(receiveValue: { selectedGenresIds in
                guard selectedGenresIds.count != 0 else {
                    self.navigateToGenresList(initialGenresChoiceMade: false)
                    return
                }
                
                self.gamesListViewModel.getGames()
            })
            .store(in: &subscriptions)
        
        gamesListViewModel.updateGamesTableView
            .sink { updateGamesTableView in
                if updateGamesTableView == true {
                    self.gamesListView.gamesTableView.reloadData()
                }
            }
            .store(in: &subscriptions)
        
        gamesListView.gamesTableView.dataSource = self
        gamesListView.gamesTableView.delegate = self
        gamesListView.gamesTableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameTableCell")
    }
}

extension GamesListViewController {
    @objc func genresButtonTapped() {
        mainCoordinator?.navigateToGenresList()
    }
}

extension GamesListViewController {
    func navigateToGenresList(initialGenresChoiceMade: Bool) {
        mainCoordinator?.navigateToGenresList()
    }
}

extension GamesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesListViewModel.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableCell", for: indexPath) as! GameTableViewCell
        
        cell.selectionStyle = .none
        
        cell.setupUI()
        
        cell.gameNameLabel.text = gamesListViewModel.games[indexPath.row].name
        
        guard let imageURL = URL(string: gamesListViewModel.games[indexPath.row].background_image) else {
            cell.gameImageView.image = UIImage(systemName: "photo")
            return cell
        }
        
        cell.gameImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.gameImageView.sd_imageIndicator?.startAnimatingIndicator()
        cell.gameImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return gameTableCellHeight
    }
}

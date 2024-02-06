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
        self.gamesListViewModel = GamesListViewModel(mainCoordinator: mainCoordinator)
        self.gamesListView = GamesListView()
        
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
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.backgroundColor = .systemGray5
        activityIndicatorView.layer.cornerRadius = 10
        activityIndicatorView.layer.zPosition = 1
        
        UserDefaults.standard
            .publisher(for: \.selectedGenresIds)
            .sink(receiveValue: { selectedGenresIds in
                guard selectedGenresIds.count != 0 else {
                    self.navigateToGenresList(initialGenresChoiceMade: false)
                    return
                }
                
                activityIndicatorView.startAnimating()
                
                self.gamesListView.contentView.addSubview(activityIndicatorView)
                activityIndicatorView.snp.makeConstraints { make -> Void in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                }

                self.gamesListViewModel.getGames()
            })
            .store(in: &subscriptions)
        
        gamesListViewModel.updateGamesTableView
            .sink { updateGamesTableView in
                if updateGamesTableView == true {
                    activityIndicatorView.removeFromSuperview()
                    self.gamesListView.gamesTableView.reloadData()
                }
            }
            .store(in: &subscriptions)
        
        gamesListViewModel.presentGamesAPIErrorModal
            .sink { presentGamesAPIErrorModal in
                if presentGamesAPIErrorModal == true {
                    self.mainCoordinator?.presentGetGamesFailure(handler: self.gamesListViewModel.getGames)
                }
            }
            .store(in: &subscriptions)
        
        gamesListViewModel.presentMoreGamesAPIErrorModal
            .sink { presentMoreGamesAPIErrorModal in
                if presentMoreGamesAPIErrorModal == true {
                    self.mainCoordinator?.presentGetGamesFailure(handler: self.gamesListViewModel.getMoreGames)
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
        
        cell.gameGenresCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "GenreCollectionCell")
        
        cell.gameNameLabel.text = gamesListViewModel.games[indexPath.row].name
        
        cell.gameRatingDonutChartHostingController.rootView = DonutChart(statistics: [GameRatingDonutChartModel(title: "Rating", value: gamesListViewModel.games[indexPath.row].rating, color: .blue), GameRatingDonutChartModel(title: "Gap", value: 5 - gamesListViewModel.games[indexPath.row].rating, color: .clear)])

        cell.gameRatingLabel.text = String(format: "%.1f", gamesListViewModel.games[indexPath.row].rating / 5 * 100) + "%"
        
        guard let imageURL = URL(string: gamesListViewModel.games[indexPath.row].background_image) else {
            cell.gameImageView.image = UIImage(systemName: "photo")
            return cell
        }
        
        cell.gameImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.gameImageView.sd_imageIndicator?.startAnimatingIndicator()
        cell.gameImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .continueInBackground, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return gameTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let gameTableCell = cell as? GameTableViewCell else {
            return
        }

        gameTableCell.setGenresCollectionViewDataSourceAndDelegate(dataSourceAndDelegate: self, forRow: indexPath.row)
        
        if indexPath.row == gamesListViewModel.games.count - 3 {
            gamesListViewModel.getMoreGames()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GameTableViewCell
        
        cell.onPressAnimation()
        
        gameTableCellTapped(gameId: gamesListViewModel.games[indexPath.row].id)
    }
}

extension GamesListViewController {
    func gameTableCellTapped(gameId: Int) {
        UserDefaults.standard.selectedGameId = gameId
        mainCoordinator?.presentGameDetails()
    }
}

extension GamesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gamesListViewModel.games[collectionView.tag].genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionCell", for: indexPath) as! GenreCollectionViewCell
        
        cell.setupUI()
        
        cell.genreNameLabel.text = gamesListViewModel.games[collectionView.tag].genres[indexPath.row].name
        
        if UserDefaults.standard.selectedGenresIds.contains(gamesListViewModel.games[collectionView.tag].genres[indexPath.row].id) {
            cell.genreNameLabel.textColor = .white
            cell.contentView.backgroundColor = .systemBlue
        }
        
        else {
            cell.genreNameLabel.textColor = .black
            cell.contentView.backgroundColor = .systemGray2
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
